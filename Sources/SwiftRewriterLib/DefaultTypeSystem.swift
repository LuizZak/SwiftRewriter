import SwiftAST
import TypeDefinitions
import Utils

// TODO: Implement local caching on compound known types within the type system
// to reduce burden of re-creating known types over and over during type resolving.

/// Standard type system implementation
public class DefaultTypeSystem: TypeSystem {
    /// A singleton instance to a default type system.
    public static let defaultTypeSystem: TypeSystem = DefaultTypeSystem()
    
    private var compoundKnownTypesCache: CompoundKnownTypesCache?
    private var baseClassTypesByName: [String: ClassType] = [:]
    private var initializedCache = false
    
    /// Type-aliases
    var innerAliasesProvider = CollectionTypealiasProvider(aliases: [:])
    var typealiasProviders: CompoundTypealiasProvider
    
    // Known types
    var innerKnownTypes = CollectionKnownTypeProvider(knownTypes: [])
    var knownTypeProviders: CompoundKnownTypeProvider
    
    private var typesByName: [String: KnownType] = [:]
    
    public init() {
        typealiasProviders = CompoundTypealiasProvider(providers: [innerAliasesProvider])
        knownTypeProviders = CompoundKnownTypeProvider(providers: [innerKnownTypes])
        
        registerInitialKnownTypes()
    }
    
    public func makeCache() {
        compoundKnownTypesCache = CompoundKnownTypesCache()
    }
    
    public func tearDownCache() {
        compoundKnownTypesCache = nil
    }
    
    public func addTypealiasProvider(_ provider: TypealiasProvider) {
        typealiasProviders.providers.append(provider)
    }
    
    public func addKnownTypeProvider(_ provider: KnownTypeProvider) {
        knownTypeProviders.providers.append(provider)
    }
    
    /// Resets the storage of all known types and type aliases to the default
    /// values.
    public func reset() {
        innerKnownTypes.removeAllTypes()
        innerAliasesProvider.removeAllTypealises()
        
        knownTypeProviders.providers.removeAll()
        typealiasProviders.providers.removeAll()
        
        typesByName.removeAll()
        registerInitialKnownTypes()
    }
    
    public func addType(_ type: KnownType) {
        innerKnownTypes.addType(type)
        
        typesByName[type.typeName] = type
    }
    
    public func typesMatch(_ type1: SwiftType, _ type2: SwiftType, ignoreNullability: Bool) -> Bool {
        // Structurally the same
        if !ignoreNullability && type1 == type2 {
            return true
        } else if ignoreNullability && type1.deepUnwrapped == type2.deepUnwrapped {
            return true
        }
        
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
        
        if typesByName.keys.contains(name) {
            return true
        }
        
        if knownTypeProviders.knownType(withName: name) != nil {
            return true
        }
        
        return false
    }
    
    public func knownTypes(ofKind kind: KnownTypeKind) -> [KnownType] {
        return knownTypeProviders.knownTypes(ofKind: kind)
    }
    
    public func knownTypeWithName(_ name: String) -> KnownType? {
        guard let name = typeNameIn(swiftType: resolveAlias(in: name)) else {
            return nil
        }
        
        return knownTypeProviders.knownType(withName: name)
    }
    
    public func composeTypeWithKnownTypes(_ typeNames: [String]) -> KnownType? {
        if typeNames.isEmpty {
            return nil
        }
        if typeNames.count == 1 {
            return knownTypeWithName(typeNames[0])
        }
        
        if let type = compoundKnownTypesCache?.fetch(names: typeNames) {
            return type
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
        let compoundType =
            CompoundKnownType(typeName: typeNames.joined(separator: " & "),
                              types: types,
                              typeSystem: self)
        
        compoundKnownTypesCache?.record(type: compoundType, names: typeNames)
        
        return compoundType
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
            
            switch c.supertype {
            case .knownType(let type)?:
                current = type
            case .typeName(let name)?:
                current = knownTypeWithName(name)
            default:
                current = nil
            }
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
        return category(forType: .typeName(type))
    }
    
    public func category(forType type: SwiftType) -> TypeCategory {
        if type == .void {
            return .void
        }
        
        let aliasedType = resolveAlias(in: type)
        
        if isInteger(aliasedType) {
            return .integer
        }
        
        switch aliasedType {
        case .nominal(.typeName(let typeName)):
            switch typeName {
            case "Bool", "ObjCBool", "CBool":
                return .boolean
            case "CGFloat", "Float", "Double", "CFloat", "CDouble", "Float80":
                return .float
            default:
                break
            }
        default:
            break
        }
        
        if let type = self.findType(for: aliasedType) {
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
        func internalIsInteger(_ type: SwiftType) -> Bool {
            switch type {
            case .int, .uint:
                return true
            case .nominal(.typeName(let name)):
                switch name {
                // Swift integer types
                case "Int", "Int64", "Int32", "Int16", "Int8", "UInt", "UInt64",
                     "UInt32", "UInt16", "UInt8":
                    return true
                // C integer types
                case "CChar", "CSignedChar", "CChar16", "CChar32", "CUnsignedChar",
                     "CInt", "CUnsignedInt", "CShort", "CUnsignedShort", "CLong",
                     "CUnsignedLong", "CLongLong", "CUnsignedLongLong", "CWideChar":
                    return true
                default:
                    return false
                }
            default:
                return false
            }
        }
        
        return internalIsInteger(type) || internalIsInteger(resolveAlias(in: type))
    }
    
    func unalias(typeName: String) -> SwiftType? {
        return typealiasProviders.unalias(typeName)
    }
    
    public func resolveAlias(in typeName: String) -> SwiftType {
        guard let type = typealiasProviders.unalias(typeName) else {
            return .typeName(typeName)
        }
        
        return resolveAlias(in: type)
    }
    
    public func resolveAlias(in type: SwiftType) -> SwiftType {
        let resolver = TypealiasExpander(aliasesSource: typealiasProviders)
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
    
    public func constructor(withArgumentLabels labels: [String?], in type: KnownType) -> KnownConstructor? {
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
    
    public func property(named name: String,
                         static isStatic: Bool,
                         includeOptional: Bool,
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
    
    public func constructor(withArgumentLabels labels: [String?], in type: SwiftType) -> KnownConstructor? {
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
    
    public func method(withObjcSelector selector: SelectorSignature,
                       static isStatic: Bool,
                       includeOptional: Bool,
                       in type: SwiftType) -> KnownMethod? {
        
        guard let knownType = self.findType(for: type) else {
            return nil
        }
        return method(withObjcSelector: selector, static: isStatic, includeOptional: includeOptional,
                      in: knownType)
    }
    
    public func property(named name: String,
                         static isStatic: Bool,
                         includeOptional: Bool,
                         in type: SwiftType) -> KnownProperty? {
        
        guard let knownType = self.findType(for: type) else {
            return nil
        }
        return property(named: name,
                        static: isStatic,
                        includeOptional: includeOptional,
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
        
        private var source: TypealiasProvider
        
        init(aliasesSource: TypealiasProvider) {
            self.source = aliasesSource
        }
        
        func expand(in type: SwiftType) -> SwiftType {
            switch type {
            case let .block(returnType, parameters):
                return .block(returnType: expand(in: returnType), parameters: parameters.map(expand))
                
            case .nominal(.typeName(let name)):
                if let type = source.unalias(name) {
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
                return .protocolComposition(.fromCollection(composition.map(expand(inComposition:))))
            }
        }
        
        private func expand(inString string: String) -> String {
            guard let aliased = source.unalias(string) else {
                return string
            }
            
            return pushingAlias(string) {
                return typeNameIn(swiftType: aliased).map(expand(inString:)) ?? string
            }
        }
        
        private func expand(inComposition composition: ProtocolCompositionComponent) -> ProtocolCompositionComponent {
            switch composition {
            case .nested(let nested):
                return .nested(.fromCollection(nested.map(expand(inNominal:))))
            case .nominal(let nominal):
                return .nominal(expand(inNominal: nominal))
            }
        }
        
        private func expand(inNominal nominal: NominalSwiftType) -> NominalSwiftType {
            switch nominal {
            case .typeName(let name):
                return .typeName(expand(inString: name))
            case let .generic(name, parameters):
                if case .tail = parameters { } // Here to avoid a weird crash due
                                               // to a compiler bug when accessing
                                               // `parameters` without destructuring
                                               // it somehow first
                return .generic(expand(inString: name),
                                parameters: .fromCollection(parameters.map(expand)))
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
    
    private final class CompoundKnownTypesCache {
        private var types: [[String]: KnownType]
        
        init() {
            types = [:]
        }
        
        func fetch(names: [String]) -> KnownType? {
            return types[names]
        }
        
        func record(type: KnownType, names: [String]) {
            types[names] = type
        }
    }
}

extension DefaultTypeSystem {
    public func addTypealias(aliasName: String, originalType: SwiftType) {
        self.innerAliasesProvider.addTypealias(aliasName, originalType)
    }
}

extension DefaultTypeSystem {
    /// Initializes the default known types
    func registerInitialKnownTypes() {
        let nsObjectProtocol =
            KnownTypeBuilder(typeName: "NSObjectProtocol", kind: .protocol)
                .method(withSignature:
                    FunctionSignature(
                        name: "responds",
                        parameters: [ParameterSignature(label: "to",
                                                        name: "selector",
                                                        type: .selector)],
                        returnType: .bool,
                        isStatic: false)
                )
                .method(withSignature:
                    FunctionSignature(
                        name: "isEqual",
                        parameters: [ParameterSignature(label: "_",
                                                        name: "object",
                                                        type: .anyObject)],
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
                    ),
                        semantics: Semantics.collectionMutator
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
                    ),
                        semantics: Semantics.collectionMutator
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
                    ),
                        semantics: Semantics.collectionMutator
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

func typeNameIn(swiftType: SwiftType) -> String? {
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
