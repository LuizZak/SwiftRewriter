import GrammarModelBase
import SwiftAST
import KnownType

/// An intention to generate a static/instance function for a type.
public class MethodGenerationIntention: MemberGenerationIntention, ParameterizedFunctionIntention, MutableFunctionIntention, MutableSignatureFunctionIntention {
    public override var children: [Intention] {
        (functionBody.map { [$0] } ?? [])
    }
    
    public var isOverride: Bool = false
    
    public var signature: FunctionSignature
    
    public var functionBody: FunctionBodyIntention? {
        didSet {
            oldValue?.parent = nil
            functionBody?.parent = self
        }
    }
    
    public override var isStatic: Bool {
        signature.isStatic
    }
    public var optional: Bool {
        false
    }
    
    public var name: String {
        signature.name
    }
    public var returnType: SwiftType {
        signature.returnType
    }
    public var parameters: [ParameterSignature] {
        signature.parameters
    }
    public var selector: SelectorSignature {
        signature.asSelector
    }
    public override var memberType: SwiftType {
        .block(signature.swiftClosureType)
    }
    
    public convenience init(
        isStatic: Bool,
        name: String,
        returnType: SwiftType,
        parameters: [ParameterSignature],
        accessLevel: AccessLevel = .internal,
        source: ASTNode? = nil
    ) {
        
        let signature =
            FunctionSignature(
                name: name,
                parameters: parameters,
                returnType: returnType,
                isStatic: isStatic,
                isMutating: false
            )
        
        self.init(
            signature: signature,
            accessLevel: accessLevel,
            source: source
        )
    }
    
    public init(
        signature: FunctionSignature,
        functionBody: FunctionBodyIntention? = nil,
        accessLevel: AccessLevel = .internal,
        source: ASTNode? = nil
    ) {
        self.functionBody = functionBody
        self.signature = signature
        
        super.init(accessLevel: accessLevel, source: source)

        self.functionBody?.parent = self
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        isOverride = try container.decode(Bool.self, forKey: .isOverride)
        signature = try container.decode(FunctionSignature.self, forKey: .signature)
        functionBody = try container.decodeIntentionIfPresent(forKey: .functionBody)
        
        try super.init(from: container.superDecoder())
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(isOverride, forKey: .isOverride)
        try container.encode(signature, forKey: .signature)
        try container.encodeIntentionIfPresent(functionBody, forKey: .functionBody)
        
        try super.encode(to: container.superEncoder())
    }

    public override func accept<T: IntentionVisitor>(_ visitor: T) -> T.Result {
        visitor.visitMethod(self)
    }
    
    private enum CodingKeys: String, CodingKey {
        case isOverride
        case signature
        case functionBody
    }
}

extension MethodGenerationIntention: OverridableMemberGenerationIntention {
    
}

extension MethodGenerationIntention: KnownMethod {
    public var body: KnownMethodBody? {
        functionBody
    }
}
