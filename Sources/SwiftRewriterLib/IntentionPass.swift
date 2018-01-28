import GrammarModels
import Foundation

/// A protocol for objects that perform passes through intentions collected and
/// perform changes and optimizations on them.
public protocol IntentionPass {
    func apply(on intentionCollection: IntentionCollection)
}

/// Gets an array of intention passes to apply before writing the final Swift code.
/// Used by `SwiftRewriter` before it outputs the final intents to `SwiftWriter`.
public enum IntentionPasses {
    public static var passes: [IntentionPass] = [
        FileGroupingIntentionPass(),
        RemoveDuplicatedTypeIntentIntentionPass()
    ]
}

/// From file intentions, remove intentions for interfaces that already have a
/// matching implementation.
/// Must be executed after a pass of `FileGroupingIntentionPass` to avoid dropping
/// @property declarations and the like.
public class RemoveDuplicatedTypeIntentIntentionPass: IntentionPass {
    public func apply(on intentionCollection: IntentionCollection) {
        for file in intentionCollection.intentions(ofType: FileGenerationIntention.self) {
            // Remove from file implementation any class generation intent that came
            // from an @interface
            file.removeTypes(where: { type in
                if !(type.source is ObjcClassInterface) {
                    return false
                }
                
                return
                    file.typeIntentions.contains {
                        $0.typeName == type.typeName && $0.source is ObjcClassImplementation
                }
            })
        }
    }
}

public class FileGroupingIntentionPass: IntentionPass {
    public func apply(on intentionCollection: IntentionCollection) {
        // Collect .h/.m pairs
        let intentions =
            intentionCollection.intentions(ofType: FileGenerationIntention.self)
        
        var headers: [FileGenerationIntention] = []
        var implementations: [FileGenerationIntention] = []
        
        for intent in intentions {
            if intent.filePath.hasSuffix(".m") {
                implementations.append(intent)
            } else if intent.filePath.hasSuffix(".h") {
                headers.append(intent)
            }
        }
        
        // For each impl, search for a matching header intent and combine any
        // class intent within
        for implementation in implementations {
            // Merge definitions from within an implementation file first
            mergeDefinitions(in: implementation)
            
            let implFile =
                (implementation.filePath as NSString).deletingPathExtension
            
            guard let header = headers.first(where: { hIntent -> Bool in
                let headerFile =
                    (hIntent.filePath as NSString).deletingPathExtension
                
                return implFile == headerFile
            }) else {
                continue
            }
            
            mergeDefinitions(from: header, into: implementation)
        }
        
        // Remove all header intentions (implementation intentions override them)
        intentionCollection.removeIntentions { (intent: FileGenerationIntention) -> Bool in
            return intent.filePath.hasSuffix(".h")
        }
    }
    
    private func mergeDefinitions(from header: FileGenerationIntention,
                                  into implementation: FileGenerationIntention) {
        let total = header.typeIntentions + implementation.typeIntentions
        
        let groupedTypes = Dictionary(grouping: total, by: { $0.typeName })
        
        for (_, types) in groupedTypes where types.count == 2 {
            mergeTypes(from: types[0], into: types[1])
        }
    }
    
    private func mergeDefinitions(in implementation: FileGenerationIntention) {
        let groupedTypes = Dictionary(grouping: implementation.typeIntentions,
                                      by: { $0.typeName })
        
        for (_, types) in groupedTypes where types.count == 2 {
            mergeTypes(from: types[0], into: types[1])
        }
    }
    
    private func mergeTypes(from first: TypeGenerationIntention, into second: TypeGenerationIntention) {
        // Protocols
        for prot in first.protocols {
            if !second.hasProtocol(named: prot.protocolName) {
                second.addProtocol(prot)
            }
        }
        
        // Instance vars
        for ivar in first.instanceVariables {
            if !second.hasInstanceVariable(named: ivar.name) {
                second.addInstanceVariable(ivar)
            }
        }
        
        // Properties
        for prop in first.properties {
            if !second.hasProperty(named: prop.name) {
                second.addProperty(prop)
            }
        }
        
        // Methods
        // TODO: Figure out how to deal with same-signature selectors properly
        for method in first.methods {
            if !second.hasMethod(withSignature: method.signature) {
                second.addMethod(method)
            }
        }
    }
    
    private struct Pair {
        var header: FileGenerationIntention
        var implementation: FileGenerationIntention
    }
}
