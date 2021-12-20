import ObjcParserAntlr
import GrammarModelBase

public final class ExpressionNode: ObjcASTNode {
    public var expression: ObjectiveCParser.ExpressionContext?
}

public final class MethodBody: ObjcASTNode {
    public var statements: ObjectiveCParser.CompoundStatementContext?
    
    /// List of comments found within the range of this method body
    public var comments: [CodeComment] = []
    
    public override var shortDescription: String {
        statements?.getText() ?? ""
    }
}

public class MethodDefinition: ObjcASTNode, ObjcInitializableNode {
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
        super.init(isInNonnullContext: isInNonnullContext)
    }
}

public class MethodSelector: ObjcASTNode, ObjcInitializableNode {
    public var selector: SelectorKind {
        let sel = childrenMatching(type: Identifier.self)
        let kw = childrenMatching(type: KeywordDeclarator.self)
        
        if sel.count == 1 {
            return .selector(sel[0])
        }
        
        return .keywords(kw)
    }
    
    public required init(isInNonnullContext: Bool) {
        super.init(isInNonnullContext: isInNonnullContext)
    }
    
    public enum SelectorKind {
        case selector(Identifier)
        case keywords([KeywordDeclarator])
    }
}

public final class KeywordDeclarator: ObjcASTNode, ObjcInitializableNode {
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
        super.init(isInNonnullContext: isInNonnullContext)
    }
}

public final class MethodType: ObjcASTNode, ObjcInitializableNode {
    public var nullabilitySpecifiers: [NullabilitySpecifier] {
        childrenMatching()
    }
    public var type: ObjcTypeNameNode? {
        firstChild()
    }
    
    public required init(isInNonnullContext: Bool) {
        super.init(isInNonnullContext: isInNonnullContext)
    }
}

public final class NullabilitySpecifier: Identifier {
    
}
