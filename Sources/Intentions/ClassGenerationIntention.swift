import GrammarModels
import SwiftAST
import KnownType

/// An intention to generate a Swift class type
public final class ClassGenerationIntention: BaseClassIntention {
    public var superclassName: String?
    
    public override var isEmptyType: Bool {
        return super.isEmptyType
    }
    
    public override var supertype: KnownTypeReference? {
        if let superclassName = superclassName {
            return KnownTypeReference.typeName(superclassName)
        }
        
        return nil
    }
    
    public override init(typeName: String,
                         accessLevel: AccessLevel = .internal,
                         source: ASTNode? = nil) {
        
        super.init(typeName: typeName,
                   accessLevel: accessLevel,
                   source: source)
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        superclassName = try container.decode(String.self, forKey: .superclassName)
        
        try super.init(from: container.superDecoder())
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(superclassName, forKey: .superclassName)
        
        try super.encode(to: container.superEncoder())
    }
    
    private enum CodingKeys: String, CodingKey {
        case superclassName
    }
}
