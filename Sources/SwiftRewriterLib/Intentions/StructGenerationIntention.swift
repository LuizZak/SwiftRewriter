import SwiftAST

/// An intention to generate a struct type
public class StructGenerationIntention: TypeGenerationIntention, InstanceVariableContainerIntention {
    public override var kind: KnownTypeKind {
        return .struct
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
