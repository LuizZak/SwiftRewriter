/// Outputs to a string buffer
public final class StringRewriterOutput: RewriterOutputTarget {
    var indentDepth: Int = 0
    var settings: RewriterOutputSettings
    var ignoreCallChange = false
    private(set) public var buffer: String = ""
    
    /// Called everytime the buffer changes due to an output request
    public var onChangeBuffer: ((String) -> Void)?
    
    public init(settings: RewriterOutputSettings = .defaults) {
        self.settings = settings
    }
    
    public func outputRaw(_ text: String) {
        buffer += text
        
        callChangeCallback()
    }
    
    public func output(line: String, style: TextStyle) {
        ignoreCallChange = true
        
        outputIndentation()
        buffer += line
        outputLineFeed()
        
        ignoreCallChange = false
        
        callChangeCallback()
    }
    
    public func outputIndentation() {
        buffer += indentString()
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
    
    public func increaseIndentation() {
        indentDepth += 1
    }
    
    public func decreaseIndentation() {
        guard indentDepth > 0 else { return }
        
        indentDepth -= 1
    }
    
    public func onAfterOutput() {
        buffer = buffer.trimmingWhitespaces()
        
        callChangeCallback()
    }
    
    private func callChangeCallback() {
        if ignoreCallChange {
            return
        }
        
        onChangeBuffer?(buffer)
    }
    
    private func indentString() -> String {
        switch settings.tabStyle {
        case .spaces(let sp):
            return String(repeating: " ", count: sp * indentDepth)
        case .tabs:
            return String(repeating: "\t", count: indentDepth)
        }
    }
}
