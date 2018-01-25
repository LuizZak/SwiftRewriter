/// Represents a local context for constructing types with.
public class TypeContext {
    var contexts: [Context] = []
    
    public init() {
        
    }
    
    public func pushContext(_ context: Context) {
        contexts.append(context)
    }
    
    public func context<T: Context>(ofType type: T.Type = T.self) -> T? {
        return contexts.reversed().first { $0 is T } as? T
    }
    
    public func popContext() {
        contexts.removeLast()
    }
}

/// A context for a type context
public protocol Context {
    
}
