/// A global variable declaration.
public class VariableDeclaration: ObjcASTNode, ObjcInitializableNode {
    public var type: TypeNameNode? {
        firstChild()
    }
    
    public var identifier: Identifier? {
        firstChild()
    }
    
    public var initialExpression: InitialExpression? {
        firstChild()
    }
    
    public required init(isInNonnullContext: Bool) {
        super.init(isInNonnullContext: isInNonnullContext)
    }
}

/// Represents the initial expression for a global variable definition.
public class InitialExpression: ObjcASTNode, ObjcInitializableNode {
    public var constantExpression: ConstantExpressionNode? {
        firstChild()
    }
    
    public required init(isInNonnullContext: Bool) {
        super.init(isInNonnullContext: isInNonnullContext)
    }
}

/// Represents a constant expression used as the initial value to global variables
/// parsed from a source file.
public class ConstantExpressionNode: ObjcASTNode, ObjcInitializableNode {
    public var expression: ExpressionNode? {
        firstChild()
    }
    
    public required init(isInNonnullContext: Bool) {
        super.init(isInNonnullContext: isInNonnullContext)
    }
}
