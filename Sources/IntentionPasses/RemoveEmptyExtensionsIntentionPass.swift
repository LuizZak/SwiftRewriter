import Intentions

/// An intention pass that removes all empty extensions that do not extend
/// protocols or contain members.
public class RemoveEmptyExtensionsIntentionPass: IntentionPass {
    public init() {
        
    }
    
    public func apply(on intentionCollection: IntentionCollection,
                      context: IntentionPassContext) {
        
        for file in intentionCollection.fileIntentions() {
            for ext in file.extensionIntentions {
                if ext.isEmptyType {
                    file.removeClassTypes(where: { $0 === ext })
                }
            }
        }
    }
}
