import KnownType
import Intentions

/// Gives support for querying an object for types by name.
public protocol KnownTypeProvider {
    /// Returns a type with a given (unaliased) name to this type provider.
    /// Returns `nil`, in case no matching type is found.
    func knownType(withName name: String) -> KnownType?
    
    /// Requests all types contained within this known type provider that match
    /// a given type kind.
    func knownTypes(ofKind kind: KnownTypeKind) -> [KnownType]
    
    /// Gets the canonical name for a given type name, in case it has an auxiliary
    /// canonical name available.
    func canonicalName(for typeName: String) -> String?
}

/// Gathers one or more type providers into a single `KnownTypeProvider` interface.
public class CompoundKnownTypeProvider: KnownTypeProvider {
    
    @ConcurrentValue private var typesCache: [String: KnownType?] = [:]
    @ConcurrentValue private var canonicalTypenameCache: [String: String] = [:]
    
    public var providers: [KnownTypeProvider]
    
    public init(providers: [KnownTypeProvider]) {
        self.providers = providers
    }
    
    func makeCache() {
        $typesCache.setAsCaching(value: [:])
        $canonicalTypenameCache.setAsCaching(value: [:])
    }
    
    func tearDownCache() {
        $typesCache.tearDownCaching(resetToValue: [:])
        $canonicalTypenameCache.tearDownCaching(resetToValue: [:])
    }
    
    public func addKnownTypeProvider(_ typeProvider: KnownTypeProvider) {
        providers.append(typeProvider)
        
        // Reset cache to allow types from this type provider to be considered.
        if $typesCache.usingCache {
            tearDownCache()
            makeCache()
        }
    }
    
    public func knownType(withName name: String) -> KnownType? {
        if $typesCache.usingCache, let type = typesCache[name] {
            return type
        }
        
        var types: [KnownType] = []
        
        for provider in providers {
            if let type = provider.knownType(withName: name) {
                types.append(type)
            }
        }
        
        if types.isEmpty {
            if $typesCache.usingCache {
                $typesCache.modifyingValue {
                    $0[name] = nil
                }
            }
            return nil
        }
        
        let type = CompoundKnownType(typeName: name, types: types)
        
        if $typesCache.usingCache {
            $typesCache.modifyingValue {
                $0[name] = type
            }
        }
        
        return type
    }
    
    public func knownTypes(ofKind kind: KnownTypeKind) -> [KnownType] {
        var backing: [KnownType] = []
        
        for provider in providers {
            backing.append(contentsOf: provider.knownTypes(ofKind: kind))
        }
        
        return backing
    }
    
    public func canonicalName(for typeName: String) -> String? {
        if $canonicalTypenameCache.usingCache {
            if let canonical = canonicalTypenameCache[typeName] {
                return canonical
            }
        }
        
        for provider in providers {
            guard let canonical = provider.canonicalName(for: typeName) else {
                continue
            }
            
            if $canonicalTypenameCache.usingCache {
                $canonicalTypenameCache.modifyingValue {
                    $0[typeName] = canonical
                }
            }
            
            return canonical
        }
        
        return nil
    }
}

/// Provides known type access via a simple backing array
public class CollectionKnownTypeProvider: KnownTypeProvider {
    private var knownTypes: [KnownType]
    private var knownTypesByName: [String: [KnownType]] = [:]
    private var canonicalMappings: [String: String] = [:]
    
    public init(knownTypes: [KnownType] = []) {
        self.knownTypes = knownTypes
        
        knownTypesByName = knownTypes.groupBy({ $0.typeName })
    }
    
    public func removeAllTypes() {
        knownTypes.removeAll()
        knownTypesByName.removeAll()
    }
    
    public func addType(_ type: KnownType) {
        knownTypes.append(type)
        knownTypesByName[type.typeName, default: []].append(type)
    }
    
    public func addCanonicalMapping(nonCanonical: String, canonical: String) {
        assert(nonCanonical != canonical,
               "Cannot map a non-canonical type name as a canonical of itself.")
        
        canonicalMappings[nonCanonical] = canonical
    }
    
    public func knownType(withName name: String) -> KnownType? {
        return knownTypesByName[name]?.first
    }
    
    public func knownTypes(ofKind kind: KnownTypeKind) -> [KnownType] {
        return knownTypes.filter { $0.kind == kind }
    }
    
    public func canonicalName(for typeName: String) -> String? {
        return canonicalMappings[typeName]
    }
}
