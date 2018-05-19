import GrammarModels
import SwiftAST

/// An intention to create an instance variable (Objective-C's 'ivar').
public class InstanceVariableGenerationIntention: MemberGenerationIntention, ValueStorageIntention {
    public var typedSource: IVarDeclaration? {
        return source as? IVarDeclaration
    }
    
    public var name: String
    public var storage: ValueStorage
    
    public override var memberType: SwiftType {
        return type
    }
    
    public init(name: String, storage: ValueStorage, accessLevel: AccessLevel = .internal,
                source: ASTNode? = nil) {
        self.name = name
        self.storage = storage
        super.init(accessLevel: accessLevel, source: source)
    }
}

extension InstanceVariableGenerationIntention: KnownProperty {
    public var attributes: [PropertyAttribute] {
        return []
    }
    
    public var accessor: KnownPropertyAccessor {
        return .getterAndSetter
    }
    
    public var optional: Bool {
        return false
    }
    
    public var isEnumCase: Bool {
        return false
    }
}
