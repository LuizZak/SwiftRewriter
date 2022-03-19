import GrammarModelBase
import SwiftAST

/// An intention to generate a `deinit` method for a reference type.
public class DeinitGenerationIntention: MemberGenerationIntention, MutableFunctionIntention {
    public override var children: [Intention] {
        super.children + (functionBody.map { [$0] } ?? [])
    }

    public var functionBody: FunctionBodyIntention? {
        didSet {
            oldValue?.parent = nil
            functionBody?.parent = self
        }
    }
    
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

    public override func accept<T: IntentionVisitor>(_ visitor: T) -> T.Result {
        visitor.visitDeinit(self)
    }
    
    private enum CodingKeys: String, CodingKey {
        case functionBody
    }
}
