import SwiftAST
import SwiftRewriterLib

public class ClassVisitingIntentionPass: IntentionPass {
    internal var context: IntentionPassContext!
    
    func notifyChange() {
        context.notifyChange()
    }
    
    public func apply(on intentionCollection: IntentionCollection, context: IntentionPassContext) {
        self.context = context
        
        for file in intentionCollection.fileIntentions() {
            applyOnFile(file)
        }
    }
    
    func applyOnFile(_ file: FileGenerationIntention) {
        for type in file.typeIntentions {
            applyOnType(type)
        }
    }
    
    func applyOnType(_ type: TypeGenerationIntention) {
        if let cls = type as? BaseClassIntention {
            for ivar in cls.instanceVariables {
                applyOnInstanceVar(ivar)
            }
        }
        
        for property in type.properties {
            applyOnProperty(property)
        }
        
        for method in type.methods {
            applyOnMethod(method)
        }
    }
    
    func applyOnInstanceVar(_ ivar: InstanceVariableGenerationIntention) {
        
    }
    
    func applyOnMethod(_ method: MethodGenerationIntention) {
        
    }
    
    func applyOnProperty(_ property: PropertyGenerationIntention) {
        
    }
}

