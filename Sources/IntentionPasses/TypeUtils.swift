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
    
    // Merge global variables
    for gvar in source.globalVariableIntentions {
        guard let targetVar = target.globalVariableIntentions.first(where: { $0.name == gvar.name }) else {
            continue
        }
        
        mergeTypeNullability(gvar.type, &targetVar.storage.type)
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
                             on target: TypeGenerationIntention) {
    for source in types {
        target.history.mergeHistories(source.history)
        
        mergeTypes(from: source, into: target)
    }
}

/// Merges all global function definitions such that global definitions
///
/// When a global function matches the signature of another, and is visible from
/// that declaration's point, the two are merged such that they result into a single
/// function with proper nullability annotations merged from both, and the original
/// header declaration is removed.
func mergeGlobalFunctionDefinitions(in intentions: IntentionCollection) {
    var declarations: [GlobalFunctionGenerationIntention] = []
    var implementations: [GlobalFunctionGenerationIntention] = []
    
    // Search all declarations
    for function in intentions.globalFunctions() {
        if function.isDeclaration {
            declarations.append(function)
        } else {
            implementations.append(function)
        }
    }
    
    for impl in implementations {
        let visibleMatches =
            declarations.filter {
                $0.signature.matchesAsCFunction(impl.signature) && $0.isVisible(for: impl)
            }
        
        // Pick the first match and use it
        guard let match = visibleMatches.first else {
            continue
        }
        
        mergeFunction(match, into: impl)
        
        // Remove declarations
        for match in visibleMatches {
            match.file?.removeFunctions(where: { $0 === match })
        }
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
                .recordChange(
                    tag: "TypeMerge",
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
                .recordChange(
                    tag: "TypeMerge",
                    description: """
                    Setting superclass of \(second.typeName) to \(superclass) due to \
                    superclass definition found at \(first.origin)
                    """)
        }
    }
    
    if let first = first as? BaseClassIntention,
        let second = second as? BaseClassIntention {
        // Instance vars
        for ivar in first.instanceVariables {
            if !second.hasInstanceVariable(named: ivar.name) {
                second.addInstanceVariable(ivar)
                
                second.history
                    .recordChange(
                        tag: "TypeMerge",
                        description: """
                        Moved ivar \(ivar.name) from \(first.origin) to \(second.file?.sourcePath ?? "")
                        """)
            }
        }
    }
    
    mergePropertySignatures(from: first, into: second)
    
    // Methods
    mergeMethodSignatures(from: first, into: second)
}

/// Merges properties from a starting type into a target type.
func mergePropertySignatures(from first: KnownType, into second: TypeGenerationIntention) {
    // Properties
    for prop in first.knownProperties {
        if !second.hasProperty(named: prop.name) {
            let generated = second.generateProperty(from: prop)
            
            if let historic = prop as? Historic {
                generated.history.mergeHistories(historic.history)
            }
        }
    }
}

/// Merges the signatures of a given known type's methods into the second type's
/// methods.
///
/// Matching signatures (matched by Objective-C selector) have their nullability
/// merged, and new methods not existent on the target type are created anew.
///
/// If `skipCreatingOptionalMethods` is `true`, protocol methods that are marked
/// `optional` that do not match any method on the target type are ignored and
/// are not created. Defaults to `true`.
///
/// Bodies from the methods are not copied over.
/// - SeeAlso:
/// `mergeMethods(_ method1:KnownMethod, into method2: MethodGenerationIntention)`
func mergeMethodSignatures(from first: KnownType,
                           into second: TypeGenerationIntention,
                           skipCreatingOptionalMethods: Bool = true) {
    for knownMethod in first.knownMethods {
        if let existing = second.method(matchingSelector: knownMethod.signature.asSelector) {
            mergeMethods(knownMethod, into: existing)
        } else {
            if skipCreatingOptionalMethods && knownMethod.optional {
                continue
            }
            
            let generated = second.generateMethod(from: knownMethod)
            
            second.history
                .recordChange(
                    tag: "TypeMerge",
                    description: """
                    Creating definition for newly found method \
                    \(TypeFormatter.asString(method: knownMethod, ofType: first))
                    """)
            
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
    
    target.signature = mergeSignatures(source.signature, target.signature)
    
    // Track change
    if originalSignature != target.signature {
        target.history
            .recordChange(tag: historyTag,
                          description: """
                Updated nullability signature from \(TypeFormatter.asString(signature: originalSignature)) \
                to: \(TypeFormatter.asString(signature: target.signature))
                """)
    }
    
    if let body = source.body, target.functionBody == nil {
        target.functionBody =
            FunctionBodyIntention(body: body.body)
        
        target.functionBody?.history.recordCreation(description: "Merged from existing type body")
        
        target.history
            .recordChange(
                tag: historyTag,
                description: """
                Inserted body from function \
                \(TypeFormatter.asString(signature: source.signature, includeName: false))
                """)
    }
}

/// Merges two global functions such that the target one retains all proper nullability
/// annotations and the implementation body.
func mergeFunction(_ source: GlobalFunctionGenerationIntention,
                   into target: GlobalFunctionGenerationIntention) {
    
    let originalSignature = target.signature
    
    target.signature = mergeSignatures(source.signature, target.signature)
    
    // Track change
    if originalSignature != target.signature {
        target.history
            .recordChange(tag: historyTag,
                          description: """
                Updated nullability signature from \(TypeFormatter.asString(signature: originalSignature)) \
                to: \(TypeFormatter.asString(signature: target.signature))
                """)
    }
    
    if let body = source.functionBody, target.functionBody == nil {
        target.functionBody =
            FunctionBodyIntention(body: body.body)
        
        target.functionBody?.history.recordCreation(description: "Merged from existing type body")
        
        let funcSign = TypeFormatter.asString(signature: source.signature, includeName: false)
        
        target.history
            .recordChange(tag: historyTag, description: "Inserted body from function \(funcSign)")
    }
}

/// Merges two function signatures, collapsing nullability specifiers that are
/// defined on the first signature, but undefined on the second.
func mergeSignatures(_ sign1: FunctionSignature,
                     _ sign2: FunctionSignature) -> FunctionSignature {
    
    var result = sign2
    
    mergeTypeNullability(sign1.returnType, &result.returnType)
    
    for (i, p1) in sign1.parameters.enumerated() {
        if i >= result.parameters.count {
            break
        }
        
        mergeTypeNullability(p1.type, &result.parameters[i].type)
    }
    
    return result
}

func mergeTypeNullability(_ type1: SwiftType, _ type2: inout SwiftType) {
    if !type1.isImplicitlyUnwrapped && type2.isImplicitlyUnwrapped {
        if SwiftType.asNonnullDeep(type1) == SwiftType.asNonnullDeep(type2) {
            type2 = type1
        }
    }
    
    // Merge block types
    switch (type1, type2) {
    case (let .block(t1Ret, t1Params), var .block(ret, params))
        where t1Params.count == params.count:
        mergeTypeNullability(t1Ret, &ret)
        
        for (i, p1) in t1Params.enumerated() {
            mergeTypeNullability(p1, &params[i])
        }
        
        type2 = .block(returnType: ret, parameters: params)
    default:
        break
    }
}
