/// Represents a global function definition
public class FunctionDefinition: ObjcASTNode, ObjcInitializableNode {
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
        super.init(isInNonnullContext: isInNonnullContext)
    }
}

/// Represents the parameters list for a function definition
public class ParameterList: ObjcASTNode, ObjcInitializableNode {
    public var parameters: [FunctionParameter] {
        childrenMatching()
    }
    
    public var variadicParameter: VariadicParameter? {
        firstChild()
    }
    
    public required init(isInNonnullContext: Bool) {
        super.init(isInNonnullContext: isInNonnullContext)
    }
}

/// Represents a parameter for a parameters list for a function definition
public class FunctionParameter: ObjcASTNode, ObjcInitializableNode {
    public var identifier: Identifier? {
        firstChild()
    }
    
    public var type: TypeNameNode? {
        firstChild()
    }
    
    public required init(isInNonnullContext: Bool) {
        super.init(isInNonnullContext: isInNonnullContext)
    }
}

/// A variadic parameter which is specified as a (', ...') after at least one
/// function parameter.
public class VariadicParameter: ObjcASTNode, ObjcInitializableNode {
    public required init(isInNonnullContext: Bool) {
        super.init(isInNonnullContext: isInNonnullContext)
    }
}
