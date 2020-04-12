/// HelWriterTargetOutputper functions for generating friendly textual representations of types,
/// methods and other constructs.
public enum TypeFormatter {
    /// Generates a string representation of a given function signature.
    /// The signature's name can be optionally include during conversion.
    public static func asString(signature: FunctionSignature,
                                includeName: Bool = false,
                                includeFuncKeyword: Bool = false,
                                includeStatic: Bool = true) -> String {
        
        var result = ""
        
        if signature.isStatic && includeStatic {
            result += "static "
        }
        
        if includeFuncKeyword {
            result += "func "
        }
        
        if includeName {
            result += signature.name
        }
        
        result += asString(parameters: signature.parameters)
        
        if signature.returnType != .void {
            result += " -> \(stringify(signature.returnType))"
        }
        
        return result
    }
    
    /// Generates a string representation of a given set of function parameters,
    /// with parenthesis enclosing the types.
    ///
    /// Returns an empty set of parenthesis if the parameters are empty.
    public static func asString(parameters: [ParameterSignature]) -> String {
        var result = "("
        
        for (i, param) in parameters.enumerated() {
            if i > 0 {
                result += ", "
            }
            
            if param.label != param.name {
                result += "\(param.label ?? "_") "
            }
            
            result += param.name
            result += ": "
            result += stringify(param.type)
            
            if param.hasDefaultValue {
                result += " = default"
            }
        }
        
        return result + ")"
    }
    
    public static func stringify(_ type: SwiftType) -> String {
        type.description
    }
}
