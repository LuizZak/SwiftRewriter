import GrammarModelBase
import SwiftAST

/// An intention of generating a Swift `typealias` clause.
public final class TypealiasIntention: FromSourceIntention {
    public var fromType: SwiftType
    public var name: String
    
    public init(
        fromType: SwiftType,
        named name: String,
        accessLevel: AccessLevel = .internal,
        source: ASTNode? = nil
    ) {
        
        self.fromType = fromType
        self.name = name
        
        super.init(accessLevel: accessLevel, source: source)
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        fromType = try container.decode(SwiftType.self, forKey: .fromType)
        name = try container.decode(String.self, forKey: .name)
        
        try super.init(from: container.superDecoder())
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(fromType, forKey: .fromType)
        try container.encode(name, forKey: .name)
        
        try super.encode(to: container.superEncoder())
    }

    public override func accept<T: IntentionVisitor>(_ visitor: T) -> T.Result {
        visitor.visitTypealias(self)
    }
    
    private enum CodingKeys: String, CodingKey {
        // case originalObjcType
        case fromType
        case name
    }
}
