import GrammarModels
import SwiftAST

/// An intention to generate a Swift enumeration type
public class EnumGenerationIntention: TypeGenerationIntention {
    public var rawValueType: SwiftType
    
    public var cases: [EnumCaseGenerationIntention] {
        return properties.compactMap { $0 as? EnumCaseGenerationIntention }
    }
    
    public init(typeName: String, rawValueType: SwiftType,
                accessLevel: AccessLevel = .internal, source: ASTNode? = nil) {
        self.rawValueType = rawValueType
        super.init(typeName: typeName, accessLevel: accessLevel, source: source)
    }
    
    public func addCase(_ enumCase: EnumCaseGenerationIntention) {
        addProperty(enumCase)
        enumCase.storage.type = .typeName(typeName)
        enumCase.parent = self
    }
}

public class EnumCaseGenerationIntention: PropertyGenerationIntention {
    public var expression: Expression?
    
    public override var isStatic: Bool {
        return true // Enum cases are always static
    }
    
    public init(name: String, expression: Expression?,
                accessLevel: AccessLevel = .internal, source: ASTNode? = nil) {
        self.expression = expression
        
        let storage = ValueStorage(type: .any, ownership: .strong, isConstant: true)
        
        super.init(name: name, storage: storage, attributes: [], accessLevel: accessLevel, source: source)
    }
}
