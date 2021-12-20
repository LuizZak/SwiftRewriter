import ObjcGrammarModels
import SwiftAST

/// An intention to generate a `deinit` method for a reference type.
public class DeinitGenerationIntention: MemberGenerationIntention, MutableFunctionIntention {
    public var functionBody: FunctionBodyIntention?
    
    public override init(accessLevel: AccessLevel = .internal,
                         source: ASTNode? = nil) {
        
        super.init(accessLevel: accessLevel, source: source)
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        functionBody = try container.decodeIntentionIfPresent(forKey: .functionBody)
        
        try super.init(from: container.superDecoder())
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeIntentionIfPresent(functionBody, forKey: .functionBody)
        
        try super.encode(to: container.superEncoder())
    }
    
    private enum CodingKeys: String, CodingKey {
        case functionBody
    }
}
