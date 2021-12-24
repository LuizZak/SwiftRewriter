import JsParserAntlr
import GrammarModelBase

/// A body of a JavaScript function declaration.
public final class JsFunctionBodyNode: JsASTNode, JsInitializableNode {
    public var body: JavaScriptParser.FunctionBodyContext?
    
    /// List of comments found within the range of this method body
    public var comments: [CodeComment] = []
    
    public override var shortDescription: String {
        body?.getText() ?? ""
    }

    public init() {
        super.init()
    }
}
