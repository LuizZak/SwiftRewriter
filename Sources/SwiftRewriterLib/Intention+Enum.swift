import GrammarModels
import SwiftAST

/// An intention to generate a Swift enumeration type
public class EnumGenerationIntention: TypeGenerationIntention {
    public var rawValueType: SwiftType
    
    private(set) public var cases: [EnumCaseGenerationIntention] = []
    
    public init(typeName: String, rawValueType: SwiftType,
                accessLevel: AccessLevel = .internal, source: ASTNode? = nil) {
        self.rawValueType = rawValueType
        super.init(typeName: typeName, accessLevel: accessLevel, source: source)
    }
    
    public func addCase(_ enumCase: EnumCaseGenerationIntention) {
        cases.append(enumCase)
        enumCase.parent = self
    }
}

public class EnumCaseGenerationIntention: FromSourceIntention {
    public var name: String
    public var expression: Expression?
    
    public init(name: String, expression: Expression?,
                accessLevel: AccessLevel = .internal, source: ASTNode? = nil) {
        self.name = name
        self.expression = expression
        
        super.init(accessLevel: accessLevel, source: source)
    }
}
