import SwiftAST

/// A default implementation of a code scope
public final class DefaultCodeScope: CodeScope {
    private var source: ArrayDefinitionsSource
    internal var definitions: [CodeDefinition] {
        didSet {
            source = ArrayDefinitionsSource(definitions: definitions)
        }
    }
    
    public init(definitions: [CodeDefinition] = []) {
        self.definitions = definitions
        self.source = ArrayDefinitionsSource(definitions: definitions)
    }
    
    public func firstDefinition(named name: String) -> CodeDefinition? {
        source.firstDefinition(named: name)
    }
    
    public func functionDefinitions(matching identifier: FunctionIdentifier) -> [CodeDefinition] {
        source.functionDefinitions(matching: identifier)
    }
    
    public func functionDefinitions(named name: String) -> [CodeDefinition] {
        source.functionDefinitions(named: name)
    }
    
    public func localDefinitions() -> [CodeDefinition] {
        source.localDefinitions()
    }
    
    public func recordDefinition(_ definition: CodeDefinition, overwrite: Bool) {
        if overwrite {
            definitions.removeAll(where: { $0.name == definition.name })
        }

        definitions.append(definition)
    }
    
    public func recordDefinitions(_ definitions: [CodeDefinition], overwrite: Bool) {
        for def in definitions {
            recordDefinition(def, overwrite: overwrite)
        }
    }
    
    public func removeLocalDefinitions() {
        definitions.removeAll()
    }
}
