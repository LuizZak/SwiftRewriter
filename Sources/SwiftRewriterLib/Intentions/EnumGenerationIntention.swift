import GrammarModels
import SwiftAST

/// An intention to generate a Swift enumeration type
public class EnumGenerationIntention: TypeGenerationIntention {
    public var typedSource: ObjcEnumDeclaration? {
        return source as? ObjcEnumDeclaration
    }
    
    public override var kind: KnownTypeKind {
        return .enum
    }
    
    public var rawValueType: SwiftType
    
    public var cases: [EnumCaseGenerationIntention] {
        return properties.compactMap { $0 as? EnumCaseGenerationIntention }
    }
    
    public init(typeName: String, rawValueType: SwiftType,
                accessLevel: AccessLevel = .internal, source: ASTNode? = nil) {
        self.rawValueType = rawValueType
        super.init(typeName: typeName, accessLevel: accessLevel, source: source)
        
        setKnownTrait(KnownTypeTraits.enumRawValue, value: TraitType.swiftType(rawValueType))
    }
    
    public func addCase(_ enumCase: EnumCaseGenerationIntention) {
        addProperty(enumCase)
        enumCase.storage.type = .typeName(typeName)
        enumCase.parent = self
    }
}
