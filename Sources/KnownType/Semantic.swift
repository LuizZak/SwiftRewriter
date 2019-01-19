/// Represents a semantic annotation on a source type, method or property.
public struct Semantic: Hashable, Codable {
    public let name: String
    
    public init(name: String) {
        self.name = name
    }
}
