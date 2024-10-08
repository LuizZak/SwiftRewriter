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

    public func firstDefinition(where predicate: (CodeDefinition) -> Bool) -> CodeDefinition? {
        for source in sources {
            if let def = source.firstDefinition(where: predicate) {
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

    public func functionDefinitions(named name: String) -> [CodeDefinition] {
        var definitions: [CodeDefinition] = []

        for source in sources {
            let defs = source.functionDefinitions(named: name)

            definitions.append(contentsOf: defs)
        }

        return definitions
    }

    public func functionDefinitions(where predicate: (CodeDefinition) -> Bool) -> [CodeDefinition] {
        var result: [CodeDefinition] = []

        for source in sources {
            result.append(contentsOf: source.functionDefinitions(where: predicate))
        }

        return result
    }

    public func localDefinitions() -> [CodeDefinition] {
        sources.flatMap { $0.localDefinitions() }
    }
}
