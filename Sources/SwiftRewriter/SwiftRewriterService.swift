import Foundation
import SwiftRewriterLib
import ExpressionPasses
import SourcePreprocessors
import IntentionPasses

var options = ASTWriterOptions()
var verbose = false

/// Protocol for enabling Swift rewriting service from CLI
public protocol SwiftRewriterService {
    /// Performs a rewrite of the given files
    func rewrite(files: [URL]) throws
}

public class SwiftRewriterServiceImpl: SwiftRewriterService {
    public static var fileDiskService = SwiftRewriterServiceImpl(output: FileDiskWriterOutput())
    
    var output: WriterOutput
    
    public init(output: WriterOutput) {
        self.output = output
    }
    
    public func rewrite(files: [URL]) throws {
        let input = FileInputProvider(files: files)
        
        let converter = SwiftRewriter(input: input, output: output)
        
        converter.preprocessors.append(QuickSpecPreprocessor())
        
        converter.syntaxNodeRewriters.append(ASTSimplifier.self)
        converter.syntaxNodeRewriters.append(AllocInitExpressionPass.self)
        converter.syntaxNodeRewriters.append(CoreGraphicsExpressionPass.self)
        converter.syntaxNodeRewriters.append(FoundationExpressionPass.self)
        converter.syntaxNodeRewriters.append(UIKitExpressionPass.self)
        converter.syntaxNodeRewriters.append(NilValueTransformationsPass.self)
        
        converter.writerOptions = options
        converter.verbose = verbose
        
        converter.intentionPassesSource = DefaultIntentionPasses()
        
        try converter.rewrite()
        
        // Print diagnostics
        for diag in converter.diagnostics.diagnostics {
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
