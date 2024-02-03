import JsParserAntlr

/// An expression for a variable definition.
public final class JsExpressionNode: JsASTNode {
    public var expression: JavaScriptParser.SingleExpressionContext?
}
