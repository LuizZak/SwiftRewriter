/// An intention to generate a protocol method
public class ProtocolMethodGenerationIntention: MethodGenerationIntention {
    public var isOptional: Bool = false
    
    public override var optional: Bool {
        isOptional
    }
}
