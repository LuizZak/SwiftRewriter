import GrammarModels
import SwiftAST
import KnownType

/// An intention to create an instance variable (Objective-C's 'ivar').
public final class InstanceVariableGenerationIntention: MemberGenerationIntention, ValueStorageIntention {
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
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try container.decode(String.self, forKey: .name)
        storage = try container.decode(ValueStorage.self, forKey: .storage)
        
        try super.init(from: container.superDecoder())
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(name, forKey: .name)
        try container.encode(storage, forKey: .storage)
        
        try super.encode(to: container.superEncoder())
    }
    
    private enum CodingKeys: String, CodingKey {
        case name
        case storage
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
