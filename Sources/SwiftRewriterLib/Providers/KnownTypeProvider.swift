import Dispatch

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
    var cacheBarrier = DispatchQueue(label: "com.swiftrewriter.compoundtypeprovider.barrier",
                                     qos: .default,
                                     attributes: .concurrent,
                                     autoreleaseFrequency: .inherit,
                                     target: nil)
    var cache: [Int: KnownType]?
    var usingCache = false
    
    public var providers: [KnownTypeProvider]
    
    public init(providers: [KnownTypeProvider]) {
        self.providers = providers
    }
    
    func makeCache() {
        cacheBarrier.sync(flags: .barrier) {
            cache = [:]
            usingCache = true
        }
    }
    
    func tearDownCache() {
        cacheBarrier.sync(flags: .barrier) {
            cache = nil
            usingCache = false
        }
    }
    
    public func addKnownTypeProvider(_ typeProvider: KnownTypeProvider) {
        providers.append(typeProvider)
        
        // Reset cache to allow types from this type provider to be considered.
        if usingCache {
            tearDownCache()
            makeCache()
        }
    }
    
    public func knownType(withName name: String) -> KnownType? {
        if usingCache, let type = cacheBarrier.sync(execute: { cache?[name.hashValue] }) {
            return type
        }
        
        var types: [KnownType] = []
        
        for provider in providers {
            if let type = provider.knownType(withName: name) {
                types.append(type)
            }
        }
        
        if types.isEmpty {
            return nil
        }
        
        let type = CompoundKnownType(typeName: name, types: types)
        
        if usingCache {
            cacheBarrier.sync(flags: .barrier) {
                cache?[name.hashValue] = type
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
}

/// Provides known type access via a simple backing array
public class CollectionKnownTypeProvider: KnownTypeProvider {
    // TODO: Cache by names in a dictionary, similar to
    // `IntentionCollectionTypeSystem`
    private var knownTypes: [KnownType]
    private var knownTypesByName: [String: [KnownType]] = [:]
    
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
    
    public func knownType(withName name: String) -> KnownType? {
        return knownTypesByName[name]?.first
    }
    
    public func knownTypes(ofKind kind: KnownTypeKind) -> [KnownType] {
        return knownTypes.filter { $0.kind == kind }
    }
}
