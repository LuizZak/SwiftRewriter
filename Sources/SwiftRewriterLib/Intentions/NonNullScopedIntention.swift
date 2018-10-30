/// Represents an intention that has a value associated that indicates whether it
/// was defined within NS_ASSUME_NONNULL contexts
public protocol NonNullScopedIntention: IntentionProtocol {
    /// Gets a value indicating whether this intention was defined within
    /// NS_ASSUME_NONNULL contexts
    var inNonnullContext: Bool { get }
}
