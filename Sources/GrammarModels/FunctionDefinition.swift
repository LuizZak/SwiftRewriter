/// Represents a global function definition
public class FunctionDefinition: ASTNode, InitializableNode {
    public var returnType: TypeNameNode? {
        firstChild()
    }
    
    public var identifier: Identifier? {
        firstChild()
    }
    
    public var parameterList: ParameterList? {
        firstChild()
    }
    
    public var methodBody: MethodBody? {
        firstChild()
    }
    
    public required init(isInNonnullContext: Bool) {
        super.init(_isInNonnullContext: isInNonnullContext)
    }
}

/// Represents the parameters list for a function definition
public class ParameterList: ASTNode, InitializableNode {
    public var parameters: [FunctionParameter] {
        childrenMatching()
    }
    
    public var variadicParameter: VariadicParameter? {
        firstChild()
    }
    
    public required init(isInNonnullContext: Bool) {
        super.init(_isInNonnullContext: isInNonnullContext)
    }
}

/// Represents a parameter for a parameters list for a function definition
public class FunctionParameter: ASTNode, InitializableNode {
    public var identifier: Identifier? {
        firstChild()
    }
    
    public var type: TypeNameNode? {
        firstChild()
    }
    
    public required init(isInNonnullContext: Bool) {
        super.init(_isInNonnullContext: isInNonnullContext)
    }
}

/// A variadic parameter which is specified as a (', ...') after at least one
/// function parameter.
public class VariadicParameter: ASTNode, InitializableNode {
    public required init(isInNonnullContext: Bool) {
        super.init(_isInNonnullContext: isInNonnullContext)
    }
}
