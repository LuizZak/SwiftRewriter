import ObjcParserAntlr
import GrammarModelBase

public final class ObjcMethodBodyNode: ObjcASTNode {
    public var statements: ObjectiveCParser.CompoundStatementContext?
    
    /// List of comments found within the range of this method body
    public var comments: [CodeComment] = []
    
    public override var shortDescription: String {
        statements?.getText() ?? ""
    }
}

public class ObjcMethodDefinitionNode: ObjcASTNode, ObjcInitializableNode {
    public var returnType: ObjcMethodTypeNode? {
        firstChild()
    }
    public var methodSelector: ObjcMethodSelectorNode? {
        firstChild()
    }
    public var body: ObjcMethodBodyNode?
    
    public var isClassMethod: Bool = false
    
    // For use in protocol methods only
    public var isOptionalMethod: Bool = false
    
    public required init(isInNonnullContext: Bool) {
        super.init(isInNonnullContext: isInNonnullContext)
    }
}

public class ObjcMethodSelectorNode: ObjcASTNode, ObjcInitializableNode {
    public var selector: SelectorKind {
        let sel = childrenMatching(type: ObjcIdentifierNode.self)
        let kw = childrenMatching(type: ObjcKeywordDeclaratorNode.self)
        
        if sel.count == 1 {
            return .selector(sel[0])
        }
        
        return .keywords(kw)
    }
    
    public required init(isInNonnullContext: Bool) {
        super.init(isInNonnullContext: isInNonnullContext)
    }
    
    public enum SelectorKind {
        case selector(ObjcIdentifierNode)
        case keywords([ObjcKeywordDeclaratorNode])
    }
}

public final class ObjcKeywordDeclaratorNode: ObjcASTNode, ObjcInitializableNode {
    public var selector: ObjcIdentifierNode? {
        let children = childrenMatching(type: ObjcIdentifierNode.self)
        if children.count == 1 {
            return nil
        }
        
        return children.first
    }
    public var type: ObjcMethodTypeNode? {
        firstChild()
    }
    public var identifier: ObjcIdentifierNode? {
        childrenMatching().last
    }
    
    public required init(isInNonnullContext: Bool) {
        super.init(isInNonnullContext: isInNonnullContext)
    }
}

public final class ObjcMethodTypeNode: ObjcASTNode, ObjcInitializableNode {
    public var nullabilitySpecifiers: [ObjcNullabilitySpecifierNode] {
        childrenMatching()
    }
    public var type: ObjcTypeNameNode? {
        firstChild()
    }
    
    public required init(isInNonnullContext: Bool) {
        super.init(isInNonnullContext: isInNonnullContext)
    }
}

public final class ObjcNullabilitySpecifierNode: ObjcIdentifierNode {
    
}
