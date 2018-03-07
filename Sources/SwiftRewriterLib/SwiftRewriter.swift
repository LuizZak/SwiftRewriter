import Foundation
import GrammarModels
import ObjcParser
import SwiftAST
import Utils

private typealias NonnullTokenRange = (start: Int, end: Int)

/// Main front-end for Swift Rewriter
public class SwiftRewriter {
    
    private var outputTarget: WriterOutput
    private let typeMapper: TypeMapper
    private let intentionCollection: IntentionCollection
    private let sourcesProvider: InputSourcesProvider
    private var typeSystem: IntentionCollectionTypeSystem
    
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
                  settings: .default)
    }
    
    public init(input: InputSourcesProvider, output: WriterOutput,
                intentionPassesSource: IntentionPassSource,
                syntaxNodeRewriterSources: SyntaxNodeRewriterPassSource,
                settings: Settings) {
        self.diagnostics = Diagnostics()
        self.sourcesProvider = input
        self.outputTarget = output
        self.intentionCollection = IntentionCollection()
        self.intentionPassesSource = intentionPassesSource
        self.syntaxNodeRewriterSources = syntaxNodeRewriterSources
        
        typeSystem = IntentionCollectionTypeSystem(intentions: intentionCollection)
        
        let context = TypeConstructionContext(typeSystem: typeSystem)
        self.typeMapper = DefaultTypeMapper(context: context)
        self.settings = settings
    }
    
    public func rewrite() throws {
        defer {
            lazyResolve = []
        }
        
        try autoreleasepool {
            parsers.removeAll()
            
            try loadInputSources()
            evaluateTypes()
            performIntentionPasses()
            outputDefinitions()
        }
    }
    
    private func loadInputSources() throws {
        // Load input sources
        let sources = sourcesProvider.sources()
        
        let queue = OperationQueue()
        
        var outError: Error?
        
        for src in sources {
            queue.addOperation {
                do {
                    try autoreleasepool {
                        try self.loadObjcSource(from: src)
                    }
                } catch {
                    outError = error
                }
            }
        }
        
        if let error = outError {
            throw error
        }
        
        queue.waitUntilAllOperationsAreFinished()
    }
    
    /// Evaluate all type signatures, now with the knowledge of all types present
    /// in the program.
    private func evaluateTypes() {
        let context = TypeConstructionContext(typeSystem: typeSystem)
        context.pushContext(AssumeNonnullContext(isNonnullOn: false))
        defer {
            context.popContext()
        }
        
        for item in lazyResolve {
            switch item {
            case let .property(prop):
                guard let node = prop.propertySource else { continue }
                guard let type = node.type?.type else { continue }
                
                let context =
                    TypeMappingContext(modifiers: node.attributesList,
                                       inNonnull: prop.inNonnullContext)
                
                prop.storage.type = typeMapper.swiftType(forObjcType: type, context: context)
                
            case let .method(method):
                guard let node = method.typedSource else { continue }
                
                context.assumeNonnulContext?.isNonnullOn = method.inNonnullContext
                
                let signGen = SwiftMethodSignatureGen(context: context, typeMapper: typeMapper)
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
                
                context.assumeNonnulContext?.isNonnullOn = fn.inNonnullContext
                
                let signGen = SwiftMethodSignatureGen(context: context, typeMapper: typeMapper)
                fn.signature = signGen.generateDefinitionSignature(from: node)
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
        
        let typeResolverInvoker = DefaultTypeResolverInvoker(typeSystem: typeSystem)
        
        if settings.verbose {
            print("Running intention passes...")
        }
        
        // Make a pre-type resolve before applying passes
        typeResolverInvoker.resolveAllExpressionTypes(in: intentionCollection, force: true)
        
        var requiresResolve = false
        
        let context =
            IntentionPassContext(typeSystem: typeSystem,
                                 typeMapper: typeMapper,
                                 typeResolverInvoker: typeResolverInvoker,
                                 notifyChange: { requiresResolve = true })
        
        for pass in intentionPassesSource.intentionPasses {
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
        let writer = SwiftWriter(intentions: intentionCollection,
                                 options: writerOptions,
                                 diagnostics: diagnostics,
                                 output: outputTarget,
                                 typeMapper: typeMapper)
        
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
    
    private func loadObjcSource(from source: InputSource) throws {
        // Generate intention for this source
        var path = source.sourceName()
        
        if settings.verbose {
            print("Parsing \((path as NSString).lastPathComponent)...")
        }
        
        path = (path as NSString).deletingPathExtension + ".swift"
        
        let src = try source.loadSource()
        
        let processedSrc = applyPreprocessors(source: src)
        
        let parser = ObjcParser(string: processedSrc, fileName: src.filePath)
        
        try parser.parse()
        
        let collectorDelegate =
            CollectorDelegate(typeMapper: typeMapper,
                              nonnullTokenRanges: parser.nonnullMacroRegionsTokenRange)
        
        let ctx = TypeConstructionContext(typeSystem: typeSystem)
        
        let fileIntent = FileGenerationIntention(sourcePath: source.sourceName(), targetPath: path)
        fileIntent.preprocessorDirectives = parser.preprocessorDirectives
        ctx.pushContext(fileIntent)
        
        let intentionCollector = IntentionCollector(delegate: collectorDelegate, context: ctx)
        intentionCollector.collectIntentions(parser.rootNode)
        
        resolveIncludes(in: fileIntent.preprocessorDirectives,
                        basePath: (src.filePath as NSString).deletingLastPathComponent)
        
        ctx.popContext() // FileGenerationIntention
        
        synchronized(self) {
            parsers.append(parser)
            lazyResolve.append(contentsOf: collectorDelegate.lazyResolve)
            diagnostics.merge(with: parser.diagnostics)
            intentionCollection.addIntention(fileIntent)
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
        
        var lazyResolve: [LazyTypeResolveItem] = []
        
        init(typeMapper: TypeMapper, nonnullTokenRanges: [NonnullTokenRange]) {
            self.typeMapper = typeMapper
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
                
            default:
                break
            }
        }
        
        public func typeMapper(for intentionCollector: IntentionCollector) -> TypeMapper {
            return typeMapper
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
        }
    }
}
