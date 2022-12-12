/// An object that supports attribute markings
public protocol AttributeTaggableObject {
    /// Gets an array of all known attributes for this object
    var knownAttributes: [KnownAttribute] { get }

    /// Returns `true` if this object contains a known attribute with a specified
    /// name.
    func hasAttribute(named name: String) -> Bool
}

public extension AttributeTaggableObject {
    func hasAttribute(named name: String) -> Bool {
        knownAttributes.contains(where: { $0.name == name })
    }
}
