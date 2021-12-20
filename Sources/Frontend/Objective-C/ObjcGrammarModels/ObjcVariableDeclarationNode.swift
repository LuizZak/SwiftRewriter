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
    
    public required init(isInNonnullContext: Bool) {
        super.init(isInNonnullContext: isInNonnullContext)
    }
}

/// Represents the initial expression for a global variable definition.
public class ObjcInitialExpressionNode: ObjcASTNode, ObjcInitializableNode {
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
    public var expression: ObjcExpressionNode? {
        firstChild()
    }
    
    public required init(isInNonnullContext: Bool) {
        super.init(isInNonnullContext: isInNonnullContext)
    }
}
