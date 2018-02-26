import Foundation
import SwiftRewriterLib
import SwiftAST

public class FileTypeMergingIntentionPass: IntentionPass {
    public init() {
        
    }
    
    public func apply(on intentionCollection: IntentionCollection, context: IntentionPassContext) {
        // Collect .h/.m pairs
        let intentions = intentionCollection.fileIntentions()
        
        var headers: [FileGenerationIntention] = []
        var implementations: [FileGenerationIntention] = []
        
        for intent in intentions {
            if intent.sourcePath.hasSuffix(".m") {
                implementations.append(intent)
            } else if intent.sourcePath.hasSuffix(".h") {
                headers.append(intent)
            }
        }
        
        // For each impl, search for a matching header intent and combine any
        // class intent within
        for implementation in implementations {
            // Merge definitions from within an implementation file first
            mergeTypeIntentions(typeIntentions: implementation.typeIntentions,
                                into: implementation,
                                intentionCollection: intentionCollection)
            
            let implFile =
                (implementation.sourcePath as NSString).deletingPathExtension
            
            guard let header = headers.first(where: { hIntent -> Bool in
                let headerFile =
                    (hIntent.sourcePath as NSString).deletingPathExtension
                
                return implFile == headerFile
            }) else {
                continue
            }
            
            let intentions = implementation.typeIntentions + header.typeIntentions
            
            mergeTypeIntentions(typeIntentions: intentions,
                                into: implementation,
                                intentionCollection: intentionCollection)
        }
        
        // Remove all header intentions that have a matching implementation
        // (implementation intentions override them)
        intentionCollection.removeIntentions { (intent: FileGenerationIntention) -> Bool in
            if !intent.sourcePath.hasSuffix(".h") {
                return false
            }
            
            let headerFile = (intent.sourcePath as NSString).deletingPathExtension
            
            if implementations.contains(where: { impl -> Bool in
                (impl.sourcePath as NSString).deletingPathExtension == headerFile
            }) {
                return true
            }
            
            return false
        }
    }
}
