import GrammarModels
import SwiftAST
import KnownType

/// An intention to create an instance variable (Objective-C's 'ivar').
public final class InstanceVariableGenerationIntention: MemberGenerationIntention, MutableValueStorageIntention {
    public var typedSource: IVarDeclaration? {
        source as? IVarDeclaration
    }
    
    public var name: String
    public var storage: ValueStorage
    
    public var initialValue: Expression?
    
    public override var memberType: SwiftType {
        type
    }
    
    public init(name: String,
                storage: ValueStorage,
                accessLevel: AccessLevel = .internal,
                source: ASTNode? = nil) {
        
        self.name = name
        self.storage = storage
        super.init(accessLevel: accessLevel, source: source)
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try container.decode(String.self, forKey: .name)
        storage = try container.decode(ValueStorage.self, forKey: .storage)
        initialValue = try container.decodeIfPresent(Expression.self, forKey: .initialValue)
        
        try super.init(from: container.superDecoder())
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(name, forKey: .name)
        try container.encode(storage, forKey: .storage)
        try container.encodeIfPresent(initialValue, forKey: .initialValue)
        
        try super.encode(to: container.superEncoder())
    }
    
    private enum CodingKeys: String, CodingKey {
        case name
        case storage
        case initialValue
    }
}

extension InstanceVariableGenerationIntention: KnownProperty {
    public var attributes: [PropertyAttribute] {
        []
    }
    
    public var accessor: KnownPropertyAccessor {
        .getterAndSetter
    }
    
    public var optional: Bool {
        false
    }
    
    public var isEnumCase: Bool {
        false
    }
}
