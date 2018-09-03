import SwiftAST

/// An intention to generate a struct type
public class StructGenerationIntention: TypeGenerationIntention, InstanceVariableContainerIntention {
    public override var kind: KnownTypeKind {
        return .struct
    }
    
    public override var isEmptyType: Bool {
        // Unlike with classes, constructors do not count when defining whether
        // the type definition is empty or not.
        return protocols.isEmpty
            && properties.isEmpty
            && methods.isEmpty
            && instanceVariables.isEmpty
    }
    
    private(set) public var instanceVariables: [InstanceVariableGenerationIntention] = []
    
    public func addInstanceVariable(_ intention: InstanceVariableGenerationIntention) {
        if let parent = intention.parent as? BaseClassIntention {
            parent.removeInstanceVariable(named: intention.name)
        }
        
        instanceVariables.append(intention)
        intention.parent = self
        intention.type = self
    }
}
