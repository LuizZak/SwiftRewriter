/// A simple intention passes source that feeds from a contents array
public struct ArrayIntentionPassSource: IntentionPassSource {
    public var intentionPasses: [IntentionPass]
    
    public init(intentionPasses: [IntentionPass]) {
        self.intentionPasses = intentionPasses
    }

    public init(source: IntentionPassSource) {
        self.intentionPasses = source.intentionPasses
    }
}
