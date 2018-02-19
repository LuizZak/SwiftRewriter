import Foundation
import SwiftRewriterLib
import ExpressionPasses
import SourcePreprocessors

/// Protocol for enabling Swift rewriting service from CLI
public protocol SwiftRewriterService {
    /// Performs a rewrite of the given files
    func rewrite(files: [URL]) throws
}

public class SwiftRewriterServiceImpl: SwiftRewriterService {
    var output: WriterOutput
    
    public init(output: WriterOutput) {
        self.output = output
    }
    
    public func rewrite(files: [URL]) throws {
        let input = FileInputProvider(files: files)
        
        let converter = SwiftRewriter(input: input, output: output)
        
        converter.preprocessors.append(QuickSpecPreprocessor())
        
        converter.expressionPasses.append(AllocInitExpressionPass())
        converter.expressionPasses.append(CoreGraphicsExpressionPass())
        converter.expressionPasses.append(FoundationExpressionPass())
        converter.expressionPasses.append(UIKitExpressionPass())
        
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
