import JsParserAntlr

/// A body of a JavaScript function declaration.
public final class JsFunctionBodyNode: JsASTNode, JsInitializableNode {
    public var body: JavaScriptParser.FunctionBodyContext?
    
    public override var shortDescription: String {
        body?.getText() ?? ""
    }

    public init() {
        super.init()
    }
}
