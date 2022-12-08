import ObjcParserAntlr

/// A node containing an unprocessed expression parser rule context.
public final class ObjcExpressionNode: ObjcASTNode {
    public var expression: ExpressionKind?

    /// Specifies how an expression is stored in this `ExpressionNode`.
    public enum ExpressionKind {
        /// Expression is stored as a parsed ANTLR context.
        case antlr(ObjectiveCParser.ExpressionContext)

        /// Expression is stored as a string representation of the original source
        /// code that the expression represents.
        ///
        /// Must be parsable back into an Objective-C expression later.
        case string(String)

        public var expressionContext: ObjectiveCParser.ExpressionContext? {
            switch self {
            case .antlr(let value):
                return value
            default:
                return nil
            }
        }
    }
}
