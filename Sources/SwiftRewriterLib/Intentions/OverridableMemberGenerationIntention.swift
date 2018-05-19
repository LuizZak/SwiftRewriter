/// Specifies an intention for a member that can be overriden by subtypes
public protocol OverridableMemberGenerationIntention: Intention {
    /// Whether this member overrides a base member matching its signature.
    var isOverride: Bool { get set }
}
