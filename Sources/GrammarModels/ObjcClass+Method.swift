import ObjcParserAntlr

public final class ExpressionNode: ASTNode {
    public var expression: ObjectiveCParser.ExpressionContext?
}

public final class MethodBody: ASTNode {
    public var statements: ObjectiveCParser.CompoundStatementContext?
    
    public override func shortDescription() -> String {
        statements?.getText() ?? ""
    }
}

public class MethodDefinition: ASTNode, InitializableNode {
    public var returnType: MethodType? {
        firstChild()
    }
    public var methodSelector: MethodSelector? {
        firstChild()
    }
    public var body: MethodBody?
    
    public var isClassMethod: Bool = false
    
    // For use in protocol methods only
    public var isOptionalMethod: Bool = false
    
    public required init(isInNonnullContext: Bool) {
        super.init(_isInNonnullContext: isInNonnullContext)
    }
    
    public override func addChild(_ node: ASTNode) {
        super.addChild(node)
    }
}

public class MethodSelector: ASTNode, InitializableNode {
    public var selector: SelectorKind {
        let sel = childrenMatching(type: Identifier.self)
        let kw = childrenMatching(type: KeywordDeclarator.self)
        
        if sel.count == 1 {
            return .selector(sel[0])
        }
        
        return .keywords(kw)
    }
    
    public required init(isInNonnullContext: Bool) {
        super.init(_isInNonnullContext: isInNonnullContext)
    }
    
    public enum SelectorKind {
        case selector(Identifier)
        case keywords([KeywordDeclarator])
    }
}

public final class KeywordDeclarator: ASTNode, InitializableNode {
    public var selector: Identifier? {
        let children = childrenMatching(type: Identifier.self)
        if children.count == 1 {
            return nil
        }
        
        return children.first
    }
    public var type: MethodType? {
        firstChild()
    }
    public var identifier: Identifier? {
        childrenMatching().last
    }
    
    public required init(isInNonnullContext: Bool) {
        super.init(_isInNonnullContext: isInNonnullContext)
    }
}

public final class MethodType: ASTNode, InitializableNode {
    public var nullabilitySpecifiers: [NullabilitySpecifier] {
        childrenMatching()
    }
    public var type: TypeNameNode? {
        firstChild()
    }
    
    public required init(isInNonnullContext: Bool) {
        super.init(_isInNonnullContext: isInNonnullContext)
    }
}

public final class NullabilitySpecifier: Identifier {
    
}
