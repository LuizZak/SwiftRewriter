import ObjcParserAntlr

/// A global variable declaration.
public class ObjcVariableDeclarationNode: ObjcASTNode, ObjcInitializableNode {
    public var type: ObjcTypeNameNode? {
        firstChild()
    }
    
    public var identifier: ObjcIdentifierNode? {
        firstChild()
    }
    
    public var initialExpression: ObjcInitialExpressionNode? {
        firstChild()
    }

    /// Whether this variable was defined with a `static` storage modifier.
    public var isStatic: Bool = false
    
    public required init(isInNonnullContext: Bool) {
        super.init(isInNonnullContext: isInNonnullContext)
    }
}

/// Represents the initial expression for a global variable definition.
public class ObjcInitialExpressionNode: ObjcASTNode, ObjcInitializableNode {
    public var expression: ObjcExpressionNode? {
        firstChild()
    }
    
    public required init(isInNonnullContext: Bool) {
        super.init(isInNonnullContext: isInNonnullContext)
    }
}

/// Represents a constant expression used as the initial value to global variables
/// parsed from a source file.
public class ObjcConstantExpressionNode: ObjcASTNode, ObjcInitializableNode {
    public var expression: ExpressionKind?

    public required init(isInNonnullContext: Bool) {
        super.init(isInNonnullContext: isInNonnullContext)
    }

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
