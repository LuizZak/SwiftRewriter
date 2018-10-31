import GrammarModels
import SwiftAST

/// An intention to generate a global variable.
public final class GlobalVariableGenerationIntention: FromSourceIntention, FileLevelIntention, ValueStorageIntention {
    public var variableSource: VariableDeclaration? {
        return source as? VariableDeclaration
    }
    
    public var name: String
    public var storage: ValueStorage
    public var initialValueExpr: GlobalVariableInitialValueIntention?
    
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
