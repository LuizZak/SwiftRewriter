import GrammarModels
import SwiftAST

/// An intention to generate a global function.
public class GlobalFunctionGenerationIntention: FromSourceIntention, FileLevelIntention, FunctionIntention {
    public var typedSource: FunctionDefinition? {
        return source as? FunctionDefinition
    }
    
    public var signature: FunctionSignature
    
    /// Gets the name of this global function definition by looking into its'
    /// signatures' name
    public var name: String {
        return signature.name
    }
    
    public var parameters: [ParameterSignature] {
        return signature.parameters
    }
    
    /// Returns `true` if this global function intention is a declaration, but not
    /// an implementation, of a global function signature.
    public var isDeclaration: Bool {
        return functionBody == nil
    }
    
    public var functionBody: FunctionBodyIntention?
    
    public init(signature: FunctionSignature, accessLevel: AccessLevel = .internal, source: ASTNode? = nil) {
        self.signature = signature
        super.init(accessLevel: accessLevel, source: source)
    }
}
