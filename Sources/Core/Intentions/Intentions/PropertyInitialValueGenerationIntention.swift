import GrammarModelBase
import SwiftAST

public class PropertyInitialValueGenerationIntention: FromSourceIntention {
    public var expression: Expression
    
    public init(expression: Expression, source: ASTNode?) {
        self.expression = expression
        
        super.init(accessLevel: .public, source: source)
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        expression = try container.decodeExpression(forKey: .expression)
        
        try super.init(from: container.superDecoder())
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeExpression(expression, forKey: .expression)
        
        try super.encode(to: container.superEncoder())
    }

    public override func accept<T: IntentionVisitor>(_ visitor: T) -> T.Result {
        visitor.visitPropertyInitialValue(self)
    }
    
    private enum CodingKeys: String, CodingKey {
        case expression
    }
}
