import KnownType

/// An intention to create a protocol.
public final class ProtocolGenerationIntention: TypeGenerationIntention {
    public override var kind: KnownTypeKind {
        .protocol
    }

    public override func accept<T: IntentionVisitor>(_ visitor: T) -> T.Result {
        visitor.visitProtocol(self)
    }
}
