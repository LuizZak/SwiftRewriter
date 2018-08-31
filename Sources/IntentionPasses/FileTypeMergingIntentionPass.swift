import Foundation
import SwiftRewriterLib
import SwiftAST

public class FileTypeMergingIntentionPass: IntentionPass {
    public init() {
        
    }
    
    public func apply(on intentionCollection: IntentionCollection, context: IntentionPassContext) {
        
        let typeMerger = TypeMerger(typeSystem: context.typeSystem)
        
        // Collect .h/.m pairs
        let intentions = intentionCollection.fileIntentions()
        
        var headers: [FileGenerationIntention] = []
        var implementations: [FileGenerationIntention] = []
        
        headers = intentions.filter { intent in
            intent.sourcePath.hasSuffix(".h")
        }
        implementations = intentions.filter { intent in
            intent.sourcePath.hasSuffix(".m")
        }
        
        // Merge all types from the header files into the associated implementation
        // files.
        implementations.forEach { implementation in
            // First, merge within implementations themselves
            typeMerger.mergeDuplicatedTypesInFile(implementation)
            
            headers.forEach { header in
                typeMerger.mergeTypesToMatchingImplementations(from: header, into: implementation)
            }
        }
        
        // Remove empty extension/categories from files
        intentionCollection.extensionIntentions().forEach { ext in
            if ext.isEmptyType && (ext.categoryName == nil || ext.categoryName?.isEmpty == true) {
                ext.file?.removeTypes { $0 === ext }
            }
        }
        
        // Move all enum/protocol/global variables from .h to .m files, when
        // available
        for header in headers {
            let path = (header.sourcePath as NSString).deletingPathExtension
            guard let impl = implementations.first(where: {
                ($0.sourcePath as NSString).deletingPathExtension == path
            }) else {
                continue
            }
            
            header.enumIntentions.forEach { en in
                header.removeTypes(where: { $0 === en })
                impl.addType(en)
            }
            
            header.protocolIntentions.forEach { prot in
                header.removeTypes(where: { $0 === prot })
                impl.addType(prot)
            }
            
            header.typealiasIntentions.forEach { alias in
                header.removeTypealiases(where: { $0 === alias })
                impl.addTypealias(alias)
            }
            
            header.structIntentions.forEach { alias in
                header.removeTypes(where: { $0 === alias })
                impl.addType(alias)
            }
            
            header.globalVariableIntentions.forEach { gvar in
                header.removeGlobalVariables(where: { $0 === gvar })
                
                if !impl.globalVariableIntentions.contains(where: { $0.name == gvar.name }) {
                    impl.addGlobalVariable(gvar)
                }
            }
        }
        
        // Find all global function declarations and match them to their matching
        // implementation
        typeMerger.mergeGlobalFunctionDefinitions(in: intentionCollection)
        
        // Merge remaining global functions
        for header in headers {
            let path = (header.sourcePath as NSString).deletingPathExtension
            guard let impl = implementations.first(where: {
                ($0.sourcePath as NSString).deletingPathExtension == path
            }) else {
                continue
            }
            
            for gfunc in header.globalFunctionIntentions {
                header.removeGlobalFunctions(where: { $0 === gfunc })
                
                if !impl.globalFunctionIntentions.contains(where: {
                    gfunc.signature.matchesAsCFunction($0.signature)
                }) {
                    impl.addGlobalFunction(gfunc)
                }
            }
        }
        
        // Move all directives from .h to matching .m files
        for header in headers where header.isEmptyExceptDirectives {
            let path = (header.sourcePath as NSString).deletingPathExtension
            guard let impl = implementations.first(where: {
                ($0.sourcePath as NSString).deletingPathExtension == path
            }) else {
                continue
            }
            
            // Move all directives into implementation file
            impl.preprocessorDirectives.insert(contentsOf: header.preprocessorDirectives, at: 0)
            header.preprocessorDirectives.removeAll()
        }
        
        // Remove all empty header files
        intentionCollection.removeIntentions { intent -> Bool in
            return intent.sourcePath.hasSuffix(".h") && intent.isEmpty
        }
        
        // Always notify a change- it's easier to just consider things as changed
        // instead of inserting change notifications to each and every block above.
        context.notifyChange()
    }
}
