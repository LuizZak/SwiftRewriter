import GrammarModels
import KnownType
import SwiftAST

/// An intention to generate a global variable.
public final class GlobalVariableGenerationIntention: FromSourceIntention, FileLevelIntention, MutableValueStorageIntention {
    public var variableSource: VariableDeclaration? {
        return source as? VariableDeclaration
    }
    
    public var name: String
    public var storage: ValueStorage
    public var initialValueExpr: GlobalVariableInitialValueIntention?
    
    public var initialValue: Expression? {
        get {
            return initialValueExpr?.expression
        }
        set {
            initialValueExpr = newValue.map({ GlobalVariableInitialValueIntention(expression: $0, source: nil) })
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
        initialValueExpr = try container.decodeIntentionIfPresent(GlobalVariableInitialValueIntention.self, forKey: .initialValueExpr)
        
        try super.init(from: container.superDecoder())
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(name, forKey: .name)
        try container.encode(storage, forKey: .storage)
        try container.encodeIntentionIfPresent(initialValueExpr, forKey: .initialValueExpr)
        
        try super.encode(to: container.superEncoder())
    }
    
    private enum CodingKeys: String, CodingKey {
        case name
        case storage
        case initialValueExpr
    }
}

extension GlobalVariableGenerationIntention: KnownGlobalVariable {
    public var semantics: Set<Semantic> {
        return []
    }
}
