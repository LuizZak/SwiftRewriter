import SwiftRewriterLib
import SwiftAST

// TODO: This could be generalized into merging signatures from types such that
// a child class inherits nullability from the base class, in case the child
// lacks nullability annotations.

/// Propagates known protocol nullability signautres from protocol intentions into
/// classes that implement them.
public class ProtocolNullabilityPropagationToConformersIntentionPass: IntentionPass {
    public init() {
        
    }
    
    public func apply(on intentionCollection: IntentionCollection, context: IntentionPassContext) {
        // Collect protocols
        let protocols = intentionCollection.protocolIntentions()
        let classes = intentionCollection.classIntentions()
        
        if protocols.isEmpty || classes.isEmpty {
            return
        }
        
        for cls in classes {
            // Find conforming protocols
            let knownProtocols =
                protocols.filter { prot in
                    cls.protocols.contains {
                        $0.protocolName == prot.typeName
                    }
            }
            
            for prot in knownProtocols {
                mergeMethodSignatures(from: prot, into: cls)
            }
        }
        
        context.notifyChange()
    }
}
