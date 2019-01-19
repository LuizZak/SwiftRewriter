/// An intention that is to be declared at the file-level, not contained within any
/// types.
public protocol FileLevelIntention: IntentionProtocol {
    /// The file this intention is contained within
    var file: FileGenerationIntention? { get }
}
