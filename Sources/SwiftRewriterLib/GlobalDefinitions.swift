/// A storage for global definitions
public class GlobalDefinitions {
    internal(set) public var definitions: [CodeDefinition] = []
    
    public init() {
        
    }
    
    public func recordDefinition(_ definition: CodeDefinition) {
        definitions.append(definition)
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
}

/// Sources globals providers through an input array
public struct ArrayGlobalProvidersSource: GlobalsProvidersSource {
    public var globalsProviders: [GlobalsProvider]
}
