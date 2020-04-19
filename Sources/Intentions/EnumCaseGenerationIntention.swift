import GrammarModels
import SwiftAST

public class EnumCaseGenerationIntention: PropertyGenerationIntention {
    public var typedSource: ObjcEnumCase? {
        return source as? ObjcEnumCase
    }
    
    public var expression: Expression?
    
    public override var isStatic: Bool {
        true // Enum cases are always static
    }
    
    public override var isEnumCase: Bool {
        true
    }
    
    public init(name: String,
                expression: Expression?,
                accessLevel: AccessLevel = .internal,
                source: ASTNode? = nil) {
        
        self.expression = expression
        
        let storage = ValueStorage(type: .any, ownership: .strong, isConstant: true)
        
        super.init(name: name,
                   storage: storage,
                   objcAttributes: [],
                   accessLevel: accessLevel,
                   source: source)
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        expression = try container.decodeExpressionIfPresent(forKey: .expression)
        
        try super.init(from: container.superDecoder())
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeExpressionIfPresent(expression, forKey: .expression)
        
        try super.encode(to: container.superEncoder())
    }
    
    private enum CodingKeys: String, CodingKey {
        case expression
    }
}
