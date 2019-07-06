import Foundation
import SwiftAST
import Intentions

public class FileTypeMergingIntentionPass: IntentionPass {
    private let headerExtensions: [String] = [".h"]
    private let implementationExtensions: [String] = [".m", ".c"]
    
    public init() {
        
    }
    
    public func apply(on intentionCollection: IntentionCollection, context: IntentionPassContext) {
        
        let typeMerger =
            TypeMerger(
                typeSystem: context.typeSystem,
                invocatorTag: "\(FileTypeMergingIntentionPass.self)"
            )
        
        // Collect header/implementation pairs
        let intentions = intentionCollection.fileIntentions()
        
        var headers: [FileGenerationIntention] = []
        var implementations: [FileGenerationIntention] = []
        
        headers = intentions.filter { intent in
            headerExtensions.contains {
                intent.sourcePath.hasSuffix($0)
            }
        }
        implementations = intentions.filter { intent in
            implementationExtensions.contains {
                intent.sourcePath.hasSuffix($0)
            }
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
        
        func strippingPathExtension(_ path: String) -> Substring {
            return path[path.startIndex..<(path.lastIndex(of: ".") ?? path.endIndex)]
        }
        
        let implByName =
            implementations
                .groupBy {
                    strippingPathExtension($0.sourcePath)
                }.compactMapValues { $0.first }
        
        // Move all enum/protocol/global variables from header to implementation
        // files, when available
        for header in headers {
            let path = strippingPathExtension(header.sourcePath)
            guard let impl = implByName[path] else {
                continue
            }
            
            header.enumIntentions.forEach { enumIntent in
                header.removeTypes(where: { $0 === enumIntent })
                impl.addType(enumIntent)
            }
            
            header.protocolIntentions.forEach { protocolIntent in
                header.removeTypes(where: { $0 === protocolIntent })
                impl.addType(protocolIntent)
            }
            
            header.typealiasIntentions.forEach { aliasIntent in
                header.removeTypealiases(where: { $0 === aliasIntent })
                impl.addTypealias(aliasIntent)
            }
            
            header.structIntentions.forEach { structIntent in
                header.removeTypes(where: { $0 === structIntent })
                impl.addType(structIntent)
            }
            
            header.globalVariableIntentions.forEach { globalVarIntent in
                header.removeGlobalVariables(where: { $0 === globalVarIntent })
                
                if !impl.globalVariableIntentions.contains(where: { $0.name == globalVarIntent.name }) {
                    impl.addGlobalVariable(globalVarIntent)
                }
            }
        }
        
        // Find all global function declarations and match them to their matching
        // implementation
        typeMerger.mergeGlobalFunctionDefinitions(in: intentionCollection)
        
        // Merge remaining global functions
        for header in headers {
            let path = strippingPathExtension(header.sourcePath)
            guard let impl = implByName[path] else {
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
            let path = strippingPathExtension(header.sourcePath)
            guard let impl = implByName[path] else {
                continue
            }
            
            // Move all directives into implementation file
            impl.preprocessorDirectives.insert(contentsOf: header.preprocessorDirectives, at: 0)
            header.preprocessorDirectives.removeAll()
        }
        
        // Remove all empty header files
        intentionCollection.removeIntentions { intent -> Bool in
            return headerExtensions.contains {
                intent.sourcePath.hasSuffix($0)
            } && intent.isEmpty
        }
        
        // Always notify a change- it's easier to just consider things as changed
        // instead of inserting change notifications to each and every block above.
        context.notifyChange()
    }
}
