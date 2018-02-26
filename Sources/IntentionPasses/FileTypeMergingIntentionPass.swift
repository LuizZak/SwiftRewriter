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
            FileTypeMergingIntentionPass
                .mergeTypeIntentions(typeIntentions: implementation.typeIntentions,
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
            FileTypeMergingIntentionPass
                .mergeTypeIntentions(typeIntentions: intentions,
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
    
    static func mergeTypeIntentions(typeIntentions: [TypeGenerationIntention],
                                    into implementation: FileGenerationIntention,
                                    intentionCollection: IntentionCollection) {
        var newIntentions: [BaseClassIntention] = []
        
        let classes = typeIntentions.compactMap { $0 as? ClassGenerationIntention }
        let extensions = typeIntentions.compactMap { $0 as? ClassExtensionGenerationIntention }
        
        let classesByName = Dictionary(grouping: classes, by: { $0.typeName })
        let extensionsByName = Dictionary(grouping: extensions, by: { $0.typeName })
        
        for (name, classes) in classesByName.sorted(by: { (k1, k2) in k1.key < k2.key }) {
            let intention =
                ClassGenerationIntention(typeName: name)
            
            mergeAllTypeDefinitions(in: classes, on: intention)
            
            newIntentions.append(intention)
        }
        
        for (className, allExtensions) in extensionsByName {
            let allExtensions =
                allExtensions.sorted { ($0.categoryName ?? "") < ($1.categoryName ?? "") }
            
            // Merge extensions by pairing them up by original category name
            let extensionsByCategory = Dictionary(grouping: allExtensions, by: { $0.categoryName ?? "" })
            
            for (categoryName, extensions) in extensionsByCategory.sorted(by: { (k1, k2) in k1.key < k2.key }) {
                let category = ClassExtensionGenerationIntention(typeName: className)
                category.categoryName = categoryName
                
                mergeAllTypeDefinitions(in: extensions, on: category)
                
                newIntentions.append(category)
            }
        }
        
        // Replace all types
        implementation.removeClassTypes(where: { _ in true })
        for type in newIntentions {
            implementation.addType(type)
        }
    }
    
    static func mergeAllTypeDefinitions(in types: [TypeGenerationIntention],
                                        on target: TypeGenerationIntention)
    {
        for source in types {
            mergeTypes(from: source, into: target)
        }
    }
    
    static func mergeTypes(from first: KnownType,
                           into second: TypeGenerationIntention) {
        // Protocols
        for prot in first.knownProtocolConformances {
            if !second.hasProtocol(named: prot.protocolName) {
                second.generateProtocolConformance(from: prot)
            }
        }
        
        if let first = first as? ClassGenerationIntention,
            let second = second as? ClassGenerationIntention {
            // Inheritance
            if second.superclassName == nil {
                second.superclassName = first.superclassName
            }
        }
        
        if let first = first as? BaseClassIntention,
            let second = second as? BaseClassIntention {
            // Instance vars
            for ivar in first.instanceVariables {
                if !second.hasInstanceVariable(named: ivar.name) {
                    second.addInstanceVariable(ivar)
                }
            }
        }
        
        // Properties
        for prop in first.knownProperties {
            if !second.hasProperty(named: prop.name) {
                second.generateProperty(from: prop)
            }
        }
        
        // Methods
        mergeMethodSignatures(from: first, into: second)
    }
    
    static func mergeMethodSignatures(from first: KnownType,
                                      into second: TypeGenerationIntention) {
        for knownMethod in first.knownMethods {
            if let existing = second.method(matchingSelector: knownMethod.signature) {
                mergeMethods(knownMethod, into: existing)
            } else {
                second.generateMethod(from: knownMethod)
            }
        }
    }
    
    /// Merges signatures such that incoming signatures with optional or
    /// non-optional (except implicitly-unwrapped optionals) overwrite the optionality
    /// of implicitly-unwrapped optional signatures.
    ///
    /// This rewrites methods such that:
    ///
    /// ```
    /// class IncomingType {
    ///     func myFunc(_ param: AnObject?) -> String
    /// }
    ///
    /// class TargetType {
    ///     func myFunc(_ param: AnObject!) -> String!
    /// }
    /// ```
    /// have their signatures merged into the target type so they match:
    ///
    /// ```
    /// class TargetType {
    ///     // Nullability from IncomingType.myFunc() has
    ///     // overwritten the implicitly-unwrapped
    ///     // nullability from TartgetType.myFunc()
    ///     func myFunc(_ param: AnObject?) -> String
    /// }
    /// ```
    ///
    /// This is mostly used for @interface/@implementation pairing, where @interface
    /// contains the proper nullability annotations, and for @protocol conformance
    /// nullability pairing.
    static func mergeMethods(_ method1: KnownMethod,
                             into method2: MethodGenerationIntention) {
        if !method1.signature.returnType.isImplicitlyUnwrapped && method2.signature.returnType.isImplicitlyUnwrapped {
            if method1.signature.returnType.deepUnwrapped == method2.signature.returnType.deepUnwrapped {
                method2.signature.returnType = method1.signature.returnType
            }
        }
        
        for (i, p1) in method1.signature.parameters.enumerated() {
            if i >= method2.signature.parameters.count {
                break
            }
            
            let p2 = method2.signature.parameters[i]
            if !p1.type.isImplicitlyUnwrapped && p2.type.isImplicitlyUnwrapped && p1.type.deepUnwrapped == p2.type.deepUnwrapped {
                method2.signature.parameters[i].type = p1.type
            }
        }
        
        if let body = method1.body, method2.functionBody == nil {
            method2.functionBody = FunctionBodyIntention(body: body.body)
        }
    }
    
    private struct Pair {
        var header: FileGenerationIntention
        var implementation: FileGenerationIntention
    }
}

