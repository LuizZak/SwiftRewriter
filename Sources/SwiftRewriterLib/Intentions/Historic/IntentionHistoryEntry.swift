/// An entry for an intention history
public struct IntentionHistoryEntry: CustomStringConvertible {
    /// A textual tag to help when scrolling through history entries
    public var tag: String
    
    /// The description for this history entry, describing a change to an intention.
    public var description: String
    
    /// Any one or more intentions that are related to this history entry.
    /// May be empty, in case this entry is e.g. an initial creation entry.
    public var relatedIntentions: [Intention]
    
    /// Returns a brief formatted summary string.
    public var summary: String {
        return "[\(tag)] \(description)"
    }
    
    public init(tag: String, description: String, relatedIntentions: [Intention] = []) {
        self.tag = tag
        self.description = description
        self.relatedIntentions = relatedIntentions
    }
}
