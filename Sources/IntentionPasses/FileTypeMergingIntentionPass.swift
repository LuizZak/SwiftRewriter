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
        
        // Merge all types from the header files into the associated implementation
        // files.
        for implementation in implementations {
            // First, merge within implementations themselves
            mergeDuplicatedTypesInFile(implementation)
            
            for header in headers {
                mergeTypesToMatchingImplementations(from: header, into: implementation)
            }
        }
        
        // Remove all empty header files
        intentionCollection.removeIntentions { intent -> Bool in
            if !intent.sourcePath.hasSuffix(".h") {
                return false
            }
            
            return intent.isEmpty
        }
    }
}
