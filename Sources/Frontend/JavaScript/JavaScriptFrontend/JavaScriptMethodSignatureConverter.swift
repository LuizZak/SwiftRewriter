import JsGrammarModels
import SwiftAST
import TypeSystem

/// A helper class that can be used to generate a proper swift method signature
/// from an JavaScript method signature.
public class JavaScriptMethodSignatureConverter {
    public init() {
        
    }
    
    /// Generates a function definition from an JavaScript signature to use as
    /// a function definition.
    ///
    /// Returns `nil` if `function.identifier` and/or `function.signature` is `nil`.
    public func generateDefinitionSignature(from function: JsFunctionNodeType) -> FunctionSignature? {
        _generate(from: function)
    }
    
    /// Generates a function definition from an JavaScript signature to use as
    /// a function definition.
    ///
    /// Returns `nil` if `function.identifier` and/or `function.signature` is `nil`.
    public func generateDefinitionSignature(from method: JsMethodDefinitionNode) -> FunctionSignature? {
        var signature = _generate(from: method)
        signature?.isStatic = method.isStatic

        return signature
    }

    private func _generate(from function: JsFunctionNodeType) -> FunctionSignature? {
        guard let identifier = function.identifier else {
            return nil
        }
        guard let signature = function.signature else {
            return nil
        }

        let parameters: [ParameterSignature] = signature.arguments.map {
            .init(label: nil, name: $0.identifier, type: .any, isVariadic: $0.isVariadic, hasDefaultValue: false)
        }

        return FunctionSignature(
            name: identifier.name,
            parameters: parameters,
            returnType: .any,
            isStatic: false,
            isMutating: false
        )
    }
}
