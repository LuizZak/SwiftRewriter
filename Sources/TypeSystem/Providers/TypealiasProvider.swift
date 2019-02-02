import SwiftAST

/// Provides typealias conversions from a string typename to a `SwiftType`
/// structure.
public protocol TypealiasProvider {
    /// Queries this typealias provider for a typealias with a given name.
    /// Returns `nil`, in case no typealias with a matching name is found.
    func unalias(_ typeName: String) -> SwiftType?
}

/// Gathers one or more typealias providers into a single `TypealiasProvider`
/// interface.
public class CompoundTypealiasProvider: TypealiasProvider {
    private var aliasesCache = ConcurrentValue<[Int: SwiftType]>()
    private var negativeLookups = ConcurrentValue<Set<String>>()
    
    public var providers: [TypealiasProvider]
    
    public init(providers: [TypealiasProvider]) {
        self.providers = providers
    }
    
    func makeCache() {
        aliasesCache.setup(value: [:])
        negativeLookups.setup(value: [])
    }
    
    func tearDownCache() {
        aliasesCache.tearDown()
        negativeLookups.tearDown()
    }
    
    public func unalias(_ typeName: String) -> SwiftType? {
        if aliasesCache.usingCache, let type = aliasesCache.readingValue({ $0?[typeName.hashValue] }) {
            return type
        }
        
        // Negative lookups
        if negativeLookups.usingCache, negativeLookups.readingValue({ $0?.contains(typeName) == true }) {
            return nil
        }
        
        for provider in providers {
            if let type = provider.unalias(typeName) {
                
                if aliasesCache.usingCache {
                    aliasesCache.modifyingValue { value in
                        value?[typeName.hashValue] = type
                    }
                }
                
                return type
            }
        }
        
        // Store negative lookups
        if negativeLookups.usingCache {
            negativeLookups.modifyingValue { value -> Void in
                value?.insert(typeName)
            }
        }
        
        return nil
    }
    
    public func addTypealiasProvider(_ typealiasProvider: TypealiasProvider) {
        providers.append(typealiasProvider)
        
        // Reset cache to allow types from this type alias provider to be
        // considered.
        if aliasesCache.usingCache {
            tearDownCache()
            makeCache()
        }
    }
}

/// Provides typealiases by mapping them from a stored dictionary
public class CollectionTypealiasProvider: TypealiasProvider {
    private var aliases: [String: SwiftType]
    
    public init(aliases: [String: SwiftType] = [:]) {
        self.aliases = aliases
    }
    
    public func removeAllTypealises() {
        aliases.removeAll()
    }
    
    public func addTypealias(_ typeName: String, _ type: SwiftType) {
        aliases[typeName] = type
    }
    
    public func unalias(_ typeName: String) -> SwiftType? {
        return aliases[typeName]
    }
}
