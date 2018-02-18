import GrammarModels
import Foundation
import Utils

/// A protocol for objects that perform passes through intentions collected and
/// perform changes and optimizations on them.
public protocol IntentionPass {
    func apply(on intentionCollection: IntentionCollection)
}

/// Gets an array of intention passes to apply before writing the final Swift code.
/// Used by `SwiftRewriter` before it outputs the final intents to `SwiftWriter`.
public enum IntentionPasses {
    public static var passes: [IntentionPass] = [
        FileGroupingIntentionPass(),
        RemoveDuplicatedTypeIntentIntentionPass(),
        ProtocolNullabilityPropagationToConformersIntentionPass(),
        PropertyMergeIntentionPass(),
    ]
}

/// From file intentions, remove intentions for interfaces that already have a
/// matching implementation.
/// Must be executed after a pass of `FileGroupingIntentionPass` to avoid dropping
/// @property declarations and the like.
public class RemoveDuplicatedTypeIntentIntentionPass: IntentionPass {
    public func apply(on intentionCollection: IntentionCollection) {
        for file in intentionCollection.intentions(ofType: FileGenerationIntention.self) {
            // Remove from file implementation any class generation intent that came
            // from an @interface
            file.removeTypes(where: { type in
                if !(type.source is ObjcClassInterface || type.source is ObjcClassCategory) {
                    return false
                }
                
                return
                    file.typeIntentions.contains {
                        $0.typeName == type.typeName && ($0.source is ObjcClassImplementation || $0.source is ObjcClassCategoryImplementation)
                    }
            })
        }
    }
}

/// Propagates known protocol nullability signautres from protocol intentions into
/// classes that implement them.
public class ProtocolNullabilityPropagationToConformersIntentionPass: IntentionPass {
    public func apply(on intentionCollection: IntentionCollection) {
        // Collect protocols
        let protocols =
            intentionCollection.intentions(ofType: ProtocolGenerationIntention.self)
        let classes =
            intentionCollection.intentions(ofType: ClassGenerationIntention.self)
        
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
                FileGroupingIntentionPass.mergeMethodSignatures(from: prot, into: cls)
            }
        }
    }
}

public class FileGroupingIntentionPass: IntentionPass {
    public func apply(on intentionCollection: IntentionCollection) {
        // Collect .h/.m pairs
        let intentions =
            intentionCollection.intentions(ofType: FileGenerationIntention.self)
        
        var headers: [FileGenerationIntention] = []
        var implementations: [FileGenerationIntention] = []
        
        for intent in intentions {
            if intent.filePath.hasSuffix(".m") {
                implementations.append(intent)
            } else if intent.filePath.hasSuffix(".h") {
                headers.append(intent)
            }
        }
        
        // For each impl, search for a matching header intent and combine any
        // class intent within
        for implementation in implementations {
            // Merge definitions from within an implementation file first
            FileGroupingIntentionPass.mergeDefinitions(in: implementation)
            
            let implFile =
                (implementation.filePath as NSString).deletingPathExtension
            
            guard let header = headers.first(where: { hIntent -> Bool in
                let headerFile =
                    (hIntent.filePath as NSString).deletingPathExtension
                
                return implFile == headerFile
            }) else {
                continue
            }
            
            FileGroupingIntentionPass.mergeDefinitions(from: header, into: implementation)
        }
        
        // Remove all header intentions that have a matching implementation
        // (implementation intentions override them)
        intentionCollection.removeIntentions { (intent: FileGenerationIntention) -> Bool in
            if !intent.filePath.hasSuffix(".h") {
                return false
            }
            
            let headerFile =
                (intent.filePath as NSString).deletingPathExtension
            
            if implementations.contains(where: { impl -> Bool in
                (impl.filePath as NSString).deletingPathExtension == headerFile
            }) {
                return true
            }
            
            return false
        }
    }
    
    fileprivate static func mergeDefinitions(from header: FileGenerationIntention,
                                  into implementation: FileGenerationIntention) {
        let total = header.typeIntentions + implementation.typeIntentions
        
        let groupedTypes = Dictionary(grouping: total, by: { $0.typeName })
        
        for (_, types) in groupedTypes where types.count >= 2 {
            mergeAllTypeDefinitions(in: types)
        }
    }
    
    fileprivate static func mergeDefinitions(in implementation: FileGenerationIntention) {
        let groupedTypes = Dictionary(grouping: implementation.typeIntentions,
                                      by: { $0.typeName })
        
        for (_, types) in groupedTypes where types.count >= 2 {
            mergeAllTypeDefinitions(in: types)
        }
    }
    
    fileprivate static func mergeAllTypeDefinitions(in types: [TypeGenerationIntention]) {
        let target = types.reversed().first { $0.source is ObjcClassImplementation || $0.source is ObjcClassCategoryImplementation } ?? types.last!
        
        for type in types.dropLast() {
            mergeTypes(from: type, into: target)
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
            if let existing = second.method(withSignature: knownMethod.signature) {
                mergeMethodSignature(knownMethod, into: existing)
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
    static func mergeMethodSignature(_ method1: KnownMethod,
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
    }
    
    private struct Pair {
        var header: FileGenerationIntention
        var implementation: FileGenerationIntention
    }
}

public class PropertyMergeIntentionPass: IntentionPass {
    public func apply(on intentionCollection: IntentionCollection) {
        for cls in intentionCollection.intentions(ofType: ClassGenerationIntention.self) {
            apply(on: cls)
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
            if let getterBody = getter.body, let setterBody = setter.body {
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
            if let body = getter.body {
                propertySet.property.mode = .computed(body)
            }
            
            // Remove the original method intention
            classIntention.removeMethod(getter)
            
        case let (nil, setter?):
            classIntention.removeMethod(setter)
            
            guard let setterBody = setter.body else {
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
                MethodBodyIntention(body: [.return(.identifier(backingFieldName))],
                                    source: propertySet.setter?.body?.source)
            
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
