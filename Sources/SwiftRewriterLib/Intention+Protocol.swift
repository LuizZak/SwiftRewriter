import GrammarModels

/// An intention to create a protocol.
public class ProtocolGenerationIntention: TypeGenerationIntention {
    public override var kind: KnownTypeKind {
        return .protocol
    }
}

/// An intention to generate a protocol method
public class ProtocolMethodGenerationIntention: MethodGenerationIntention {
    public var isOptional: Bool = false
    
    public override var optional: Bool {
        return isOptional
    }
}

/// An intention to generate a protocol property
public class ProtocolPropertyGenerationIntention: PropertyGenerationIntention {
    public var isOptional: Bool = false
    
    public override var optional: Bool {
        return isOptional
    }
}
