/// A global variable declaration.
public class VariableDeclaration: ASTNode, InitializableNode {
    public var type: TypeNameNode? {
        return firstChild()
    }
    
    public var identifier: Identifier? {
        return firstChild()
    }
    
    public var initialExpression: InitialExpression? {
        return firstChild()
    }
    
    public required init() {
        
    }
}

/// Represents the initial expression for a global variable definition.
public class InitialExpression: ASTNode, InitializableNode {
    public var expression: ConstantExpression? {
        return firstChild()
    }
    
    public required init() {
        
    }
}

/// Represents a constant expression used as the initial value to global variables
/// parsed from a source file.
public class ConstantExpression: ASTNode, InitializableNode {
    public var expression: Expression? {
        return firstChild()
    }
    
    public required init() {
        
    }
}
