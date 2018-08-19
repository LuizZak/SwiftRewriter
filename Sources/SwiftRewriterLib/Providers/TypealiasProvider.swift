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
    public var providers: [TypealiasProvider]
    
    public init(providers: [TypealiasProvider]) {
        self.providers = providers
    }
    
    public func unalias(_ typeName: String) -> SwiftType? {
        for provider in providers {
            if let type = provider.unalias(typeName) {
                return type
            }
        }
        
        return nil
    }
    
    public func addTypealiasProvider(_ typealiasProvider: TypealiasProvider) {
        providers.append(typealiasProvider)
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
