import Foundation
import SwiftRewriterLib
import ExpressionPasses
import SourcePreprocessors
import IntentionPasses
import GlobalsProviders

public enum Settings {
    /// Settings for the AST writer
    public static var astWriter = ASTWriterOptions()
    
    /// General settings for `SwiftRewriter` instances
    public static var rewriter: SwiftRewriter.Settings = .default
}

/// Protocol for enabling Swift rewriting service from CLI
public protocol SwiftRewriterService {
    /// Performs a rewrite of the given files
    func rewrite(files: [URL]) throws
}

public class SwiftRewriterServiceImpl: SwiftRewriterService {
    public static func fileDisk() -> SwiftRewriterService {
        return SwiftRewriterServiceImpl(output: FileDiskWriterOutput())
    }
    
    public static func terminal(colorize: Bool) -> SwiftRewriterService {
        return SwiftRewriterServiceImpl(output: StdoutWriterOutput(colorize: colorize))
    }
    
    var output: WriterOutput
    
    public init(output: WriterOutput) {
        self.output = output
    }
    
    public func rewrite(files: [URL]) throws {
        let input = FileInputProvider(files: files)
        
        let jobBuilder = SwiftRewriterJobBuilder()
        
        jobBuilder.inputs.addInputs(from: input)
        jobBuilder.intentionPassesSource = DefaultIntentionPasses()
        jobBuilder.astRewriterPassSources = DefaultExpressionPasses()
        jobBuilder.globalsProvidersSource = DefaultGlobalsProvidersSource()
        jobBuilder.settings = Settings.rewriter
        jobBuilder.astWriterOptions = Settings.astWriter
        jobBuilder.preprocessors = [QuickSpecPreprocessor()]
        
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
