/// Describes a type that can contain semantic annotations.
public protocol SemanticalObject {
    var semantics: Set<Semantic> { get }
}

public extension SemanticalObject where Self: KnownMember {
    /// Returns `true` iff this member type is known to mutate arrays if either
    /// called, if this is a method, or set, in case this is a property/field.
    var isArrayMutator: Bool {
        semantics.isSuperset(of: Semantics.collectionMutator)
    }
}
