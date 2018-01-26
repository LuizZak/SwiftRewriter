public class MethodDefinition: ASTNode {
    public var returnType: ASTNodeRef<MethodType>
    public var methodSelector: ASTNodeRef<MethodSelector>
    public var body: String? // TODO: This should be a CompoundStatement node or similar later on.
    
    public init(returnType: ASTNodeRef<MethodType>,
                methodSelector: ASTNodeRef<MethodSelector>) {
        self.returnType = returnType
        self.methodSelector = methodSelector
        super.init()
    }
    
    public override func addChild(_ node: ASTNode) {
        super.addChild(node)
        
        if let retNode = node as? MethodType {
            if case .valid = returnType {
                fatalError("Attempted to add more than one method_type node to a method definition node.")
            }
            
            returnType = .valid(retNode)
        } else if let selNode = node as? MethodSelector {
            if case .valid = methodSelector {
                fatalError("Attempted to add more than one method_selector node to a method definition node.")
            }
            
            methodSelector = .valid(selNode)
        }
    }
}

public class MethodSelector: ASTNode {
    var selector: SelectorKind {
        let sel = childrenMatching(type: Identifier.self)
        let kw = childrenMatching(type: KeywordDeclarator.self)
        
        if sel.count == 1 {
            return .selector(sel[0])
        } else {
            return .keywords(kw)
        }
    }
    
    public enum SelectorKind {
        case selector(Identifier)
        case keywords([KeywordDeclarator])
        
        public var identifier: Identifier? {
            switch self {
            case .selector(let id):
                return id
            case .keywords:
                return nil
            }
        }
        
        public var keywordDeclarations: [KeywordDeclarator]? {
            switch self {
            case .selector:
                return nil
            case .keywords(let kw):
                return kw
            }
        }
    }
}

public class KeywordDeclarator: ASTNode {
    public var selector: Identifier?
    public var type: MethodType? {
        return childrenMatching().first
    }
    public var identifier: Identifier?
    
    public init(selector: Identifier?, identifier: Identifier?) {
        self.selector = selector
        self.identifier = identifier
        
        super.init()
    }
}

public class MethodType: ASTNode {
    public var nullabilitySpecifiers: [NullabilitySpecifier] {
        return childrenMatching()
    }
    public var type: ASTNodeRef<TypeNameNode>
    
    public init(type: ASTNodeRef<TypeNameNode>) {
        self.type = type
        super.init()
    }
}

public class NullabilitySpecifier: Identifier {
    
}

// MARK: - ASTNodeRef extensions
public extension ASTNodeRef where Node == MethodType {
    public var type: ASTNodeRef<TypeNameNode> {
        switch self {
        case .valid(let node):
            return node.type
        case .invalid:
            return .placeholder
        }
    }
}

public extension ASTNodeRef where Node == MethodSelector {
    public var selector: MethodSelector.SelectorKind? {
        switch self {
        case .valid(let node):
            return node.selector
        default:
            return nil
        }
    }
}
