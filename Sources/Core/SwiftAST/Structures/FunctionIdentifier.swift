/// Represents the complete name of a function, based on function name and its
/// keywords, e.g. `function(a:b:_:)`
public struct FunctionIdentifier: Hashable, Equatable, Codable, CustomStringConvertible {
    /// Base name of function
    public var name: String
    
    /// Names of each argument of the function call.
    /// Nil argument labels indicate no argument label at that position.
    public var argumentLabels: [String?]
    
    public var description: String {
        let parameters = argumentLabels.map { ($0 ?? "_") + ":" }
        return "\(name)(\(parameters.joined()))"
    }
    
    public init(name: String, argumentLabels: [String?]) {
        self.name = name
        self.argumentLabels = argumentLabels
    }

    /// Initializes a function identifier based on a function name and all of the
    /// argument labels provided by `arguments`.
    public init(name: String, arguments: [FunctionArgument]) {
        self.init(name: name, argumentLabels: arguments.map(\.label))
    }

    /// Initializes a function identifier based on a function name and all of the
    /// argument labels provided by `parameters`.
    public init(name: String, parameters: [ParameterSignature]) {
        self.init(name: name, argumentLabels: parameters.map(\.label))
    }
}

public extension FunctionCallPostfix {
    func identifierWith(methodName: String) -> FunctionIdentifier {
        let arguments = self.arguments.map(\.label)
        
        return FunctionIdentifier(name: methodName, argumentLabels: arguments)
    }
}
