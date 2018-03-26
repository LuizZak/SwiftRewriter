import SwiftAST
import TypeDefinitions
import Utils

/// Standard type system implementation
public class DefaultTypeSystem: TypeSystem, KnownTypeSink, AliasesSource {
    /// A singleton instance to a default type system.
    public static let defaultTypeSystem: TypeSystem = DefaultTypeSystem()
    
    private var baseClassTypesByName: [String: ClassType] = [:]
    private var initializedCache = false
    
    /// Type-aliases
    var aliases: [String: SwiftType] = [:]
    
    var types: [KnownType] = []
    var typesByName: [String: KnownType] = [:]
    
    public init() {
        registerInitialKnownTypes()
    }
    
    /// Resets the storage of all known types and type aliases to the default
    /// values.
    public func reset() {
        types.removeAll()
        typesByName.removeAll()
        aliases.removeAll()
        registerInitialKnownTypes()
    }
    
    public func addType(_ type: KnownType) {
        types.append(type)
        typesByName[type.typeName] = type
    }
    
    public func typesMatch(_ type1: SwiftType, _ type2: SwiftType, ignoreNullability: Bool) -> Bool {
        let expanded1 = resolveAlias(in: type1)
        let expanded2 = resolveAlias(in: type2)
        
        // Same structure, ignoring nullability
        if ignoreNullability {
            if expanded1.deepUnwrapped == expanded2.deepUnwrapped {
                return true
            }
        } else if expanded1 == expanded2 {
            // Same structure, taking nullabillity into account
            return true
        }
        
        return false
    }
    
    public func typeExists(_ name: String) -> Bool {
        guard let name = typeNameIn(swiftType: resolveAlias(in: name)) else {
            return false
        }
        
        return typesByName.keys.contains(name)
    }
    
    public func knownTypes(ofKind kind: KnownTypeKind) -> [KnownType] {
        return types.filter { $0.kind == kind }
    }
    
    public func knownTypeWithName(_ name: String) -> KnownType? {
        guard let name = typeNameIn(swiftType: resolveAlias(in: name)) else {
            return nil
        }
        
        return typesByName[name]
    }
    
    public func composeTypeWithKnownTypes(_ typeNames: [String]) -> KnownType? {
        if typeNames.isEmpty {
            return nil
        }
        if typeNames.count == 1 {
            return knownTypeWithName(typeNames[0])
        }
        
        var types: [KnownType] = []
        
        for typeName in typeNames {
            guard let type = knownTypeWithName(typeName) else {
                return nil
            }
            
            types.append(type)
        }
        
        // TODO: Expose a new protocol `KnownTypeComposition` to help expose
        // the type structure better, and get rid of this `typeName` hack-ish thing.
        return CompoundKnownType(typeName: typeNames.joined(separator: " & "), typeSystem: self, types: types)
    }
    
    public func isClassInstanceType(_ typeName: String) -> Bool {
        guard let aliased = typeNameIn(swiftType: resolveAlias(in: typeName)) else {
            return false
        }
        
        if TypeDefinitions.classesList.classes.contains(where: { $0.typeName == aliased }) {
            return true
        }
        
        if let type = knownTypeWithName(typeName) {
            return type.kind == .class || type.kind == .protocol
        }
        
        return false
    }
    
    public func isClassInstanceType(_ type: SwiftType) -> Bool {
        switch type.unwrapped {
        case .nominal(.typeName(let typeName)), .nominal(.generic(let typeName, _)):
            return isClassInstanceType(typeName)
        case .protocolComposition:
            return true
        default:
            return false
        }
    }
    
    public func isScalarType(_ type: SwiftType) -> Bool {
        if isNumeric(type) {
            return true
        }
        
        guard let knownType = findType(for: type) else {
            return false
        }
        
        return knownType.kind == .struct
    }
    
    public func isType(_ typeName: String, conformingTo protocolName: String) -> Bool {
        guard let typeName = typeNameIn(swiftType: resolveAlias(in: typeName)) else {
            return false
        }
        guard let protocolName = typeNameIn(swiftType: resolveAlias(in: protocolName)) else {
            return false
        }
        if typeName == protocolName {
            return true
        }
        
        guard let type = knownTypeWithName(typeName) else {
            return false
        }
        
        return conformance(toProtocolName: protocolName, in: type) != nil
    }
    
    public func isType(_ typeName: String, subtypeOf supertypeName: String) -> Bool {
        guard let typeName = typeNameIn(swiftType: resolveAlias(in: typeName)) else {
            return false
        }
        guard let supertypeName = typeNameIn(swiftType: resolveAlias(in: supertypeName)) else {
            return false
        }
        
        if typeName == supertypeName {
            return true
        }
        
        guard let type = knownTypeWithName(typeName) else {
            return false
        }
        
        // Direct supertype name fetching
        switch type.supertype {
        case .typeName(let tn)? where tn == supertypeName:
            return true
        case .knownType(let kt)?:
            return isType(kt.typeName, subtypeOf: supertypeName)
        default:
            break
        }
        
        guard let supertype = knownTypeWithName(supertypeName) else {
            return false
        }
        
        var current: KnownType? = type
        while let c = current {
            if c.typeName == supertype.typeName {
                return true
            }
            
            current = c.supertype?.asKnownType
        }
        
        // Search type definitions
        var currentClassType = classTypeDefinition(name: typeName)
        while let c = currentClassType {
            if c.typeName == supertypeName {
                return true
            }
            
            currentClassType = classTypeDefinition(name: c.superclass)
        }
        
        return false
    }
    
    public func category(forType type: String) -> TypeCategory {
        let aliasedType = resolveAlias(in: type)
        
        if isInteger(aliasedType) {
            return .integer
        }
        
        guard let aliased = typeNameIn(swiftType: aliasedType) else {
            return .unknown
        }
        
        switch aliased {
        case "Bool", "ObjCBool":
            return .boolean
        case "CGFloat", "Float", "Double", "CFloat", "CDouble", "Float80":
            return .float
        default:
            break
        }
        
        if let type = self.knownTypeWithName(aliased) {
            switch type.kind {
            case .class:
                return .class
            case .enum:
                return .enum
            case .protocol:
                return .protocol
            case .struct:
                return .struct
            }
        }
        
        return .unknown
    }
    
    public func category(forType type: SwiftType) -> TypeCategory {
        guard let typeName = typeNameIn(swiftType: type) else {
            return .unknown
        }
        
        return category(forType: typeName)
    }
    
    public func defaultValue(for type: SwiftType) -> Expression? {
        if isNumeric(type) {
            let exp: Expression = isInteger(type) ? .constant(0) : .constant(0.0)
            exp.resolvedType = type
            
            return exp
        }
        if type.isOptional {
            let exp = Expression.constant(.nil)
            exp.resolvedType = type
            
            return exp
        }
        if type == .bool {
            let exp = Expression.constant(false)
            exp.resolvedType = type
            
            return exp
        }
        
        switch type {
        case .nominal(.typeName(let name)):
            guard let knownType = knownTypeWithName(name) else {
                return nil
            }
            
            // Structs with default constructors are default-initialized to its
            // respective value.
            if knownType.kind == .struct, constructor(withArgumentLabels: [], in: knownType) != nil {
                let exp = Expression.identifier(name).call()
                exp.resolvedType = type
                
                return exp
            }
            
            return nil
        default:
            return nil
        }
    }
    
    public func isNumeric(_ type: SwiftType) -> Bool {
        if isInteger(type) {
            return true
        }
        
        switch type {
        case .float, .double, .cgFloat:
            return true
        case .typeName("Float80"):
            return true
        case .typeName("CFloat"), .typeName("CDouble"):
            return true
        default:
            return false
        }
    }
    
    public func isInteger(_ type: SwiftType) -> Bool {
        let aliased = resolveAlias(in: type)
        
        switch aliased {
        case .int, .uint:
            return true
        case .nominal(.typeName(let name)):
            switch name {
            // Swift integer types
            case "Int", "Int64", "Int32", "Int16", "Int8", "UInt", "UInt64", "UInt32",
                 "UInt16", "UInt8":
                return true
            // C integer types
            case "CChar", "CSignedChar", "CChar16", "CChar32", "CUnsignedChar", "CInt", "CUnsignedInt",
                 "CShort", "CUnsignedShort", "CLong", "CUnsignedLong", "CLongLong", "CUnsignedLongLong",
                 "CWideChar", "CBool":
                return true
            default:
                return false
            }
        default:
            return false
        }
    }
    
    func unaliased(typeName: String) -> SwiftType? {
        return aliases[typeName]
    }
    
    public func resolveAlias(in typeName: String) -> SwiftType {
        guard let type = aliases[typeName] else {
            return .typeName(typeName)
        }
        
        return resolveAlias(in: type)
    }
    
    public func resolveAlias(in type: SwiftType) -> SwiftType {
        let resolver = TypealiasExpander(aliasesSource: self)
        return resolver.expand(in: type)
    }
    
    public func supertype(of type: KnownType) -> KnownType? {
        guard let supertype = type.supertype else {
            return nil
        }
        
        switch supertype {
        case .knownType(let type):
            return type
        case .typeName(let type):
            return knownTypeWithName(type)
        }
    }
    
    public func constructor(withArgumentLabels labels: [String], in type: KnownType) -> KnownConstructor? {
        if let constructor =
            type.knownConstructors
                .first(where: { $0.parameters.map { $0.label }.elementsEqual(labels) }) {
            return constructor
        }
        
        // Search on supertypes
        return supertype(of: type).flatMap {
            constructor(withArgumentLabels: labels, in: $0)
        }
    }
    
    public func conformance(toProtocolName name: String, in type: KnownType) -> KnownProtocolConformance? {
        if let conformance =
            type.knownProtocolConformances
                .first(where: { $0.protocolName == name }) {
            return conformance
        }
        
        // Search on supertypes
        let supertypeConformance = supertype(of: type).flatMap {
            conformance(toProtocolName: name, in: $0)
        }
        
        if let supertypeConformance = supertypeConformance {
            return supertypeConformance
        }
        
        // Search on protocols
        for prot in type.knownProtocolConformances {
            guard let type = knownTypeWithName(prot.protocolName) else {
                continue
            }
            
            if let conformance = conformance(toProtocolName: name, in: type) {
                return conformance
            }
        }
        
        return nil
    }
    
    public func method(withObjcSelector selector: SelectorSignature, static isStatic: Bool,
                       includeOptional: Bool, in type: KnownType) -> KnownMethod? {
        if let method = type.knownMethods.first(where: {
            $0.signature.asSelector == selector
                && $0.isStatic == isStatic
                && (includeOptional || !$0.optional)
        }) {
            return method
        }
        
        // Search on protocol conformances
        for conformance in type.knownProtocolConformances {
            guard let prot = knownTypeWithName(conformance.protocolName) else {
                continue
            }
            
            if let method = method(withObjcSelector: selector, static: isStatic,
                                   includeOptional: includeOptional, in: prot) {
                return method
            }
        }
        
        // Search on supertypes
        return supertype(of: type).flatMap {
            method(withObjcSelector: selector, static: isStatic, includeOptional: includeOptional, in: $0)
        }
    }
    
    public func property(named name: String, static isStatic: Bool, includeOptional: Bool,
                         in type: KnownType) -> KnownProperty? {
        if let property = type.knownProperties.first(where: {
            $0.name == name
                && $0.isStatic == isStatic
                && (includeOptional || !$0.optional)
        }) {
            return property
        }
        
        // Search on supertypes
        return supertype(of: type).flatMap {
            property(named: name, static: isStatic, includeOptional: includeOptional, in: $0)
        }
    }
    
    public func field(named name: String, static isStatic: Bool, in type: KnownType) -> KnownProperty? {
        if let field =
            type.knownFields
                .first(where: { $0.name == name && $0.isStatic == isStatic }) {
            return field
        }
        
        // Search on supertypes
        return supertype(of: type).flatMap {
            field(named: name, static: isStatic, in: $0)
        }
    }
    
    public func findType(for swiftType: SwiftType) -> KnownType? {
        let swiftType = swiftType.deepUnwrapped
        
        switch swiftType {
        case .nominal(.typeName(let typeName)):
            return knownTypeWithName(typeName)
            
        // Meta-types recurse on themselves
        case .metatype(for: let inner):
            let type = inner.deepUnwrapped
            
            switch type {
            case .nominal(.typeName(let name)):
                return knownTypeWithName(name)
            default:
                return findType(for: type)
            }
            
        case .protocolComposition(let types):
            return composeTypeWithKnownTypes(types.map { $0.description })
            
        // Other Swift types are not supported, at the moment.
        default:
            return nil
        }
    }
    
    public func constructor(withArgumentLabels labels: [String], in type: SwiftType) -> KnownConstructor? {
        guard let knownType = self.findType(for: type) else {
            return nil
        }
        return constructor(withArgumentLabels: labels, in: knownType)
    }
    
    public func conformance(toProtocolName name: String, in type: SwiftType) -> KnownProtocolConformance? {
        guard let knownType = self.findType(for: type) else {
            return nil
        }
        return conformance(toProtocolName: name, in: knownType)
    }
    
    public func method(withObjcSelector selector: SelectorSignature, static isStatic: Bool,
                       includeOptional: Bool, in type: SwiftType) -> KnownMethod? {
        guard let knownType = self.findType(for: type) else {
            return nil
        }
        return method(withObjcSelector: selector, static: isStatic, includeOptional: includeOptional,
                      in: knownType)
    }
    
    public func property(named name: String, static isStatic: Bool, includeOptional: Bool,
                         in type: SwiftType) -> KnownProperty? {
        guard let knownType = self.findType(for: type) else {
            return nil
        }
        return property(named: name, static: isStatic, includeOptional: includeOptional,
                        in: knownType)
    }
    
    public func field(named name: String, static isStatic: Bool, in type: SwiftType) -> KnownProperty? {
        guard let knownType = self.findType(for: type) else {
            return nil
        }
        return field(named: name, static: isStatic, in: knownType)
    }
    
    private func classTypeDefinition(name: String) -> ClassType? {
        return synchronized(self) {
            if !initializedCache {
                baseClassTypesByName =
                    TypeDefinitions
                        .classesList
                        .classes
                        .groupBy({ $0.typeName })
                        .mapValues { $0[0] }
                
                initializedCache = true
            }
            
            return baseClassTypesByName[name]
        }
    }
    
    private class TypealiasExpander {
        // Used to discover cycles in alias expansion
        private var aliasesInStack: [String] = []
        
        private var source: AliasesSource
        
        init(aliasesSource: AliasesSource) {
            self.source = aliasesSource
        }
        
        func expand(in type: SwiftType) -> SwiftType {
            switch type {
            case let .block(returnType, parameters):
                return .block(returnType: expand(in: returnType), parameters: parameters.map(expand))
            case .nominal(.typeName(let name)):
                if let type = source.unaliased(typeName: name) {
                    return pushingAlias(name) {
                        return expand(in: type)
                    }
                }
                
                return type
            case .nominal(let nominal):
                return .nominal(expand(inNominal: nominal))
            case .optional(let type):
                return .optional(expand(in: type))
            case .implicitUnwrappedOptional(let type):
                return .implicitUnwrappedOptional(expand(in: type))
            case .nested(let nested):
                return .nested(.fromCollection(nested.map(expand(inNominal:))))
            case .metatype(let type):
                return .metatype(for: expand(in: type))
            case .tuple(.empty):
                return type
            case .tuple(.types(let values)):
                return .tuple(.types(.fromCollection(values.map(expand))))
            case .protocolComposition(let composition):
                return .protocolComposition(.fromCollection(composition.map(expand(inNominal:))))
            }
        }
        
        private func expand(inString string: String) -> String {
            guard let aliased = source.unaliased(typeName: string) else {
                return string
            }
            
            return pushingAlias(string) {
                return typeNameIn(swiftType: aliased).map(expand(inString:)) ?? string
            }
        }
        
        private func expand(inNominal nominal: NominalSwiftType) -> NominalSwiftType {
            switch nominal {
            case .typeName(let name):
                return .typeName(expand(inString: name))
            case let .generic(name, parameters):
                return .generic(expand(inString: name), parameters: .fromCollection(parameters.map(expand)))
            }
        }
        
        private func pushingAlias<T>(_ name: String, do work: () -> T) -> T {
            if aliasesInStack.contains(name) {
                fatalError("Cycle found while expanding typealises: \(aliasesInStack.joined(separator: " -> ")) -> \(name)")
            }
            
            aliasesInStack.append(name)
            defer {
                aliasesInStack.removeLast()
            }
            
            return work()
        }
    }
}

protocol AliasesSource {
    func unaliased(typeName: String) -> SwiftType?
}

extension DefaultTypeSystem: TypealiasSink {
    public func addTypealias(aliasName: String, originalType: SwiftType) {
        aliases[aliasName] = originalType
    }
}

extension DefaultTypeSystem {
    /// Initializes the default known types
    func registerInitialKnownTypes() {
        let nsObjectProtocol =
            KnownTypeBuilder(typeName: "NSObjectProtocol", kind: .protocol)
                .method(withSignature:
                    FunctionSignature(name: "responds",
                                      parameters: [ParameterSignature(label: "to", name: "selector", type: .selector)],
                                      returnType: .bool,
                                      isStatic: false)
                )
                .method(withSignature:
                    FunctionSignature(name: "isEqual",
                                      parameters: [ParameterSignature(label: "_", name: "object", type: .anyObject)],
                                      returnType: .bool,
                                      isStatic: false)
                )
                .build()
        
        let nsObject =
            KnownTypeBuilder(typeName: "NSObject")
                .constructor()
                .protocolConformance(protocolName: "NSObjectProtocol")
                .build()
        
        let nsArray =
            KnownTypeBuilder(typeName: "NSArray", supertype: nsObject)
                .build()
        
        let nsMutableArray =
            KnownTypeBuilder(typeName: "NSMutableArray", supertype: nsArray)
                .method(withSignature:
                    FunctionSignature(
                        name: "addObject",
                        parameters: [
                            ParameterSignature(label: "_",
                                               name: "object",
                                               type: .anyObject)
                        ],
                        returnType: .void,
                        isStatic: false
                    )
                )
                .build()
        
        let nsDictionary =
            KnownTypeBuilder(typeName: "NSDictionary", supertype: nsObject)
                .build()
        
        let nsMutableDictionary =
            KnownTypeBuilder(typeName: "NSMutableDictionary", supertype: nsDictionary)
                .method(withSignature:
                    FunctionSignature(
                        name: "setObject",
                        parameters: [
                            ParameterSignature(label: "_", name: "anObject", type: .anyObject),
                            ParameterSignature(label: "forKey", name: "aKey", type: .anyObject)
                        ],
                        returnType: .void,
                        isStatic: false
                    )
                )
                .build()
        
        let nsSet =
            KnownTypeBuilder(typeName: "NSSet", supertype: nsObject)
                .build()
        
        let nsMutableSet =
            KnownTypeBuilder(typeName: "NSMutableSet", supertype: nsSet)
                .method(withSignature:
                    FunctionSignature(
                        name: "add",
                        parameters: [
                            ParameterSignature(label: "_", name: "object", type: .anyObject)
                        ]
                    )
                )
                .build()
        
        addType(nsObjectProtocol)
        addType(nsObject)
        addType(nsArray)
        addType(nsMutableArray)
        addType(nsDictionary)
        addType(nsMutableDictionary)
        addType(nsSet)
        addType(nsMutableSet)
        
        // Foundation types
        registerFoundation(nsObject: nsObject)
        registerFormatters(nsObject: nsObject)
    }
    
    private func registerFoundation(nsObject: KnownType) {
        let nsDate = KnownTypeBuilder(typeName: "NSDate", supertype: nsObject).build()
        let nsData = KnownTypeBuilder(typeName: "NSData", supertype: nsObject).build()
        let nsMutableData = KnownTypeBuilder(typeName: "NSMutableData", supertype: nsData).build()
        let nsMutableString =
            KnownTypeBuilder(typeName: "NSMutableString", supertype: KnownTypeReference.typeName("NSString"))
                .constructor()
                .build()
        
        addType(nsDate)
        addType(nsData)
        addType(nsMutableData)
        addType(nsMutableString)
    }
    
    private func registerFormatters(nsObject: KnownType) {
        let nsFormatter = KnownTypeBuilder(typeName: "NSFormatter", supertype: nsObject).build()
        let nsDateFormatter = KnownTypeBuilder(typeName: "NSDateFormatter", supertype: nsFormatter).build()
        
        addType(nsFormatter)
        addType(nsDateFormatter)
    }
}

/// An extension over the default type system that enables using an intention
/// collection to search for types
public class IntentionCollectionTypeSystem: DefaultTypeSystem {
    private var cache: Cache?
    public var intentions: IntentionCollection
    
    public init(intentions: IntentionCollection) {
        self.intentions = intentions
        super.init()
    }
    
    func makeCache() {
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
                CompoundKnownType(typeName: $0[0].typeName, typeSystem: self, types: $0)
            })
        
        cache = Cache(typeAliases: aliases, types: compoundTypes)
    }
    
    func tearDownCache() {
        cache = nil
    }
    
    public override func isClassInstanceType(_ typeName: String) -> Bool {
        guard let aliased = typeNameIn(swiftType: resolveAlias(in: typeName)) else {
            return false
        }
        
        if let cache = cache {
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
    
    override func unaliased(typeName: String) -> SwiftType? {
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
        
        return super.unaliased(typeName: typeName)
    }
    
    public override func resolveAlias(in typeName: String) -> SwiftType {
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
        
        return super.resolveAlias(in: typeName)
    }
    
    public override func typeExists(_ name: String) -> Bool {
        if super.typeExists(name) {
            return true
        }
        
        if let cache = cache {
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
    
    public override func knownTypeWithName(_ name: String) -> KnownType? {
        if let type = super.knownTypeWithName(name) {
            return type
        }
        
        let aliased = resolveAlias(in: name)
        guard let name = typeNameIn(swiftType: aliased) else {
            return nil
        }
        
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
        
        return CompoundKnownType(typeName: name, typeSystem: self, types: Array(types))
    }
    
    // MARK: Shortcuts for member searching
    
    public override func property(named name: String, static isStatic: Bool,
                                  includeOptional: Bool, in type: SwiftType) -> KnownProperty? {
        guard let typeName = typeNameIn(swiftType: type) else {
            return super.property(named: name, static: isStatic, includeOptional: includeOptional, in: type)
        }
        
        if let cache = cache {
            if let match = cache.types[typeName] {
                if let prop = match.knownProperties.first(where: { $0.name == name && $0.isStatic == isStatic }) {
                    return prop
                }
            }
            
            return super.property(named: name, static: isStatic, includeOptional: includeOptional, in: type)
        }
        
        for file in intentions.fileIntentions() {
            for type in file.typeIntentions where type.typeName == typeName {
                if let prop = type.properties.first(where: { $0.name == name && $0.isStatic == isStatic }) {
                    return prop
                }
            }
        }
        
        return super.property(named: name, static: isStatic, includeOptional: includeOptional, in: type)
    }
    
    public override func field(named name: String, static isStatic: Bool, in type: SwiftType) -> KnownProperty? {
        guard let typeName = typeNameIn(swiftType: type) else {
            return super.field(named: name, static: isStatic, in: type)
        }
        
        if let cache = cache {
            if let match = cache.types[typeName] {
                if let field = match.knownFields.first(where: { $0.name == name && $0.isStatic == isStatic }) {
                    return field
                }
            }
            
            return super.field(named: name, static: isStatic, in: type)
        }
        
        for file in intentions.fileIntentions() {
            for type in file.typeIntentions where type.typeName == typeName {
                if let prop = type.properties.first(where: { $0.name == name && $0.isStatic == isStatic }) {
                    return prop
                }
            }
        }
        
        return super.field(named: name, static: isStatic, in: type)
    }
    
    public override func method(withObjcSelector selector: SelectorSignature, static isStatic: Bool,
                                includeOptional: Bool, in type: SwiftType) -> KnownMethod? {
        guard let typeName = typeNameIn(swiftType: type) else {
            return super.method(withObjcSelector: selector, static: isStatic,
                                includeOptional: includeOptional, in: type)
        }
        
        if let cache = cache {
            if let match = cache.types[typeName] {
                if let method = method(matchingSelector: selector, in: match.knownMethods),
                    method.isStatic == isStatic {
                    return method
                }
            }
            
            return super.method(withObjcSelector: selector, static: isStatic,
                                includeOptional: includeOptional, in: type)
        }
        
        for file in intentions.fileIntentions() {
            for type in file.typeIntentions where type.typeName == typeName {
                if let method = type.method(matchingSelector: selector), method.isStatic == isStatic {
                    return method
                }
            }
        }
        
        return super.method(withObjcSelector: selector, static: isStatic,
                            includeOptional: includeOptional, in: type)
    }
    
    /// Finds a method on a given array of methods that matches a given
    /// Objective-C selector signature.
    ///
    /// Ignores method variable names and types of return/parameters.
    private func method(matchingSelector selector: SelectorSignature,
                        in methods: [KnownMethod]) -> KnownMethod? {
        return methods.first {
            return $0.signature.asSelector == selector
        }
    }
    
    private struct Cache {
        var typeAliases: [String: SwiftType]
        var types: [String: CompoundKnownType]
    }
}

/// A compound known type whose members are computed at creation time as aggregated
/// members of all types.
private class CompoundKnownType: KnownType {
    private var types: [KnownType]
    
    var typeName: String
    
    var kind: KnownTypeKind
    var knownTraits: [String: TraitType]
    var origin: String
    var supertype: KnownTypeReference?
    var knownConstructors: [KnownConstructor]
    var knownMethods: [KnownMethod]
    var knownProperties: [KnownProperty]
    var knownFields: [KnownProperty]
    var knownProtocolConformances: [KnownProtocolConformance]
    
    init(typeName: String, typeSystem: TypeSystem, types: [KnownType]) {
        self.typeName = typeName
        self.types = types
        
        knownTraits = types.reduce([:], { $0.merging($1.knownTraits, uniquingKeysWith: { $1 }) })
        knownConstructors = []
        knownMethods = []
        knownProperties = []
        knownFields = []
        knownProtocolConformances = []
        for type in types {
            knownConstructors.append(contentsOf: type.knownConstructors)
            knownMethods.append(contentsOf: type.knownMethods)
            knownProperties.append(contentsOf: type.knownProperties)
            knownFields.append(contentsOf: type.knownFields)
            knownProtocolConformances.append(contentsOf: type.knownProtocolConformances)
        }
        
        kind = types[0].kind
        origin = types[0].origin
        
        for type in types {
            // Search supertypes known here
            switch type.supertype {
            case .typeName(let supertypeName)?:
                supertype =
                    typeSystem.knownTypeWithName(supertypeName).map { .knownType($0) }
                        ?? .typeName(supertypeName)
            case .knownType?:
                supertype = type.supertype
            default:
                break
            }
        }
    }
}

private func typeNameIn(swiftType: SwiftType) -> String? {
    let swiftType = swiftType.deepUnwrapped
    
    switch swiftType {
    case .nominal(.typeName(let typeName)), .nominal(.generic(let typeName, _)):
        return typeName
        
    // Meta-types recurse on themselves
    case .metatype(for: let inner):
        let type = inner.deepUnwrapped
        
        switch type {
        case .nominal(.typeName(let name)):
            return name
        default:
            return typeNameIn(swiftType: type)
        }
        
    // Other Swift types are not supported, at the moment.
    default:
        return nil
    }
}
