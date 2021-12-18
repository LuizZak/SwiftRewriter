/// An intention for a type that can contain instance variables
public protocol InstanceVariableContainerIntention: IntentionProtocol {
    var instanceVariables: [InstanceVariableGenerationIntention] { get }
    
    func addInstanceVariable(_ intention: InstanceVariableGenerationIntention)
    func hasInstanceVariable(named name: String) -> Bool
    func instanceVariable(named name: String) -> InstanceVariableGenerationIntention?
}

public extension InstanceVariableContainerIntention {
    func hasInstanceVariable(named name: String) -> Bool {
        instanceVariables.contains(where: { $0.name == name })
    }
    
    func instanceVariable(named name: String) -> InstanceVariableGenerationIntention? {
        instanceVariables.first(where: { $0.name == name })
    }
}
