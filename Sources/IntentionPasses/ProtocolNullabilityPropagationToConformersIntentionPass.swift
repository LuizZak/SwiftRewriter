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
        let typeSystem = context.typeSystem as? DefaultTypeSystem
        typeSystem?.makeCache()
        defer {
            typeSystem?.tearDownCache()
        }
        
        let typeMerger = TypeMerger(typeSystem: context.typeSystem)
        
        // Collect protocols
        let protocols = intentionCollection.protocolIntentions()
        let classes = intentionCollection.typeIntentions().filter { $0 is BaseClassIntention }
        
        if protocols.isEmpty || classes.isEmpty {
            return
        }
        
        for cls in classes {
            guard let type = context.typeSystem.knownTypeWithName(cls.typeName) else {
                continue
            }
            
            // Find conforming protocols
            let knownProtocols =
                protocols.filter { prot in
                    context.typeSystem
                        .conformance(toProtocolName: prot.typeName, in: type) != nil
                    }
            
            for prot in knownProtocols {
                typeMerger.mergeMethodSignatures(from: prot,
                                                 into: cls,
                                                 createIfUnexistent: false)
            }
        }
        
        context.notifyChange()
    }
}
