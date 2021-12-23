import GrammarModelBase
import SwiftAST

public class EnumCaseGenerationIntention: PropertyGenerationIntention {
    /*
    public var typedSource: ObjcEnumCaseNode? {
        return source as? ObjcEnumCaseNode
    }
    */

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
        
        let storage = ValueStorage(type: .any, ownership: .strong, isConstant: true)
        
        super.init(name: name,
                   storage: storage,
                   objcAttributes: [],
                   accessLevel: accessLevel,
                   source: source)
        
        initialValue = expression
    }
    
    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
    
    private enum CodingKeys: String, CodingKey {
        case expression
    }
}
