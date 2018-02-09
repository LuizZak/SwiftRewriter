/// Represents a centralization point where all source code generation intentions
/// are placed and queried for.
public class IntentionCollection {
    private var _intentions: [Intention] = []
    
    public func allIntentions() -> [Intention] {
        return _intentions
    }
    
    public func intentionFor(fileNamed name: String) -> FileGenerationIntention? {
        return intentions().first { $0.filePath == name }
    }
    
    public func intentionFor(classNamed name: String) -> ClassGenerationIntention? {
        return intentions().first { $0.typeName == name }
    }
    
    public func intentionFor(structNamed name: String) -> StructGenerationIntention? {
        return intentions().first { $0.typeName == name }
    }
    
    public func intentionFor(enumNamed name: String) -> EnumGenerationIntention? {
        return intentions().first { $0.typeName == name }
    }
    
    public func addIntention(_ intention: Intention) {
        _intentions.append(intention)
    }
    
    public func intentions<T>(ofType type: T.Type = T.self) -> [T] {
        return _intentions.compactMap { $0 as? T }
    }
    
    public func removeIntention<T>(where predicate: (T) -> Bool) {
        for (i, item) in _intentions.enumerated() {
            if let it = item as? T, predicate(it) {
                _intentions.remove(at: i)
                return
            }
        }
    }
    
    public func removeIntentions<T>(where predicate: (T) -> Bool) {
        for (i, item) in _intentions.enumerated().reversed() {
            if let it = item as? T, predicate(it) {
                _intentions.remove(at: i)
            }
        }
    }
}
