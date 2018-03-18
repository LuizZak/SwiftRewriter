import Foundation
import GrammarModels
import ObjcParser
import SwiftAST
import Utils

private typealias NonnullTokenRange = (start: Int, end: Int)

/// Main front-end for Swift Rewriter
public class SwiftRewriter {
    private static var _parserStatePool: ObjcParserStatePool = ObjcParserStatePool()
    
    private var outputTarget: WriterOutput
    private let typeMapper: TypeMapper
    private let intentionCollection: IntentionCollection
    private let sourcesProvider: InputSourcesProvider
    private var typeSystem: IntentionCollectionTypeSystem
    
    /// For pooling and reusing Antlr parser states to aid in performance
    private var parserStatePool: ObjcParserStatePool { return SwiftRewriter._parserStatePool }
    
    /// Items to type-parse after parsing is complete, and all types have been
    /// gathered.
    private var lazyParse: [LazyParseItem] = []
    
    /// Items to type-resolve after parsing is complete, and all types have been
    /// gathered.
    private var lazyResolve: [LazyTypeResolveItem] = []
    
    /// Full path of files from followed includes, when `followIncludes` is on.
    private var includesFollowed: [String] = []
    
    /// To keep token sources alive long enough.
    private var parsers: [ObjcParser] = []
    
    /// A diagnostics instance that collects all diagnostic errors during input
    /// source processing.
    public let diagnostics: Diagnostics
    
    /// An expression pass is executed for every method expression to allow custom
    /// transformations to be applied to resulting code.
    public var syntaxNodeRewriterSources: SyntaxNodeRewriterPassSource
    
    /// Custom source pre-processors that are applied to each input source code
    /// before parsing.
    public var preprocessors: [SourcePreprocessor] = []
    
    /// Provider for intention passes to apply before passing the constructs to
    /// the output
    public var intentionPassesSource: IntentionPassSource
    
    /// Provider for global variables
    public var globalsProvidersSource: GlobalsProvidersSource
    
    /// If true, `#include "file.h"` directives are resolved and the new unique
    /// files found during importing are included into the transpilation step.
    public var followIncludes: Bool = false
    
    /// Describes settings for the current `SwiftRewriter` invocation
    public var settings: Settings
    
    /// Describes settings to pass to the AST writers when outputting code
    public var writerOptions: ASTWriterOptions = .default
    
    public convenience init(input: InputSourcesProvider, output: WriterOutput) {
        self.init(input: input, output: output,
                  intentionPassesSource: ArrayIntentionPassSource(intentionPasses: []),
                  syntaxNodeRewriterSources: ArraySyntaxNodeRewriterPassSource(syntaxNodePasses: []),
                  globalsProvidersSource: ArrayGlobalProvidersSource(globalsProviders: []),
                  settings: .default)
    }
    
    public init(input: InputSourcesProvider, output: WriterOutput,
                intentionPassesSource: IntentionPassSource,
                syntaxNodeRewriterSources: SyntaxNodeRewriterPassSource,
                globalsProvidersSource: GlobalsProvidersSource,
                settings: Settings) {
        self.diagnostics = Diagnostics()
        self.sourcesProvider = input
        self.outputTarget = output
        self.intentionCollection = IntentionCollection()
        self.intentionPassesSource = intentionPassesSource
        self.syntaxNodeRewriterSources = syntaxNodeRewriterSources
        self.globalsProvidersSource = globalsProvidersSource
        
        typeSystem = IntentionCollectionTypeSystem(intentions: intentionCollection)
        
        self.typeMapper = DefaultTypeMapper(typeSystem: typeSystem)
        self.settings = settings
    }
    
    public func rewrite() throws {
        defer {
            lazyResolve = []
            typeSystem.reset()
        }
        
        try autoreleasepool {
            parsers.removeAll()
            
            try loadInputSources()
            parseStatements()
            evaluateTypes()
            performIntentionPasses()
            outputDefinitions()
        }
    }
    
    private func loadInputSources() throws {
        // Load input sources
        let sources = sourcesProvider.sources()
        
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = settings.numThreads
        
        var outError: Error?
        let outErrorBarrier
            = DispatchQueue(label: "br.com.swiftrewriter", qos: .default,
                            attributes: .concurrent, autoreleaseFrequency: .inherit,
                            target: nil)
        
        for (i, src) in sources.enumerated() {
            queue.addOperation {
                if outErrorBarrier.sync(execute: { outError }) != nil {
                    return
                }
                
                do {
                    try autoreleasepool {
                        try self.loadObjcSource(from: src, index: i)
                    }
                } catch {
                    outErrorBarrier.sync(flags: .barrier) {
                        if outError != nil { return }
                        
                        outError = error
                    }
                }
            }
        }
        
        queue.waitUntilAllOperationsAreFinished()
        
        if let error = outError {
            throw error
        }
        
        // Keep file ordering of intentions
        intentionCollection.sortFileIntentions()
    }
    
    /// Parses all statements now, with proper type information available.
    private func parseStatements() {
        if settings.verbose {
            print("Parsing function bodies...")
        }
        
        typeSystem.makeCache()
        
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = settings.numThreads
        
        for item in lazyParse {
            queue.addOperation {
                let typeMapper = DefaultTypeMapper(typeSystem: self.typeSystem)
                let state = SwiftRewriter._parserStatePool.pull()
                let typeParser = TypeParsing(state: state)
                defer {
                    SwiftRewriter._parserStatePool.repool(state)
                }
                
                let reader = SwiftASTReader(typeMapper: typeMapper, typeParser: typeParser)
                
                switch item {
                case .enumCase(let enCase):
                    guard let expression = (enCase.source as? ObjcEnumCase)?.expression?.expression else {
                        return
                    }
                    
                    enCase.expression = reader.parseExpression(expression: expression)
                case .functionBody(let funcBody):
                    guard let body = funcBody.typedSource?.statements else {
                        return
                    }
                    
                    funcBody.body = reader.parseStatements(compoundStatement: body)
                    
                case .globalVar(let v):
                    guard let expression = v.typedSource?.constantExpression?.expression?.expression else {
                        return
                    }
                    
                    v.expression = reader.parseExpression(expression: expression)
                }
            }
        }
        
        queue.waitUntilAllOperationsAreFinished()
        
        typeSystem.tearDownCache()
    }
    
    /// Evaluate all type signatures, now with the knowledge of all types present
    /// in the program.
    private func evaluateTypes() {
        for item in lazyResolve {
            switch item {
            case let .property(prop):
                guard let node = prop.propertySource else { continue }
                guard let type = node.type?.type else { continue }
                
                let context =
                    TypeMappingContext(modifiers: node.attributesList,
                                       inNonnull: prop.inNonnullContext)
                
                prop.storage.type = typeMapper.swiftType(forObjcType: type,
                                                         context: context)
                
            case let .method(method):
                guard let node = method.typedSource else { continue }
                
                let instancetype = (method.type?.typeName).map { SwiftType.typeName($0) }
                
                let signGen = SwiftMethodSignatureGen(typeMapper: typeMapper,
                                                      inNonnullContext: method.inNonnullContext,
                                                      instanceTypeAlias: instancetype)
                method.signature = signGen.generateDefinitionSignature(from: node)
                
            case let .ivar(ivar):
                guard let node = ivar.typedSource else { continue }
                guard let type = node.type?.type else { continue }
                
                ivar.storage.type =
                    typeMapper.swiftType(forObjcType: type,
                                         context: .init(inNonnull: ivar.inNonnullContext))
                
            case let .globalVar(gvar):
                guard let node = gvar.variableSource else { continue }
                guard let type = node.type?.type else { continue }
                
                gvar.storage.type =
                    typeMapper.swiftType(forObjcType: type,
                                         context: .init(inNonnull: gvar.inNonnullContext))
                
            case let .enumDecl(en):
                guard let type = en.typedSource?.type else { return }
                
                en.rawValueType = typeMapper.swiftType(forObjcType: type.type, context: .alwaysNonnull)
                
            case .globalFunc(let fn):
                guard let node = fn.typedSource else { continue }
                
                let signGen = SwiftMethodSignatureGen(typeMapper: typeMapper,
                                                      inNonnullContext: fn.inNonnullContext,
                                                      instanceTypeAlias: nil)
                fn.signature = signGen.generateDefinitionSignature(from: node)
                
            case .extensionDecl(let ext):
                let typeName = typeMapper.typeNameString(for: .pointer(.struct(ext.typeName)), context: .alwaysNonnull)
                ext.typeName = typeName
                
            case .typealias(let typeali):
                let nullability =
                    InternalSwiftWriter._typeNullability(inType: typeali.originalObjcType)
                
                let ctx =
                    TypeMappingContext(explicitNullability: nullability,
                                       inNonnull: typeali.inNonnullContext)
                
                typeali.fromType =
                    typeMapper.swiftType(forObjcType: typeali.originalObjcType,
                                         context: ctx)
            }
        }
    }
    
    private func performIntentionPasses() {
        let syntaxPasses =
            [MandatorySyntaxNodePass.self]
                + syntaxNodeRewriterSources.syntaxNodePasses
        
        let applier =
            SyntaxNodeRewriterPassApplier(passes: syntaxPasses,
                                          typeSystem: typeSystem,
                                          numThreds: settings.numThreads)
        
        let globals = GlobalDefinitions()
        
        let typeResolverInvoker =
            DefaultTypeResolverInvoker(globals: globals, typeSystem: typeSystem,
                                       numThreads: settings.numThreads)
        
        if settings.verbose {
            print("Running intention passes...")
        }
        
        // Register globals first
        for provider in globalsProvidersSource.globalsProviders {
            provider.registerDefinitions(on: globals)
            provider.registerTypes(in: typeSystem)
        }
        
        // Make a pre-type resolve before applying passes
        typeResolverInvoker.resolveAllExpressionTypes(in: intentionCollection, force: true)
        
        var requiresResolve = false
        
        let context =
            IntentionPassContext(typeSystem: typeSystem,
                                 typeMapper: typeMapper,
                                 typeResolverInvoker: typeResolverInvoker,
                                 notifyChange: { requiresResolve = true })
        
        let intentionPasses =
            [MandatoryIntentionPass()]
                + intentionPassesSource.intentionPasses
        
        // Execute passes
        for pass in intentionPasses {
            autoreleasepool {
                requiresResolve = false
                
                pass.apply(on: intentionCollection, context: context)
                
                if requiresResolve {
                    typeResolverInvoker
                        .resolveAllExpressionTypes(in: intentionCollection,
                                                   force: true)
                }
            }
        }
        
        if settings.verbose {
            print("Running syntax passes...")
        }
        
        applier.apply(on: intentionCollection)
    }
    
    private func outputDefinitions() {
        if settings.verbose {
            print("Saving files...")
        }
        
        let writer = SwiftWriter(intentions: intentionCollection,
                                 options: writerOptions,
                                 diagnostics: diagnostics,
                                 output: outputTarget,
                                 typeMapper: typeMapper,
                                 typeSystem: typeSystem)
        
        writer.execute()
    }
    
    private func applyPreprocessors(source: CodeSource) -> String {
        let src = source.fetchSource()
        
        let context = _PreprocessingContext(filePath: source.filePath)
        
        return preprocessors.reduce(src) {
            $1.preprocess(source: $0, context: context)
        }
    }
    
    private func resolveIncludes(in directives: [String], basePath: String) {
        if !followIncludes {
            return
        }
        
        var includeFiles: [String] = []
        
        for line in directives {
            guard line.starts(with: "#include \"") else {
                continue
            }
            
            let split = line.split(separator: "\"", maxSplits: 2, omittingEmptySubsequences: true)
            
            if split.count > 1 {
                includeFiles.append(String(split[1]))
            }
        }
        
        for file in includeFiles {
            let fullPath = (basePath as NSString).appendingPathComponent(file)
            
            guard !includesFollowed.contains(fullPath) else {
                continue
            }
            
            // TODO: Do meaningful work here to open the files and parse their
            // declarations
        }
    }
    
    private func loadObjcSource(from source: InputSource, index: Int) throws {
        let state = parserStatePool.pull()
        defer { parserStatePool.repool(state) }
        
        // Generate intention for this source
        var path = source.sourceName()
        
        if settings.verbose {
            print("Parsing \((path as NSString).lastPathComponent)...")
        }
        
        path = (path as NSString).deletingPathExtension + ".swift"
        
        let src = try source.loadSource()
        
        let processedSrc = applyPreprocessors(source: src)
        
        let parser = ObjcParser(string: processedSrc, fileName: src.filePath, state: state)
        try parser.parse()
        
        let typeMapper = DefaultTypeMapper(typeSystem: DefaultTypeSystem.defaultTypeSystem)
        let typeParser = TypeParsing(state: state)
        
        let collectorDelegate =
            CollectorDelegate(typeMapper: typeMapper, typeParser: typeParser,
                              nonnullTokenRanges: parser.nonnullMacroRegionsTokenRange)
        
        let ctx = IntentionBuildingContext()
        
        let fileIntent = FileGenerationIntention(sourcePath: source.sourceName(), targetPath: path)
        fileIntent.preprocessorDirectives = parser.preprocessorDirectives
        fileIntent._index = index
        ctx.pushContext(fileIntent)
        
        let intentionCollector = IntentionCollector(delegate: collectorDelegate, context: ctx)
        intentionCollector.collectIntentions(parser.rootNode)
        
        ctx.popContext() // FileGenerationIntention
        
        synchronized(self) {
            parsers.append(parser)
            lazyParse.append(contentsOf: collectorDelegate.lazyParse)
            lazyResolve.append(contentsOf: collectorDelegate.lazyResolve)
            diagnostics.merge(with: parser.diagnostics)
            intentionCollection.addIntention(fileIntent)
            
            resolveIncludes(in: fileIntent.preprocessorDirectives,
                            basePath: (src.filePath as NSString).deletingLastPathComponent)
        }
    }
    
    /// Settings for a `SwiftRewriter` instance
    public struct Settings {
        /// Gets the default settings for a `SwiftRewriter` invocation
        public static var `default`: Settings = Settings(numThreads: 8, verbose: false)
        
        /// The number of concurrent threads to use when applying intention/syntax
        /// node passes and other multi-threadable operations.
        ///
        /// Default is 8.
        public var numThreads: Int
        
        /// Whether to deploy a verbose mode that outputs information about the
        /// transpilation process while executing it.
        ///
        /// Default is false.
        public var verbose: Bool
        
        public init(numThreads: Int, verbose: Bool) {
            self.numThreads = numThreads
            self.verbose = verbose
        }
    }
}

// MARK: - IntentionCollectorDelegate
fileprivate extension SwiftRewriter {
    fileprivate class CollectorDelegate: IntentionCollectorDelegate {
        /// During parsing, the index of each NS_ASSUME_NONNULL_BEGIN/END pair is
        /// collected so during source analysis by SwiftRewriter we can verify whether
        /// or not a declaration is under the effects of NS_ASSUME_NONNULL by checking
        /// whether it is contained within one of these ranges.
        var nonnullTokenRanges: [NonnullTokenRange]
        
        var typeMapper: TypeMapper
        var typeParser: TypeParsing
        
        var lazyParse: [LazyParseItem] = []
        var lazyResolve: [LazyTypeResolveItem] = []
        
        init(typeMapper: TypeMapper, typeParser: TypeParsing, nonnullTokenRanges: [NonnullTokenRange]) {
            self.typeMapper = typeMapper
            self.typeParser = typeParser
            self.nonnullTokenRanges = nonnullTokenRanges
        }
        
        public func isNodeInNonnullContext(_ node: ASTNode) -> Bool {
            let ranges = nonnullTokenRanges
            
            // Requires original ANTLR's rule context
            guard let ruleContext = node.sourceRuleContext else {
                return false
            }
            // Fetch the token indices of the node's start and end
            guard let startToken = ruleContext.getStart(), let stopToken = ruleContext.getStop() else {
                return false
            }
            
            // Check if it the token start/end indices are completely contained
            // within NS_ASSUME_NONNULL_BEGIN/END intervals
            for n in ranges {
                if n.start <= startToken.getTokenIndex() && n.end >= stopToken.getTokenIndex() {
                    return true
                }
            }
            
            return false
        }
        
        public func reportForLazyResolving(intention: Intention) {
            switch intention {
            case let intention as GlobalVariableGenerationIntention:
                lazyResolve.append(.globalVar(intention))
                
            case let intention as GlobalFunctionGenerationIntention:
                lazyResolve.append(.globalFunc(intention))
                
            case let intention as PropertyGenerationIntention:
                lazyResolve.append(.property(intention))
                
            case let intention as MethodGenerationIntention:
                lazyResolve.append(.method(intention))
                
            case let intention as EnumGenerationIntention:
                lazyResolve.append(.enumDecl(intention))
                
            case let intention as InstanceVariableGenerationIntention:
                lazyResolve.append(.ivar(intention))
                
            case let intention as ClassExtensionGenerationIntention:
                lazyResolve.append(.extensionDecl(intention))
                
            case let intention as TypealiasIntention:
                lazyResolve.append(.typealias(intention))
                
            default:
                fatalError("Cannot handle type resolving for intention of type \(type(of: intention))")
            }
        }
        
        func reportForLazyParsing(intention: Intention) {
            switch intention {
            case let intention as GlobalVariableInitialValueIntention:
                lazyParse.append(.globalVar(intention))
                
            case let intention as FunctionBodyIntention:
                lazyParse.append(.functionBody(intention))
                
            case let intention as EnumCaseGenerationIntention:
                lazyParse.append(.enumCase(intention))
                
            default:
                fatalError("Cannot handle parsing for intention of type \(type(of: intention))")
            }
        }
        
        public func typeMapper(for intentionCollector: IntentionCollector) -> TypeMapper {
            return typeMapper
        }
        
        func typeParser(for intentionCollector: IntentionCollector) -> TypeParsing {
            return typeParser
        }
    }
}

private enum LazyParseItem {
    case enumCase(EnumCaseGenerationIntention)
    case functionBody(FunctionBodyIntention)
    case globalVar(GlobalVariableInitialValueIntention)
    
    /// Returns the base `FromSourceIntention`-typed value, which is the intention
    /// associated with every case.
    var fromSourceIntention: FromSourceIntention {
        switch self {
        case .enumCase(let i):
            return i
        case .functionBody(let i):
            return i
        case .globalVar(let i):
            return i
        }
    }
}

private enum LazyTypeResolveItem {
    case property(PropertyGenerationIntention)
    case ivar(InstanceVariableGenerationIntention)
    case method(MethodGenerationIntention)
    case globalVar(GlobalVariableGenerationIntention)
    case globalFunc(GlobalFunctionGenerationIntention)
    case enumDecl(EnumGenerationIntention)
    case extensionDecl(ClassExtensionGenerationIntention)
    case `typealias`(TypealiasIntention)
    
    /// Returns the base `FromSourceIntention`-typed value, which is the intention
    /// associated with every case.
    var fromSourceIntention: FromSourceIntention {
        switch self {
        case .property(let i):
            return i
        case .ivar(let i):
            return i
        case .method(let i):
            return i
        case .globalVar(let i):
            return i
        case .globalFunc(let i):
            return i
        case .enumDecl(let i):
            return i
        case .extensionDecl(let i):
            return i
        case .typealias(let i):
            return i
        }
    }
}
