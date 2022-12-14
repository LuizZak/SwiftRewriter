/// Specifies a known declaration. Declarations can be types, or global
/// functions/variables.
public protocol KnownDeclaration {
    /// If non-nil, specifies the originating file for this declaration.
    var knownFile: KnownFile? { get }
}
