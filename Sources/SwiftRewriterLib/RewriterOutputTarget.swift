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

/// Protocol for output targets of `SwiftRewriter` instances.
public protocol RewriterOutputTarget: class {
    /// Outputs the given string with a `.plain` text style and outputs a line
    /// feed at the end, with padding for identation at the begginning.
    func output(line: String)
    
    /// Outputs a given string inline with a `.plain` text style without adding
    /// a line feed at the end.
    func outputInline(_ content: String)
    
    /// Outputs the given string and outputs a line feed at the end, with padding
    /// for identation at the begginning.
    func output(line: String, style: TextStyle)
    
    /// Outputs a given string inline without adding a line feed at the end.
    func outputInline(_ content: String, style: TextStyle)
    
    /// Outputs a given string inline and follows it with a space without adding
    /// a line feed at the end.
    /// The style is not applied to the spacing string.
    func outputInlineWithSpace(_ content: String, style: TextStyle)
    
    /// Outputs a line feed character at the current position
    func outputLineFeed()
    
    /// Outputs the current identation spacing at the current location.
    func outputIdentation()
    
    /// Increases the identation of output lines from this output target
    func increaseIdentation()
    
    /// Decreases the identation of output lines from this output target
    func decreaseIdentation()
    
    /// Performs a series of operations while idented, decreasing the identation
    /// automatically after.
    func idented(perform block: () -> Void)
    
    /// Called after the entire output operation is finished on this rewriter.
    /// Used to allow post-printing operations to be performed, like string trimming
    /// or passing on the output to a different object etc.
    func onAfterOutput()
}

/// Defines the style of a text to emit.
public enum TextStyle {
    case plain
    case keyword
    case attribute
    case typeName
    case stringLiteral
    case numberLiteral
    case comment
    case directive
    case memberName
}

public extension RewriterOutputTarget {
    
    func output(line: String) {
        output(line: line, style: .plain)
    }
    
    func outputInline(_ content: String) {
        outputInline(content, style: .plain)
    }
    
    func outputInlineWithSpace(_ content: String, style: TextStyle) {
        outputInline(content, style: style)
        outputInline(" ")
    }
    
    func idented(perform block: () -> Void) {
        increaseIdentation()
        block()
        decreaseIdentation()
    }
}

/// Outputs to a string buffer
public final class StringRewriterOutput: RewriterOutputTarget {
    private var identDepth: Int = 0
    private var settings: RewriterOutputSettings
    private var ignoreCallChange = false
    private(set) public var buffer: String = ""
    
    /// Called everytime the buffer changes due to an output request
    public var onChangeBuffer: ((String) -> Void)?
    
    public init(settings: RewriterOutputSettings = .defaults) {
        self.settings = settings
    }
    
    public func output(line: String, style: TextStyle) {
        ignoreCallChange = true
        
        outputIdentation()
        buffer += line
        outputLineFeed()
        
        ignoreCallChange = false
        
        callChangeCallback()
    }
    
    public func outputIdentation() {
        buffer += identString()
        callChangeCallback()
    }
    
    public func outputLineFeed() {
        buffer += "\n"
        callChangeCallback()
    }
    
    public func outputInline(_ content: String, style: TextStyle) {
        buffer += content
        callChangeCallback()
    }
    
    public func increaseIdentation() {
        identDepth += 1
    }
    
    public func decreaseIdentation() {
        identDepth -= 1
    }
    
    public func onAfterOutput() {
        buffer = buffer.trimmingCharacters(in: .whitespacesAndNewlines)
        
        callChangeCallback()
    }
    
    private func callChangeCallback() {
        if ignoreCallChange {
            return
        }
        
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
