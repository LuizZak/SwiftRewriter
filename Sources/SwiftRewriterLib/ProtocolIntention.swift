import GrammarModels

/// An intention to create a protocol.
public class ProtocolGenerationIntention: TypeGenerationIntention {
    
}

/// An intention to generate a protocol method
public class ProtocolMethodGenerationIntention: MethodGenerationIntention {
    public var isOptional: Bool = false
}

/// An intention to generate a protocol property
public class ProtocolPropertyGenerationIntention: PropertyGenerationIntention {
    public var isOptional: Bool = false
}

