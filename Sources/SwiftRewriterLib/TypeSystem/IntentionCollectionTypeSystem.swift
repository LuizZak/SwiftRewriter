import SwiftAST

/// An extension over the default type system that enables using an intention
/// collection to search for types
public class IntentionCollectionTypeSystem: DefaultTypeSystem {
    public var intentions: IntentionCollection
    
    private var intentionsProvider: IntentionCollectionProvider
    
    public init(intentions: IntentionCollection) {
        self.intentions = intentions
        intentionsProvider = IntentionCollectionProvider(intentions: intentions,
                                                         typeSystem: nil)
        
        super.init()
        
        intentionsProvider.typeSystem = self
        
        knownTypeProviders.providers.append(intentionsProvider)
        typealiasProviders.providers.append(intentionsProvider)
    }
    
    public override func makeCache() {
        super.makeCache()
        
        var aliases: [String: SwiftType] = [:]
        var types: [String: [TypeGenerationIntention]] = [:]
        
        for file in intentions.fileIntentions() {
            for alias in file.typealiasIntentions {
                aliases[alias.name] = alias.fromType
            }
        }
        
        for file in intentions.fileIntentions() {
            for type in file.typeIntentions {
                types[type.typeName, default: []].append(type)
            }
        }
        
        let compoundTypes =
            types.mapValues({
                CompoundKnownType(typeName: $0[0].typeName, types: $0)
            })
        
        intentionsProvider.cache =
            IntentionCollectionProvider.Cache(typeAliases: aliases,
                                              types: compoundTypes)
    }
    
    public override func tearDownCache() {
        super.tearDownCache()
        
        intentionsProvider.cache = nil
    }
    
    public override func isClassInstanceType(_ typeName: String) -> Bool {
        guard let aliased = typeNameIn(swiftType: resolveAlias(in: typeName)) else {
            return false
        }
        
        if let cache = intentionsProvider.cache {
            if let type = cache.types[aliased] {
                return type.kind == .class || type.kind == .protocol
            }
        } else {
            for file in intentions.fileIntentions() {
                if let type = file.typeIntentions.first(where: { $0.typeName == aliased }) {
                    return type.kind == .class || type.kind == .protocol
                }
            }
        }
        
        return super.isClassInstanceType(typeName)
    }
    
    public override func typeExists(_ name: String) -> Bool {
        if super.typeExists(name) {
            return true
        }
        
        if let cache = intentionsProvider.cache {
            if cache.types.keys.contains(name) {
                return true
            }
        } else {
            for file in intentions.fileIntentions() {
                if file.typeIntentions.contains(where: { $0.typeName == name }) {
                    return true
                }
            }
        }
        
        return false
    }
    
    public override func knownTypes(ofKind kind: KnownTypeKind) -> [KnownType] {
        var types = super.knownTypes(ofKind: kind)
        
        if let cache = intentionsProvider.cache {
            for type in cache.types.values where type.kind == kind {
                types.append(type)
            }
        } else {
            for file in intentions.fileIntentions() {
                for type in file.typeIntentions where type.kind == kind {
                    types.append(type)
                }
            }
        }
        
        return types
    }
    
    // MARK: Shortcuts for member searching
    
    public override func property(named name: String, static isStatic: Bool,
                                  includeOptional: Bool, in type: SwiftType) -> KnownProperty? {
        guard let typeName = typeNameIn(swiftType: type) else {
            return super.property(named: name, static: isStatic,
                                  includeOptional: includeOptional, in: type)
        }
        
        if let type = intentionsProvider.knownType(withName: typeName) {
            if let prop = type.knownProperties.first(where: { $0.name == name && $0.isStatic == isStatic }) {
                return prop
            }
        }
        
        return super.property(named: name, static: isStatic, includeOptional: includeOptional, in: type)
    }
    
    public override func field(named name: String, static isStatic: Bool, in type: SwiftType) -> KnownProperty? {
        guard let typeName = typeNameIn(swiftType: type) else {
            return super.field(named: name, static: isStatic, in: type)
        }
        
        if let type = intentionsProvider.knownType(withName: typeName) {
            if let field = type.knownFields.first(where: { $0.name == name && $0.isStatic == isStatic }) {
                return field
            }
        }
        
        return super.field(named: name, static: isStatic, in: type)
    }
    
    public override func method(withObjcSelector selector: SelectorSignature,
                                invocationTypeHints: [SwiftType?]?,
                                static isStatic: Bool,
                                includeOptional: Bool,
                                in type: SwiftType) -> KnownMethod? {
        
        guard let typeName = typeNameIn(swiftType: type) else {
            return super.method(withObjcSelector: selector,
                                invocationTypeHints: invocationTypeHints,
                                static: isStatic,
                                includeOptional: includeOptional,
                                in: type)
        }
        
        if let type = intentionsProvider.knownType(withName: typeName) {
            if let method = method(matchingSelector: selector,
                                   invocationTypeHints: invocationTypeHints,
                                   in: type.knownMethods), method.isStatic == isStatic {
                
                return method
            }
        }
        
        return super.method(withObjcSelector: selector,
                            invocationTypeHints: invocationTypeHints,
                            static: isStatic,
                            includeOptional: includeOptional,
                            in: type)
    }
    
    /// Finds a method on a given array of methods that matches a given
    /// Objective-C selector signature.
    ///
    /// Ignores method variable names and types of return/parameters.
    // TODO: Apply parameter type overload resolution
    private func method(matchingSelector selector: SelectorSignature,
                        invocationTypeHints: [SwiftType?]?,
                        in methods: [KnownMethod]) -> KnownMethod? {
        
        guard let invocationTypeHints = invocationTypeHints else {
            return methods.first { $0.signature.asSelector == selector }
        }
        
        let methods = methods.filter {
            $0.signature.asSelector == selector
        }
        
        return overloadResolver()
            .findBestOverload(in: methods,
                                     argumentTypes: invocationTypeHints)
    }
    
    private class IntentionCollectionProvider: TypealiasProvider, KnownTypeProvider {
        var cache: Cache?
        
        var intentions: IntentionCollection
        weak var typeSystem: DefaultTypeSystem?
        
        init(intentions: IntentionCollection, typeSystem: DefaultTypeSystem?) {
            self.intentions = intentions
            self.typeSystem = typeSystem
        }
        
        func knownType(withName name: String) -> KnownType? {
            if let cache = cache {
                if let match = cache.types[name] {
                    return match
                }
                
                return nil
            }
            
            // Search in type intentions
            var types: [KnownType] = []
            for file in intentions.fileIntentions() {
                for type in file.typeIntentions where type.typeName == name {
                    types.append(type)
                }
            }
            
            guard !types.isEmpty else {
                return nil
            }
            
            // Single type found: Avoid complex merge operations and return it as is.
            if types.count == 1 {
                return types.first
            }
            
            return CompoundKnownType(typeName: name, types: Array(types), typeSystem: typeSystem)
        }
        
        func knownTypes(ofKind kind: KnownTypeKind) -> [KnownType] {
            var types: [KnownType] = []
            
            if let cache = cache {
                for type in cache.types.values where type.kind == kind {
                    types.append(type)
                }
            } else {
                for file in intentions.fileIntentions() {
                    for type in file.typeIntentions where type.kind == kind {
                        types.append(type)
                    }
                }
            }
            
            return types
        }
        
        func canonicalName(for typeName: String) -> String? {
            return nil
        }
        
        func unalias(_ typeName: String) -> SwiftType? {
            if let cache = cache {
                if let alias = cache.typeAliases[typeName] {
                    return alias
                }
            } else {
                for file in intentions.fileIntentions() {
                    for alias in file.typealiasIntentions where alias.name == typeName {
                        return alias.fromType
                    }
                }
            }
            
            return nil
        }
        
        struct Cache {
            var typeAliases: [String: SwiftType]
            var types: [String: CompoundKnownType]
        }
    }
}

/// A compound known type whose members are computed at creation time as aggregated
/// members of all types.
class CompoundKnownType: KnownType {
    private var types: [KnownType]
    
    var typeName: String
    
    var kind: KnownTypeKind
    var knownTraits: [String: TraitType]
    var origin: String
    var isExtension: Bool
    var supertype: KnownTypeReference?
    var knownConstructors: [KnownConstructor]
    var knownMethods: [KnownMethod]
    var knownProperties: [KnownProperty]
    var knownFields: [KnownProperty]
    var knownProtocolConformances: [KnownProtocolConformance]
    var knownAttributes: [KnownAttribute]
    var semantics: Set<Semantic>
    
    init(typeName: String, types: [KnownType], typeSystem: TypeSystem? = nil) {
        self.typeName = typeName
        self.types = types
        
        knownTraits = types.reduce([:], { $0.merging($1.knownTraits, uniquingKeysWith: { $1 }) })
        knownConstructors = []
        knownMethods = []
        knownProperties = []
        knownFields = []
        knownProtocolConformances = []
        knownAttributes = []
        semantics = []
        var isExt = true
        for type in types {
            if !type.isExtension {
                isExt = false
            }
            
            knownConstructors.append(contentsOf: type.knownConstructors)
            knownMethods.append(contentsOf: type.knownMethods)
            knownProperties.append(contentsOf: type.knownProperties)
            knownFields.append(contentsOf: type.knownFields)
            knownProtocolConformances.append(contentsOf: type.knownProtocolConformances)
            knownAttributes.append(contentsOf: type.knownAttributes)
            semantics.formUnion(type.semantics)
        }
        
        isExtension = isExt
        
        kind = types[0].kind
        origin = types[0].origin
        
        for type in types {
            // Search supertypes known here
            switch type.supertype {
            case .typeName(let supertypeName)?:
                supertype =
                    typeSystem?.knownTypeWithName(supertypeName).map { .knownType($0) }
                        ?? .typeName(supertypeName)
            case .knownType?:
                supertype = type.supertype
            default:
                break
            }
        }
    }
}
