import Foundation

/// A protocol for objects that perform passes through intentions collected and
/// perform changes and optimizations on them.
public protocol IntentionPass {
    func apply(on intentionCollection: IntentionCollection)
}

public class FileGroupingIntentionPass: IntentionPass {
    public func apply(on intentionCollection: IntentionCollection) {
        // Collect .h/.m pairs
        let intentions =
            intentionCollection.intentions(ofType: FileGenerationIntention.self)
        
        var headers: [FileGenerationIntention] = []
        var implementations: [FileGenerationIntention] = []
        
        var pairs: [Pair] = []
        
        for intent in intentions {
            let fileName =
                (intent.filePath as NSString).lastPathComponent
            
            if fileName.hasSuffix(".m") {
                
            } else if fileName.hasSuffix(".h") {
                
            }
        }
    }
    
    private struct Pair {
        var header: FileGenerationIntention
        var implementation: FileGenerationIntention
    }
}
