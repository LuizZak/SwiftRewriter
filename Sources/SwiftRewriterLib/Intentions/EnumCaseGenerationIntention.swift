import GrammarModels
import SwiftAST

public class EnumCaseGenerationIntention: PropertyGenerationIntention {
    public var expression: Expression?
    
    public override var isStatic: Bool {
        return true // Enum cases are always static
    }
    
    public override var isEnumCase: Bool {
        return true
    }
    
    public init(name: String, expression: Expression?,
                accessLevel: AccessLevel = .internal, source: ASTNode? = nil) {
        self.expression = expression
        
        let storage = ValueStorage(type: .any, ownership: .strong, isConstant: true)
        
        super.init(name: name, storage: storage, attributes: [], accessLevel: accessLevel, source: source)
    }
}
