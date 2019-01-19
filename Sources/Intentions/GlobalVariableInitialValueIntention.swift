import GrammarModels
import SwiftAST

/// An intention to generate the initial value for a global variable.
public final class GlobalVariableInitialValueIntention: FromSourceIntention {
    public var typedSource: InitialExpression? {
        return source as? InitialExpression
    }
    
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
    
    private enum CodingKeys: String, CodingKey {
        case expression
    }
}
