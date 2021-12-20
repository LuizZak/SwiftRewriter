import Foundation
import AntlrCommons
import ObjectiveCFrontend

public struct Settings {
    /// Settings for the AST writer
    public var astWriter: SwiftSyntaxOptions = .default
    
    /// General settings for `ObjectiveC2SwiftRewriter` instances
    public var rewriter: ObjectiveC2SwiftRewriter.Settings = .default
}

public final class ObjectiveCSwiftRewriterServiceImpl: ObjectiveCSwiftRewriterService {
    public static func fileDisk(settings: Settings) -> ObjectiveCSwiftRewriterService {
        Self(
            output: FileDiskWriterOutput(),
            settings: settings
        )
    }
    
    public static func terminal(settings: Settings, colorize: Bool) -> ObjectiveCSwiftRewriterService {
        Self(
            output: StdoutWriterOutput(colorize: colorize),
            settings: settings
        )
    }
    
    let output: WriterOutput
    let settings: Settings
    let preprocessors: [SourcePreprocessor] = [QuickSpecPreprocessor()]
    let parserStatePool: ObjcParserStatePool
    
    public var parserCache: ObjectiveCParserCache
    
    public init(output: WriterOutput, settings: Settings) {
        let antlrSettings = AntlrSettings(forceUseLLPrediction: settings.rewriter.forceUseLLPrediction)
        
        parserStatePool = ObjcParserStatePool()
        parserCache = ObjectiveCParserCache(fileProvider: FileDiskProvider(),
                                  parserStatePool: parserStatePool,
                                  sourcePreprocessors: preprocessors,
                                  antlrSettings: antlrSettings)
        self.output = output
        self.settings = settings
    }
    
    public func rewrite(files: [URL]) throws {
        let inputFiles = files.map { DiskInputFile(url: $0, isPrimary: true) }
        try rewrite(files: inputFiles)
    }
    
    public func rewrite(files: [DiskInputFile]) throws {
        try rewrite(inputs: files)
    }
    
    public func rewrite(inputs: [InputSource]) throws {
        let input = ArrayInputSourcesProvider(inputs: inputs)
        
        let jobBuilder = SwiftRewriterJobBuilder()
        
        jobBuilder.inputs.addInputs(from: input)
        jobBuilder.intentionPassesSource = DefaultIntentionPasses()
        jobBuilder.astRewriterPassSources = DefaultExpressionPasses()
        jobBuilder.globalsProvidersSource = DefaultGlobalsProvidersSource()
        jobBuilder.syntaxRewriterPassSource = DefaultSyntaxPassProvider()
        jobBuilder.settings = settings.rewriter
        jobBuilder.swiftSyntaxOptions = settings.astWriter
        jobBuilder.preprocessors = preprocessors
        jobBuilder.parserCache = parserCache
        
        let job = jobBuilder.createJob()
        
        let results = job.execute(output: output)
        
        if !results.succeeded {
            print("One or more errors where found while transpiling the input source code.")
            print("See bellow for more information.")
        }
        
        // Print diagnostics
        for diag in results.diagnostics.diagnostics {
            switch diag {
            case .note:
                print("// Note: \(diag)")
            case .warning:
                print("// Warning: \(diag)")
            case .error:
                print("// Error: \(diag)")
            }
        }
    }
}
