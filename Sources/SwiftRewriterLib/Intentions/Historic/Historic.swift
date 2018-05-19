/// Defines an object that features a history tracker instance
public protocol Historic {
    /// Gets the history tracker for this intention
    var history: IntentionHistory { get }
}
