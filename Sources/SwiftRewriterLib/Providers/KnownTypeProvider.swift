/// Gives support for querying an object for types by name.
public protocol KnownTypeProvider {
    /// Returns a type with a given (unaliased) name to this type provider.
    /// Returns `nil`, in case no matching type is found.
    func knownType(withName name: String) -> KnownType?
    
    /// Requests all types contained within this known type provider that match
    /// a given type kind.
    func knownTypes(ofKind kind: KnownTypeKind) -> [KnownType]
}

/// Gathers one or more type providers into a single `KnownTypeProvider` interface.
public class CompoundKnownTypeProvider: KnownTypeProvider {
    public var providers: [KnownTypeProvider]
    
    public init(providers: [KnownTypeProvider]) {
        self.providers = providers
    }
    
    public func knownType(withName name: String) -> KnownType? {
        for provider in providers {
            if let type = provider.knownType(withName: name) {
                return type
            }
        }
        
        return nil
    }
    
    public func knownTypes(ofKind kind: KnownTypeKind) -> [KnownType] {
        var backing: [KnownType] = []
        
        for provider in providers {
            backing.append(contentsOf: provider.knownTypes(ofKind: kind))
        }
        
        return backing
    }
}

/// Provides known type access via a simple backing array
public class CollectionKnownTypeProvider: KnownTypeProvider {
    private var knownTypes: [KnownType]
    
    public init(knownTypes: [KnownType] = []) {
        self.knownTypes = knownTypes
    }
    
    public func removeAllTypes() {
        knownTypes.removeAll()
    }
    
    public func addType(_ type: KnownType) {
        knownTypes.append(type)
    }
    
    public func knownType(withName name: String) -> KnownType? {
        for type in knownTypes {
            if type.typeName == name {
                return type
            }
        }
        
        return nil
    }
    
    public func knownTypes(ofKind kind: KnownTypeKind) -> [KnownType] {
        return knownTypes.filter { $0.kind == kind }
    }
}
