import Foundation
import SwiftRewriterLib
import ExpressionPasses
import SourcePreprocessors
import IntentionPasses
import GlobalsProviders
import SwiftSyntaxRewriterPasses
import ObjcParser

public struct Settings {
    /// Settings for the AST writer
    public var astWriter = SwiftSyntaxOptions()
    
    /// General settings for `SwiftRewriter` instances
    public var rewriter: SwiftRewriter.Settings = .default
}

/// Protocol for enabling Swift rewriting service from CLI
public protocol SwiftRewriterService {
    /// Gets the input parser cache to be used during rewriting
    var parserCache: ParserCache { get }
    
    /// Performs a rewrite of the given files
    func rewrite(files: [URL]) throws

    /// Performs a rewrite of the given files
    func rewrite(files: [DiskInputFile]) throws
}

public class SwiftRewriterServiceImpl: SwiftRewriterService {
    public static func fileDisk(settings: Settings) -> SwiftRewriterService {
        SwiftRewriterServiceImpl(output: FileDiskWriterOutput(),
                                 settings: settings)
    }
    
    public static func terminal(settings: Settings, colorize: Bool) -> SwiftRewriterService {
        SwiftRewriterServiceImpl(output: StdoutWriterOutput(colorize: colorize),
                                 settings: settings)
    }
    
    let output: WriterOutput
    let settings: Settings
    let preprocessors: [SourcePreprocessor] = [QuickSpecPreprocessor()]
    let parserStatePool: ObjcParserStatePool
    
    public var parserCache: ParserCache
    
    public init(output: WriterOutput, settings: Settings) {
        let antlrSettings = AntlrSettings(forceUseLLPrediction: settings.rewriter.forceUseLLPrediction)
        
        parserStatePool = ObjcParserStatePool()
        parserCache = ParserCache(fileProvider: FileDiskProvider(),
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
        let input = ArrayInputSourcesProvider(files: files)
        
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
