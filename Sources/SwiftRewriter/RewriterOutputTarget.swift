import Foundation

/// Defines settings for a rewriter output target to follow when writing code
public struct RewriterOutputSettings {
    public var tabStyle: TabStyle
    
    public init(tabStyle: TabStyle) {
        self.tabStyle = tabStyle
    }
    
    public enum TabStyle {
        case spaces(Int)
        case tabs
    }
    
    /// Default settings
    public static var defaults = RewriterOutputSettings(tabStyle: .spaces(4))
}

/// Protocol for output targets of `SwiftRewritter` instances.
public protocol RewriterOutputTarget: class {
    init(settings: RewriterOutputSettings)
    
    func output(line: String)
    
    /// Increases the identation of output lines from this output target
    func increaseIdentation()
    
    /// Decreases the identation of output lines from this output target
    func decreaseIdentation()
    
    /// Performs a series of operations while idented, decreasing the identation
    /// automatically after.
    func idented(perform block: () -> ())
    
    /// Called after the entire output operation is finished on this rewriter.
    /// Used to allow post-printing operations to be performed, like string trimming
    /// or passing on the output to a different object etc.
    func onAfterOutput()
}

public extension RewriterOutputTarget {
    func idented(perform block: () -> ()) {
        increaseIdentation()
        block()
        decreaseIdentation()
    }
}

/// Outputs to a string buffer
public final class StringRewriterOutput: RewriterOutputTarget {
    private var identDepth: Int = 0
    private var settings: RewriterOutputSettings
    private(set) public var buffer: String = ""
    
    /// Called everytime the buffer changes due to an output request
    public var onChangeBuffer: ((String) -> Void)?
    
    required public init(settings: RewriterOutputSettings = .defaults) {
        self.settings = settings
    }
    
    public func output(line: String) {
        buffer += identString()
        buffer += line
        buffer += "\n"
        
        onChangeBuffer?(buffer)
    }
    
    public func increaseIdentation() {
        identDepth += 1
    }
    
    public func decreaseIdentation() {
        identDepth -= 1
    }
    
    public func onAfterOutput() {
        buffer = buffer.trimmingCharacters(in: .whitespacesAndNewlines)
        
        onChangeBuffer?(buffer)
    }
    
    private func identString() -> String {
        switch settings.tabStyle {
        case .spaces(let sp):
            return String(repeating: " ", count: sp * identDepth)
        case .tabs:
            return String(repeating: "\t", count: identDepth)
        }
    }
}
