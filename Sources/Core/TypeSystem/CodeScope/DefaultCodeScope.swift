import SwiftAST

/// A default implementation of a code scope
public final class DefaultCodeScope: CodeScope {
    private var definitionsByName: [String: CodeDefinition] = [:]
    private var functionDefinitions: [FunctionIdentifier: [CodeDefinition]] = [:]
    internal var definitions: [CodeDefinition]
    
    public init(definitions: [CodeDefinition] = []) {
        self.definitions = definitions
        self.definitionsByName = definitions
            .groupBy(\.name)
            .mapValues { $0[0] }
        
        self.functionDefinitions =
            definitions
                .compactMap { def -> (FunctionIdentifier, CodeDefinition)? in
                    switch def.kind {
                    case .function(let signature):
                        return (signature.asIdentifier, def)
                    case .variable:
                        return nil
                    }
                }.groupBy(\.0)
                .mapValues { $0.map(\.1) }
    }
    
    public func firstDefinition(named name: String) -> CodeDefinition? {
        definitionsByName[name]
    }
    
    public func functionDefinitions(matching identifier: FunctionIdentifier) -> [CodeDefinition] {
        functionDefinitions[identifier] ?? []
    }
    
    public func allDefinitions() -> [CodeDefinition] {
        definitions
    }
    
    public func recordDefinition(_ definition: CodeDefinition, overwrite: Bool) {
        if overwrite {
            definitions.removeAll(where: { $0.name == definition.name })
        }

        definitions.append(definition)
        definitionsByName[definition.name] = definition
        
        switch definition.kind {
        case .function(let signature):
            functionDefinitions[signature.asIdentifier, default: []].append(definition)
            
        case .variable:
            break
        }
    }
    
    public func recordDefinitions(_ definitions: [CodeDefinition], overwrite: Bool) {
        for def in definitions {
            recordDefinition(def, overwrite: overwrite)
        }
    }
    
    public func removeAllDefinitions() {
        definitions.removeAll()
        definitionsByName.removeAll()
    }
}
