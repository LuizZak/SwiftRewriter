#if canImport(ObjectiveC)
import ObjectiveC
#endif

import Foundation
import Dispatch
import Utils
import AntlrCommons
import GrammarModelBase
import JsGrammarModels
import JsParser
import SwiftAST
import TypeSystem
import WriterTargetOutput
import Intentions
import Analysis
import IntentionPasses
import ExpressionPasses
import SourcePreprocessors
import SwiftSyntaxSupport
import Utils
import SwiftRewriterLib

private typealias NonnullTokenRange = (start: Int, end: Int)

/// Main front-end for Swift Rewriter
public final class JavaScript2SwiftRewriter {
    private static var _parserStatePool: JsParserStatePool = JsParserStatePool()

    /// The default settings for the underlying syntax writer.
    public static let defaultWriterOptions: SwiftSyntaxOptions = .default.with(\.alwaysEmitVariableTypes, true)
    
    private let sourcesProvider: InputSourcesProvider
    private var outputTarget: WriterOutput
    
    private let typeMapper: TypeMapper
    private let intentionCollection: IntentionCollection
    private var typeSystem: IntentionCollectionTypeSystem
    
    /// For pooling and reusing Antlr parser states to aid in performance
    private var parserStatePool: JsParserStatePool { JavaScript2SwiftRewriter._parserStatePool }
    
    /// To keep token sources alive long enough.
    private var parsers: [JsParser] = []
    
    /// An optional instance of a parser cache with pre-parsed input files.
    public var parserCache: JavaScriptParserCache?
    
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
    
    /// Describes settings for the current `JavaScript2SwiftRewriter` invocation
    public var settings: Settings

    /// Describes settings to pass to the AST writers when outputting code
    public var writerOptions: SwiftSyntaxOptions = JavaScript2SwiftRewriter.defaultWriterOptions
    
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
        parsers.removeAll()
        intentionCollection.removeAll()

        try autoreleasepool {
            let lazyParse = try loadInputSources()

            if settings.emitJavaScriptObject {
                emitJavaScriptObject()
            }

            parseStatements(lazyParse)
            resolveAutotypeDeclarations(lazyParse)
            performIntentionAndSyntaxPasses(intentionCollection)
            outputDefinitions(intentionCollection)
        }
    }
    
    private func loadInputSources() throws -> [LazyParseItem] {
        // Load input sources
        let sources = sourcesProvider.sources()
        
        let queue = ConcurrentOperationQueue()
        queue.maxConcurrentOperationCount = settings.numThreads
        
        let outError: ConcurrentValue<Error?> = ConcurrentValue(wrappedValue: nil)
        let mutex = Mutex()
        var lazyParse: [LazyParseItem] = []
        
        for (i, src) in sources.enumerated() {
            queue.addOperation {
                if outError.wrappedValue != nil {
                    return
                }
                
                do {
                    try autoreleasepool {
                        let result = try self.loadJsSource(from: src, index: i, mutex: mutex)

                        mutex.locking {
                            lazyParse.append(contentsOf: result)
                        }
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

        return lazyParse
    }
    
    /// Emits a `JavaScriptObject` type generation intention along with the
    /// currently parsed intentions.
    ///
    /// Must be called with at least one intention parsed, in order to have a
    /// base path to use for the generated file intention.
    private func emitJavaScriptObject() {
        if settings.verbose {
            print("Emitting JavaScriptObject...")
        }

        let intention = JavaScriptObjectGenerator().generateTypeIntention()
        
        // Find the common path root across all generation intentions for the
        // synthesized intention
        var path: [String]?
        for file in intentionCollection.fileIntentions() {
            let components = (file.targetPath as NSString).pathComponents
            if let current = path {
                path = zip(components, current).split(whereSeparator: { $0 != $1 }).first?.map { $0.0 }
            } else {
                path = components.dropLast()
            }
        }

        path?.append("JavaScriptObject.swift")

        if let path = path, let first = path.first {
            let basePath = path.dropFirst().reduce(first) { ($0 as NSString).appendingPathComponent($1) }
            
            let file = FileGenerationIntention(
                sourcePath: "<generated>",
                targetPath: basePath
            )

            file.addType(intention)

            intentionCollection.addIntention(file)
        } else {
            if settings.verbose {
                print("Failed to find potential target path for JavaScriptObject.swift. Emitting into first file found instead...")
            }

            // Failed to find a proper file path: Emit on the first input file,
            // sorted alphabetically
            let sorted = intentionCollection.fileIntentions().sorted { 
                URL(fileURLWithPath: $0.targetPath).lastPathComponent < URL(fileURLWithPath: $1.targetPath).lastPathComponent
            }

            if let first = sorted.first {
                first.addType(intention)
            } else {
                // Failed - emit error
                diagnostics.error(
                    "Error emitting JavaScriptObject type: No file found to insert generated type in.",
                    origin: "<generated>",
                    location: .invalid
                )
            }
        }
    }

    /// Parses all statements now, with proper type information available.
    private func parseStatements(_ items: [LazyParseItem]) {
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
        
        let queue = ConcurrentOperationQueue()
        queue.maxConcurrentOperationCount = settings.numThreads
        
        for item in items {
            let source: Source
            switch item {
            case .globalFunction(let s, _, _),
                .method(let s, _, _),
                .globalVar(let s, _, _),
                .classProperty(let s, _, _):

                source = s
            }

            queue.addOperation {
                autoreleasepool {
                    let delegate = InnerASTReaderDelegate(parseItem: item)

                    let state = JavaScript2SwiftRewriter._parserStatePool.pull()
                    defer {
                        JavaScript2SwiftRewriter._parserStatePool.repool(state)
                    }
                    
                    let reader = JavaScriptASTReader(
                        source: source,
                        typeSystem: self.typeSystem,
                        options: self.makeASTReaderOptions()
                    )
                    reader.delegate = delegate
                    
                    switch item {
                    case let .globalFunction(_, funcBody, _):
                        guard let sourceBody = funcBody.typedSource else {
                            return
                        }
                        guard let body = sourceBody.body else {
                            return
                        }
                        
                        funcBody.body =
                            reader.parseStatements(
                                body: body,
                                comments: sourceBody.comments,
                                typeContext: nil
                            )
                    
                    case let .method(_, funcBody, method):
                        guard let sourceBody = funcBody.typedSource else {
                            return
                        }
                        guard let body = sourceBody.body else {
                            return
                        }
                        
                        funcBody.body =
                            reader.parseStatements(
                                body: body,
                                comments: sourceBody.comments,
                                typeContext: method.type
                            )
                    
                    case .classProperty(_, let initialValue, _):
                        guard let expression = initialValue.typedSource?.expression else {
                            return
                        }
                        
                        initialValue.expression = reader.parseExpression(expression: expression)
                        
                    case .globalVar(_, let v, _):
                        guard let expression = v.typedSource?.expression else {
                            return
                        }
                        
                        v.expression = reader.parseExpression(expression: expression)
                    }
                }
            }
        }
        
        queue.runAndWaitConcurrent()
    }
    
    /// Evaluate all type signatures, now with the knowledge of all types present
    /// in the program.
    private func evaluateTypes() {
        if settings.verbose {
            print("Resolving member types...")
        }
        
        typeSystem.makeCache()
        defer {
            typeSystem.tearDownCache()
        }

        fatalError("Not implemented")
    }

    private func resolveAutotypeDeclarations(_ items: [LazyParseItem]) {
        let typeResolverInvoker = makeTypeResolverInvoker()

        // Make a pre-type resolve before propagating types
        typeResolverInvoker.resolveAllExpressionTypes(
            in: intentionCollection,
            force: true
        )

        let baseType = SwiftType.any

        let makePropagator: (ExpressionTypeResolver) -> DefinitionTypePropagator = { [typeSystem] in
            return DefinitionTypePropagator(
                options: .init(
                    baseType: baseType,
                    baseNumericType: .double,
                    baseStringType: nil
                ),
                typeSystem: typeSystem,
                typeResolver: $0
            )
        }

        for item in items {
            let typeResolverDelegate = typeResolverInvoker.makeQueueDelegate()

            let functionBody: FunctionBodyIntention
            let typeResolver: ExpressionTypeResolver

            switch item {
            case .globalVar(_, let value, let intention):
                typeResolver = typeResolverDelegate.makeContext(forGlobalVariable: intention, initializer: value).typeResolver

                let typePropagator = makePropagator(typeResolver)
                value.expression = typePropagator.propagate(value.expression)
                
                continue
            
            case .classProperty(_, let value, let intention):
                typeResolver = typeResolverDelegate.makeContext(forProperty: intention, initializer: value).typeResolver

                let typePropagator = makePropagator(typeResolver)
                value.expression = typePropagator.propagate(value.expression)

                continue

            case .method(_, let body, let intention):
                functionBody = body
                typeResolver = typeResolverDelegate.makeContext(forMethod: intention).typeResolver

            case .globalFunction(_, let body, let intention):
                functionBody = body
                typeResolver = typeResolverDelegate.makeContext(forFunction: intention).typeResolver
            }

            let typePropagator = makePropagator(typeResolver)
            functionBody.body = typePropagator.propagate(functionBody.body)
        }
    }
    
    private func performIntentionAndSyntaxPasses(_ intentionCollection: IntentionCollection) {
        let globals = CompoundDefinitionsSource()
        
        if settings.verbose {
            print("Running intention passes...")
        }
        
        // Register globals first
        for provider in globalsProvidersSource.globalsProviders {
            globals.addSource(provider.definitionsSource())
        }
        
        let typeResolverInvoker = makeTypeResolverInvoker()
        
        // Make a pre-type resolve before applying passes
        typeResolverInvoker.resolveAllExpressionTypes(in: intentionCollection, force: true)
        
        var requiresResolve = false
        
        let context =
            IntentionPassContext(typeSystem: typeSystem,
                                 typeMapper: typeMapper,
                                 typeResolverInvoker: typeResolverInvoker,
                                 numThreads: settings.numThreads,
                                 notifyChange: { requiresResolve = true })
        
        let intentionPasses = intentionPassesSource.intentionPasses
        
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
                    let progressString =
                        String(
                            format: "[%0\(totalPadLength)d/%d]",
                            i + 1,
                            intentionPasses.count
                        )
                    
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
        
        let syntaxPasses = astRewriterPassSources.syntaxNodePasses
        
        let applier =
            ASTRewriterPassApplier(
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
        
        typeSystem.tearDownCache()
    }
    
    private func outputDefinitions(_ intentionCollection: IntentionCollection) {
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
    
    private func loadJsSource(from source: InputSource, index: Int, mutex: Mutex) throws -> [LazyParseItem] {
        let state = parserStatePool.pull()
        defer { parserStatePool.repool(state) }
        
        // Generate intention for this source
        var path = source.sourcePath()
        
        if settings.verbose {
            print("Parsing \((path as NSString).lastPathComponent)...")
        }
        
        path = (path as NSString).deletingPathExtension + ".swift"
        
        // Hit parser cache, if available
        let parser: JsParser
        if let parserCache = parserCache {
            parser = try parserCache.loadParsedTree(input: source)
        } else {
            // TODO: Reduce duplication with JavaScriptParserCache.applyPreprocessors
            let src = try source.loadSource()
            
            let processedSrc = applyPreprocessors(source: src)
            
            parser = JsParser(string: processedSrc, fileName: src.filePath, state: state)
            parser.antlrSettings = makeAntlrSettings()
            try parser.parse()
        }
        
        let collectorDelegate = CollectorDelegate(source: parser.source)
        
        if settings.stageDiagnostics.contains(.parsedAST) {
            parser.rootNode.printNode({ print($0) })
        }
        
        let ctx = JavaScriptIntentionCollector.Context()
        
        let fileIntent = FileGenerationIntention(sourcePath: source.sourcePath(), targetPath: path)
        fileIntent.index = index
        fileIntent.isPrimary = source.isPrimary
        ctx.pushContext(fileIntent)
        
        let intentionCollector = JavaScriptIntentionCollector(delegate: collectorDelegate, context: ctx)
        intentionCollector.collectIntentions(parser.rootNode)
        
        assert(
            ctx.popContext() is FileGenerationIntention,
            "Expected \(FileGenerationIntention.self) to be last element on the stack after intention collection."
        )
        
        mutex.locking {
            parsers.append(parser)
            diagnostics.merge(with: parser.diagnostics)
            intentionCollection.addIntention(fileIntent)
        }
        
        return collectorDelegate.lazyParse
    }
    
    private func applyPreprocessors(source: CodeSource) -> String {
        let src = source.fetchSource()
        
        let context = _PreprocessingContext(filePath: source.filePath)
        
        return preprocessors.reduce(src) {
            $1.preprocess(source: $0, context: context)
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
    
    private func makeTypeResolverInvoker() -> DefaultTypeResolverInvoker {
        let globals = CompoundDefinitionsSource()

        // Register globals first
        for provider in globalsProvidersSource.globalsProviders {
            globals.addSource(provider.definitionsSource())
        }

        let typeResolverInvoker =
            DefaultTypeResolverInvoker(globals: globals, typeSystem: typeSystem,
                                       numThreads: settings.numThreads)
        
        return typeResolverInvoker
    }
    
    private func makeAntlrSettings() -> AntlrSettings {
        AntlrSettings(forceUseLLPrediction: settings.forceUseLLPrediction)
    }

    private func makeASTReaderOptions() -> JavaScriptASTReaderOptions {
        var options = JavaScriptASTReaderOptions.default

        if settings.emitJavaScriptObject {
            options.objectLiteralKind = .javaScriptObject()
        }

        return options
    }
    
    /// Settings for a `JavaScript2SwiftRewriter` instance
    public struct Settings {
        /// Gets the default settings for a `JavaScript2SwiftRewriter` invocation
        public static var `default`: Self = .init(
            numThreads: 8,
            verbose: false,
            diagnoseFiles: [],
            forceUseLLPrediction: false,
            stageDiagnostics: [],
            emitJavaScriptObject: false
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

        /// Whether to emit JavaScript object declarations wrapped in a JavaScriptObject
        /// declaration.
        /// If specified, this will also emit a new file along the output for
        /// the JavaScriptObject type definition.
        public var emitJavaScriptObject: Bool

        public init(
            numThreads: Int,
            verbose: Bool,
            diagnoseFiles: [String],
            forceUseLLPrediction: Bool,
            stageDiagnostics: [StageDiagnosticFlag],
            emitJavaScriptObject: Bool
        ) {
            self.numThreads = numThreads
            self.verbose = verbose
            self.diagnoseFiles = []
            self.forceUseLLPrediction = forceUseLLPrediction
            self.stageDiagnostics = stageDiagnostics
            self.emitJavaScriptObject = emitJavaScriptObject
        }
        
        /// To ease modifications of single parameters from default settings
        /// without having to create a temporary variable first
        public func with<T>(_ keyPath: WritableKeyPath<Self, T>, _ value: T) -> Self {
            var copy = self
            copy[keyPath: keyPath] = value
            return copy
        }
        
        public enum StageDiagnosticFlag {
            /// Prints result of grammar parsing stage
            case parsedAST
        }
    }
}

// MARK: - ASTRewriterPassApplierProgressDelegate
private extension JavaScript2SwiftRewriter {
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
private extension JavaScript2SwiftRewriter {
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

// MARK: - JavaScriptIntentionCollectorDelegate
fileprivate extension JavaScript2SwiftRewriter {
    class CollectorDelegate: JavaScriptIntentionCollectorDelegate {
        let source: Source

        var lazyParse: [LazyParseItem] = []

        init(source: Source) {
            self.source = source
        }

        func reportForLazyParsing(_ item: JavaScriptLazyParseItem) {
            switch item {
            case .globalVar(let value, let intention):
                lazyParse.append(.globalVar(source, value, intention))
            
            case .classProperty(let value, let intention):
                lazyParse.append(.classProperty(source, value, intention))
                
            case .globalFunction(let body, let intention):
                lazyParse.append(.globalFunction(source, body, intention))
            
            case .method(let body, let intention):
                lazyParse.append(.method(source, body, intention))
            }
        }
    }

    private class InnerASTReaderDelegate: JavaScriptASTReaderDelegate {
        var parseItem: LazyParseItem

        init(parseItem: LazyParseItem) {
            self.parseItem = parseItem
        }
    }
}

private enum LazyParseItem {
    case globalFunction(Source, FunctionBodyIntention, GlobalFunctionGenerationIntention)
    case method(Source, FunctionBodyIntention, MethodGenerationIntention)
    case classProperty(Source, PropertyInitialValueGenerationIntention, PropertyGenerationIntention)
    case globalVar(Source, GlobalVariableInitialValueIntention, GlobalVariableGenerationIntention)
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
