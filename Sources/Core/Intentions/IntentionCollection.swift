/// Represents a centralization point where all source code generation intentions
/// are placed and queried for.
public class IntentionCollection: Codable {
    private var _intentions: [FileGenerationIntention] = []
    
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        _intentions = try container.decodeIntentions(forKey: .files)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeIntentions(_intentions, forKey: .files)
    }
    
    public func fileIntentions() -> [FileGenerationIntention] {
        _intentions
    }
    
    /// Gets all global variable intentions across all files
    public func globalVariables() -> [GlobalVariableGenerationIntention] {
        _intentions.flatMap(\.globalVariableIntentions)
    }
    
    /// Gets all global functions intentions across all files
    public func globalFunctions() -> [GlobalFunctionGenerationIntention] {
        _intentions.flatMap(\.globalFunctionIntentions)
    }
    
    /// Performs a full search of all types intended to be created on all files.
    public func typeIntentions() -> [TypeGenerationIntention] {
        _intentions.flatMap(\.typeIntentions)
    }
    
    /// Gets all nominal class generation intentions across all files
    public func classIntentions() -> [ClassGenerationIntention] {
        _intentions.flatMap(\.classIntentions)
    }
    
    /// Gets all extension intentions across all files
    public func extensionIntentions() -> [ClassExtensionGenerationIntention] {
        _intentions.flatMap(\.extensionIntentions)
    }
    
    /// Gets all protocols intended to be created on all files.
    public func protocolIntentions() -> [ProtocolGenerationIntention] {
        _intentions.flatMap(\.protocolIntentions)
    }
    
    /// Performs a full search of all typealias intended to be created on all files.
    public func typealiasIntentions() -> [TypealiasIntention] {
        _intentions.flatMap(\.typealiasIntentions)
    }
    
    public func intentionFor(fileNamed name: String) -> FileGenerationIntention? {
        fileIntentions().first { $0.targetPath == name }
    }
    
    public func addIntention(_ intention: FileGenerationIntention) {
        _intentions.append(intention)
        intention.intentionCollection = self
    }

    /// Removes all intentions stored within this intention collection.
    public func removeAll() {
        _intentions.removeAll()
    }
    
    public func removeIntention(where predicate: (FileGenerationIntention) -> Bool) {
        for (i, item) in _intentions.enumerated() {
            if predicate(item) {
                _intentions.remove(at: i)
                item.intentionCollection = nil
                return
            }
        }
    }
    
    public func removeIntentions(where predicate: (FileGenerationIntention) -> Bool) {
        for (i, item) in _intentions.enumerated().reversed() {
            if predicate(item) {
                _intentions.remove(at: i)
                item.intentionCollection = nil
            }
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case files
    }
}

extension IntentionCollection {
    public func sortFileIntentions() {
        _intentions.sort { $0.index < $1.index }
    }
}
