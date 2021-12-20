/// Represents a global function definition
public class ObjcFunctionDefinition: ObjcASTNode, ObjcInitializableNode {
    public var returnType: ObjcTypeNameNode? {
        firstChild()
    }
    
    public var identifier: ObjcIdentifierNode? {
        firstChild()
    }
    
    public var parameterList: ObjcParameterList? {
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
public class ObjcParameterList: ObjcASTNode, ObjcInitializableNode {
    public var parameters: [ObjcFunctionParameter] {
        childrenMatching()
    }
    
    public var variadicParameter: ObjcVariadicParameter? {
        firstChild()
    }
    
    public required init(isInNonnullContext: Bool) {
        super.init(isInNonnullContext: isInNonnullContext)
    }
}

/// Represents a parameter for a parameters list for a function definition
public class ObjcFunctionParameter: ObjcASTNode, ObjcInitializableNode {
    public var identifier: ObjcIdentifierNode? {
        firstChild()
    }
    
    public var type: ObjcTypeNameNode? {
        firstChild()
    }
    
    public required init(isInNonnullContext: Bool) {
        super.init(isInNonnullContext: isInNonnullContext)
    }
}

/// A variadic parameter which is specified as a (', ...') after at least one
/// function parameter.
public class ObjcVariadicParameter: ObjcASTNode, ObjcInitializableNode {
    public required init(isInNonnullContext: Bool) {
        super.init(isInNonnullContext: isInNonnullContext)
    }
}
