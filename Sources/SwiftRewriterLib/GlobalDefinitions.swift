/// A storage for global definitions
public class GlobalDefinitions {
    internal(set) public var definitions: [CodeDefinition] = []
    
    public init() {
        
    }
    
    public func recordDefinition(_ definition: CodeDefinition) {
        definitions.append(definition)
    }
}
