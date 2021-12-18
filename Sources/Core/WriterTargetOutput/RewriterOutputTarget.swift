import Utils

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
public protocol RewriterOutputTarget: AnyObject {
    /// Outputs a raw series of characters, with no indentation or extra line
    /// feed
    func outputRaw(_ text: String)
    
    /// Outputs the given string with a `.plain` text style and outputs a line
    /// feed at the end, with padding for indentation at the begginning.
    func output(line: String)
    
    /// Outputs a given string inline with a `.plain` text style without adding
    /// a line feed at the end.
    func outputInline(_ content: String)
    
    /// Outputs the given string and outputs a line feed at the end, with padding
    /// for indentation at the begginning.
    func output(line: String, style: TextStyle)
    
    /// Outputs a given string inline without adding a line feed at the end.
    func outputInline(_ content: String, style: TextStyle)
    
    /// Outputs a given string inline and follows it with a space without adding
    /// a line feed at the end.
    /// The style is not applied to the spacing string.
    func outputInlineWithSpace(_ content: String, style: TextStyle)
    
    /// Outputs a line feed character at the current position
    func outputLineFeed()
    
    /// Outputs the current indentation spacing at the current location.
    func outputIndentation()
    
    /// Increases the indentation of output lines from this output target
    func increaseIndentation()
    
    /// Decreases the indentation of output lines from this output target
    func decreaseIndentation()
    
    /// Performs a series of operations while indented, decreasing the indentation
    /// automatically after.
    func indented(perform block: () -> Void)
    
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
    
    func indented(perform block: () -> Void) {
        increaseIndentation()
        block()
        decreaseIndentation()
    }
}
