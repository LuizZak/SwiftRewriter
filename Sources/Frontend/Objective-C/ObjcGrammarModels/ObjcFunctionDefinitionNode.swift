/// Represents a global function definition
public class ObjcFunctionDefinitionNode: ObjcASTNode, ObjcInitializableNode {
    public var returnType: ObjcTypeNameNode? {
        firstChild()
    }
    
    public var identifier: ObjcIdentifierNode? {
        firstChild()
    }
    
    public var parameterList: ObjcParameterListNode? {
        firstChild()
    }
    
    public var methodBody: ObjcMethodBodyNode? {
        firstChild()
    }
    
    public required init(isInNonnullContext: Bool) {
        super.init(isInNonnullContext: isInNonnullContext)
    }
}

/// Represents the parameters list for a function definition
public class ObjcParameterListNode: ObjcASTNode, ObjcInitializableNode {
    public var parameters: [ObjcFunctionParameterNode] {
        childrenMatching()
    }
    
    public var variadicParameter: ObjcVariadicParameterNode? {
        firstChild()
    }
    
    public required init(isInNonnullContext: Bool) {
        super.init(isInNonnullContext: isInNonnullContext)
    }
}

/// Represents a parameter for a parameters list for a function definition
public class ObjcFunctionParameterNode: ObjcASTNode, ObjcInitializableNode {
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
public class ObjcVariadicParameterNode: ObjcASTNode, ObjcInitializableNode {
    public required init(isInNonnullContext: Bool) {
        super.init(isInNonnullContext: isInNonnullContext)
    }
}
