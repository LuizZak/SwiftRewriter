import Foundation

/// Protocol for output targets of `SwiftRewritter` instances.
public protocol RewriterOutputTarget {
    mutating func output(line: String)
    
    /// Called after the entire output operation is finished on this rewriter.
    /// Used to allow post-printing operations to be performed, like string trimming
    /// or passing on the output to a different object etc.
    mutating func onAfterOutput()
}

/// Outputs to a string buffer
public class StringRewriterOutput: RewriterOutputTarget {
    private(set) public var buffer: String = ""
    
    public init() {
        
    }
    
    public func output(line: String) {
        buffer += "\(line)\n"
    }
    
    public func onAfterOutput() {
        buffer = buffer.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
