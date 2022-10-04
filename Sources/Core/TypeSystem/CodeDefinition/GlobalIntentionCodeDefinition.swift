import Intentions

public class GlobalIntentionCodeDefinition: GlobalCodeDefinition {
    public let intention: Intention
    
    init(intention: Intention) {
        self.intention = intention
        
        switch intention {
        case let intention as GlobalVariableGenerationIntention:
            super.init(variableNamed: intention.name,
                       storage: intention.storage)
            
        case let intention as GlobalFunctionGenerationIntention:
            super.init(functionSignature: intention.signature)
            
        default:
            fatalError("Attempting to create global code definition for non-definition intention type \(Swift.type(of: intention))")
        }
    }
    
    public override func isEqual(to other: GlobalCodeDefinition) -> Bool {
        if let other = other as? GlobalIntentionCodeDefinition {
            return intention === other.intention
        }
        
        return super.isEqual(to: other)
    }
}

public extension CodeDefinition {
    static func forGlobalFunction(_ function: GlobalFunctionGenerationIntention) -> GlobalIntentionCodeDefinition {
        GlobalIntentionCodeDefinition(intention: function)
    }
    
    static func forGlobalVariable(_ variable: GlobalVariableGenerationIntention) -> GlobalIntentionCodeDefinition {
        GlobalIntentionCodeDefinition(intention: variable)
    }
}
