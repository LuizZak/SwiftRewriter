#if canImport(ObjectiveC)
import ObjectiveC
#endif

import Foundation
import Dispatch
import Utils
import AntlrCommons
import GrammarModelBase
import ObjcGrammarModels
import ObjcParser
import SwiftAST
import TypeSystem
import WriterTargetOutput
import Intentions
import Analysis
import IntentionPasses
import ExpressionPasses
import SourcePreprocessors
import SwiftSyntaxSupport
import SwiftRewriterLib

private typealias NonnullTokenRange = (start: Int, end: Int)

/// Main front-end for Swift Rewriter
public final class ObjectiveC2SwiftRewriter {
    private static var _parserStatePool: ObjcParserStatePool = ObjcParserStatePool()
    
    private let sourcesProvider: InputSourcesProvider
    private var outputTarget: WriterOutput
    
    private let typeMapper: TypeMapper
    private let intentionCollection: IntentionCollection
    private var typeSystem: IntentionCollectionTypeSystem
    
    /// For pooling and reusing Antlr parser states to aid in performance
    private var parserStatePool: ObjcParserStatePool { ObjectiveC2SwiftRewriter._parserStatePool }
    
    /// Items to type-parse after parsing is complete, and all types have been
    /// gathered.
    private var lazyParse: [(ObjcParser, ObjectiveCLazyParseItem)] = []
    
    /// Items to type-resolve after parsing is complete, and all types have been
    /// gathered.
    private var lazyResolve: [ObjectiveCLazyTypeResolveItem] = []
    
    /// To keep token sources alive long enough.
    private var parsers: [ObjcParser] = []
    
    /// An optional instance of a parser cache with pre-parsed input files.
    public var parserCache: ObjectiveCParserCache?
    
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
    
    /// Describes settings for the current `ObjectiveC2SwiftRewriter` invocation
    public var settings: Settings
    
    /// Describes settings to pass to the AST writers when outputting code
    public var writerOptions: SwiftSyntaxOptions = .default
    
    public init(
        input: InputSourcesProvider,
        output: WriterOutput,
        intentionPassesSource: IntentionPassSource? = nil,
        astRewriterPassSources: ASTRewriterPassSource? = nil,
        globalsProvidersSource: GlobalsProvidersSource? = nil,
        syntaxRewriterPassSource: SwiftSyntaxRewriterPassProvider? = nil,
        settings: Settings = .default
    ) {
        
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
            parseDefinePreprocessorDirectives()
            evaluateTypes()
            resolveAutotypeDeclarations(autotypeDecls)
            performIntentionAndSyntaxPasses()
            outputDefinitions()
        }
    }
    
    private func loadInputSources() throws {
        // Load input sources
        let sources = sourcesProvider.sources()
        
        let queue = ConcurrentOperationQueue()
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
        
        queue.runAndWaitConcurrent()
        
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

        let queue = ConcurrentOperationQueue()
        queue.maxConcurrentOperationCount = settings.numThreads
        
        for (parser, item) in lazyParse {
            queue.addOperation {
                autoreleasepool {
                    let delegate = InnerStatementASTReaderDelegate(parseItem: item)

                    let typeMapper = DefaultTypeMapper(typeSystem: self.typeSystem)
                    let state = ObjectiveC2SwiftRewriter._parserStatePool.pull()
                    let typeParser = ObjcTypeParser(state: state,
                        source: parser.source,
                        antlrSettings: antlrSettings
                    )

                    defer {
                        ObjectiveC2SwiftRewriter._parserStatePool.repool(state)
                    }
                    
                    let reader = ObjectiveCASTReader(
                        parserStatePool: self.parserStatePool,
                        typeMapper: typeMapper,
                        typeParser: typeParser,
                        typeSystem: self.typeSystem
                    )
                    reader.delegate = delegate
                    
                    switch item {
                    case .enumCase(let enCase):
                        guard let expression = enCase.typedSource?.expression?.expression else {
                            return
                        }
                        
                        enCase.initialValue = reader.parseExpression(expression: expression)
                        
                    case .method(let funcBody, let member as MemberGenerationIntention),
                        .initializer(let funcBody, let member as MemberGenerationIntention),
                        .deinitializer(let funcBody, let member as MemberGenerationIntention):

                        guard let source = funcBody.typedSource else {
                            return
                        }
                        guard let body = source.statements else {
                            return
                        }
                        
                        funcBody.body = reader.parseStatements(
                            compoundStatement: body,
                            comments: source.comments,
                            typeContext: member.type
                        )
                        
                    case let .globalFunction(funcBody, _):
                        guard let source = funcBody.typedSource else {
                            return
                        }
                        guard let body = source.statements else {
                            return
                        }
                        
                        funcBody.body = reader.parseStatements(
                            compoundStatement: body,
                            comments: source.comments,
                            typeContext: nil
                        )
                        
                    case .globalVar(let v, _):
                        guard let expression = v.typedSource?.expression?.expression else {
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
        
        queue.runAndWaitConcurrent()

        return autotypeDeclarations.wrappedValue
    }
    
    /// Analyzes and converts #define directives and converts them into global
    /// variables when suitable
    private func parseDefinePreprocessorDirectives() {
        // TODO: Use a dedicated metadata value for representing preprocessor directives.
        let resolver = makeTypeResolverInvoker()
        
        for file in intentionCollection.fileIntentions() {
            // Start by removing duplicated directives by only emitting the last
            // instance of a repeated declare directive
            var definesFound: Set<String> = []
            var headerComments: [String] = []

            for comment in file.headerComments.reversed() {
                guard
                    let parsed = CPreprocessorDirectiveConverter
                        .parseDefineDirective(
                            comment
                        )
                else {
                    continue
                }

                if definesFound.insert(parsed.identifier).inserted {
                    headerComments.insert(comment, at: 0)
                }
            }
            
            for comment in headerComments {
                let converter = CPreprocessorDirectiveConverter(
                    parserStatePool: parserStatePool,
                    typeSystem: typeSystem,
                    typeResolverInvoker: resolver
                )
                
                guard let declaration = converter.convert(directive: comment, inFile: file) else {
                    continue
                }
                
                let varDecl = GlobalVariableGenerationIntention(
                    name: declaration.name,
                    type: declaration.type,
                    // TODO: Abstract detection of .m/.c translation unit files
                    // here so we can properly generalize to any translation
                    // unit file kind
                    accessLevel: file.sourcePath.hasSuffix("h") ? .internal : .private,
                    source: nil
                )
                
                varDecl.storage.isConstant = true
                varDecl.initialValue = declaration.expression
                
                let sourceName = (file.sourcePath as NSString).lastPathComponent
                let history = """
                    Converted from compiler directive from \(sourceName): \(comment)
                    """
                
                varDecl.history.recordCreation(description: history)
                
                file.addGlobalVariable(varDecl)
                
                resolver.refreshIntentionGlobals()
            }
        }
    }
    
    /// Evaluate all type signatures, now with the knowledge of all types present
    /// in the program.
    private func evaluateTypes() {
        if settings.verbose {
            print("Resolving member types...")
        }
        
        typeSystem.makeCache()
        
        let typeMapper = self.typeMapper
        
        let queue = ConcurrentOperationQueue()
        queue.maxConcurrentOperationCount = settings.numThreads
        
        // Resolve typealiases and extension declarations first
        for item in lazyResolve {
            queue.addOperation {
                autoreleasepool {
                    switch item {
                    case .extensionDecl(let decl):
                        let typeName = typeMapper.typeNameString(
                            for: .pointer(.typeName(decl.typeName)),
                            context: .alwaysNonnull
                        )
                        
                        decl.typeName = typeName
                        
                    case .typealias(let decl):
                        guard let originalObjcType = decl.metadata.originalObjcType else {
                            break
                        }

                        let nullability = _typeNullability(
                            inType: originalObjcType
                        )
                        
                        let ctx = TypeMappingContext(
                            explicitNullability: nullability,
                            inNonnull: decl.inNonnullContext
                        )
                        
                        decl.fromType = typeMapper.swiftType(
                            forObjcType: originalObjcType,
                            context: ctx.withExplicitNullability(.nonnull)
                        )

                    default:
                        break
                    }
                }
            }
        }
        
        queue.runAndWaitConcurrent()
        
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
                        
                        let context = TypeMappingContext(
                            modifiers: node.attributesList,
                            inNonnull: prop.inNonnullContext
                        )
                        
                        prop.storage.type = typeMapper.swiftType(
                            forObjcType: type,
                            context: context
                        )
                        
                    case let .method(method):
                        guard let node = method.typedSource else { return }
                        
                        let instancetype = (method.type?.typeName).map { SwiftType.typeName($0) }
                        
                        let signGen = ObjectiveCMethodSignatureConverter(
                            typeMapper: typeMapper,
                            inNonnullContext: method.inNonnullContext,
                            instanceTypeAlias: instancetype
                        )
                        
                        method.signature = signGen.generateDefinitionSignature(from: node)
                        
                    case let .ivar(decl):
                        guard let node = decl.typedSource else { return }
                        guard let type = node.type?.type else { return }
                        
                        decl.storage.type = typeMapper.swiftType(
                            forObjcType: type,
                            context: .init(inNonnull: decl.inNonnullContext)
                        )
                        
                    case let .globalVar(decl):
                        guard let node = decl.variableSource else { return }
                        guard let type = node.type?.type else { return }
                        
                        decl.storage.type = typeMapper.swiftType(
                            forObjcType: type,
                            context: .init(inNonnull: decl.inNonnullContext)
                        )
                        
                    case let .enumDecl(en):
                        guard let type = en.typedSource?.type else { return }
                        
                        en.rawValueType = typeMapper.swiftType(
                            forObjcType: type.type,
                            context: .alwaysNonnull
                        )
                        
                    case .globalFunc(let fn):
                        guard let node = fn.typedSource else { return }
                        
                        let signGen = ObjectiveCMethodSignatureConverter(
                            typeMapper: typeMapper,
                            inNonnullContext: fn.inNonnullContext,
                            instanceTypeAlias: nil
                        )
                        
                        fn.signature = signGen.generateDefinitionSignature(from: node)
                        
                    case .extensionDecl, .typealias:
                        // These have already been resolved in a previous loop.
                        break
                    }
                }
            }
        }
        
        queue.runAndWaitConcurrent()
    }

    private func resolveAutotypeDeclarations(_ declarations: [LazyAutotypeVarDeclResolve]) {
        let typeResolverInvoker = makeTypeResolverInvoker()

        // Make a pre-type resolve before propagating types
        typeResolverInvoker.resolveAllExpressionTypes(
            in: intentionCollection,
            force: true
        )

        let cache = DefinitionTypePropagator.PerIntentionTypeCache()
        let autotype = SwiftType.typeName("__auto_type")

        for declaration in declarations {
            let stmt = declaration.statement
            let decl = stmt.decl[declaration.index]

            // If this declaration's initializer depends on another auto type,
            // resolve expression types so the actual type can be propagated
            if decl.initialization?.resolvedType == autotype {
                typeResolverInvoker.resolveAllExpressionTypes(in: intentionCollection, force: true)
            }
            
            let carrier: FunctionBodyCarryingIntention

            switch declaration.parseItem {
            case .enumCase:
                continue
            
            case .globalVar(let initialization, let intention):
                carrier = .globalVariable(intention, initialization)
            
            case .method(_, let intention):
                carrier = .method(intention)

            case .initializer(_, let intention):
                carrier = .initializer(intention)

            case .deinitializer(_, let intention):
                carrier = .deinit(intention)

            case .globalFunction(_, let intention):
                carrier = .global(intention)
            }

            let localTypeResolver = DefaultLocalTypeResolverInvoker(
                intention: carrier,
                globals: makeGlobalDefinitionsSource(),
                typeSystem: typeSystem
            )

            let typePropagator = DefinitionTypePropagator(
                cache: cache.cache(for: carrier),
                options: .init(
                    baseType: autotype,
                    baseNumericType: nil,
                    baseStringType: nil
                ),
                typeSystem: typeSystem,
                typeResolver: localTypeResolver
            )

            typePropagator.propagate(in: carrier)
        }
    }
    
    private func performIntentionAndSyntaxPasses() {
        if settings.verbose {
            print("Running intention passes...")
        }
        
        let globals = makeGlobalDefinitionsSource()
        
        let typeResolverInvoker = makeTypeResolverInvoker()
        
        // Make a pre-type resolve before applying passes
        typeResolverInvoker.resolveAllExpressionTypes(in: intentionCollection, force: true)
        
        var requiresResolve = false
        
        let context = IntentionPassContext(
            typeSystem: typeSystem,
            typeMapper: typeMapper,
            typeResolverInvoker: typeResolverInvoker,
            numThreads: settings.numThreads,
            notifyChange: { requiresResolve = true }
        )
        
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
                    let progressString = String(
                        format: "[%0\(totalPadLength)d/%d]",
                        i + 1,
                        intentionPasses.count
                    )
                    
                    print("\(progressString): \(type(of: pass))")
                }
                
                pass.apply(on: intentionCollection, context: context)
                
                printDiagnosedFiles(step: "After intention pass \(type(of: pass))")
                
                if requiresResolve {
                    typeResolverInvoker.resolveAllExpressionTypes(
                        in: intentionCollection,
                        force: true
                    )
                }
            }
        }
        
        if settings.verbose {
            print("Running syntax passes...")
        }
        
        // Resolve all expressions again
        typeResolverInvoker.resolveAllExpressionTypes(
            in: intentionCollection,
            force: true
        )
        
        let syntaxPasses =
            [MandatorySyntaxNodePass.self]
                + astRewriterPassSources.syntaxNodePasses
        
        let applier = ASTRewriterPassApplier(
            passes: syntaxPasses,
            typeSystem: typeSystem,
            globals: globals,
            numThreads: settings.numThreads
        )
        
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

        if settings.stageDiagnostics.contains(.callGraph) {
            let graph = CallGraph.fromIntentions(
                intentionCollection,
                typeSystem: typeSystem
            )

            let graphviz = graph.asGraphviz().generateFile(
                options: .init(simplifyGroups: false)
            )

            print(graphviz)
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
        
        let writer = SwiftWriter(
            intentions: intentionCollection,
            options: writerOptions,
            numThreads: settings.numThreads,
            diagnostics: diagnostics,
            output: outputTarget,
            typeSystem: typeSystem,
            syntaxRewriterApplier: syntaxApplier
        )
        
        if settings.verbose {
            writer.progressListener = progressListener
        }
        
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
        var path = source.sourcePath()
        
        if settings.verbose {
            print("Parsing \((path as NSString).lastPathComponent)...")
        }
        
        path = (path as NSString).deletingPathExtension + ".swift"
        
        // Hit parser cache, if available
        let parser: ObjcParser
        if let parserCache = parserCache {
            parser = try parserCache.loadParsedTree(input: source)
        } else {
            // TODO: Reduce duplication with ObjectiveCParserCache.applyPreprocessors
            let src = try source.loadSource()
            
            let processedSrc = applyPreprocessors(source: src)
            
            parser = ObjcParser(string: processedSrc, fileName: src.filePath, state: state)
            parser.antlrSettings = makeAntlrSettings()
            try parser.parse()
        }
        
        let typeMapper = DefaultTypeMapper(typeSystem: TypeSystem.defaultTypeSystem)
        
        let collectorDelegate = CollectorDelegate(typeMapper: typeMapper)
        
        if settings.stageDiagnostics.contains(.parsedAST) {
            parser.rootNode.printNode({ print($0) })
        }
        
        let ctx = ObjectiveCIntentionCollector.Context()
        
        let fileIntent = FileGenerationIntention(sourcePath: source.sourcePath(), targetPath: path)
        if !parser.preprocessorDirectives.isEmpty {
            fileIntent.headerComments.append(
                "Preprocessor directives found in file:"
            )
            fileIntent.headerComments.append(contentsOf:
                parser.preprocessorDirectives.map(\.string)
            )
        }
        fileIntent.index = index
        fileIntent.isPrimary = source.isPrimary
        ctx.pushContext(fileIntent)
        
        let intentionCollector = ObjectiveCIntentionCollector(delegate: collectorDelegate, context: ctx)
        intentionCollector.collectIntentions(parser.rootNode)
        
        ctx.popContext() // FileGenerationIntention
        
        mutex.locking {
            parsers.append(parser)
            lazyParse.append(contentsOf: collectorDelegate.lazyParse.map {
                (parser, $0)
            })
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
        
        let writer = SwiftSyntaxProducer(settings: writerOptions.toSwiftSyntaxProducerSettings())
        
        let output = writer.generateFile(match)
        
        print("Diagnose file: \(match.targetPath)\ncontext: \(step)")
        print(output)
        print("")
    }
    
    /// Returns a list of all globals within all intentions.
    private func makeGlobalDefinitionsSource() -> DefinitionsSource {
        let globals = CompoundDefinitionsSource()
        
        for provider in globalsProvidersSource.globalsProviders {
            globals.addSource(provider.definitionsSource())
        }

        return globals
    }
    
    private func makeTypeResolverInvoker() -> DefaultTypeResolverInvoker {
        let globals = CompoundDefinitionsSource()

        // Register globals first
        for provider in globalsProvidersSource.globalsProviders {
            globals.addSource(provider.definitionsSource())
        }

        let typeResolverInvoker = DefaultTypeResolverInvoker(
            globals: globals,
            typeSystem: typeSystem,
            numThreads: settings.numThreads
        )
        
        return typeResolverInvoker
    }
    
    private func makeAntlrSettings() -> AntlrSettings {
        AntlrSettings(forceUseLLPrediction: settings.forceUseLLPrediction)
    }
    
    /// Settings for a `ObjectiveC2SwiftRewriter` instance
    public struct Settings {
        /// Gets the default settings for a `ObjectiveC2SwiftRewriter` invocation
        public static var `default`: Self = .init(
            numThreads: 8,
            verbose: false,
            diagnoseFiles: [],
            forceUseLLPrediction: false,
            stageDiagnostics: []
        )
        
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

        public init(
            numThreads: Int,
            verbose: Bool,
            diagnoseFiles: [String],
            forceUseLLPrediction: Bool,
            stageDiagnostics: [StageDiagnosticFlag]
        ) {
            
            self.numThreads = numThreads
            self.verbose = verbose
            self.diagnoseFiles = []
            self.forceUseLLPrediction = forceUseLLPrediction
            self.stageDiagnostics = stageDiagnostics
        }
        
        public enum StageDiagnosticFlag {
            /// Prints result of Objective-C grammar parsing stage.
            case parsedAST

            /// Prints result of call graph from generated IntentionCollection.
            case callGraph
        }
    }
}

// MARK: - ASTRewriterPassApplierProgressDelegate
private extension ObjectiveC2SwiftRewriter {
    class ASTRewriterDelegate: ASTRewriterPassApplierProgressDelegate {
        private var didPrintLine = false
        
        func astWriterPassApplier(
            _ passApplier: ASTRewriterPassApplier,
            applyingPassType passType: ASTRewriterPass.Type,
            toFile file: FileGenerationIntention
        ) {
            
            // Clear previous line and re-print, instead of bogging down the
            // terminal with loads of prints
            if didPrintLine {
                _terminalClearLine()
            }
            
            let totalPadLength = passApplier.progress.total.description.count
            let progressString = String(
                format: "[%0\(totalPadLength)d/%d]",
                passApplier.progress.current,
                passApplier.progress.total
            )
            
            print("\(progressString): \((file.targetPath as NSString).lastPathComponent)")
            
            didPrintLine = true
        }
    }
}

// MARK: - SwiftWriterDelegate
private extension ObjectiveC2SwiftRewriter {
    class InnerSwiftWriterDelegate: SwiftWriterProgressListener {
        private var didPrintLine = false
        
        func swiftWriterReportProgress(
            _ writer: SwiftWriter,
            filesEmitted: Int,
            totalFiles: Int,
            latestFile: FileGenerationIntention
        ) {
            
            // Clear previous line and re-print, instead of bogging down the
            // terminal with loads of prints
            if didPrintLine {
                _terminalClearLine()
            }
            
            let totalPadLength = totalFiles.description.count
            let progressString = String(
                format: "[%0\(totalPadLength)d/%d]",
                filesEmitted,
                totalFiles
            )
            
            print("\(progressString): \((latestFile.targetPath as NSString).lastPathComponent)")
            
            didPrintLine = true
        }
    }
}

// MARK: - ObjectiveCIntentionCollectorDelegate
fileprivate extension ObjectiveC2SwiftRewriter {
    class CollectorDelegate: ObjectiveCIntentionCollectorDelegate {
        var typeMapper: TypeMapper
        
        var lazyParse: [ObjectiveCLazyParseItem] = []
        var lazyResolve: [ObjectiveCLazyTypeResolveItem] = []
        
        init(typeMapper: TypeMapper) {
            self.typeMapper = typeMapper
        }
        
        func isNodeInNonnullContext(_ node: ObjcASTNode) -> Bool {
            node.isInNonnullContext
        }
        
        func reportForLazyResolving(_ item: ObjectiveCLazyTypeResolveItem) {
            lazyResolve.append(item)
        }
        
        func reportForLazyParsing(_ item: ObjectiveCLazyParseItem) {
            lazyParse.append(item)
        }
        
        func typeMapper(for intentionCollector: ObjectiveCIntentionCollector) -> TypeMapper {
            typeMapper
        }
    }

    private class InnerStatementASTReaderDelegate: ObjectiveCStatementASTReaderDelegate {
        var parseItem: ObjectiveCLazyParseItem
        var autotypeDeclarations: [LazyAutotypeVarDeclResolve] = []

        init(parseItem: ObjectiveCLazyParseItem) {
            self.parseItem = parseItem
        }

        func swiftStatementASTReader(
            reportAutoTypeDeclaration varDecl: VariableDeclarationsStatement,
            declarationAtIndex index: Int
        ) {

            autotypeDeclarations.append(
                LazyAutotypeVarDeclResolve(
                    parseItem: parseItem,
                    statement: varDecl,
                    index: index
                )
            )
        }
    }
}

/// Stored '__auto_type' variable declaration that needs to be resolved after
/// statement parsing
private struct LazyAutotypeVarDeclResolve {
    var parseItem: ObjectiveCLazyParseItem
    var statement: VariableDeclarationsStatement
    var index: Int
}

internal func _typeNullability(inType type: ObjcType) -> ObjcNullabilitySpecifier? {
    switch type {
    case .specified(let specifiers, let type):
        
        // Struct types are never null.
        if case .typeName = type {
            return .nonnull
        }
        
        if specifiers.contains(.weak) {
            return .nullable
        } else if specifiers.contains(.unsafeUnretained) {
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
