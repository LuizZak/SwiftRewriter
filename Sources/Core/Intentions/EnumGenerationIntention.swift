import GrammarModelBase
import SwiftAST
import KnownType

/// An intention to generate a Swift enumeration type
public final class EnumGenerationIntention: TypeGenerationIntention {
    /*
    public var typedSource: ObjcEnumDeclarationNode? {
        source as? ObjcEnumDeclarationNode
    }
    */
    
    public override var kind: KnownTypeKind {
        .enum
    }
    
    public var rawValueType: SwiftType {
        didSet {
            knownTraits[KnownTypeTraits.enumRawValue] = .swiftType(rawValueType)
        }
    }
    
    public var cases: [EnumCaseGenerationIntention] {
        properties.compactMap { $0 as? EnumCaseGenerationIntention }
    }
    
    public init(typeName: String,
                rawValueType: SwiftType,
                accessLevel: AccessLevel = .internal,
                source: ASTNode? = nil) {
        
        self.rawValueType = rawValueType
        super.init(typeName: typeName, accessLevel: accessLevel, source: source)
        
        knownTraits[KnownTypeTraits.enumRawValue] = .swiftType(rawValueType)
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        rawValueType = try container.decode(SwiftType.self, forKey: .rawValueType)
        
        try super.init(from: container.superDecoder())
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(rawValueType, forKey: .rawValueType)
        
        try super.encode(to: container.superEncoder())
    }
    
    public func addCase(_ enumCase: EnumCaseGenerationIntention) {
        addProperty(enumCase)
        enumCase.storage.type = .typeName(typeName)
        enumCase.parent = self
    }
    
    private enum CodingKeys: String, CodingKey {
        case rawValueType
        case cases
    }
}
