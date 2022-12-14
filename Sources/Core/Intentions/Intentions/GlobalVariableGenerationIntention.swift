import GrammarModelBase
import KnownType
import SwiftAST

/// An intention to generate a global variable.
public final class GlobalVariableGenerationIntention: FromSourceIntention, FileLevelIntention, MutableValueStorageIntention {
    public override var children: [Intention] {
        (initialValueIntention.map { [$0] } ?? [])
    }
    
    public var name: String
    public var storage: ValueStorage
    public var initialValueIntention: GlobalVariableInitialValueIntention? {
        didSet {
            oldValue?.parent = nil
            initialValueIntention?.parent = self
        }
    }
    
    public var initialValue: Expression? {
        get {
            initialValueIntention?.expression
        }
        set {
            initialValueIntention = newValue.map({ GlobalVariableInitialValueIntention(expression: $0, source: nil) })
        }
    }
    
    public init(name: String,
                storage: ValueStorage,
                accessLevel: AccessLevel = .internal,
                source: ASTNode? = nil) {
        
        self.name = name
        self.storage = storage
        super.init(accessLevel: accessLevel, source: source)
    }
    
    public convenience init(name: String,
                            type: SwiftType,
                            accessLevel: AccessLevel = .internal,
                            source: ASTNode? = nil) {
        
        self.init(name: name,
                  storage: ValueStorage(type: type, ownership: .strong, isConstant: false),
                  accessLevel: accessLevel,
                  source: source)
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try container.decode(String.self, forKey: .name)
        storage = try container.decode(ValueStorage.self, forKey: .storage)
        initialValueIntention = try container.decodeIntentionIfPresent(GlobalVariableInitialValueIntention.self, forKey: .initialValueIntention)
        
        try super.init(from: container.superDecoder())
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(name, forKey: .name)
        try container.encode(storage, forKey: .storage)
        try container.encodeIntentionIfPresent(initialValueIntention, forKey: .initialValueIntention)
        
        try super.encode(to: container.superEncoder())
    }

    public override func accept<T: IntentionVisitor>(_ visitor: T) -> T.Result {
        visitor.visitGlobalVariable(self)
    }
    
    private enum CodingKeys: String, CodingKey {
        case name
        case storage
        case initialValueIntention
    }
}

extension GlobalVariableGenerationIntention: KnownGlobalVariable {
    public var semantics: Set<Semantic> {
        []
    }
}
