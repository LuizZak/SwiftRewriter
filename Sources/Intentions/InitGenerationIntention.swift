import GrammarModels
import SwiftAST
import KnownType

/// Intention to generate a type initializer for a class or protocol initializer
public final class InitGenerationIntention: MemberGenerationIntention, FunctionIntention {
    public var parameters: [ParameterSignature]
    
    public var functionBody: FunctionBodyIntention?
    
    public var isOverride: Bool = false
    public var isFailable: Bool = false
    public var isConvenience: Bool = false
    
    public init(parameters: [ParameterSignature],
                accessLevel: AccessLevel = .internal,
                source: ASTNode? = nil) {
        
        self.parameters = parameters
        super.init(accessLevel: accessLevel, source: source)
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        parameters = try container.decode([ParameterSignature].self, forKey: .parameters)
        functionBody = try container.decodeIntentionIfPresent(forKey: .functionBody)
        isOverride = try container.decode(Bool.self, forKey: .isOverride)
        isFailable = try container.decode(Bool.self, forKey: .isFailable)
        isConvenience = try container.decode(Bool.self, forKey: .isConvenience)
        
        try super.init(from: container.superDecoder())
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(parameters, forKey: .parameters)
        try container.encodeIntentionIfPresent(functionBody, forKey: .functionBody)
        try container.encode(isOverride, forKey: .isOverride)
        try container.encode(isFailable, forKey: .isFailable)
        try container.encode(isConvenience, forKey: .isConvenience)
        
        try super.encode(to: container.superEncoder())
    }
    
    private enum CodingKeys: String, CodingKey {
        case parameters
        case functionBody
        case isOverride
        case isFailable
        case isConvenience
    }
}

extension InitGenerationIntention: OverridableMemberGenerationIntention {
    
}

extension InitGenerationIntention: KnownConstructor {
    
}
