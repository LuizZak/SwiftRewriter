import GrammarModels
import Foundation
import Utils

/// A protocol for objects that perform passes through intentions collected and
/// perform changes and optimizations on them.
public protocol IntentionPass {
    func apply(on intentionCollection: IntentionCollection, context: IntentionPassContext)
}

/// Context for an intention pass
public struct IntentionPassContext {
    public let intentions: IntentionCollection
    public let types: KnownTypeStorage
}

/// Gets an array of intention passes to apply before writing the final Swift code.
/// Used by `SwiftRewriter` before it outputs the final intents to `SwiftWriter`.
public enum IntentionPasses {
    public static var passes: [IntentionPass] = [
        FileTypeMergingIntentionPass(),
        RemoveDuplicatedTypeIntentIntentionPass(),
        StoredPropertyToNominalTypesIntentionPass(),
        ProtocolNullabilityPropagationToConformersIntentionPass(),
        PropertyMergeIntentionPass(),
        ClangifyMethodSignaturesIntentionPass()
    ]
}

/// From file intentions, remove intentions for interfaces that already have a
/// matching implementation.
/// Must be executed after a pass of `FileGroupingIntentionPass` to avoid dropping
/// @property declarations and the like.
public class RemoveDuplicatedTypeIntentIntentionPass: IntentionPass {
    public func apply(on intentionCollection: IntentionCollection, context: IntentionPassContext) {
        for file in intentionCollection.fileIntentions() {
            // Remove from file implementation any class generation intent that came
            // from an @interface
            file.removeClassTypes(where: { type in
                if !(type.source is ObjcClassInterface || type.source is ObjcClassCategoryInterface) {
                    return false
                }
                
                return
                    file.typeIntentions.contains {
                        $0.typeName == type.typeName &&
                            ($0.source is ObjcClassImplementation ||
                                $0.source is ObjcClassCategoryImplementation)
                    }
            })
        }
    }
}

/// Propagates known protocol nullability signautres from protocol intentions into
/// classes that implement them.
public class ProtocolNullabilityPropagationToConformersIntentionPass: IntentionPass {
    public func apply(on intentionCollection: IntentionCollection, context: IntentionPassContext) {
        // Collect protocols
        let protocols = intentionCollection.protocolIntentions()
        let classes = intentionCollection.classIntentions()
        
        if protocols.count == 0 || classes.count == 0 {
            return
        }
        
        for cls in classes {
            // Find conforming protocols
            let knownProtocols =
                protocols.filter { prot in
                    cls.protocols.contains {
                        $0.protocolName == prot.typeName
                    }
                }
            
            for prot in knownProtocols {
                FileTypeMergingIntentionPass.mergeMethodSignatures(from: prot, into: cls)
            }
        }
    }
}

public class FileTypeMergingIntentionPass: IntentionPass {
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
    
    fileprivate static func mergeTypeIntentions(typeIntentions: [TypeGenerationIntention],
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
    
    fileprivate static func mergeAllTypeDefinitions(in types: [TypeGenerationIntention],
                                                    on target: TypeGenerationIntention)
    {
        for source in types {
            mergeTypes(from: source, into: target)
        }
    }
    
    fileprivate
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
    
    fileprivate
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
    fileprivate
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

/// An intention to move all instance variables/properties from extensions into
/// the nominal types.
///
/// Extensions in Swift cannot declare stored variables, so they must be moved to
/// the proper nominal instances.
public class StoredPropertyToNominalTypesIntentionPass: IntentionPass {
    public func apply(on intentionCollection: IntentionCollection, context: IntentionPassContext) {
        let classes = intentionCollection.classIntentions()
        let extensions = intentionCollection.extensionIntentions()
        
        for cls in classes {
            let ext = extensions.filter { $0.typeName == cls.typeName }
            
            mergeStoredProperties(from: ext, into: cls)
        }
    }
    
    public func mergeStoredProperties(from extensions: [ClassExtensionGenerationIntention],
                                      into nominalClass: ClassGenerationIntention) {
        for ext in extensions {
            // IVar
            StoredPropertyToNominalTypesIntentionPass
                .moveInstanceVariables(from: ext, into: nominalClass)
        }
    }
    
    static func moveInstanceVariables(from first: BaseClassIntention,
                                      into second: BaseClassIntention) {
        for ivar in first.instanceVariables {
            if !second.hasInstanceVariable(named: ivar.name) {
                second.addInstanceVariable(ivar)
            } else {
                first.removeInstanceVariable(named: ivar.name)
            }
        }
    }
    
    static func moveStoredProperties(from first: BaseClassIntention,
                                     into second: BaseClassIntention) {
        for prop in first.properties {
            first.removeProperty(prop)
            
            if !second.hasProperty(named: prop.name) {
                second.addProperty(prop)
            }
        }
    }
}

public class PropertyMergeIntentionPass: IntentionPass {
    public func apply(on intentionCollection: IntentionCollection, context: IntentionPassContext) {
        for file in intentionCollection.fileIntentions() {
            
            for cls in file.typeIntentions.compactMap({ $0 as? ClassGenerationIntention }) {
                apply(on: cls)
            }
        }
    }
    
    func apply(on classIntention: ClassGenerationIntention) {
        let properties = collectProperties(fromClass: classIntention)
        let methods = collectMethods(fromClass: classIntention)
        
        // Match property intentions with the appropriately named methods
        var matches: [PropertySet] = []
        
        for property in properties where property.name.count > 1 {
            let expectedName = "set" + property.name.uppercasedFirstLetter
            
            // Getters
            let potentialGetters =
                methods.filter { $0.name == property.name }
                    .filter { $0.returnType.deepUnwrapped == property.type.deepUnwrapped }
                    .filter { $0.parameters.count == 0 }
            let potentialSetters =
                methods.filter { $0.returnType == .void }
                    .filter { $0.parameters.count == 1 }
                    .filter { $0.parameters[0].type.deepUnwrapped == property.type.deepUnwrapped }
                    .filter { $0.name == expectedName }
            
            var propSet = PropertySet(property: property, getter: nil, setter: nil)
            
            if potentialGetters.count == 1 {
                propSet.getter = potentialGetters[0]
            }
            if potentialSetters.count == 1 {
                propSet.setter = potentialSetters[0]
            }
            
            if propSet.getter == nil && propSet.setter == nil {
                continue
            }
            
            matches.append(propSet)
        }
        
        // Flatten properties now
        for match in matches {
            joinPropertySet(match, on: classIntention)
        }
    }
    
    func collectProperties(fromClass classIntention: ClassGenerationIntention) -> [PropertyGenerationIntention] {
        return classIntention.properties
    }
    
    func collectMethods(fromClass classIntention: ClassGenerationIntention) -> [MethodGenerationIntention] {
        return classIntention.methods
    }
    
    /// From a given found joined set of @property definition and potential
    /// getter/setter definitions, reworks the intented signatures on the class
    /// definition such that properties are correctly flattened with their non-synthesized
    /// getter/setters into `var myVar { get set }` Swift computed properties.
    private func joinPropertySet(_ propertySet: PropertySet, on classIntention: ClassGenerationIntention) {
        switch (propertySet.getter, propertySet.setter) {
        case let (getter?, setter?):
            if let getterBody = getter.functionBody, let setterBody = setter.functionBody {
                let setter =
                    PropertyGenerationIntention
                        .Setter(valueIdentifier: setter.parameters[0].name,
                                body: setterBody)
                
                propertySet.property.mode =
                    .property(get: getterBody, set: setter)
            }
            
            // Remove the original method intentions
            classIntention.removeMethod(getter)
            classIntention.removeMethod(setter)
            
        case let (getter?, nil) where propertySet.property.isSourceReadOnly:
            if let body = getter.functionBody {
                propertySet.property.mode = .computed(body)
            }
            
            // Remove the original method intention
            classIntention.removeMethod(getter)
            
        case let (nil, setter?):
            classIntention.removeMethod(setter)
            
            guard let setterBody = setter.functionBody else {
                break
            }
            
            let backingFieldName = "_" + propertySet.property.name
            let setter =
                PropertyGenerationIntention
                    .Setter(valueIdentifier: setter.parameters[0].name,
                            body: setterBody)
            
            // Synthesize a simple getter that has the following statement within:
            // return self._backingField
            let getterIntention =
                FunctionBodyIntention(body: [.return(.identifier(backingFieldName))],
                                    source: propertySet.setter?.functionBody?.source)
            
            propertySet.property.mode = .property(get: getterIntention, set: setter)
            
            let field =
                InstanceVariableGenerationIntention(name: backingFieldName,
                                                    storage: propertySet.property.storage,
                                                    accessLevel: .private,
                                                    source: propertySet.property.source)
            
            classIntention.addInstanceVariable(field)
        default:
            break
        }
    }
    
    private struct PropertySet {
        var property: PropertyGenerationIntention
        var getter: MethodGenerationIntention?
        var setter: MethodGenerationIntention?
    }
}

/// Performs Clang-style alterations of method signatures to attempt to match
/// somewhat its behavior when coming up with Swift names for Objective-C methods.
///
/// Examples include [[Class alloc] initWithThing:thing] -> Class(thing: thing)
public class ClangifyMethodSignaturesIntentionPass: IntentionPass {
    public func apply(on intentionCollection: IntentionCollection, context: IntentionPassContext) {
        let types = intentionCollection.typeIntentions()
        
        for type in types {
            apply(on: type)
        }
    }
    
    private func apply(on type: TypeGenerationIntention) {
        let methods = type.methods
        
        for method in methods {
            apply(on: method)
            
            // Check methods that where turned into initializers
            if !method.signature.isStatic && method.signature.name == "init" &&
                method.returnType != .void {
                type.removeMethod(method)
                type.addConstructor(method)
            }
        }
    }
    
    private func apply(on method: MethodGenerationIntention) {
        let signature = method.signature
        
        // Do a little Clang-like-magic here: If the method selector is in the
        // form `loremWithThing:thing...`, where after a `[...]With` prefix, a
        // noun is followed by a parameter that has the same name, we collapse
        // such selector in Swift as `lorem(with:)`.
        if signature.name.contains("With") && signature.parameters.count > 0 {
            let split = signature.name.components(separatedBy: "With")
            if split.count != 2 || split.contains(where: { $0.count < 2 }) {
                return
            }
            if split[1].lowercased() != signature.parameters[0].name.lowercased() {
                return
            }
            
            // All good! Collapse the identifier into a more 'swifty' construct
            method.signature.name = split[0]
            
            // Init works slightly different: We leave the first label as the
            // noun found after "With"
            if split[0] == "init" {
                method.signature.parameters[0].label = split[1].lowercased()
            } else {
                method.signature.parameters[0].label = "with"
            }
        }
    }
}

private extension RangeReplaceableCollection where Index == Int {
    mutating func remove(where predicate: (Element) -> Bool) {
        for (i, item) in enumerated() {
            if predicate(item) {
                remove(at: i)
                return
            }
        }
    }
}
