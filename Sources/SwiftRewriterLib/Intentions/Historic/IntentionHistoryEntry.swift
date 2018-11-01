/// An entry for an intention history
public struct IntentionHistoryEntry: CustomStringConvertible, Codable {
    /// A textual tag to help when scrolling through history entries
    public var tag: String
    
    /// The description for this history entry, describing a change to an intention.
    public var description: String
    
    /// Returns a brief formatted summary string.
    public var summary: String {
        return "[\(tag)] \(description)"
    }
    
    public init(tag: String, description: String) {
        self.tag = tag
        self.description = description
    }
}
