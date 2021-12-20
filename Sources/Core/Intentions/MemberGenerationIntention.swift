import ObjcGrammarModels
import SwiftAST
import KnownType

/// An intention to generate a property or method on a type
public class MemberGenerationIntention: FromSourceIntention {
    /// Type this member generation intention belongs to
    public internal(set) weak var type: TypeGenerationIntention?
    
    /// Returns whether this member is static (i.e. class member).
    /// Defaults to `false`, unless overriden by a subclass.
    public var isStatic: Bool { false }
    
    public var semantics: Set<Semantic> = []
    public var knownAttributes: [KnownAttribute] = []
    public var annotations: [String] = []
    
    public var memberType: SwiftType {
        fatalError("Must be overriden by subtypes")
    }
    
    public override init(accessLevel: AccessLevel = .internal, source: ASTNode? = nil) {
        super.init(accessLevel: accessLevel, source: source)
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        semantics = try container.decode(Set<Semantic>.self, forKey: .semantics)
        knownAttributes = try container.decode([KnownAttribute].self, forKey: .knownAttributes)
        annotations = try container.decode([String].self, forKey: .annotations)
        
        try super.init(from: container.superDecoder())
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(semantics, forKey: .semantics)
        try container.encode(knownAttributes, forKey: .knownAttributes)
        try container.encode(annotations, forKey: .annotations)
        
        try super.encode(to: container.superEncoder())
    }
    
    private enum CodingKeys: String, CodingKey {
        case semantics
        case knownAttributes
        case annotations
    }
}

extension MemberGenerationIntention: KnownMember {
    public var ownerType: KnownTypeReference? {
        type?.asKnownTypeReference
    }
}
