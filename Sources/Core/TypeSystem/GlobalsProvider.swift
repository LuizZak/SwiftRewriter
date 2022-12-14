import SwiftAST

/// Source for `GlobalsProvider` instances
public protocol GlobalsProvidersSource {
    var globalsProviders: [GlobalsProvider] { get }
}

/// Protocol for objects to register global definitions to a target global definitions
/// scope
public protocol GlobalsProvider {
    /// Gets a source for definitions for this globals provider
    func definitionsSource() -> DefinitionsSource
    
    /// Gets a typealias provider for this globals provider
    func typealiasProvider() -> TypealiasProvider
    
    /// Gets a known type provider for this globals provider
    func knownTypeProvider() -> KnownTypeProvider
}

/// Sources globals providers through an input array
public struct ArrayGlobalProvidersSource: GlobalsProvidersSource {
    public var globalsProviders: [GlobalsProvider]
    
    public init(globalsProviders: [GlobalsProvider]) {
        self.globalsProviders = globalsProviders
    }
}
