#if canImport(ObjectiveC)
import ObjectiveC
#endif

import Foundation
import Dispatch
import GrammarModels
import ObjcParser
import SwiftAST
import TypeSystem
import WriterTargetOutput
import Intentions
import IntentionPasses
import ExpressionPasses
import SourcePreprocessors
import GlobalsProviders
import SwiftSyntaxSupport
import Utils

private typealias NonnullTokenRange = (start: Int, end: Int)

/// Main front-end for Swift Rewriter
public final class SwiftRewriter {
    private static var _parserStatePool: ObjcParserStatePool = ObjcParserStatePool()
    
    private let sourcesProvider: InputSourcesProvider
    private var outputTarget: WriterOutput
    
    private let typeMapper: TypeMapper
    private let intentionCollection: IntentionCollection
    private var typeSystem: IntentionCollectionTypeSystem
    
    /// For pooling and reusing Antlr parser states to aid in performance
    private var parserStatePool: ObjcParserStatePool { SwiftRewriter._parserStatePool }
    
    /// Items to type-parse after parsing is complete, and all types have been
    /// gathered.
    private var lazyParse: [LazyParseItem] = []
    
    /// Items to type-resolve after parsing is complete, and all types have been
    /// gathered.
    private var lazyResolve: [LazyTypeResolveItem] = []
    
    /// To keep token sources alive long enough.
    private var parsers: [ObjcParser] = []
    
    /// An optional instance of a parser cache with pre-parsed input files.
    public var parserCache: ParserCache?
    
    /// A diagnostics instance that collects all diagnostic errors during input
    /// source processing.
    public let diagnostics: Diagnostics
    
    /// An expression pass is executed for every method expression to allow custom
    /// transformations to be applied to resulting code.
    public var astRewriterPassSources: ASTRewriterPassSource
    
    /// Custom source pre-processors that are applied to each input source code
    /// before parsing.
    public var preprocessors: [SourcePreprocessor] = []
    
    /// Provider for intention passes to apply before passing the constructs to
    /// the output
    public var intentionPassesSource: IntentionPassSource
    
    /// Provider for global variables
    public var globalsProvidersSource: GlobalsProvidersSource
    
    /// Provider for swift-syntax rewriters
    public var syntaxRewriterPassSource: SwiftSyntaxRewriterPassProvider
    
    /// Describes settings for the current `SwiftRewriter` invocation
    public var settings: Settings
    
    /// Describes settings to pass to the AST writers when outputting code
    public var writerOptions: SwiftSyntaxOptions = .default
    
    public init(input: InputSourcesProvider,
                output: WriterOutput,
                intentionPassesSource: IntentionPassSource? = nil,
                astRewriterPassSources: ASTRewriterPassSource? = nil,
                globalsProvidersSource: GlobalsProvidersSource? = nil,
                syntaxRewriterPassSource: SwiftSyntaxRewriterPassProvider? = nil,
                settings: Settings = .default) {
        
        self.diagnostics = Diagnostics()
        self.sourcesProvider = input
        self.outputTarget = output
        self.intentionCollection = IntentionCollection()
        self.intentionPassesSource =
            intentionPassesSource ?? ArrayIntentionPassSource(intentionPasses: [])
        self.astRewriterPassSources =
            astRewriterPassSources ?? ArrayASTRewriterPassSource(syntaxNodePasses: [])
        self.globalsProvidersSource =
            globalsProvidersSource ?? ArrayGlobalProvidersSource(globalsProviders: [])
        self.syntaxRewriterPassSource =
            syntaxRewriterPassSource ?? ArraySwiftSyntaxRewriterPassProvider(passes: [])
        
        typeSystem = IntentionCollectionTypeSystem(intentions: intentionCollection)
        
        self.typeMapper = DefaultTypeMapper(typeSystem: typeSystem)
        self.settings = settings
    }
    
    public func rewrite() throws {
        defer {
            lazyResolve = []
            typeSystem.reset()
            parsers.removeAll()
        }
        
        try autoreleasepool {
            try loadInputSources()
            let autotypeDecls = parseStatements()
            evaluateTypes()
            resolveAutotypeDeclarations(autotypeDecls)
            performIntentionAndSyntaxPasses()
            outputDefinitions()
        }
    }
    
    private func loadInputSources() throws {
        // Load input sources
        let sources = sourcesProvider.sources()
        
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = settings.numThreads
        
        let outError: ConcurrentValue<Error?> = ConcurrentValue(wrappedValue: nil)
        let mutex = Mutex()
        
        for (i, src) in sources.enumerated() {
            queue.addOperation {
                if outError.wrappedValue != nil {
                    return
                }
                
                do {
                    try autoreleasepool {
                        try self.loadObjcSource(from: src, index: i, mutex: mutex)
                    }
                } catch {
                    outError.modifyingValue {
                        if $0 != nil { return }
                        
                        $0 = error
                    }
                }
            }
        }
        
        queue.waitUntilAllOperationsAreFinished()
        
        if let error = outError.wrappedValue {
            throw error
        }
        
        // Keep file ordering of intentions
        intentionCollection.sortFileIntentions()
    }
    
    /// Parses all statements now, with proper type information available.
    private func parseStatements() -> [LazyAutotypeVarDeclResolve] {
        if settings.verbose {
            print("Parsing function bodies...")
        }
        
        // Register globals first
        for provider in globalsProvidersSource.globalsProviders {
            typeSystem.addTypealiasProvider(provider.typealiasProvider())
            typeSystem.addKnownTypeProvider(provider.knownTypeProvider())
        }
        
        typeSystem.makeCache()
        defer {
            typeSystem.tearDownCache()
        }

        let autotypeDeclarations = ConcurrentValue<[LazyAutotypeVarDeclResolve]>(wrappedValue: [])
        
        let antlrSettings = makeAntlrSettings()

        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = settings.numThreads
        
        for item in lazyParse {
            queue.addOperation {
                autoreleasepool {
                    let delegate = InnerStatementASTReaderDelegate(parseItem: item)

                    let typeMapper = DefaultTypeMapper(typeSystem: self.typeSystem)
                    let state = SwiftRewriter._parserStatePool.pull()
                    let typeParser = TypeParsing(state: state, antlrSettings: antlrSettings)
                    defer {
                        SwiftRewriter._parserStatePool.repool(state)
                    }
                    
                    let reader = SwiftASTReader(typeMapper: typeMapper,
                                                typeParser: typeParser,
                                                typeSystem: self.typeSystem)
                    reader.delegate = delegate
                    
                    switch item {
                    case .enumCase(let enCase):
                        guard let expression = enCase.typedSource?.expression?.expression else {
                            return
                        }
                        
                        enCase.expression = reader.parseExpression(expression: expression)
                        
                    case let .functionBody(funcBody, method):
                        guard let methodBody = funcBody.typedSource else {
                            return
                        }
                        guard let body = methodBody.statements else {
                            return
                        }
                        
                        funcBody.body =
                            reader.parseStatements(compoundStatement: body,
                                                   comments: methodBody.comments,
                                                   typeContext: method?.type)
                        
                    case .globalVar(let v):
                        guard let expression = v.typedSource?.constantExpression?.expression?.expression else {
                            return
                        }
                        
                        v.expression = reader.parseExpression(expression: expression)
                    }

                    autotypeDeclarations.modifyingValue {
                        $0.append(contentsOf: delegate.autotypeDeclarations)
                    }
                }
            }
        }
        
        queue.waitUntilAllOperationsAreFinished()

        return autotypeDeclarations.wrappedValue
    }
    
    /// Evaluate all type signatures, now with the knowledge of all types present
    /// in the program.
    private func evaluateTypes() {
        if settings.verbose {
            print("Resolving member types...")
        }
        
        typeSystem.makeCache()
        
        let typeMapper = self.typeMapper
        
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = settings.numThreads
        
        // Resolve typealiases and extension declarations first
        for item in lazyResolve {
            queue.addOperation {
                autoreleasepool {
                    switch item {
                    case .extensionDecl(let ext):
                        let typeName =
                            typeMapper.typeNameString(for: .pointer(.struct(ext.typeName)),
                                                      context: .alwaysNonnull)
                        
                        ext.typeName = typeName
                        
                    case .typealias(let typeali):
                        let nullability =
                            _typeNullability(inType: typeali.originalObjcType)
                        
                        let ctx =
                            TypeMappingContext(explicitNullability: nullability,
                                               inNonnull: typeali.inNonnullContext)
                        
                        typeali.fromType =
                            typeMapper.swiftType(forObjcType: typeali.originalObjcType,
                                                 context: ctx.withExplicitNullability(.nonnull))
                        _=typeali.fromType
                    default:
                        break
                    }
                }
            }
        }
        
        queue.waitUntilAllOperationsAreFinished()
        
        typeSystem.tearDownCache()
        
        // Re-create cache with newly created typealiases available
        typeSystem.makeCache()
        defer {
            typeSystem.tearDownCache()
        }
        
        // Now resolve all remaining items
        for item in lazyResolve {
            queue.addOperation {
                autoreleasepool {
                    switch item {
                    case let .property(prop):
                        guard let node = prop.propertySource else { return }
                        guard let type = node.type?.type else { return }
                        
                        let context =
                            TypeMappingContext(modifiers: node.attributesList,
                                               inNonnull: prop.inNonnullContext)
                        
                        prop.storage.type = typeMapper.swiftType(forObjcType: type,
                                                                 context: context)
                        
                    case let .method(method):
                        guard let node = method.typedSource else { return }
                        
                        let instancetype = (method.type?.typeName).map { SwiftType.typeName($0) }
                        
                        let signGen = SwiftMethodSignatureGen(typeMapper: typeMapper,
                                                              inNonnullContext: method.inNonnullContext,
                                                              instanceTypeAlias: instancetype)
                        method.signature = signGen.generateDefinitionSignature(from: node)
                        
                    case let .ivar(ivar):
                        guard let node = ivar.typedSource else { return }
                        guard let type = node.type?.type else { return }
                        
                        ivar.storage.type =
                            typeMapper.swiftType(forObjcType: type,
                                                 context: .init(inNonnull: ivar.inNonnullContext))
                        
                    case let .globalVar(gvar):
                        guard let node = gvar.variableSource else { return }
                        guard let type = node.type?.type else { return }
                        
                        gvar.storage.type =
                            typeMapper.swiftType(forObjcType: type,
                                                 context: .init(inNonnull: gvar.inNonnullContext))
                        
                    case let .enumDecl(en):
                        guard let type = en.typedSource?.type else { return }
                        
                        en.rawValueType = typeMapper.swiftType(forObjcType: type.type, context: .alwaysNonnull)
                        
                    case .globalFunc(let fn):
                        guard let node = fn.typedSource else { return }
                        
                        let signGen = SwiftMethodSignatureGen(typeMapper: typeMapper,
                                                              inNonnullContext: fn.inNonnullContext,
                                                              instanceTypeAlias: nil)
                        fn.signature = signGen.generateDefinitionSignature(from: node)
                        
                    case .extensionDecl, .typealias:
                        // These have already been resolved in a previous loop.
                        break
                    }
                }
            }
        }
        
        queue.waitUntilAllOperationsAreFinished()
    }

    private func resolveAutotypeDeclarations(_ declarations: [LazyAutotypeVarDeclResolve]) {
        let globals = CompoundDefinitionsSource()

        // Register globals first
        for provider in globalsProvidersSource.globalsProviders {
            globals.addSource(provider.definitionsSource())
        }

        let typeResolverInvoker =
            DefaultTypeResolverInvoker(globals: globals, typeSystem: typeSystem,
                                       numThreads: settings.numThreads)

        // Make a pre-type resolve before applying passes
        typeResolverInvoker.resolveAllExpressionTypes(in: intentionCollection, force: true)

        for declaration in declarations {
            let stmt = declaration.statement
            let decl = stmt.decl[declaration.index]
            
            // If this declaration's initializer depends on another auto type,
            // resolve expression types so the actual type can be propagated
            if decl.initialization?.resolvedType == SwiftType.typeName("__auto_type") {
                typeResolverInvoker.resolveAllExpressionTypes(in: intentionCollection, force: true)
            }
            
            if let type = decl.initialization?.resolvedType {
                if decl.ownership == .weak && typeSystem.isClassInstanceType(type) {
                    stmt.decl[declaration.index].type = .optional(type)
                } else {
                    stmt.decl[declaration.index].type = type
                }
            }
        }
    }
    
    private func performIntentionAndSyntaxPasses() {
        let globals = CompoundDefinitionsSource()
        
        if settings.verbose {
            print("Running intention passes...")
        }
        
        // Register globals first
        for provider in globalsProvidersSource.globalsProviders {
            globals.addSource(provider.definitionsSource())
        }
        
        let typeResolverInvoker =
            DefaultTypeResolverInvoker(globals: globals, typeSystem: typeSystem,
                                       numThreads: settings.numThreads)
        
        // Make a pre-type resolve before applying passes
        typeResolverInvoker.resolveAllExpressionTypes(in: intentionCollection, force: true)
        
        var requiresResolve = false
        
        let context =
            IntentionPassContext(typeSystem: typeSystem,
                                 typeMapper: typeMapper,
                                 typeResolverInvoker: typeResolverInvoker,
                                 numThreads: settings.numThreads,
                                 notifyChange: { requiresResolve = true })
        
        let intentionPasses =
            [MandatoryIntentionPass(phase: .beforeOtherIntentions)]
                + intentionPassesSource.intentionPasses
                + [MandatoryIntentionPass(phase: .afterOtherIntentions)]
        
        // Execute passes
        for (i, pass) in intentionPasses.enumerated() {
            autoreleasepool {
                requiresResolve = false
                
                if settings.verbose {
                    // Clear previous line and re-print, instead of bogging down
                    // the terminal with loads of prints
                    if i > 0 {
                        _terminalClearLine()
                    }
                    
                    let totalPadLength = intentionPasses.count.description.count
                    let progressString = String(format: "[%0\(totalPadLength)d/%d]",
                                                i + 1,
                                                intentionPasses.count)
                    
                    print("\(progressString): \(type(of: pass))")
                }
                
                pass.apply(on: intentionCollection, context: context)
                
                printDiagnosedFiles(step: "After intention pass \(type(of: pass))")
                
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
        
        // Resolve all expressions again
        typeResolverInvoker
            .resolveAllExpressionTypes(in: intentionCollection,
                                       force: true)
        
        let syntaxPasses =
            [MandatorySyntaxNodePass.self]
                + astRewriterPassSources.syntaxNodePasses
        
        let applier =
            ASTRewriterPassApplier(passes: syntaxPasses,
                                   typeSystem: typeSystem,
                                   globals: globals,
                                   numThreds: settings.numThreads)
        
        let progressDelegate = ASTRewriterDelegate()
        if settings.verbose {
            applier.progressDelegate = progressDelegate
        }
        
        if !settings.diagnoseFiles.isEmpty {
            let mutex = Mutex()
            applier.afterFile = { file, passName in
                mutex.locking {
                    self.printDiagnosedFile(targetPath: file, step: "After applying \(passName) pass")
                }
            }
        }
        
        typeSystem.makeCache()
        
        withExtendedLifetime(progressDelegate) {
            applier.apply(on: intentionCollection)
        }
        
        typeSystem.tearDownCache()
    }
    
    private func outputDefinitions() {
        if settings.verbose {
            print("Applying Swift syntax passes and saving files...")
        }
        
        let progressListener = InnerSwiftWriterDelegate()
        let syntaxApplier =
            SwiftSyntaxRewriterPassApplier(provider: syntaxRewriterPassSource)
        
        let writer = SwiftWriter(intentions: intentionCollection,
                                 options: writerOptions,
                                 numThreads: settings.numThreads,
                                 diagnostics: diagnostics,
                                 output: outputTarget,
                                 typeSystem: typeSystem,
                                 syntaxRewriterApplier: syntaxApplier)
        
        writer.progressListener = progressListener
        
        withExtendedLifetime(progressListener) {
            writer.execute()
        }
    }
    
    private func applyPreprocessors(source: CodeSource) -> String {
        let src = source.fetchSource()
        
        let context = _PreprocessingContext(filePath: source.filePath)
        
        return preprocessors.reduce(src) {
            $1.preprocess(source: $0, context: context)
        }
    }
    
    private func loadObjcSource(from source: InputSource, index: Int, mutex: Mutex) throws {
        let state = parserStatePool.pull()
        defer { parserStatePool.repool(state) }
        
        // Generate intention for this source
        var path = source.sourceName()
        
        if settings.verbose {
            print("Parsing \((path as NSString).lastPathComponent)...")
        }
        
        path = (path as NSString).deletingPathExtension + ".swift"
        
        // Hit parser cache, if available
        let parser: ObjcParser
        if let parserCache = parserCache {
            parser = try parserCache.loadParsedTree(input: source)
        } else {
            // TODO: Reduce duplication with ParserCache.applyPreprocessors
            let src = try source.loadSource()
            
            let processedSrc = applyPreprocessors(source: src)
            
            parser = ObjcParser(string: processedSrc, fileName: src.filePath, state: state)
            parser.antlrSettings = makeAntlrSettings()
            try parser.parse()
        }
        
        let typeMapper = DefaultTypeMapper(typeSystem: TypeSystem.defaultTypeSystem)
        let typeParser = TypeParsing(state: state, antlrSettings: parser.antlrSettings)
        
        let collectorDelegate =
            CollectorDelegate(typeMapper: typeMapper, typeParser: typeParser)
        
        if settings.stageDiagnostics.contains(.parsedAST) {
            parser.rootNode.printNode({ print($0) })
        }
        
        let ctx = IntentionBuildingContext()
        
        let fileIntent = FileGenerationIntention(sourcePath: source.sourceName(), targetPath: path)
        fileIntent.preprocessorDirectives = parser.preprocessorDirectives
        fileIntent.index = index
        fileIntent.isPrimary = source.isPrimary
        ctx.pushContext(fileIntent)
        
        let intentionCollector = IntentionCollector(delegate: collectorDelegate, context: ctx)
        intentionCollector.collectIntentions(parser.rootNode)
        
        ctx.popContext() // FileGenerationIntention
        
        mutex.locking {
            parsers.append(parser)
            lazyParse.append(contentsOf: collectorDelegate.lazyParse)
            lazyResolve.append(contentsOf: collectorDelegate.lazyResolve)
            diagnostics.merge(with: parser.diagnostics)
            intentionCollection.addIntention(fileIntent)
        }
    }
    
    private func printDiagnosedFiles(step: String) {
        for diagnoseFile in settings.diagnoseFiles {
            printDiagnosedFile(targetPath: diagnoseFile, step: step)
        }
    }
    
    private func printDiagnosedFile(targetPath: String, step: String) {
        let files = intentionCollection.fileIntentions()
        
        if !settings.diagnoseFiles.contains(where: { targetPath.contains($0) }) {
            return
        }
        
        guard let match = files.first(where: { $0.targetPath.hasSuffix(targetPath) }) else {
            return
        }
        
        let writer = SwiftSyntaxProducer(settings: writerOptions)
        
        let output = writer.generateFile(match)
        
        print("Diagnose file: \(match.targetPath)\ncontext: \(step)")
        print(output)
        print("")
    }
    
    private func makeAntlrSettings() -> AntlrSettings {
        AntlrSettings(forceUseLLPrediction: settings.forceUseLLPrediction)
    }
    
    /// Settings for a `SwiftRewriter` instance
    public struct Settings {
        /// Gets the default settings for a `SwiftRewriter` invocation
        public static var `default` = Settings()
        
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
        
        /// Array of files to periodically print out on the console whenever
        /// intention and expression passes are passed through the files.
        public var diagnoseFiles: [String]
        
        /// Whether to indicate to parser instances to force usage of LL prediction
        /// mode on the underlying ANTLR parser.
        ///
        /// Sometimes skipping SLL prediction mode straight to LL prediction can
        /// be more effective.
        public var forceUseLLPrediction: Bool
        
        /// Enables printing outputs of stages for diagnostic purposes.
        public var stageDiagnostics: [StageDiagnosticFlag]

        public init(numThreads: Int = 8,
                    verbose: Bool = false,
                    diagnoseFiles: [String] = [],
                    forceUseLLPrediction: Bool = false,
                    stageDiagnostics: [StageDiagnosticFlag] = []) {
            
            self.numThreads = numThreads
            self.verbose = verbose
            self.diagnoseFiles = []
            self.forceUseLLPrediction = forceUseLLPrediction
            self.stageDiagnostics = stageDiagnostics
        }
        
        public enum StageDiagnosticFlag {
            /// Prints result of Objective-C grammar parsing stage
            case parsedAST
        }
    }
}

// MARK: - ASTRewriterPassApplierProgressDelegate
private extension SwiftRewriter {
    class ASTRewriterDelegate: ASTRewriterPassApplierProgressDelegate {
        private var didPrintLine = false
        
        func astWriterPassApplier(_ passApplier: ASTRewriterPassApplier,
                                  applyingPassType passType: ASTRewriterPass.Type,
                                  toFile file: FileGenerationIntention) {
            
            // Clear previous line and re-print, instead of bogging down the
            // terminal with loads of prints
            if didPrintLine {
                _terminalClearLine()
            }
            
            let totalPadLength = passApplier.progress.total.description.count
            let progressString = String(format: "[%0\(totalPadLength)d/%d]",
                                        passApplier.progress.current,
                                        passApplier.progress.total)
            
            print("\(progressString): \((file.targetPath as NSString).lastPathComponent)")
            
            didPrintLine = true
        }
    }
}

// MARK: - SwiftWriterDelegate
private extension SwiftRewriter {
    class InnerSwiftWriterDelegate: SwiftWriterProgressListener {
        private var didPrintLine = false
        
        func swiftWriterReportProgress(_ writer: SwiftWriter,
                                       filesEmitted: Int,
                                       totalFiles: Int,
                                       latestFile: FileGenerationIntention) {
            
            // Clear previous line and re-print, instead of bogging down the
            // terminal with loads of prints
            if didPrintLine {
                _terminalClearLine()
            }
            
            let totalPadLength = totalFiles.description.count
            let progressString = String(format: "[%0\(totalPadLength)d/%d]",
                                        filesEmitted,
                                        totalFiles)
            
            print("\(progressString): \((latestFile.targetPath as NSString).lastPathComponent)")
            
            didPrintLine = true
        }
    }
}

// MARK: - IntentionCollectorDelegate
fileprivate extension SwiftRewriter {
    class CollectorDelegate: IntentionCollectorDelegate {
        var typeMapper: TypeMapper
        var typeParser: TypeParsing
        
        var lazyParse: [LazyParseItem] = []
        var lazyResolve: [LazyTypeResolveItem] = []
        
        init(typeMapper: TypeMapper, typeParser: TypeParsing) {
            self.typeMapper = typeMapper
            self.typeParser = typeParser
        }
        
        func isNodeInNonnullContext(_ node: ASTNode) -> Bool {
            node.isInNonnullContext
        }
        
        func reportForLazyResolving(intention: Intention) {
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
                let context =
                    intention.ancestor(ofType: MethodGenerationIntention.self)
                
                lazyParse.append(.functionBody(intention, method: context))
                
            case let intention as EnumCaseGenerationIntention:
                lazyParse.append(.enumCase(intention))
                
            default:
                fatalError("Cannot handle parsing for intention of type \(type(of: intention))")
            }
        }
        
        func typeMapper(for intentionCollector: IntentionCollector) -> TypeMapper {
            typeMapper
        }
        
        func typeParser(for intentionCollector: IntentionCollector) -> TypeParsing {
            typeParser
        }
    }

    private class InnerStatementASTReaderDelegate: SwiftStatementASTReaderDelegate {
        var parseItem: LazyParseItem
        var autotypeDeclarations: [LazyAutotypeVarDeclResolve] = []

        init(parseItem: LazyParseItem) {
            self.parseItem = parseItem
        }

        func swiftStatementASTReader(reportAutoTypeDeclaration varDecl: VariableDeclarationsStatement,
                                     declarationAtIndex index: Int) {

            autotypeDeclarations.append(
                LazyAutotypeVarDeclResolve(parseItem: parseItem,
                                           statement: varDecl,
                                           index: index)
            )
        }
    }
}

private enum LazyParseItem {
    case enumCase(EnumCaseGenerationIntention)
    case functionBody(FunctionBodyIntention, method: MethodGenerationIntention?)
    case globalVar(GlobalVariableInitialValueIntention)
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
}

/// Stored '__auto_type' variable declaration that needs to be resolved after
/// statement parsing
private struct LazyAutotypeVarDeclResolve {
    var parseItem: LazyParseItem
    var statement: VariableDeclarationsStatement
    var index: Int
}

internal func _typeNullability(inType type: ObjcType) -> TypeNullability? {
    switch type {
    case .specified(let specifiers, let type),
         .qualified(let type, let specifiers):
        
        // Struct types are never null.
        if case .struct = type {
            return .nonnull
        }
        
        if specifiers.contains("__weak") {
            return .nullable
        } else if specifiers.contains("__unsafe_unretained") {
            return .nonnull
        }
        
        return nil
    default:
        return nil
    }
}

internal struct _PreprocessingContext: PreprocessingContext {
    var filePath: String
}

private func _terminalClearLine() {
    // Move up command
    print("\u{001B}[1A", terminator: "")
    // Clear line command
    print("\u{001B}[2K", terminator: "")
}
