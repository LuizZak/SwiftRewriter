import ObjcGrammarModels
import SwiftAST
import KnownType

/// Base intention for Class and Class Category/Extension intentions
public class BaseClassIntention: TypeGenerationIntention, InstanceVariableContainerIntention {
    /// Returns `true` if this class intention originated from an `@interface`
    /// declaration.
    public var isInterfaceSource: Bool = false
    
    public override var isEmptyType: Bool {
        super.isEmptyType && instanceVariables.isEmpty && synthesizations.isEmpty
    }
    
    private(set) public var instanceVariables: [InstanceVariableGenerationIntention] = []
    
    private(set) public var synthesizations: [PropertySynthesizationIntention] = []
    
    public override var knownFields: [KnownProperty] {
        instanceVariables
    }
    
    /// If present, represents the deinit method defined for this class type
    public var deinitIntention: DeinitGenerationIntention? {
        didSet {
            deinitIntention?.parent = self
            deinitIntention?.type = self
            
            oldValue?.parent = nil
            oldValue?.type = nil
        }
    }
    
    public override init(typeName: String,
                         accessLevel: AccessLevel = .internal,
                         source: ObjcASTNode? = nil) {
        
        super.init(typeName: typeName,
                   accessLevel: accessLevel,
                   source: source)
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        isInterfaceSource = try container.decode(Bool.self, forKey: .isInterfaceSource)
        instanceVariables = try container.decodeIntentions(forKey: .instanceVariables)
        synthesizations = try container.decodeIntentions(forKey: .synthesizations)
        deinitIntention = try container.decodeIntentionIfPresent(forKey: .deinitIntention)
        
        try super.init(from: container.superDecoder())
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(isInterfaceSource, forKey: .isInterfaceSource)
        try container.encodeIntentions(instanceVariables, forKey: .instanceVariables)
        try container.encodeIntentions(synthesizations, forKey: .synthesizations)
        try container.encodeIntentionIfPresent(deinitIntention, forKey: .deinitIntention)
        
        try super.encode(to: container.superEncoder())
    }
    
    public func addInstanceVariable(_ intention: InstanceVariableGenerationIntention) {
        if let previousParent = intention.parent as? BaseClassIntention {
            previousParent.removeInstanceVariable(named: intention.name)
        }
        
        instanceVariables.append(intention)
        intention.parent = self
        intention.type = self
    }
    
    public func removeInstanceVariable(named name: String) {
        guard let index = instanceVariables.firstIndex(where: { $0.name == name }) else {
            return
        }
        
        instanceVariables[index].type = nil
        instanceVariables[index].parent = nil
        instanceVariables.remove(at: index)
    }
    
    public func addSynthesization(_ intention: PropertySynthesizationIntention) {
        if let previousParent = intention.parent as? BaseClassIntention {
            previousParent.removeSynthesization(intention)
        }
        
        synthesizations.append(intention)
        intention.parent = self
    }
    
    public func removeSynthesization(_ intention: PropertySynthesizationIntention) {
        guard let index = synthesizations.firstIndex(where: { $0 === intention }) else {
            return
        }
        
        synthesizations[index].parent = nil
        synthesizations.remove(at: index)
    }
    
    private enum CodingKeys: String, CodingKey {
        case isInterfaceSource
        case instanceVariables
        case synthesizations
        case deinitIntention
    }
}
