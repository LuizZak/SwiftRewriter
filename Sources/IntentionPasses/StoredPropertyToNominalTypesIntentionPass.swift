import SwiftRewriterLib
import SwiftAST

/// An intention to move all instance variables/properties from extensions into
/// the nominal types.
///
/// Extensions in Swift cannot declare stored variables, so they must be moved to
/// the proper nominal instances.
public class StoredPropertyToNominalTypesIntentionPass: IntentionPass {
    public init() {
        
    }
    
    public func apply(on intentionCollection: IntentionCollection, context: IntentionPassContext) {
        let classes = intentionCollection.classIntentions()
        let extensions = intentionCollection.extensionIntentions()
        
        for cls in classes {
            let ext = extensions.filter { $0.typeName == cls.typeName }
            
            mergeStoredProperties(from: ext, into: cls)
        }
    }
    
    public func mergeStoredProperties(from extensions: [ClassExtensionGenerationIntention],
                                      into nominalClass: ClassGenerationIntention) {
        for ext in extensions {
            // IVar
            StoredPropertyToNominalTypesIntentionPass
                .moveInstanceVariables(from: ext, into: nominalClass)
        }
    }
    
    static func moveInstanceVariables(from first: BaseClassIntention,
                                      into second: BaseClassIntention) {
        for ivar in first.instanceVariables {
            if !second.hasInstanceVariable(named: ivar.name) {
                second.addInstanceVariable(ivar)
            } else {
                first.removeInstanceVariable(named: ivar.name)
            }
        }
    }
    
    static func moveStoredProperties(from first: BaseClassIntention,
                                     into second: BaseClassIntention) {
        for prop in first.properties {
            first.removeProperty(prop)
            
            if !second.hasProperty(named: prop.name) {
                second.addProperty(prop)
            }
        }
    }
}
