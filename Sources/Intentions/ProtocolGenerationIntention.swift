import KnownType

/// An intention to create a protocol.
public final class ProtocolGenerationIntention: TypeGenerationIntention {
    public override var kind: KnownTypeKind {
        return .protocol
    }
}
