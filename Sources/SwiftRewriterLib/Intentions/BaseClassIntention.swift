import GrammarModels
import SwiftAST

/// Base intention for Class and Class Category intentions
public class BaseClassIntention: TypeGenerationIntention, InstanceVariableContainerIntention {
    /// Returns `true` if this class intention originated from an `@interface`
    /// declaration.
    public var isInterfaceSource: Bool {
        return source is ObjcClassInterface
            || source is ObjcClassCategoryInterface
    }
    
    public override var isEmptyType: Bool {
        return super.isEmptyType && instanceVariables.isEmpty && synthesizations.isEmpty
    }
    
    private(set) public var instanceVariables: [InstanceVariableGenerationIntention] = []
    
    private(set) public var synthesizations: [PropertySynthesizationIntention] = []
    
    public override var knownFields: [KnownProperty] {
        return instanceVariables
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
        guard let index = instanceVariables.index(where: { $0.name == name }) else {
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
        guard let index = synthesizations.index(where: { $0 === intention }) else {
            return
        }
        
        synthesizations[index].parent = nil
        synthesizations.remove(at: index)
    }
}
