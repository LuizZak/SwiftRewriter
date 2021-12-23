import JsGrammarModels
import SwiftAST
import TypeSystem

/// A helper class that can be used to generate a proper swift method signature
/// from an JavaScript method signature.
public class JavaScriptMethodSignatureConverter {
    private let typeMapper: TypeMapper
    private let inNonnullContext: Bool
    private let instanceTypeAlias: SwiftType?
    
    public init(typeMapper: TypeMapper, inNonnullContext: Bool, instanceTypeAlias: SwiftType? = nil) {
        self.typeMapper = typeMapper
        self.inNonnullContext = inNonnullContext
        self.instanceTypeAlias = instanceTypeAlias
    }
    
    /// Generates a function definition from an JavaScript signature to use as
    /// a class-type function definition.
    public func generateDefinitionSignature(from method: JsMethodDefinitionNode) -> FunctionSignature {
        fatalError("Not implemented")
    }
    
    /// Generates a function definition from a JavaScript function signature to
    /// use as a global function signature.
    public func generateDefinitionSignature(from function: JsFunctionDeclarationNode) -> FunctionSignature {
        fatalError("Not implemented")
    }
}
