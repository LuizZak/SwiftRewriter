/// An intention to generate a protocol property
public class ProtocolPropertyGenerationIntention: PropertyGenerationIntention {
    public var isOptional: Bool = false
    
    public override var optional: Bool {
        isOptional
    }

    public override func accept<T: IntentionVisitor>(_ visitor: T) -> T.Result {
        visitor.visitProtocolProperty(self)
    }
}
