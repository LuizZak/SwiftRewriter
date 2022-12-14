/// A protocol for sourcing intention passes
public protocol IntentionPassSource {
    var intentionPasses: [IntentionPass] { get }
}
