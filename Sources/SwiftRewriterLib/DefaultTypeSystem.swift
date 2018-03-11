import SwiftAST
import TypeDefinitions

/// Standard type system implementation
public class DefaultTypeSystem: TypeSystem {
    /// A singleton instance to a default type system.
    public static let defaultTypeSystem: TypeSystem = DefaultTypeSystem()

    var types: [KnownType] = []
    var typesByName: [String: KnownType] = [:]
    
    public init() {
        registerInitialKnownTypes()
    }
    
    public func addType(_ type: KnownType) {
        types.append(type)
        typesByName[type.typeName] = type
    }
    
    public func typeExists(_ name: String) -> Bool {
        return typesByName.keys.contains(name)
    }
    
    public func knownTypes(ofKind kind: KnownTypeKind) -> [KnownType] {
        return types.filter { $0.kind == kind }
    }
    
    public func knownTypeWithName(_ name: String) -> KnownType? {
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
        return LazyKnownType(typeName: typeNames.joined(separator: " & "), typeSystem: self, types: types)
    }
    
    public func isClassInstanceType(_ typeName: String) -> Bool {
        if TypeDefinitions.classesList.classes.contains(where: { $0.typeName == typeName }) {
            return true
        }
        
        if knownTypeWithName(typeName) != nil {
            return true
        }
        
        return false
    }
    
    public func isType(_ typeName: String, subtypeOf supertypeName: String) -> Bool {
        if typeName == supertypeName {
            return true
        }
        
        guard let type = knownTypeWithName(typeName) else {
            return false
        }
        
        // Direct supertype name fetching
        switch type.supertype {
        case .some(.typeName(let tn)) where tn == supertypeName:
            return true
        case .some(.knownType(let kt)):
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
        switch type {
        case .int, .uint:
            return true
        case .typeName(let name):
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
        return supertype(of: type).flatMap {
            conformance(toProtocolName: name, in: $0)
        }
    }
    
    public func method(withObjcSelector selector: FunctionSignature, static isStatic: Bool,
                       includeOptional: Bool, in type: KnownType) -> KnownMethod? {
        if let method = type.knownMethods.first(where: {
            $0.signature.matchesAsSelector(selector)
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
        let swiftType = swiftType.normalized.deepUnwrapped
        
        switch swiftType {
        case .typeName(let typeName):
            return knownTypeWithName(typeName)
            
        // Meta-types recurse on themselves
        case .metatype(for: let inner):
            let type = inner.deepUnwrapped
            
            switch type {
            case .typeName(let name):
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
    
    fileprivate func typeNameIn(swiftType: SwiftType) -> String? {
        let swiftType = swiftType.normalized.deepUnwrapped
        
        switch swiftType {
        case .typeName(let typeName):
            return typeName
            
        // Meta-types recurse on themselves
        case .metatype(for: let inner):
            let type = inner.deepUnwrapped
            
            switch type {
            case .typeName(let name):
                return name
            default:
                return typeNameIn(swiftType: type)
            }
            
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
    
    public func method(withObjcSelector selector: FunctionSignature, static isStatic: Bool,
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
        return TypeDefinitions.classesList.classes.first(where: { $0.typeName == name })
    }
}

extension DefaultTypeSystem {
    /// Initializes the default known types
    func registerInitialKnownTypes() {
        let nsObjectProtocol =
            KnownTypeBuilder(typeName: "NSObjectProtocol", kind: .protocol)
                .addingMethod(withSignature:
                    FunctionSignature(name: "responds",
                                      parameters: [ParameterSignature(label: "to", name: "selector", type: .selector)],
                                      returnType: .bool,
                                      isStatic: false)
                )
                .build()
        
        let nsObject =
            KnownTypeBuilder(typeName: "NSObject")
                .addingConstructor()
                .addingProtocolConformance(protocolName: "NSObjectProtocol")
                .build()
        
        let nsArray =
            KnownTypeBuilder(typeName: "NSArray", supertype: nsObject)
                .build()
        
        let nsMutableArray =
            KnownTypeBuilder(typeName: "NSMutableArray", supertype: nsArray)
                .addingMethod(withSignature:
                    FunctionSignature(name: "addObject",
                                      parameters: [
                                        ParameterSignature(label: "_",
                                                           name: "object",
                                                           type: .anyObject)],
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
                .addingMethod(withSignature:
                    FunctionSignature(name: "setObject",
                                      parameters: [
                                        ParameterSignature(label: "_", name: "anObject", type: .anyObject),
                                        ParameterSignature(label: "forKey", name: "aKey", type: .anyObject)],
                                      returnType: .void,
                                      isStatic: false
                    )
                )
                .build()
        
        addType(nsObjectProtocol)
        addType(nsObject)
        addType(nsArray)
        addType(nsMutableArray)
        addType(nsDictionary)
        addType(nsMutableDictionary)
        
        // Foundation types
        registerFoundation(nsObject: nsObject)
        registerFormatters(nsObject: nsObject)
    }
    
    private func registerFoundation(nsObject: KnownType) {
        let nsDate = KnownTypeBuilder(typeName: "NSDate", supertype: nsObject).build()
        let nsData = KnownTypeBuilder(typeName: "NSData", supertype: nsObject).build()
        let nsMutableData = KnownTypeBuilder(typeName: "NSMutableData", supertype: nsData).build()
        let nsMutableString =
            KnownTypeBuilder(typeName: "NSMutableString", supertype: KnownSupertype.typeName("NSString"))
                .addingConstructor()
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
    public var intentions: IntentionCollection
    
    public init(intentions: IntentionCollection) {
        self.intentions = intentions
        super.init()
    }
    
    public override func isClassInstanceType(_ typeName: String) -> Bool {
        if intentions.typeIntentions().contains(where: { $0.typeName == typeName }) {
            return true
        }
        
        return super.isClassInstanceType(typeName)
    }
    
    public override func typeExists(_ name: String) -> Bool {
        if super.typeExists(name) {
            return true
        }
        
        for file in intentions.fileIntentions() {
            if file.typeIntentions.contains(where: { $0.typeName == name }) {
                return true
            }
        }
        
        return false
    }
    
    public override func knownTypes(ofKind kind: KnownTypeKind) -> [KnownType] {
        var types = super.knownTypes(ofKind: kind)
        
        for file in intentions.fileIntentions() {
            for type in file.typeIntentions where type.kind == kind {
                types.append(type)
            }
        }
        
        return types
    }
    
    public override func knownTypeWithName(_ name: String) -> KnownType? {
        if let type = super.knownTypeWithName(name) {
            return type
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
        
        return LazyKnownType(typeName: name, typeSystem: self, types: Array(types))
    }
    
    // MARK: Shortcuts for member searching
    
    public override func property(named name: String, static isStatic: Bool,
                                  includeOptional: Bool, in type: SwiftType) -> KnownProperty? {
        guard let typeName = typeNameIn(swiftType: type) else {
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
        
        for file in intentions.fileIntentions() {
            for type in file.typeIntentions where type.typeName == typeName {
                if let prop = type.properties.first(where: { $0.name == name && $0.isStatic == isStatic }) {
                    return prop
                }
            }
        }
        
        return super.field(named: name, static: isStatic, in: type)
    }
    
    public override func method(withObjcSelector selector: FunctionSignature, static isStatic: Bool,
                                includeOptional: Bool, in type: SwiftType) -> KnownMethod? {
        guard let typeName = typeNameIn(swiftType: type) else {
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
}

/// A lazily-resolved compound known type that computes the value of each its
/// properties on demand.
private class LazyKnownType: KnownType {
    private var types: [KnownType]
    
    var typeName: String
    var typeSystem: TypeSystem
    
    lazy var kind: KnownTypeKind = {
        return types[0].kind
    }()
    
    lazy var origin: String = {
        return types[0].origin
    }()
    
    lazy var supertype: KnownSupertype? = {
        var supertype: KnownSupertype?
        for type in types {
            // Search supertypes known here
            switch type.supertype {
            case .typeName(let supertypeName)?:
                supertype = typeSystem.knownTypeWithName(supertypeName).map { .knownType($0) }
            case .knownType?:
                supertype = type.supertype
            default:
                break
            }
        }
        
        return supertype
    }()
    
    lazy var knownConstructors: [KnownConstructor] = {
        var data: [KnownConstructor] = []
        data.reserveCapacity(types.count)
        for type in types {
            data.append(contentsOf: type.knownConstructors)
        }
        return data
    }()
    
    lazy var knownMethods: [KnownMethod] = {
        var data: [KnownMethod] = []
        data.reserveCapacity(types.count)
        for type in types {
            data.append(contentsOf: type.knownMethods)
        }
        return data
    }()
    
    lazy var knownProperties: [KnownProperty] = {
        var data: [KnownProperty] = []
        data.reserveCapacity(types.count)
        for type in types {
            data.append(contentsOf: type.knownProperties)
        }
        return data
    }()
    
    lazy var knownFields: [KnownProperty] = {
        var data: [KnownProperty] = []
        data.reserveCapacity(types.count)
        for type in types {
            data.append(contentsOf: type.knownFields)
        }
        return data
    }()
    
    lazy var knownProtocolConformances: [KnownProtocolConformance] = {
        var data: [KnownProtocolConformance] = []
        data.reserveCapacity(types.count)
        for type in types {
            data.append(contentsOf: type.knownProtocolConformances)
        }
        return data
    }()
    
    init(typeName: String, typeSystem: TypeSystem, types: [KnownType]) {
        self.typeName = typeName
        self.typeSystem = typeSystem
        self.types = types
    }
}
