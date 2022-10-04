/// Helper functions for generating friendly textual representations of types,
/// methods and other constructs.
public enum TypeFormatter {
    /// Generates a string representation of a given function signature.
    /// The signature's name can be optionally include during conversion.
    public static func asString(
        signature: FunctionSignature,
        includeName: Bool = false,
        includeTraits: Bool = true,
        includeFuncKeyword: Bool = false,
        includeStatic: Bool = true
    ) -> String {
        
        var result = ""
        
        if signature.isStatic && includeStatic {
            result += "static "
        }

        if includeTraits {
            let traitDesc = signature.traits.subtracting(.static).description

            if !traitDesc.isEmpty {
                result += traitDesc + " "
            }
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

    /// Generates a string representation of a given subscript signature.
    public static func asString(
        signature: SubscriptSignature,
        includeSubscriptKeyword: Bool = true,
        includeStatic: Bool = true
    ) -> String {
        
        var result = ""
        
        if signature.isStatic && includeStatic {
            result += "static "
        }
        
        if includeSubscriptKeyword {
            result += "subscript"
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
        
        result += parameters.map(\.description).joined(separator: ", ")
        
        return result + ")"
    }
    
    public static func stringify(_ type: SwiftType) -> String {
        type.description
    }
}
