import Foundation
import SwiftAST
import KnownType
import Intentions
import Utils

// TODO: This could be generalized into merging signatures from types such that
// a child class inherits nullability from the base class, in case the child
// lacks nullability annotations.

/// Propagates known protocol nullability signautres from protocol intentions into
/// classes that implement them.
public class ProtocolNullabilityPropagationToConformersIntentionPass: IntentionPass {
    public init() {
        
    }
    
    public func apply(on intentionCollection: IntentionCollection, context: IntentionPassContext) {
        context.typeSystem.makeCache()
        defer {
            context.typeSystem.tearDownCache()
        }
        
        let typeMerger =
            TypeMerger(
                typeSystem: context.typeSystem,
                invocatorTag: "\(ProtocolNullabilityPropagationToConformersIntentionPass.self)"
            )
        
        // Collect protocols
        let protocols = context.typeSystem.knownTypes(ofKind: .protocol)
        let classes = intentionCollection.typeIntentions().filter { $0 is BaseClassIntention }
        
        if protocols.isEmpty || classes.isEmpty {
            return
        }
        
        var classProtocols: [String: [KnownProtocolConformance]] = [:]
        
        let queue = ConcurrentOperationQueue()
        queue.maxConcurrentOperationCount = context.numThreads
        
        let mutex = Mutex()
        
        // First roundtrip: Collect all known conformances
        for clsName in Set(classes.map(\.typeName)) {
            queue.addOperation {
                guard let type = context.typeSystem.knownTypeWithName(clsName) else {
                    return
                }
                
                let conformances = context.typeSystem.allConformances(of: type)
                
                mutex.locking {
                    classProtocols[type.typeName] = conformances
                }
            }
        }
        
        queue.runAndWaitConcurrent()
        
        // Second round-trip: Merge conformers with protocols
        for cls in classes {
            queue.addOperation {
                guard let type = context.typeSystem.knownTypeWithName(cls.typeName) else {
                    return
                }
                guard let conformances = classProtocols[type.typeName] else {
                    return
                }
                
                // Find conforming protocols
                for prot in protocols where conformances.contains(where: { $0.protocolName == prot.typeName }) {
                    typeMerger.mergeMethodSignatures(from: prot,
                                                     into: cls,
                                                     createIfUnexistent: false,
                                                     copyComments: false)
                }
            }
        }
        
        queue.runAndWaitConcurrent()
        
        context.notifyChange()
    }
}
