/// A global variable declaration.
public class ObjcVariableDeclaration: ObjcASTNode, ObjcInitializableNode {
    public var type: ObjcTypeNameNode? {
        firstChild()
    }
    
    public var identifier: Identifier? {
        firstChild()
    }
    
    public var initialExpression: ObjcInitialExpression? {
        firstChild()
    }
    
    public required init(isInNonnullContext: Bool) {
        super.init(isInNonnullContext: isInNonnullContext)
    }
}

/// Represents the initial expression for a global variable definition.
public class ObjcInitialExpression: ObjcASTNode, ObjcInitializableNode {
    public var constantExpression: ObjcConstantExpressionNode? {
        firstChild()
    }
    
    public required init(isInNonnullContext: Bool) {
        super.init(isInNonnullContext: isInNonnullContext)
    }
}

/// Represents a constant expression used as the initial value to global variables
/// parsed from a source file.
public class ObjcConstantExpressionNode: ObjcASTNode, ObjcInitializableNode {
    public var expression: ExpressionNode? {
        firstChild()
    }
    
    public required init(isInNonnullContext: Bool) {
        super.init(isInNonnullContext: isInNonnullContext)
    }
}
