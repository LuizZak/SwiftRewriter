/// An intention for a type that can contain instance variables
public protocol InstanceVariableContainerIntention: Intention {
    var instanceVariables: [InstanceVariableGenerationIntention] { get }
    
    func addInstanceVariable(_ intention: InstanceVariableGenerationIntention)
    func hasInstanceVariable(named name: String) -> Bool
    func instanceVariable(named name: String) -> InstanceVariableGenerationIntention?
}

public extension InstanceVariableContainerIntention {
    public func hasInstanceVariable(named name: String) -> Bool {
        return instanceVariables.contains(where: { $0.name == name })
    }
    
    public func instanceVariable(named name: String) -> InstanceVariableGenerationIntention? {
        return instanceVariables.first(where: { $0.name == name })
    }
}
