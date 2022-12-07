import ObjcParserAntlr

/// A global variable declaration.
public class VariableDeclaration: ASTNode, InitializableNode {
    public var type: TypeNameNode? {
        firstChild()
    }
    
    public var identifier: Identifier? {
        firstChild()
    }
    
    public var initialExpression: InitialExpression? {
        firstChild()
    }

    /// Whether this variable was defined with a `static` storage modifier.
    public var isStatic: Bool = false
    
    public required init(isInNonnullContext: Bool) {
        super.init(isInNonnullContext: isInNonnullContext)
    }
}

/// Represents the initial expression for a global variable definition.
public class InitialExpression: ASTNode, InitializableNode {
    public var expression: ExpressionNode? {
        firstChild()
    }
    
    public required init(isInNonnullContext: Bool) {
        super.init(isInNonnullContext: isInNonnullContext)
    }
}

/// Represents a constant expression used as the initial value to global variables
/// parsed from a source file.
public class ConstantExpressionNode: ASTNode {
    public var expression: ExpressionKind?

    /// Specifies how an expression is stored in this `ConstantExpressionNode`.
    public enum ExpressionKind {
        /// Expression is stored as a parsed ANTLR context.
        case antlr(ObjectiveCParser.ConstantExpressionContext)

        /// Expression is stored as a string representation of the original source
        /// code that the expression represents.
        ///
        /// Must be parsable back into an Objective-C expression later.
        case string(String)

        public var constantExpressionContext: ObjectiveCParser.ConstantExpressionContext? {
            switch self {
            case .antlr(let value):
                return value
            default:
                return nil
            }
        }
    }
}

/// A node containing an unprocessed expression parser rule context.
public final class ExpressionNode: ASTNode {
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
