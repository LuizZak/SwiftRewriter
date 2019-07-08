import Dispatch
import TypeDefinitions
import SwiftAST
import KnownType
import Intentions
import Utils

/// Standard type system implementation
public class TypeSystem {
    /// A singleton instance to a default type system.
    public static let defaultTypeSystem: TypeSystem = TypeSystem()
    
    private var compoundKnownTypesCache: CompoundKnownTypesCache?
    private var protocolConformanceCache: ProtocolConformanceCache?
    private var baseClassTypesByNameCache = ConcurrentValue<[String: ClassType]>(value: [:])
    private var overloadResolverState = OverloadResolverState()
    var memberSearchCache = MemberSearchCache()
    var aliasCache = ConcurrentValue<[SwiftType: SwiftType]>(value: [:])
    var allConformancesCache = ConcurrentValue<[String: [KnownProtocolConformance]]>(value: [:])
    var typeExistsCache = ConcurrentValue<[String: Bool]>(value: [:])
    var knownTypeForSwiftType = ConcurrentValue<[SwiftType: KnownType?]>(value: [:])
    
    /// Type-aliases
    var innerAliasesProvider = CollectionTypealiasProvider(aliases: [:])
    var typealiasProviders: CompoundTypealiasProvider
    
    // Known types
    var innerKnownTypes = CollectionKnownTypeProvider(knownTypes: [])
    var knownTypeProviders: CompoundKnownTypeProvider
    
    public init() {
        typealiasProviders = CompoundTypealiasProvider(providers: [])
        knownTypeProviders = CompoundKnownTypeProvider(providers: [])
        
        registerInitialTypeProviders()
        registerInitialKnownTypes()
    }
    
    public func makeCache() {
        knownTypeProviders.makeCache()
        typealiasProviders.makeCache()
        compoundKnownTypesCache = CompoundKnownTypesCache()
        protocolConformanceCache = ProtocolConformanceCache()
        overloadResolverState.makeCache()
        memberSearchCache.makeCache()
        aliasCache.setAsCaching(value: [:])
        allConformancesCache.setAsCaching(value: [:])
        typeExistsCache.setAsCaching(value: [:])
        knownTypeForSwiftType.setAsCaching(value: [:])
    }
    
    public func tearDownCache() {
        knownTypeProviders.tearDownCache()
        typealiasProviders.tearDownCache()
        compoundKnownTypesCache = nil
        protocolConformanceCache = nil
        overloadResolverState.tearDownCache()
        memberSearchCache.tearDownCache()
        aliasCache.tearDownCaching(resetToValue: [:])
        allConformancesCache.tearDownCaching(resetToValue: [:])
        typeExistsCache.tearDownCaching(resetToValue: [:])
        knownTypeForSwiftType.tearDownCaching(resetToValue: [:])
    }
    
    /// Gets the overload resolver instance for this type system
    public func overloadResolver() -> OverloadResolver {
        return OverloadResolver(typeSystem: self,
                                state: overloadResolverState)
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
        
        registerInitialTypeProviders()
        registerInitialKnownTypes()
    }
    
    public func addType(_ type: KnownType) {
        innerKnownTypes.addType(type)
    }
    
    /// Returns true if two given Swift types match semmantically after expanding
    /// all typealises.
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
            return expanded1.deepUnwrapped == expanded2.deepUnwrapped
        }
        
        return expanded1 == expanded2
    }
    
    /// Returns `true` if a type is known to exists with a given name.
    public func typeExists(_ name: String) -> Bool {
        if typeExistsCache.usingCache, let result = typeExistsCache.readingValue({ $0[name] }) {
            return result
        }
        
        var result: Bool
        
        if _knownTypeWithNameUnaliased(name) != nil {
            result = true
        } else if let name = typeNameIn(swiftType: resolveAlias(in: name)) {
            result = _knownTypeWithNameUnaliased(name) != nil
        } else {
            result = false
        }
        
        if typeExistsCache.usingCache {
            typeExistsCache.modifyingValue { cache in
                cache[name] = result
            }
        }
        
        return result
    }
    
    /// Returns all known types that match a specified type
    public func knownTypes(ofKind kind: KnownTypeKind) -> [KnownType] {
        return knownTypeProviders.knownTypes(ofKind: kind)
    }
    
    /// Gets a known type with a given name from this type system.
    public func knownTypeWithName(_ name: String) -> KnownType? {
        if let type = _knownTypeWithNameUnaliased(name) {
            return type
        }
        
        guard let name = typeNameIn(swiftType: resolveAlias(in: name)) else {
            return nil
        }
        
        return _knownTypeWithNameUnaliased(name)
    }
    
    private func _knownTypeWithNameUnaliased(_ name: String) -> KnownType? {
        return knownTypeProviders.knownType(withName: name)
    }
    
    /// Given a non-canonical type name, returns the matching canonical name.
    ///
    /// The given typename is unaliased before canonical form replacing is
    /// performed.
    ///
    /// In case the type name is already canonical, or no canonical form is found
    /// for a given type name, `nil` is returned, instead.
    public func canonicalName(forTypeName typeName: String) -> String? {
        let type = resolveAlias(in: typeName)
        guard let name = typeNameIn(swiftType: type) else {
            return nil
        }
        
        return knownTypeProviders.canonicalName(for: name)
    }
    
    /// Returns a composition of a set of types as a single known type.
    /// Returns nil, if any of the types is unknown, or the list is empty.
    public func composeTypeWithKnownTypes(_ typeNames: [String]) -> KnownType? {
        if typeNames.isEmpty {
            return nil
        }
        if typeNames.count == 1 {
            return knownTypeWithName(typeNames.first!)
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
    
    /// Returns `true` if a given type is considered a class instance type.
    /// Class instance types are considered to be any type that is either a Swift
    /// or Objective-C class/protocol, or a subclass implementer of one of them.
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
    
    /// Returns `true` if a given type is considered a class instance type.
    /// Class instance types are considered to be any type that is either a Swift
    /// or Objective-C class/protocol, or a subclass implementer of one of them.
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
    
    /// Returns `true` if a given type is a known scalar type.
    public func isScalarType(_ type: SwiftType) -> Bool {
        if isNumeric(type) {
            return true
        }
        
        guard let knownType = findType(for: type) else {
            return false
        }
        
        return knownType.kind == .struct
    }
    
    /// Returns `true` if a given type conforms to a protocol with a given name,
    /// either by directly or indirectly conforming to the protocol via
    /// superclasses and other protocols.
    public func isType(_ type: SwiftType, conformingTo protocolName: String) -> Bool {
        guard let typeName = typeNameIn(swiftType: type) else {
            return false
        }
        
        return isType(typeName, conformingTo: protocolName)
    }
    
    /// Returns `true` if a given type is a subtype of another type.
    public func isType(_ type: SwiftType, subtypeOf supertypeName: String) -> Bool {
        guard let typeName = typeNameIn(swiftType: type) else {
            return false
        }
        
        return isType(typeName, subtypeOf: supertypeName)
    }
    
    /// Returns `true` if a type with a given name conforms to a protocol with
    /// a given name, either by directly or indirectly conforming to the protocol
    /// via superclasses and other protocols.
    public func isType(_ typeName: String, conformingTo protocolName: String) -> Bool {
        if typeName == protocolName {
            return true
        }
        
        if let cache = protocolConformanceCache {
            if let result = cache.typeName(typeName, conformsTo: protocolName) {
                return result
            }
        }
        
        guard let unaliasedTypeName = typeNameIn(swiftType: resolveAlias(in: typeName)) else {
            return false
        }
        guard let unaliasedProtocolName = typeNameIn(swiftType: resolveAlias(in: protocolName)) else {
            return false
        }
        if unaliasedTypeName == unaliasedProtocolName {
            return true
        }
        
        let conforms = _unaliasedIsType(unaliasedTypeName,
                                        conformingTo: unaliasedProtocolName)
        
        if let cache = protocolConformanceCache {
            cache.record(typeName: typeName, conformsTo: protocolName, conforms)
        }
        
        return conforms
    }
    
    private func _unaliasedIsType(_ unaliasedTypeName: String,
                                  conformingTo unaliasedProtocolName: String) -> Bool {
        
        guard let type = _knownTypeWithNameUnaliased(unaliasedTypeName) else {
            return false
        }
        
        return conformance(toProtocolName: unaliasedProtocolName, in: type) != nil
    }
    
    /// Returns `true` if a type represented by a given type name is a subtype of
    /// another type.
    public func isType(_ typeName: String, subtypeOf supertypeName: String) -> Bool {
        if typeName == supertypeName {
            return true
        }
        
        guard let unaliasedTypeName = typeNameIn(swiftType: resolveAlias(in: typeName)) else {
            return false
        }
        guard let unaliasedSupertypeName = typeNameIn(swiftType: resolveAlias(in: supertypeName)) else {
            return false
        }
        
        if unaliasedTypeName == unaliasedSupertypeName {
            return true
        }
        
        return _unaliasedIsType(unaliasedTypeName, subtypeOf: unaliasedSupertypeName)
    }
    
    private func _unaliasedIsType(_ unaliasedTypeName: String, subtypeOf unaliasedSupertypeName: String) -> Bool {
        guard let type = _knownTypeWithNameUnaliased(unaliasedTypeName) else {
            return false
        }
        
        // Direct supertype name fetching
        switch type.supertype {
        case .typeName(let tn)? where tn == unaliasedSupertypeName:
            return true
            
        case .knownType(let kt)?:
            return isType(kt.typeName, subtypeOf: unaliasedSupertypeName)
            
        default:
            break
        }
        
        guard let supertype = _knownTypeWithNameUnaliased(unaliasedSupertypeName) else {
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
        var currentClassType = classTypeDefinition(name: unaliasedTypeName)
        while let c = currentClassType {
            if c.typeName == unaliasedSupertypeName {
                return true
            }
            
            currentClassType = classTypeDefinition(name: c.superclass)
        }
        
        return false
    }
    
    /// Returns `true` if a given type can be assigned to a value of another type.
    public func isType(_ type: SwiftType, assignableTo baseType: SwiftType) -> Bool {
        if type == baseType {
            return true
        }
        
        let unaliasedType = resolveAlias(in: type)
        let unaliasedBaseType = resolveAlias(in: baseType)
        
        if unaliasedType == unaliasedBaseType {
            return true
        }
        
        // For nominal types, check for subtyping conformance
        if case .nominal(let nominalType) = unaliasedType,
            case .nominal(let nominalBaseType) = unaliasedBaseType {

            let typeName = typeNameIn(nominalType: nominalType)
            let baseTypeName = typeNameIn(nominalType: nominalBaseType)

            return isType(typeName, subtypeOf: baseTypeName) ||
                isType(typeName, conformingTo: baseTypeName)
        }
        
        // TODO: Convert into this switch later; currently it crashes during
        // runtime because Swift is failing to detect the switch as non-exhaustive.
        // Care should be taken when switching over SwiftTypes elsewhere, too.
        #if false
        
        switch (unaliasedType, unaliasedBaseType) {
        case (.nominal(let nominalType), .nominal(let nominalBaseType)):
            let typeName = typeNameIn(nominalType: nominalType)
            let baseTypeName = typeNameIn(nominalType: nominalBaseType)
            
            return isType(typeName, subtypeOf: baseTypeName) ||
                isType(typeName, conformingTo: baseTypeName)
        }
        
        #endif
        
        return false
    }
    
    /// Returns the category for a given type name.
    public func category(forType type: String) -> TypeCategory {
        return category(forType: .typeName(type))
    }
    
    /// Returns the category for a given type.
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
    
    /// Returns an expression representing the default value for a given Swift type.
    /// Returns nil, in case no default values are known
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
    
    /// Between two scalar numeric types, returns the type that the type system
    /// should favor when cast-converting.
    ///
    /// In case the types are equivalent, or no casting is prefered between the
    /// two, nil is returned, instead.
    public func implicitCoercedNumericType(for type1: SwiftType,
                                           _ type2: SwiftType) -> SwiftType? {
        
        if !isNumeric(type1) || !isNumeric(type2) {
            return nil
        }
        
        let isInt1 = isInteger(type1)
        let isInt2 = isInteger(type2)
        
        let isFloat1 = isFloat(type1)
        let isFloat2 = isFloat(type2)
        
        if (isInt1 && isInt2) || (isFloat1 && isFloat2) {
            let bw1 = bitwidth(intType: type1)
            let bw2 = bitwidth(intType: type2)
            
            if bw1 > bw2 {
                return type1
            } else if bw2 > bw1 {
                return type2
            } else {
                return nil
            }
        }
        
        if isInt1 && isFloat2 {
            return type2
        }
        if isFloat1 && isInt2 {
            return type1
        }
        
        return nil
    }
    
    /// Returns `true` if `type` represents a numerical type (`Int`, `Float`,
    /// `CGFloat`, etc.).
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
    
    private func bitwidth(intType: SwiftType) -> Int {
        func internalBitwidth(_ type: SwiftType) -> Int? {
            // TODO: Validate these results
            switch type {
            case .int, .uint:
                return 64
            case .nominal(.typeName(let name)):
                switch name {
                // Swift integer types
                case "Int", "UInt":
                    return 64
                case "Int64", "UInt64":
                    return 64
                case "Int32", "UInt32":
                    return 32
                case "Int16", "UInt16":
                    return 16
                case "Int8", "UInt8":
                    return 8
                // C integer types
                case "CChar", "CSignedChar", "CUnsignedChar":
                    return 8
                case "CChar16", "CShort", "CUnsignedShort":
                    return 16
                case "CChar32", "CInt", "CUnsignedInt", "CWideChar":
                    return 32
                case "CLong", "CUnsignedLong", "CLongLong",
                     "CUnsignedLongLong":
                    return 64
                // Float values
                case "CGFloat":
                    return 64
                case "Float", "CFloat":
                    return 32
                case "Float80":
                    return 80
                case "Double", "CDouble":
                    return 64
                default:
                    return nil
                }
            default:
                return nil
            }
        }
        
        return internalBitwidth(intType) ?? internalBitwidth(resolveAlias(in: intType)) ?? 8
    }
    
    /// Returns `true` if `type` is an integer (signed or unsigned) type.
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
    
    /// Returns `true` if `type` is a floating-point type.
    public func isFloat(_ type: SwiftType) -> Bool {
        let aliasedType = resolveAlias(in: type)
        
        switch aliasedType {
        case .nominal(.typeName(let typeName)):
            switch typeName {
            case "CGFloat", "Float", "Double", "CFloat", "CDouble", "Float80":
                return true
            default:
                return false
            }
            
        default:
            return false
        }
    }
    
    /// Resolves type aliases in a given type name, returning a resulting type
    /// with all aliases expanded.
    /// Returns a plain `.typeName` with the passed type name within, in case no
    /// typealiases where found.
    public func resolveAlias(in typeName: String) -> SwiftType {
        guard let type = typealiasProviders.unalias(typeName) else {
            return .typeName(typeName)
        }
        
        return resolveAlias(in: type)
    }
    
    /// Resolves type aliases in a given type, returning a resulting type with
    /// all aliases expanded.
    /// Returns a plain `.typeName` with the passed type name within, in case no
    /// typealiases where found.
    public func resolveAlias(in type: SwiftType) -> SwiftType {
        if aliasCache.usingCache {
            if let result = aliasCache.readingValue({ $0[type] }) {
                return result
            }
        }
        
        let resolver = TypealiasExpander(aliasesSource: typealiasProviders)
        let result = resolver.expand(in: type)
        
        if aliasCache.usingCache {
            aliasCache.modifyingValue {
                $0[type] = result
            }
        }
        
        return result
    }
    
    /// Gets the supertype of a given type on this type system.
    ///
    /// - Parameter type: A known type with available supertype information.
    /// - Returns: The supertype of the given type.
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
    
    // MARK: Member searching methods - KnownType
    
    /// Gets a constructor matching a given argument label set on a given known
    /// type.
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
    
    /// Gets a protocol conformance to a given protocol name on a given known type.
    public func conformance(toProtocolName name: String, in type: KnownType) -> KnownProtocolConformance? {
        return _conformance(toProtocolName: name, in: type, visitedTypes: [])
    }
    
    private func _conformance(toProtocolName name: String,
                              in type: KnownType,
                              visitedTypes: Set<String>) -> KnownProtocolConformance? {
        
        var visitedTypes = visitedTypes
        
        visitedTypes.insert(type.typeName)
        
        if let conformance =
            type.knownProtocolConformances
                .first(where: { $0.protocolName == name }) {
            return conformance
        }
        
        // Search on supertypes
        if let supertype = supertype(of: type), !visitedTypes.contains(supertype.typeName) {
            if let supertypeConformance = _conformance(toProtocolName: name,
                                                       in: supertype,
                                                       visitedTypes: visitedTypes) {
                return supertypeConformance
            }
        }
        
        // Search on protocols
        for prot in type.knownProtocolConformances {
            if visitedTypes.contains(prot.protocolName) {
                continue
            }
            
            guard let type = knownTypeWithName(prot.protocolName) else {
                continue
            }
            
            if let conformance = _conformance(toProtocolName: name,
                                              in: type,
                                              visitedTypes: visitedTypes) {
                return conformance
            }
        }
        
        return nil
    }
    
    /// Gets a list of all protocol conformances of a given type.
    ///
    /// Looks through supertype and protocol hierarchies, if available, resulting
    /// in all known protocol conformances of a type.
    public func allConformances(of type: KnownType) -> [KnownProtocolConformance] {
        return _allConformances(of: type, visitedTypes: [])
    }
    
    private func _allConformances(of type: KnownType,
                                  visitedTypes: Set<String>) -> [KnownProtocolConformance] {
        
        var visitedTypes = visitedTypes
        
        visitedTypes.insert(type.typeName)
        
        if allConformancesCache.usingCache {
            if let result = allConformancesCache.readingValue({ $0[type.typeName] }) {
                return result
            }
        }
        
        var protocols =
            type.knownProtocolConformances
                .filter { !visitedTypes.contains($0.protocolName) }
        
        for prot in type.knownProtocolConformances {
            if visitedTypes.contains(prot.protocolName) {
                continue
            }
            
            if let type = knownTypeWithName(prot.protocolName) {
                protocols.append(contentsOf:
                    _allConformances(of: type, visitedTypes: visitedTypes)
                )
            }
        }
        
        if let supertype = supertype(of: type), !visitedTypes.contains(supertype.typeName) {
            protocols.append(contentsOf:
                _allConformances(of: supertype, visitedTypes: visitedTypes)
            )
        }
        
        if allConformancesCache.usingCache {
            allConformancesCache.modifyingValue { value in
                value[type.typeName] = protocols
            }
        }
        
        return protocols
    }
    
    /// Searches for a method with a given Objective-C equivalent selector, also
    /// specifying whether to include optional methods (from optional protocol
    /// methods that where not implemented by a concrete class).
    ///
    /// An optional list of types which correlate to the type of each argument
    /// passed to the function can be provided to allow overload detection.
    public func method(withObjcSelector selector: SelectorSignature,
                       invocationTypeHints: [SwiftType?]?,
                       static isStatic: Bool,
                       includeOptional: Bool,
                       in type: KnownType) -> KnownMethod? {
        
        let lookup = makeTypeMemberLookup()
        
        return lookup.method(withObjcSelector: selector,
                             invocationTypeHints: invocationTypeHints,
                             static: isStatic,
                             includeOptional: includeOptional,
                             in: type)
    }
    
    /// Gets a property with a given name on a given known type, also specifying
    /// whether to include optional methods (from optional protocol methods that
    /// where not implemented by a concrete class).
    public func property(named name: String,
                         static isStatic: Bool,
                         includeOptional: Bool,
                         in type: KnownType) -> KnownProperty? {
        
        let lookup = makeTypeMemberLookup()
        
        return lookup.property(named: name,
                               static: isStatic,
                               includeOptional: includeOptional,
                               in: type)
    }
    
    /// Gets an instance field with a given name on a given known type.
    public func field(named name: String, static isStatic: Bool, in type: KnownType) -> KnownProperty? {
        let lookup = makeTypeMemberLookup()
        
        return lookup.field(named: name, static: isStatic, in: type)
    }
    
    /// Returns a known type for a given SwiftType, if present.
    public func findType(for swiftType: SwiftType) -> KnownType? {
        if knownTypeForSwiftType.usingCache {
            if let result = knownTypeForSwiftType.readingValue({ $0[swiftType] }) {
                return result
            }
        }
        
        let swiftType = swiftType.deepUnwrapped
        let result: KnownType?
        
        switch swiftType {
        case .nominal(.typeName(let typeName)):
            result = knownTypeWithName(typeName)
            
        // Meta-types recurse on themselves
        case .metatype(for: let inner):
            let type = inner.deepUnwrapped
            
            switch type {
            case .nominal(.typeName(let name)):
                result = knownTypeWithName(name)
            default:
                result = findType(for: type)
            }
            
        case .protocolComposition(let types):
            result = composeTypeWithKnownTypes(types.map { $0.description })
            
        // Other Swift types are not supported, at the moment.
        default:
            result = nil
        }
        
        if knownTypeForSwiftType.usingCache {
            knownTypeForSwiftType.modifyingValue { cache in
                cache[swiftType] = result
            }
        }
        
        return result
    }
    
    // MARK: Member searching methods - SwiftType
    
    /// Gets a constructor matching a given argument label set on a given known
    /// type.
    public func constructor(withArgumentLabels labels: [String?],
                            in type: SwiftType) -> KnownConstructor? {
        
        guard let knownType = self.findType(for: type) else {
            return nil
        }
        return constructor(withArgumentLabels: labels, in: knownType)
    }
    
    /// Gets a protocol conformance to a given protocol name on a given known type.
    public func conformance(toProtocolName name: String,
                            in type: SwiftType) -> KnownProtocolConformance? {
        
        guard let knownType = self.findType(for: type) else {
            return nil
        }
        return conformance(toProtocolName: name, in: knownType)
    }
    
    /// Searches for a method with a given Objective-C equivalent selector, also
    /// specifying whether to include optional methods (from optional protocol
    /// methods that where not implemented by a concrete class).
    ///
    /// An optional list of types which correlate to the type of each argument
    /// passed to the function can be provided to allow overload detection.
    public func method(withObjcSelector selector: SelectorSignature,
                       invocationTypeHints: [SwiftType?]?,
                       static isStatic: Bool,
                       includeOptional: Bool,
                       in type: SwiftType) -> KnownMethod? {
        
        let lookup = makeTypeMemberLookup()
        
        return lookup.method(withObjcSelector: selector,
                             invocationTypeHints: invocationTypeHints,
                             static: isStatic,
                             includeOptional: includeOptional,
                             in: type)
    }
    
    /// Gets a property with a given name on a given known type, also specifying
    /// whether to include optional methods (from optional protocol methods that
    /// where not implemented by a concrete class).
    public func property(named name: String,
                         static isStatic: Bool,
                         includeOptional: Bool,
                         in type: SwiftType) -> KnownProperty? {
        
        let lookup = makeTypeMemberLookup()
        
        return lookup.property(named: name,
                               static: isStatic,
                               includeOptional: includeOptional,
                               in: type)
    }
    
    /// Gets an instance field with a given name on a given known type.
    public func field(named name: String, static isStatic: Bool, in type: SwiftType) -> KnownProperty? {
        let lookup = makeTypeMemberLookup()
        
        return lookup.field(named: name, static: isStatic, in: type)
    }
    
    private func makeTypeMemberLookup() -> TypeMemberLookup {
        return TypeMemberLookup(typeSystem: self, memberSearchCache: memberSearchCache)
    }
    
    private func classTypeDefinition(name: String) -> ClassType? {
        if !baseClassTypesByNameCache.usingCache {
            baseClassTypesByNameCache
                .setAsCaching(value:
                    TypeDefinitions
                        .classesList
                        .classes
                        .groupBy({ $0.typeName })
                        .mapValues { $0[0] }
                )
        }
        
        return baseClassTypesByNameCache.readingValue { $0[name] }
    }
}

extension TypeSystem {
    /// Adds a typealias from a given nominal type to a target SwiftType.
    /// Typealiases affect lookup of types by name via `knownTypeWithName` and
    /// resolveAliases(in:).
    public func addTypealias(aliasName: String, originalType: SwiftType) {
        self.innerAliasesProvider.addTypealias(aliasName, originalType)
    }
}

extension TypeSystem {
    /// Registers the default type providers needed for the type system to work
    /// properly.
    func registerInitialTypeProviders() {
        typealiasProviders.addTypealiasProvider(innerAliasesProvider)
        knownTypeProviders.addKnownTypeProvider(innerKnownTypes)
        knownTypeProviders.addKnownTypeProvider(TypeDefinitionsProtocolKnownTypeProvider())
        knownTypeProviders.addKnownTypeProvider(TypeDefinitionsClassKnownTypeProvider())
    }
}

extension TypeSystem {
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
                        isStatic: false,
                        isMutating: false)
                )
                .method(withSignature:
                    FunctionSignature(
                        name: "isEqual",
                        parameters: [ParameterSignature(label: nil,
                                                        name: "object",
                                                        type: .anyObject)],
                        returnType: .bool,
                        isStatic: false,
                        isMutating: false)
                )
                .build()
        
        let nsObject =
            KnownTypeBuilder(typeName: "NSObject")
                .constructor()
                .protocolConformance(protocolName: "NSObjectProtocol")
                .property(named: "description", type: .string)
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
                            ParameterSignature(label: nil, name: "anObject", type: .anyObject),
                            ParameterSignature(label: "forKey", name: "aKey", type: .anyObject)
                        ],
                        returnType: .void,
                        isStatic: false,
                        isMutating: false
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
                            ParameterSignature(label: nil, name: "object", type: .anyObject)
                        ],
                        isMutating: false
                    ),
                        semantics: Semantics.collectionMutator
                )
                .build()
        
        addType(nsObjectProtocol)
        addType(nsObject)
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
    case .nominal(let nominalType):
        return typeNameIn(nominalType: nominalType)
        
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

func typeNameIn(nominalType: NominalSwiftType) -> String {
    return nominalType.typeNameValue
}

private class TypeMemberLookup {
    private let typeSystem: TypeSystem
    private let memberSearchCache: MemberSearchCache
    private var visitedTypes: Set<String> = []
    
    init(typeSystem: TypeSystem, memberSearchCache: MemberSearchCache) {
        self.typeSystem = typeSystem
        self.memberSearchCache = memberSearchCache
    }
    
    func method(withObjcSelector selector: SelectorSignature,
                invocationTypeHints: [SwiftType?]?,
                static isStatic: Bool,
                includeOptional: Bool,
                in type: KnownType) -> KnownMethod? {
        
        visitedTypes.insert(type.typeName)
        
        if memberSearchCache.usingCache,
            let result =
            memberSearchCache.lookupMethod(withObjcSelector: selector,
                                           invocationTypeHints: invocationTypeHints,
                                           static: isStatic,
                                           includeOptional: includeOptional,
                                           in: type.typeName) {
            
            return result
        }
        
        let result = _method(withObjcSelector: selector,
                             invocationTypeHints: invocationTypeHints,
                             static: isStatic,
                             includeOptional: includeOptional,
                             in: type)
        
        if memberSearchCache.usingCache {
            memberSearchCache.storeMethod(withObjcSelector: selector,
                                          invocationTypeHints: invocationTypeHints,
                                          static: isStatic,
                                          includeOptional: includeOptional,
                                          in: type.typeName,
                                          method: result)
        }
        
        return result
    }
    
    private func _method(withObjcSelector selector: SelectorSignature,
                         invocationTypeHints: [SwiftType?]?,
                         static isStatic: Bool,
                         includeOptional: Bool,
                         in type: KnownType) -> KnownMethod? {
        
        let methods =
            type.knownMethods
                .filter {
                    $0.isStatic == isStatic
                        && (includeOptional || !$0.optional)
                        && $0.signature.possibleSelectorSignatures().contains(selector)
                }
        
        if !methods.isEmpty {
            if methods.count == 1 || invocationTypeHints == nil {
                return methods[0]
            }
            
            // Attempt overload resolution based on argument type information
            if let invocationTypeHints = invocationTypeHints,
                selector.keywords.count - 1 == invocationTypeHints.count {
                
                if let method =
                    typeSystem.overloadResolver()
                        .findBestOverload(in: methods,
                                          argumentTypes: invocationTypeHints)
                        ?? methods.first {
                    
                    return method
                }
            }
        }
        
        // Search on supertypes
        let onSupertype =
            typeSystem.supertype(of: type)
                .flatMap {
                    method(withObjcSelector: selector,
                           invocationTypeHints: invocationTypeHints,
                           static: isStatic,
                           includeOptional: includeOptional,
                           in: $0)
                }
        
        if let result = onSupertype {
            return result
        }
        
        // Search on protocol conformances
        for conformance in type.knownProtocolConformances {
            if visitedTypes.contains(conformance.protocolName) {
                continue
            }
            
            guard let prot = typeSystem.knownTypeWithName(conformance.protocolName) else {
                continue
            }
            
            if let method = method(withObjcSelector: selector,
                                   invocationTypeHints: invocationTypeHints,
                                   static: isStatic,
                                   includeOptional: includeOptional,
                                   in: prot) {
                
                return method
            }
        }
        
        return nil
    }
    
    func property(named name: String,
                  static isStatic: Bool,
                  includeOptional: Bool,
                  in type: KnownType) -> KnownProperty? {
        
        visitedTypes.insert(type.typeName)
        
        if memberSearchCache.usingCache,
            let result =
            memberSearchCache.lookupProperty(named: name,
                                             static: isStatic,
                                             includeOptional: includeOptional,
                                             in: type.typeName) {
            
            return result
        }
        
        let result = _property(named: name,
                               static: isStatic,
                               includeOptional: includeOptional,
                               in: type)
        
        if memberSearchCache.usingCache {
            memberSearchCache.storeProperty(named: name,
                                            static: isStatic,
                                            includeOptional: includeOptional,
                                            in: type.typeName,
                                            property: result)
        }
        
        return result
    }
    
    private func _property(named name: String,
                           static isStatic: Bool,
                           includeOptional: Bool,
                           in type: KnownType) -> KnownProperty? {
        
        visitedTypes.insert(type.typeName)
        
        if let property = type.knownProperties.first(where: {
            $0.name == name
                && $0.isStatic == isStatic
                && (includeOptional || !$0.optional)
        }) {
            return property
        }
        
        // Search on supertypes
        return typeSystem.supertype(of: type).flatMap {
            property(named: name,
                     static: isStatic,
                     includeOptional: includeOptional,
                     in: $0)
        }
    }
    
    func field(named name: String, static isStatic: Bool, in type: KnownType) -> KnownProperty? {
        visitedTypes.insert(type.typeName)
        
        if memberSearchCache.usingCache,
            let result =
            memberSearchCache.lookupField(named: name,
                                          static: isStatic,
                                          in: type.typeName) {
            
            return result
        }
        
        let result = _field(named: name, static: isStatic, in: type)
        
        if memberSearchCache.usingCache {
            memberSearchCache.storeField(named: name,
                                         static: isStatic,
                                         in: type.typeName,
                                         field: result)
        }
        
        return result
    }
    
    func _field(named name: String, static isStatic: Bool, in type: KnownType) -> KnownProperty? {
        if let field =
            type.knownFields
                .first(where: { $0.name == name && $0.isStatic == isStatic }) {
            return field
        }
        
        // Search on supertypes
        return typeSystem.supertype(of: type).flatMap {
            field(named: name, static: isStatic, in: $0)
        }
    }
    
    func method(withObjcSelector selector: SelectorSignature,
                invocationTypeHints: [SwiftType?]?,
                static isStatic: Bool,
                includeOptional: Bool,
                in type: SwiftType) -> KnownMethod? {
        
        let typeName =
            memberSearchCache.usingCache
                ? typeNameIn(swiftType: type)
                : nil
        
        if memberSearchCache.usingCache, let typeName = typeName {
            if let result =
                memberSearchCache.lookupMethod(withObjcSelector: selector,
                                               invocationTypeHints: invocationTypeHints,
                                               static: isStatic,
                                               includeOptional: includeOptional,
                                               in: typeName) {
                
                return result
            }
        }
        
        guard let knownType = typeSystem.findType(for: type) else {
            return nil
        }
        let result = method(withObjcSelector: selector,
                            invocationTypeHints: invocationTypeHints,
                            static: isStatic,
                            includeOptional: includeOptional,
                            in: knownType)
        
        if memberSearchCache.usingCache, let typeName = typeName {
            memberSearchCache.storeMethod(withObjcSelector: selector,
                                          invocationTypeHints: invocationTypeHints,
                                          static: isStatic,
                                          includeOptional: includeOptional,
                                          in: typeName,
                                          method: result)
        }
        
        return result
    }
    
    /// Gets a property with a given name on a given known type, also specifying
    /// whether to include optional methods (from optional protocol methods that
    /// where not implemented by a concrete class).
    public func property(named name: String,
                         static isStatic: Bool,
                         includeOptional: Bool,
                         in type: SwiftType) -> KnownProperty? {
        
        let typeName =
            memberSearchCache.usingCache
                ? typeNameIn(swiftType: type)
                : nil
        
        if memberSearchCache.usingCache, let typeName = typeName {
            if let result =
                memberSearchCache.lookupProperty(named: name,
                                                 static: isStatic,
                                                 includeOptional: includeOptional,
                                                 in: typeName) {
                
                return result
            }
        }
        
        guard let knownType = typeSystem.findType(for: type) else {
            return nil
        }
        let result = property(named: name,
                              static: isStatic,
                              includeOptional: includeOptional,
                              in: knownType)
        
        if memberSearchCache.usingCache, let typeName = typeName {
            memberSearchCache.storeProperty(named: name,
                                            static: isStatic,
                                            includeOptional: includeOptional,
                                            in: typeName,
                                            property: result)
        }
        
        return result
    }
    
    /// Gets an instance field with a given name on a given known type.
    public func field(named name: String, static isStatic: Bool, in type: SwiftType) -> KnownProperty? {
        
        let typeName =
            memberSearchCache.usingCache
                ? typeNameIn(swiftType: type)
                : nil
        
        if memberSearchCache.usingCache, let typeName = typeName {
            if let result = memberSearchCache.lookupField(named: name, static: isStatic, in: typeName) {
                return result
            }
        }
        
        guard let knownType = typeSystem.findType(for: type) else {
            return nil
        }
        
        let result = field(named: name, static: isStatic, in: knownType)
        
        if memberSearchCache.usingCache, let typeName = typeName {
            memberSearchCache.storeField(named: name, static: isStatic, in: typeName, field: result)
        }
        
        return result
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
        case let .block(returnType, parameters, attributes):
            return .block(returnType: expand(in: returnType),
                          parameters: parameters.map(expand),
                          attributes: attributes)
            
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
            
        case .nullabilityUnspecified(let type):
            return .nullabilityUnspecified(expand(in: type))
            
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
            
        case .array(let inner):
            return .array(expand(in: inner))
            
        case let .dictionary(key, value):
            return .dictionary(key: expand(in: key), value: expand(in: value))
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
            return .generic(expand(inString: name),
                            parameters: .fromCollection(parameters.map(expand)))
        }
    }
    
    private func pushingAlias<T>(_ name: String, do work: () -> T) -> T {
        if aliasesInStack.contains(name) {
            fatalError("""
                Cycle found while expanding typealises: \
                \(aliasesInStack.joined(separator: " -> ")) -> \(name)
                """)
        }
        
        aliasesInStack.append(name)
        defer {
            aliasesInStack.removeLast()
        }
        
        return work()
    }
}

private final class CompoundKnownTypesCache {
    private var types: ConcurrentValue<[[String]: KnownType]> = ConcurrentValue(value: [:])
    
    func fetch(names: [String]) -> KnownType? {
        return types.readingValue({ $0[names] })
    }
    
    func record(type: KnownType, names: [String]) {
        types.modifyingValue {
            $0[names] = type
        }
    }
}

private final class ProtocolConformanceCache {
    private let cache = ConcurrentValue<[String: Entry]>(value: [:])
    
    init() {
        cache.setAsCaching(value: [:])
    }
    
    func record(typeName: String, conformsTo protocolName: String, _ value: Bool) {
        cache.modifyingValue { entries -> Void in
            var entry = entries[typeName, default: Entry(conformances: [:])]
            entry.conformances[protocolName] = value
            entries[typeName] = entry
        }
    }
    
    func typeName(_ type: String, conformsTo protocolName: String) -> Bool? {
        return cache.readingValue { entries -> Bool? in
            return entries[type]?.conformances[protocolName]
        }
    }
    
    private struct Entry {
        var conformances: [String: Bool]
    }
}

private final class TypeDefinitionsProtocolKnownTypeProvider: KnownTypeProvider {
    
    private var cache: ConcurrentValue<[String: KnownType]> = ConcurrentValue(value: [:])
    
    // For remembering attempts to look for protocols that where not found on
    // the protocols list.
    // Avoids repetitive linear lookups on the protocols list over and over.
    private var negativeLookupResults: ConcurrentValue<Set<String>> = ConcurrentValue(value: [])
    
    func knownType(withName name: String) -> KnownType? {
        if let cached = cache.readingValue({ $0[name] }) {
            return cached
        }
        if negativeLookupResults.readingValue({ $0.contains(name) }) {
            return nil
        }
        
        let protocols = TypeDefinitions.protocolsList.protocols
        guard let prot = protocols.first(where: { $0.protocolName == name }) else {
            _ = negativeLookupResults.modifyingValue { value in
                value.insert(name)
            }
            
            return nil
        }
        
        let type = makeType(from: prot)
        
        cache.modifyingValue { cache in
            cache[name] = type
        }
        
        return type
    }
    
    func knownTypes(ofKind kind: KnownTypeKind) -> [KnownType] {
        guard kind == .protocol else {
            return []
        }
        
        // TODO: Return all protocols listed within TypeDefinitions.protocolsList
        return []
    }
    
    func canonicalName(for typeName: String) -> String? {
        return nil
    }
    
    func makeType(from prot: ProtocolType) -> KnownType {
        let type = ProtocolType_KnownType(protocolType: prot)
        return type
    }
    
    private class ProtocolType_KnownType: KnownType {
        let protocolType: ProtocolType
        
        let origin = "\(TypeDefinitionsProtocolKnownTypeProvider.self)"
        let isExtension = false
        let supertype: KnownTypeReference? = nil
        let typeName: String
        let kind: KnownTypeKind = .protocol
        let knownTraits: [String : TraitType] = [:]
        let knownConstructors: [KnownConstructor] = []
        let knownMethods: [KnownMethod] = []
        let knownProperties: [KnownProperty] = []
        let knownFields: [KnownProperty] = []
        let knownAttributes: [KnownAttribute] = []
        let knownProtocolConformances: [KnownProtocolConformance]
        let semantics: Set<Semantic> = []
        
        init(protocolType: ProtocolType) {
            self.typeName = protocolType.protocolName
            self.protocolType = protocolType
            
            knownProtocolConformances =
                protocolType.conformances.map {
                    _KnownProtocolConformance(protocolName: $0)
                }
        }
        
        private struct _KnownProtocolConformance: KnownProtocolConformance {
            var protocolName: String
        }
    }
}

private final class TypeDefinitionsClassKnownTypeProvider: KnownTypeProvider {
    
    private var cache: ConcurrentValue<[String: KnownType]> = ConcurrentValue(value: [:])
    
    // For remembering attempts to look for classes that where not found on
    // the classes list.
    // Avoids repetitive linear lookups on the classes list over and over.
    private var negativeLookupResults: ConcurrentValue<Set<String>> = ConcurrentValue(value: [])
    
    func knownType(withName name: String) -> KnownType? {
        if let cached = cache.readingValue({ $0[name] }) {
            return cached
        }
        if negativeLookupResults.readingValue({ $0.contains(name) }) {
            return nil
        }
        
        guard let prot = TypeDefinitions.classesList.classes.first(where: { $0.typeName == name }) else {
            _ = negativeLookupResults.modifyingValue {
                $0.insert(name)
            }
            
            return nil
        }
        
        let type = makeType(from: prot)
        
        cache.modifyingValue {
            $0[name] = type
        }
        
        return type
    }
    
    func knownTypes(ofKind kind: KnownTypeKind) -> [KnownType] {
        guard kind == .class else {
            return []
        }
        
        // TODO: Return all classes listed within TypeDefinitions.classesList
        return []
    }
    
    func canonicalName(for typeName: String) -> String? {
        return nil
    }
    
    func makeType(from prot: ClassType) -> KnownType {
        let type = ClassType_KnownType(classType: prot)
        return type
    }
    
    private class ClassType_KnownType: KnownType {
        let classType: ClassType
        
        let origin = "\(TypeDefinitionsProtocolKnownTypeProvider.self)"
        let isExtension = false
        let supertype: KnownTypeReference?
        let typeName: String
        let kind: KnownTypeKind = .protocol
        let knownTraits: [String : TraitType] = [:]
        let knownConstructors: [KnownConstructor] = []
        let knownMethods: [KnownMethod] = []
        let knownProperties: [KnownProperty] = []
        let knownFields: [KnownProperty] = []
        let knownProtocolConformances: [KnownProtocolConformance]
        let knownAttributes: [KnownAttribute] = []
        let semantics: Set<Semantic> = []
        
        init(classType: ClassType) {
            self.typeName = classType.typeName
            self.supertype = .typeName(classType.superclass)
            self.classType = classType
            
            knownProtocolConformances =
                classType.protocols.map {
                    _KnownProtocolConformance(protocolName: $0)
                }
        }
        
        private struct _KnownProtocolConformance: KnownProtocolConformance {
            var protocolName: String
        }
    }
}

internal final class MemberSearchCache {
    private let methodsCache = ConcurrentValue<[MethodSearchEntry: KnownMethod?]>(value: [:])
    private let propertiesCache = ConcurrentValue<[PropertySearchEntry: KnownProperty?]>(value: [:])
    private let fieldsCache = ConcurrentValue<[FieldSearchEntry: KnownProperty?]>(value: [:])

    var usingCache: Bool = false

    func makeCache() {
        usingCache = true
        methodsCache.setAsCaching(value: [:])
        propertiesCache.setAsCaching(value: [:])
        fieldsCache.setAsCaching(value: [:])
    }

    func tearDownCache() {
        usingCache = false
        methodsCache.tearDownCaching(resetToValue: [:])
        propertiesCache.tearDownCaching(resetToValue: [:])
        fieldsCache.tearDownCaching(resetToValue: [:])
    }

    func storeMethod(withObjcSelector selector: SelectorSignature,
                     invocationTypeHints: [SwiftType?]?,
                     static isStatic: Bool,
                     includeOptional: Bool,
                     in typeName: String,
                     method: KnownMethod?) {
        
        methodsCache.modifyingValue { cache in
            let entry = MethodSearchEntry(selector: selector,
                                          invocationTypeHints: invocationTypeHints,
                                          isStatic: isStatic,
                                          includeOptional: includeOptional,
                                          typeName: typeName)
            
            cache[entry] = method
        }
    }

    func storeProperty(named name: String,
                       static isStatic: Bool,
                       includeOptional: Bool,
                       in typeName: String,
                       property: KnownProperty?) {
        
        propertiesCache.modifyingValue { cache in
            let entry = PropertySearchEntry(name: name,
                                            isStatic: isStatic,
                                            includeOptional: includeOptional,
                                            typeName: typeName)
            
            cache[entry] = property
        }
    }

    func storeField(named name: String,
                    static isStatic: Bool,
                    in typeName: String,
                    field: KnownProperty?) {
        
        fieldsCache.modifyingValue { cache in
            let entry = FieldSearchEntry(name: name,
                                         isStatic: isStatic,
                                         typeName: typeName)
            
            cache[entry] = field
        }
    }

    func lookupMethod(withObjcSelector selector: SelectorSignature,
                      invocationTypeHints: [SwiftType?]?,
                      static isStatic: Bool,
                      includeOptional: Bool,
                      in typeName: String) -> KnownMethod?? {
        
        return methodsCache.readingValue { cache in
            let entry = MethodSearchEntry(selector: selector,
                                          invocationTypeHints: invocationTypeHints,
                                          isStatic: isStatic,
                                          includeOptional: includeOptional,
                                          typeName: typeName)
            
            return cache[entry]
        }
    }

    func lookupProperty(named name: String,
                        static isStatic: Bool,
                        includeOptional: Bool,
                        in typeName: String) -> KnownProperty?? {
        
        return propertiesCache.readingValue { cache in
            let entry = PropertySearchEntry(name: name,
                                            isStatic: isStatic,
                                            includeOptional: includeOptional,
                                            typeName: typeName)
            
            return cache[entry]
        }
    }

    func lookupField(named name: String,
                     static isStatic: Bool,
                     in typeName: String) -> KnownProperty?? {
        
        return fieldsCache.readingValue { cache in
            let entry = FieldSearchEntry(name: name,
                                         isStatic: isStatic,
                                         typeName: typeName)
            
            return cache[entry]
        }
    }

    struct MethodSearchEntry: Hashable {
        var selector: SelectorSignature
        var invocationTypeHints: [SwiftType?]?
        var isStatic: Bool
        var includeOptional: Bool
        var typeName: String
    }

    struct PropertySearchEntry: Hashable {
        var name: String
        var isStatic: Bool
        var includeOptional: Bool
        var typeName: String
    }

    struct FieldSearchEntry: Hashable {
        var name: String
        var isStatic: Bool
        var typeName: String
    }
}
