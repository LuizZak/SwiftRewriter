// TODO: Figure out a way to support overloading of functions with different count
// of parameters so we can support same function name with different parameter
// count

/// Base protocol for types that are used as target of type-creating objects
public protocol KnownTypeSink {
    func addType(_ type: KnownType)
}

/// A storage for global definitions
public class GlobalDefinitions: DefinitionsSource {
    internal(set) public var definitions: [CodeDefinition] = []
    
    public init() {
        
    }
    
    public func recordDefinition(_ definition: CodeDefinition) {
        definitions.append(definition)
    }
    
    public func allDefinitions() -> [CodeDefinition] {
        return definitions
    }
    
    public func definition(named name: String) -> CodeDefinition? {
        return definitions.first { $0.name == name }
    }
}

/// Source for `GlobalsProvider` instances
public protocol GlobalsProvidersSource {
    var globalsProviders: [GlobalsProvider] { get }
}

/// Protocol for objects to register global definitions to a target global definitions
/// scope
public protocol GlobalsProvider {
    func registerDefinitions(on globals: GlobalDefinitions)
    func registerTypes(in typeSink: KnownTypeSink)
}

public extension GlobalsProvider {
    func registerTypes(in typeSink: KnownTypeSink) {
        
    }
}

/// Sources globals providers through an input array
public struct ArrayGlobalProvidersSource: GlobalsProvidersSource {
    public var globalsProviders: [GlobalsProvider]
}
