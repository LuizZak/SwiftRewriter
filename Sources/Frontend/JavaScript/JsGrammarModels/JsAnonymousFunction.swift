import JsParserAntlr

/// Represents an anonymous, in-line JavaScript function declaration.
public struct JsAnonymousFunction {
    /// Identifier for the function.
    ///
    /// Is `nil` for fully anonymous inline functions.
    public var identifier: String?

    /// The signature of this function.
    public var signature: JsFunctionSignature

    /// The body of this anonymous function.
    public var body: Body

    public init(identifier: String? = nil, signature: JsFunctionSignature, body: Body) {
        self.identifier = identifier
        self.signature = signature
        self.body = body
    }

    /// Represents one of the types of anonymous function bodies.
    public enum Body {
        case singleExpression(JavaScriptParser.SingleExpressionContext)
        case functionBody(JavaScriptParser.FunctionBodyContext)
    }
}
