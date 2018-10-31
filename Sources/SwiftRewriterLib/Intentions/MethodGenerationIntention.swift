import ObjcParser
import SwiftAST
import GrammarModels

/// An intention to generate a static/instance function for a type.
public class MethodGenerationIntention: MemberGenerationIntention, FunctionIntention {
    public var typedSource: MethodDefinition? {
        return source as? MethodDefinition
    }
    
    public var isOverride: Bool = false
    
    public var signature: FunctionSignature
    
    public var functionBody: FunctionBodyIntention?
    
    public override var isStatic: Bool {
        return signature.isStatic
    }
    public var optional: Bool {
        return false
    }
    
    public var name: String {
        return signature.name
    }
    public var returnType: SwiftType {
        return signature.returnType
    }
    public var parameters: [ParameterSignature] {
        return signature.parameters
    }
    public var selector: SelectorSignature {
        return signature.asSelector
    }
    public override var memberType: SwiftType {
        return signature.swiftClosureType
    }
    
    public convenience init(isStatic: Bool,
                            name: String,
                            returnType: SwiftType,
                            parameters: [ParameterSignature],
                            accessLevel: AccessLevel = .internal,
                            source: ASTNode? = nil) {
        
        let signature =
            FunctionSignature(name: name,
                              parameters: parameters,
                              returnType: returnType,
                              isStatic: isStatic,
                              isMutating: false)
        
        self.init(signature: signature,
                  accessLevel: accessLevel,
                  source: source)
    }
    
    public init(signature: FunctionSignature,
                accessLevel: AccessLevel = .internal,
                source: ASTNode? = nil) {
        
        self.signature = signature
        super.init(accessLevel: accessLevel, source: source)
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        isOverride = try container.decode(Bool.self, forKey: .isOverride)
        signature = try container.decode(FunctionSignature.self, forKey: .signature)
        functionBody = try container.decodeIfPresent(FunctionBodyIntention.self, forKey: .functionBody)
        
        try super.init(from: container.superDecoder())
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(isOverride, forKey: .isOverride)
        try container.encode(signature, forKey: .signature)
        try container.encode(functionBody, forKey: .functionBody)
        
        try super.encode(to: container.superEncoder())
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
        return functionBody
    }
}
