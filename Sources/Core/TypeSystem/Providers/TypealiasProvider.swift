import SwiftAST
import Utils

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
    @ConcurrentValue private var aliasesCache: [Int: SwiftType] = [:]
    @ConcurrentValue private var negativeLookups: Set<String> = []
    
    public var providers: [TypealiasProvider]
    
    public init(providers: [TypealiasProvider]) {
        self.providers = providers
    }
    
    func makeCache() {
        _aliasesCache.setAsCaching(value: [:])
        _negativeLookups.setAsCaching(value: [])
    }
    
    func tearDownCache() {
        _aliasesCache.tearDownCaching(resetToValue: [:])
        _negativeLookups.tearDownCaching(resetToValue: [])
    }
    
    public func unalias(_ typeName: String) -> SwiftType? {
        if _aliasesCache.usingCache, let type = aliasesCache[typeName.hashValue] {
            return type
        }
        
        // Negative lookups
        if _negativeLookups.usingCache, negativeLookups.contains(typeName) {
            return nil
        }
        
        for provider in providers {
            if let type = provider.unalias(typeName) {
                
                if _aliasesCache.usingCache {
                    aliasesCache[typeName.hashValue] = type
                }
                
                return type
            }
        }
        
        // Store negative lookups
        if _negativeLookups.usingCache {
            negativeLookups.insert(typeName)
        }
        
        return nil
    }
    
    public func addTypealiasProvider(_ typealiasProvider: TypealiasProvider) {
        providers.append(typealiasProvider)
        
        // Reset cache to allow types from this type alias provider to be
        // considered.
        if _aliasesCache.usingCache {
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
        aliases[typeName]
    }
}
