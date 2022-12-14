/// Represents the complete identifier signature of a subscript, based on
/// its keyword labels, e.g. `subscript(a:b:_:)`
public struct SubscriptIdentifier: Hashable, Equatable, Codable, CustomStringConvertible {
    /// Names of each argument of the subscript access.
    /// Nil argument labels indicate no argument label at that position.
    public var argumentLabels: [String?]
    
    public var description: String {
        let parameters = argumentLabels.map { ($0 ?? "_") + ":" }
        return "subscript(\(parameters.joined()))"
    }
    
    public init(argumentLabels: [String?]) {
        self.argumentLabels = argumentLabels
    }
}

public extension SubscriptPostfix {
    func identifier() -> SubscriptIdentifier {
        let arguments = self.arguments.map(\.label)
        
        return SubscriptIdentifier(argumentLabels: arguments)
    }
}
