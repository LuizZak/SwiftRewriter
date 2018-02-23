/// Represents a local context for constructing types with.
public class TypeConstructionContext {
    var contexts: [Context] = []
    
    public init() {
        
    }
    
    public func pushContext(_ context: Context) {
        contexts.append(context)
    }
    
    /// Returns the latest context on the contexts stack that matches a given type.
    ///
    /// Searches from top-to-bottom, so the last context `T` that was pushed is
    /// returned first.
    public func findContext<T: Context>(ofType type: T.Type = T.self) -> T? {
        return contexts.reversed().first { $0 is T } as? T
    }
    
    /// Returns the topmost context on the contexts stack casted to a specific type.
    ///
    /// If the topmost context is not T, nil is returned instead.
    public func currentContext<T: Context>(as type: T.Type = T.self) -> T? {
        return contexts.last as? T
    }
    
    public func popContext() {
        contexts.removeLast()
    }
}

/// A context for a `TypeConstructionContext`
public protocol Context {
    
}

/// Context pushed when the the parser is in between NS_ASSUME_NONNULL_BEGIN/END
/// macros.
public class AssumeNonnullContext: Context {
    /// Whether assume nonnull is on.
    public var isNonnullOn: Bool
    
    public init(isNonnullOn: Bool = false) {
        self.isNonnullOn = isNonnullOn
    }
}

// MARK: - AssumeNonnullContext-specific TypeConstructionContext extension
public extension TypeConstructionContext {
    /// Returns a value specifying whether assume nonnull is on for pointer types.
    public var isAssumeNonnullOn: Bool {
        return findContext(ofType: AssumeNonnullContext.self)?.isNonnullOn ?? false
    }
}
