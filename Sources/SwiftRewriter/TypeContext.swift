/// Represents a local context for constructing types with.
public class TypeContext {
    var classes: [ClassConstruct] = []
    var contexts: [Context] = []
    
    public func getClass(named name: String) -> ClassConstruct? {
        return classes.first { $0.name == name }
    }
    
    @discardableResult
    public func defineClass(named name: String) -> ClassConstruct {
        let cls = ClassConstruct(name: name)
        classes.append(cls)
        
        return cls
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
