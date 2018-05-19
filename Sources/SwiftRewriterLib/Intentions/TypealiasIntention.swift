import GrammarModels
import SwiftAST

/// An intention of generating a Swift `typealias` clause.
public class TypealiasIntention: FromSourceIntention {
    public var originalObjcType: ObjcType
    
    public var fromType: SwiftType
    public var name: String
    
    public init(originalObjcType: ObjcType, fromType: SwiftType, named name: String,
                accessLevel: AccessLevel = .internal, source: ASTNode? = nil) {
        self.originalObjcType = originalObjcType
        self.fromType = fromType
        self.name = name
        
        super.init(accessLevel: accessLevel, source: source)
    }
}
