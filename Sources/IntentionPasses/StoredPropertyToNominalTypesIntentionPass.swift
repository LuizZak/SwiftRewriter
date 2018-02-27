import SwiftRewriterLib
import SwiftAST

/// An intention to move all instance variables/properties from extensions into
/// the nominal types.
///
/// Extensions in Swift cannot declare stored variables, so they must be moved to
/// the proper nominal instances.
public class StoredPropertyToNominalTypesIntentionPass: IntentionPass {
    public static let historyTag: String = "\(StoredPropertyToNominalTypesIntentionPass.self)"
    
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
    
    static func moveInstanceVariables(from first: ClassExtensionGenerationIntention,
                                      into second: BaseClassIntention) {
        for ivar in first.instanceVariables {
            if !second.hasInstanceVariable(named: ivar.name) {
                second.addInstanceVariable(ivar)
                
                ivar.history
                    .recordChange(tag: historyTag,
                                  description: """
                        Moving field from \(TypeFormatter.asString(extension: first)) \
                        to type declaration \(second.typeName)
                        """, relatedIntentions: [first])
            } else {
                first.removeInstanceVariable(named: ivar.name)
                
                first.history
                     .recordChange(tag: historyTag,
                                   description: """
                         Removing field \(ivar.name) from \(TypeFormatter.asString(extension: first)) \
                         since matching field name was found on original declaration
                         """, relatedIntentions: [first])
            }
        }
    }
    
    static func moveStoredProperties(from first: ClassExtensionGenerationIntention,
                                     into second: BaseClassIntention) {
        for prop in first.properties {
            first.removeProperty(prop)
            
            if !second.hasProperty(named: prop.name) {
                prop.history
                    .recordChange(tag: historyTag,
                                  description: """
                        Moving stored property from \(TypeFormatter.asString(extension: first)) \
                        to type declaration \(second.typeName)
                        """, relatedIntentions: [first])
                
                second.addProperty(prop)
            } else {
                first.history
                     .recordChange(tag: historyTag,
                                   description: """
                         Removing stored property \(prop.name) from \(TypeFormatter.asString(extension: first)) \
                         since matching property name was found on original declaration
                         """, relatedIntentions: [first])
                
            }
        }
    }
}
