/// Represents the complete name of a function, based on function name and its
/// keywords, e.g. `function(a:b:_:)`
public struct FunctionIdentifier: Hashable, Equatable, CustomStringConvertible {
    /// Base name of function
    public var name: String
    
    /// Names of each argument of the function call.
    /// Nil argument labels indicate no argument label at that position.
    public var argumentLabels: [String?]
    
    public var description: String {
        let parameters = argumentLabels.map { ($0 ?? "_") + ":" }
        return "\(name)(\(parameters.joined()))"
    }
    
    public init(name: String, parameterNames: [String?]) {
        self.name = name
        self.argumentLabels = parameterNames
    }
}

public extension FunctionCallPostfix {
    func identifierWith(methodName: String) -> FunctionIdentifier {
        let arguments = self.arguments.map { $0.label }
        
        return FunctionIdentifier(name: methodName, parameterNames: arguments)
    }
}
