/// Common semantic annotations
public enum Semantics {
    
    /// Represents a semantic annotation for method invocations that mutate
    /// collections, like NSMutableArray, NSMutableDictionary, and NSMutableSet.
    public static let collectionMutator: Set<Semantic> = [
        Semantic(name: "_collector_mutator")
    ]
    
}
