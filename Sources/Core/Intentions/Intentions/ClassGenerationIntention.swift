import GrammarModelBase
import SwiftAST
import KnownType

/// An intention to generate a Swift class type
public final class ClassGenerationIntention: BaseClassIntention {
    /// An optional name for a superclass for this class.
    public var superclassName: String?

    /// Whether this class should be generated as a final class type.
    public var isFinal: Bool = false
    
    /// Gets the reference for the superclass as a `KnownTypeReference`.
    public override var supertype: KnownTypeReference? {
        if let superclassName = superclassName {
            return KnownTypeReference.typeName(superclassName)
        }
        
        return nil
    }
    
    public override init(
        typeName: String,
        accessLevel: AccessLevel = .internal,
        source: ASTNode? = nil
    ) {
        super.init(
            typeName: typeName,
            accessLevel: accessLevel,
            source: source
        )
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        superclassName = try container.decode(String.self, forKey: .superclassName)
        isFinal = try container.decode(Bool.self, forKey: .isFinal)
        
        try super.init(from: container.superDecoder())
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(superclassName, forKey: .superclassName)
        try container.encode(isFinal, forKey: .isFinal)
        
        try super.encode(to: container.superEncoder())
    }

    public override func accept<T: IntentionVisitor>(_ visitor: T) -> T.Result {
        visitor.visitClass(self)
    }
    
    private enum CodingKeys: String, CodingKey {
        case superclassName
        case isFinal
    }
}
