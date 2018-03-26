import SwiftAST

// TODO: Figure out a way to support overloading of functions with different count
// of parameters so we can support same function name with different parameter
// count

/// Base protocol for types that are used as target of type-creating objects
public protocol KnownTypeSink {
    func addType(_ type: KnownType)
}

/// Source for `GlobalsProvider` instances
public protocol GlobalsProvidersSource {
    var globalsProviders: [GlobalsProvider] { get }
}

/// Protocol for objects to register global definitions to a target global definitions
/// scope
public protocol GlobalsProvider {
    /// Gets a source for definitions for this globals provider
    func definitionsSource() -> DefinitionsSource
    
    func registerTypes(in typeSink: KnownTypeSink)
    func registerTypealiases(in typealiasSink: TypealiasSink)
}

/// Sources globals providers through an input array
public struct ArrayGlobalProvidersSource: GlobalsProvidersSource {
    public var globalsProviders: [GlobalsProvider]
}

public protocol TypealiasSink {
    func addTypealias(aliasName: String, originalType: SwiftType)
}
