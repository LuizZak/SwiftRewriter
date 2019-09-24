/// An intention to generate a protocol property
public class ProtocolPropertyGenerationIntention: PropertyGenerationIntention {
    public var isOptional: Bool = false
    
    public override var optional: Bool {
        isOptional
    }
}
