import GrammarModels
import SwiftAST
import KnownType

/// An intention to generate a struct type
public final class StructGenerationIntention: TypeGenerationIntention, InstanceVariableContainerIntention {
    public override var kind: KnownTypeKind {
        .struct
    }
    
    public override var isEmptyType: Bool {
        // Unlike with classes, constructors do not count when defining whether
        // the type definition is empty or not.
        protocols.isEmpty
            && properties.isEmpty
            && methods.isEmpty
            && instanceVariables.isEmpty
    }
    
    private(set) public var instanceVariables: [InstanceVariableGenerationIntention] = []
    
    public override init(typeName: String,
                         accessLevel: AccessLevel = .internal,
                         source: ASTNode? = nil) {
        
        super.init(typeName: typeName, accessLevel: accessLevel, source: source)
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        instanceVariables =
            try container.decodeIntentions(forKey: .instanceVariables)
        
        try super.init(from: container.superDecoder())
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeIntentions(instanceVariables, forKey: .instanceVariables)
        
        try super.encode(to: container.superEncoder())
    }
    
    public func addInstanceVariable(_ intention: InstanceVariableGenerationIntention) {
        if let parent = intention.parent as? BaseClassIntention {
            parent.removeInstanceVariable(named: intention.name)
        }
        
        instanceVariables.append(intention)
        intention.parent = self
        intention.type = self
    }
    
    private enum CodingKeys: String, CodingKey {
        case instanceVariables
    }
}
