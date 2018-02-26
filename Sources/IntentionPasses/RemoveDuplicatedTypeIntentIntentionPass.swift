import SwiftRewriterLib
import SwiftAST
import GrammarModels

/// From file intentions, remove intentions for interfaces that already have a
/// matching implementation.
/// Must be executed after a pass of `FileGroupingIntentionPass` to avoid dropping
/// @property declarations and the like.
public class RemoveDuplicatedTypeIntentIntentionPass: IntentionPass {
    public init() {
        
    }
    
    public func apply(on intentionCollection: IntentionCollection, context: IntentionPassContext) {
        for file in intentionCollection.fileIntentions() {
            // Remove from file implementation any class generation intent that came
            // from an @interface
            file.removeClassTypes(where: { type in
                if !(type.source is ObjcClassInterface || type.source is ObjcClassCategoryInterface) {
                    return false
                }
                
                return
                    file.typeIntentions.contains {
                        $0.typeName == type.typeName &&
                            ($0.source is ObjcClassImplementation ||
                                $0.source is ObjcClassCategoryImplementation)
                }
            })
        }
    }
}
