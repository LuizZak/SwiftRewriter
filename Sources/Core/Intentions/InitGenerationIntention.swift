import GrammarModelBase
import SwiftAST
import KnownType

/// Intention to generate a type initializer for a class or protocol initializer
public final class InitGenerationIntention: MemberGenerationIntention, MutableFunctionIntention, ParameterizedFunctionIntention {
    public var parameters: [ParameterSignature]
    
    public var functionBody: FunctionBodyIntention?
    
    public var isOverride: Bool = false
    public var isFallible: Bool = false
    public var isConvenience: Bool = false

    /// Returns the function signature that is equivalent to this initializer.
    public var signature: FunctionSignature {
        let returnType = type?.asSwiftType ?? .errorType 

        return .init(
            name: "init",
            parameters: parameters,
            returnType: isFallible ? returnType.asOptional : returnType,
            isStatic: true,
            isMutating: false
        )
    }
    
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
        isFallible = try container.decode(Bool.self, forKey: .isFallible)
        isConvenience = try container.decode(Bool.self, forKey: .isConvenience)
        
        try super.init(from: container.superDecoder())
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(parameters, forKey: .parameters)
        try container.encodeIntentionIfPresent(functionBody, forKey: .functionBody)
        try container.encode(isOverride, forKey: .isOverride)
        try container.encode(isFallible, forKey: .isFallible)
        try container.encode(isConvenience, forKey: .isConvenience)
        
        try super.encode(to: container.superEncoder())
    }
    
    private enum CodingKeys: String, CodingKey {
        case parameters
        case functionBody
        case isOverride
        case isFallible
        case isConvenience
    }
}

extension InitGenerationIntention: OverridableMemberGenerationIntention {
    
}

extension InitGenerationIntention: KnownConstructor {
    
}
