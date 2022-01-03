import SwiftAST

/// A definitions source composed of individual definition sources composed as
/// a single definition source.
public class CompoundDefinitionsSource: DefinitionsSource {
    private var sources: [DefinitionsSource]
    
    public init() {
        sources = []
    }
    
    public init(sources: [DefinitionsSource]) {
        self.sources = sources
    }
    
    public func addSource(_ definitionSource: DefinitionsSource) {
        sources.append(definitionSource)
    }
    
    public func firstDefinition(named name: String) -> CodeDefinition? {
        for source in sources {
            if let def = source.firstDefinition(named: name) {
                return def
            }
        }
        
        return nil
    }
    
    public func functionDefinitions(matching identifier: FunctionIdentifier) -> [CodeDefinition] {
        var definitions: [CodeDefinition] = []
        
        for source in sources {
            let defs = source.functionDefinitions(matching: identifier)
            
            definitions.append(contentsOf: defs)
        }
        
        return definitions
    }
    
    public func allDefinitions() -> [CodeDefinition] {
        sources.flatMap { $0.allDefinitions() }
    }
}
