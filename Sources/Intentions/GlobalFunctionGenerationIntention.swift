import GrammarModels
import SwiftAST
import KnownType

/// An intention to generate a global function.
public class GlobalFunctionGenerationIntention: FromSourceIntention, FileLevelIntention, MutableSignatureFunctionIntention, MutableFunctionIntention, AttributeTaggeableObject {
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
    
    public var knownAttributes: [KnownAttribute] = []
    
    public init(signature: FunctionSignature,
                accessLevel: AccessLevel = .internal,
                source: ASTNode? = nil) {
        
        self.signature = signature
        super.init(accessLevel: accessLevel, source: source)
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.signature = try container.decode(FunctionSignature.self, forKey: .signature)
        self.functionBody = try container.decodeIntentionIfPresent(forKey: .functionBody)
        
        try super.init(from: container.superDecoder())
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(signature, forKey: .signature)
        try container.encodeIntentionIfPresent(functionBody, forKey: .functionBody)
        
        try super.encode(to: container.superEncoder())
    }
    
    private enum CodingKeys: String, CodingKey {
        case signature
        case functionBody
    }
}

extension GlobalFunctionGenerationIntention: KnownGlobalFunction {
    public var identifier: FunctionIdentifier {
        return signature.asIdentifier
    }
    
    public var semantics: Set<Semantic> {
        return []
    }
}
