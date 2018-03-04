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
        
        // Remove empty extension/categories from files
        for ext in intentionCollection.extensionIntentions() {
            if ext.isEmptyType && (ext.categoryName == nil || ext.categoryName?.isEmpty == true) {
                ext.file?.removeTypes { $0 === ext }
            }
        }
        
        // Move all directives from .h to matching .m files
        for header in headers where header.isEmptyExceptDirectives {
            let path = (header.sourcePath as NSString).deletingPathExtension
            guard let impl = implementations.first(where: { ($0.sourcePath as NSString).deletingPathExtension == path }) else {
                continue
            }
            
            // Move all directives into implementation file
            impl.preprocessorDirectives.insert(contentsOf: header.preprocessorDirectives, at: 0)
            header.preprocessorDirectives.removeAll()
        }
        
        // Find all global function declarations and match them to their matching
        // implementation
        mergeGlobalFunctionDefinitions(in: intentionCollection)
        
        // Remove all empty header files
        intentionCollection.removeIntentions { intent -> Bool in
            if !intent.sourcePath.hasSuffix(".h") {
                return false
            }
            
            return intent.isEmpty
        }
        
        context.notifyChange()
    }
}
