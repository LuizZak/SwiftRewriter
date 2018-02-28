import SwiftRewriterLib
import SwiftAST

private let historyTag = "TypeMerge"

func mergeTypesToMatchingImplementations(from source: FileGenerationIntention,
                                         into target: FileGenerationIntention) {
    
    // Group class and extensions by name
    // ClassName -> [Intention1, Intention2, ...]
    // ClassName -> [ExtIntention1, ExtIntention2, ...]
    
    let sourceClasses = source.typeIntentions.compactMap { $0 as? ClassGenerationIntention }
    let targetClasses = target.typeIntentions.compactMap { $0 as? ClassGenerationIntention }
    
    let sourceExtensions = source.typeIntentions.compactMap { $0 as? ClassExtensionGenerationIntention }
    let targetExtensions = target.typeIntentions.compactMap { $0 as? ClassExtensionGenerationIntention }
    
    let allClasses = sourceClasses + targetClasses
    let allExtensions = sourceExtensions + targetExtensions
    
    let allClassesByName = Dictionary(grouping: allClasses, by: { $0.typeName })
    let allExtensionsByName = Dictionary(grouping: allExtensions, by: { $0.typeName })
    
    for (_, classes) in allClassesByName {
        guard let target = classes.first(where: { !$0.isInterfaceSource }) else {
            continue
        }
        
        let remaining = classes.filter { $0.isInterfaceSource }
        
        mergeAllTypeDefinitions(in: remaining, on: target)
        
        // Remove all interface types after merge
        source.removeTypes { type in remaining.contains { $0 === type } }
    }
    
    for (_, extensions) in allExtensionsByName {
        // Work on extensions by category name, if available.
        let categories = Dictionary(grouping: extensions, by: { $0.categoryName ?? "" })
        
        for (_, cat) in categories {
            guard let target = cat.first(where: { !$0.isInterfaceSource }) else {
                continue
            }
            
            let remaining = cat.filter { $0.isInterfaceSource }
            
            mergeAllTypeDefinitions(in: remaining, on: target)
            
            // Remove all interface types after merge
            source.removeTypes { type in remaining.contains { $0 === type } }
        }
    }
}

/// Merges in duplicated types from @interface and @implementation's that match
/// on a given file
func mergeDuplicatedTypesInFile(_ file: FileGenerationIntention) {
    let classes = file.typeIntentions.compactMap { $0 as? ClassGenerationIntention }
    let extensions = file.typeIntentions.compactMap { $0 as? ClassExtensionGenerationIntention }
    
    let classesByName = Dictionary(grouping: classes, by: { $0.typeName })
    let extensionsByName = Dictionary(grouping: extensions, by: { $0.typeName })
    
    for (_, classes) in classesByName {
        guard let target = classes.first(where: { !$0.isInterfaceSource }) else {
            continue
        }
        
        let remaining = classes.filter { $0.isInterfaceSource }
        
        mergeAllTypeDefinitions(in: remaining, on: target)
        
        // Remove all interface types after merge
        file.removeTypes { type in remaining.contains { $0 === type } }
    }
    
    for (_, extensions) in extensionsByName {
        // Work on extensions by category name, if available.
        let categories = Dictionary(grouping: extensions, by: { $0.categoryName ?? "" })
        
        for (_, cat) in categories {
            guard let target = cat.first(where: { !$0.isInterfaceSource }) else {
                continue
            }
            
            let remaining = cat.filter { $0.isInterfaceSource }
            
            mergeAllTypeDefinitions(in: remaining, on: target)
            
            // Remove all interface types after merge
            file.removeTypes { type in remaining.contains { $0 === type } }
        }
    }
}

/// Merges all types provided into a target generation intention such that the
/// resulting type is a combination of all properties, ivars and methods from the
/// original types, with matching method/property signatures merged into one when
/// duplicated.
func mergeAllTypeDefinitions(in types: [TypeGenerationIntention],
                             on target: TypeGenerationIntention)
{
    for source in types {
        target.history.mergeHistories(source.history)
        
        mergeTypes(from: source, into: target)
    }
}

/// Merges a source KnownType into a second, such that property/method signatures
/// are flattened to properly nullability-annotated methods.
func mergeTypes(from first: KnownType,
                into second: TypeGenerationIntention) {
    // Protocols
    for prot in first.knownProtocolConformances {
        if !second.hasProtocol(named: prot.protocolName) {
            let generated = second.generateProtocolConformance(from: prot)
            
            second.history
                .recordChange(tag: "TypeMerge",
                              description: "Generating protocol conformance \(prot.protocolName) due to \(first.origin)")
            
            if let historic = prot as? Historic {
                generated.history.mergeHistories(historic.history)
            }
        }
    }
    
    if let first = first as? ClassGenerationIntention,
        let second = second as? ClassGenerationIntention {
        // Inheritance
        if let superclass = first.superclassName, second.superclassName == nil {
            second.superclassName = superclass
            
            second.history
                .recordChange(tag: "TypeMerge",
                              description: "Setting superclass of \(second.typeName) to \(superclass) due to superclass definition found at \(first.origin)")
        }
    }
    
    if let first = first as? BaseClassIntention,
        let second = second as? BaseClassIntention {
        // Instance vars
        for ivar in first.instanceVariables {
            if !second.hasInstanceVariable(named: ivar.name) {
                second.addInstanceVariable(ivar)
                
                second.history
                    .recordChange(tag: "TypeMerge",
                                  description: "Moved ivar \(ivar.name) from \(first.origin) to \(second.file?.sourcePath ?? "")")
            }
        }
    }
    
    // Properties
    for prop in first.knownProperties {
        if !second.hasProperty(named: prop.name) {
            let generated = second.generateProperty(from: prop)
            
            if let historic = prop as? Historic {
                generated.history.mergeHistories(historic.history)
            }
        }
    }
    
    // Methods
    mergeMethodSignatures(from: first, into: second)
}

/// Merges the signatures of a given known type's methods into the second type's
/// methods.
///
/// Matching signatures (matched by Objective-C selector) have their nullability
/// merged, and new methods not existent on the target type are created anew.
///
/// Bodies from the methods are not copied over.
/// - SeeAlso:
/// `mergeMethods(_ method1:KnownMethod, into method2: MethodGenerationIntention)`
func mergeMethodSignatures(from first: KnownType,
                           into second: TypeGenerationIntention) {
    for knownMethod in first.knownMethods {
        if let existing = second.method(matchingSelector: knownMethod.signature) {
            mergeMethods(knownMethod, into: existing)
        } else {
            let generated = second.generateMethod(from: knownMethod)
            
            second.history
                .recordChange(tag: "TypeMerge",
                              description: "Creating definition for newly found method \(TypeFormatter.asString(method: knownMethod, ofType: first))")
            
            if let historic = knownMethod as? Historic {
                generated.history.mergeHistories(historic.history)
            }
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
func mergeMethods(_ source: KnownMethod,
                  into target: MethodGenerationIntention) {
    let originalSignature = target.signature
    
    if !source.signature.returnType.isImplicitlyUnwrapped && target.signature.returnType.isImplicitlyUnwrapped {
        if source.signature.returnType.deepUnwrapped == target.signature.returnType.deepUnwrapped {
            target.signature.returnType = source.signature.returnType
        }
    }
    
    for (i, p1) in source.signature.parameters.enumerated() {
        if i >= target.signature.parameters.count {
            break
        }
        
        let p2 = target.signature.parameters[i]
        if !p1.type.isImplicitlyUnwrapped && p2.type.isImplicitlyUnwrapped && p1.type.deepUnwrapped == p2.type.deepUnwrapped {
            target.signature.parameters[i].type = p1.type
        }
    }
    
    // Track change
    if originalSignature != target.signature {
        target.history
            .recordChange(tag: historyTag,
                          description: """
                Updated nullability signature \(TypeFormatter.asString(signature: originalSignature)) \
                -> \(TypeFormatter.asString(signature: target.signature))
                """)
    }
    
    if let body = source.body, target.functionBody == nil {
        target.functionBody =
            FunctionBodyIntention(body: body.body)
        
        target.functionBody?.history.recordCreation(description: "Merged from existing type body")
        
        if let type = source.ownerType {
            target.history
                .recordChange(tag: historyTag,
                              description: "Inserted body from method \(TypeFormatter.asString(method: source, ofType: type))")
        } else {
            target.history
                .recordChange(tag: historyTag,
                              description: "Inserted body from function \(TypeFormatter.asString(signature: source.signature, includeName: false))")
        }
    }
}
