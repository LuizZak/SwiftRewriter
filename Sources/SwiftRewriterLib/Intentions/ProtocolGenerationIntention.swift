/// An intention to create a protocol.
public class ProtocolGenerationIntention: TypeGenerationIntention {
    public override var kind: KnownTypeKind {
        return .protocol
    }
}
