/// A rewriter output target that ignores all incoming data requests and produces
/// no output.
public class NullRewriterOutputTarget: RewriterOutputTarget {
    public init() {
        
    }
    
    public func outputInline(_ content: String, style: TextStyle) {
        
    }
    
    public func output(line: String, style: TextStyle) {
        
    }
    
    public func outputRaw(_ text: String) {
        
    }
    
    public func outputLineFeed() {
        
    }
    
    public func outputIndentation() {
        
    }
    
    public func increaseIndentation() {
        
    }
    
    public func decreaseIndentation() {
        
    }
    
    public func onAfterOutput() {
        
    }
}
