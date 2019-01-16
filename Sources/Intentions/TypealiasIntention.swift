import GrammarModels
import SwiftAST

/// An intention of generating a Swift `typealias` clause.
public final class TypealiasIntention: FromSourceIntention {
    public var originalObjcType: ObjcType
    
    public var fromType: SwiftType
    public var name: String
    
    public init(originalObjcType: ObjcType,
                fromType: SwiftType,
                named name: String,
                accessLevel: AccessLevel = .internal,
                source: ASTNode? = nil) {
        
        self.originalObjcType = originalObjcType
        self.fromType = fromType
        self.name = name
        
        super.init(accessLevel: accessLevel, source: source)
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        originalObjcType = try container.decode(ObjcType.self, forKey: .originalObjcType)
        fromType = try container.decode(SwiftType.self, forKey: .fromType)
        name = try container.decode(String.self, forKey: .name)
        
        try super.init(from: container.superDecoder())
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(originalObjcType, forKey: .originalObjcType)
        try container.encode(fromType, forKey: .fromType)
        try container.encode(name, forKey: .name)
        
        try super.encode(to: container.superEncoder())
    }
    
    private enum CodingKeys: String, CodingKey {
        case originalObjcType
        case fromType
        case name
    }
}
