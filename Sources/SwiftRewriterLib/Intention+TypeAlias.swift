import GrammarModels

/// An intention of generating a Swift `typealias` clause.
public class TypealiasIntention: FromSourceIntention {
    public var fromType: ObjcType
    public var named: String
    
    public init(fromType: ObjcType, named: String, accessLevel: AccessLevel = .internal, source: ASTNode? = nil) {
        self.fromType = fromType
        self.named = named
        
        super.init(accessLevel: accessLevel, source: source)
    }
}
