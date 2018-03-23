import GrammarModels

/// Intention to generate a type initializer for a class or protocol initializer
public class InitGenerationIntention: MemberGenerationIntention, FunctionIntention, OverridableMemberGenerationIntention {
    public var parameters: [ParameterSignature]
    
    public var functionBody: FunctionBodyIntention?
    
    public var isOverride: Bool = false
    
    public init(parameters: [ParameterSignature],
                accessLevel: AccessLevel = .internal,
                source: ASTNode? = nil) {
        
        self.parameters = parameters
        super.init(accessLevel: accessLevel, source: source)
    }
}

extension InitGenerationIntention: KnownConstructor {
    
}
