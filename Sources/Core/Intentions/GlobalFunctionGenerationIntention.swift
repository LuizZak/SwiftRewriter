import GrammarModelBase
import SwiftAST
import KnownType

/// An intention to generate a global function.
public class GlobalFunctionGenerationIntention: FromSourceIntention, FileLevelIntention, MutableSignatureFunctionIntention, MutableFunctionIntention, ParameterizedFunctionIntention, AttributeTaggeableObject {
    /*
    public var typedSource: ObjcFunctionDefinitionNode? {
        source as? ObjcFunctionDefinitionNode
    }
    */
    
    public var signature: FunctionSignature
    
    /// Gets the name of this global function definition by looking into its'
    /// signatures' name
    public var name: String {
        signature.name
    }
    
    public var parameters: [ParameterSignature] {
        signature.parameters
    }
    
    /// Returns `true` if this global function intention is a declaration, but not
    /// an implementation, of a global function signature.
    public var isDeclaration: Bool {
        functionBody == nil
    }
    
    public var functionBody: FunctionBodyIntention? {
        didSet {
            oldValue?.parent = nil
            functionBody?.parent = self
        }
    }
    
    public var knownAttributes: [KnownAttribute] = []
    
    public init(
        signature: FunctionSignature,
        functionBody: FunctionBodyIntention? = nil,
        accessLevel: AccessLevel = .internal,
        source: ASTNode? = nil
    ) {
        
        self.signature = signature
        self.functionBody = functionBody

        super.init(accessLevel: accessLevel, source: source)

        functionBody?.parent = self
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
        signature.asIdentifier
    }
    
    public var semantics: Set<Semantic> {
        []
    }
}
