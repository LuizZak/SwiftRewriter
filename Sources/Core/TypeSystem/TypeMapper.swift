import SwiftAST
import ObjcGrammarModels

/// Provides type-transforming support for a Swift rewriter
public protocol TypeMapper {
    func typeNameString(for swiftType: SwiftType) -> String
    func typeNameString(for objcType: ObjcType, context: TypeMappingContext) -> String
    func swiftType(forObjcType type: ObjcType, context: TypeMappingContext) -> SwiftType
}

public extension TypeMapper {
    func typeNameString(for objcType: ObjcType) -> String {
        typeNameString(for: objcType, context: .empty)
    }
    func swiftType(forObjcType type: ObjcType) -> SwiftType {
        swiftType(forObjcType: type, context: .empty)
    }
}

/// Contexts used during type mapping.
public struct TypeMappingContext {
    /// Gets an empty type mapping context
    public static let empty = TypeMappingContext(modifiers: nil, qualifiers: [], alwaysNonnull: false)
    
    /// Gets a type mapping context that always maps to a non-null type
    public static let alwaysNonnull = TypeMappingContext(modifiers: nil, qualifiers: [], alwaysNonnull: true)
    
    /// Modifiers fetched from a @property declaration
    public var modifiers: ObjcPropertyAttributesListNode?
    /// Nullability specifiers from a method definition's type decl
    public var nullabilitySpecifiers: [ObjcNullabilitySpecifierNode] = []
    
    /// If true, every struct pointer found is considered to be an Objective-C
    /// class instance.
    public var alwaysClass: Bool = false
    
    /// If true, always infers `nonnull` for otherwise unspecified nullability
    /// cases.
    public var inNonnullContext: Bool = false
    
    /// Objc type specifiers from a type name.
    /// See `ObjcType` for more information.
    public var specifiers: [ObjcTypeSpecifier] = []
    
    /// Objc type qualifiers from a type name.
    /// See `ObjcType` for more information.
    public var qualifiers: [ObjcTypeQualifier] = []
    
    /// If `true`, all requests for nullability from this context object will
    /// result in `ObjcNullabilitySpecifier.nonnull` being returned.
    /// Used when traversing nested Objc generic types, which do not support
    /// nullability annotations.
    public var alwaysNonnull: Bool = false
    
    /// If non-nil, this explicit nullability specifier is used for all requests
    /// for nullability.
    ///
    /// Is overridden by `alwaysNonnull`.
    public var explicitNullability: ObjcNullabilitySpecifier?
    
    /// When mapping Objective-C's `instancetype` special type, this type is used
    /// as the resulting type instead.
    public var instanceTypeAlias: SwiftType?
    
    /// When no specified nullability is detected, provides the default nullability
    /// to use.
    /// Defaults to `.nullUnspecified`.
    public var unspecifiedNullability: ObjcNullabilitySpecifier = .nullUnspecified
    
    public init(
        modifiers: ObjcPropertyAttributesListNode?,
        specifiers: [ObjcTypeSpecifier] = [],
        qualifiers: [ObjcTypeQualifier] = [],
        alwaysNonnull: Bool = false,
        inNonnull: Bool = false
    ) {
        
        self.modifiers = modifiers
        self.specifiers = specifiers
        self.qualifiers = qualifiers
        self.alwaysNonnull = alwaysNonnull
        self.inNonnullContext = inNonnull
    }
    
    public init(explicitNullability: ObjcNullabilitySpecifier?, inNonnull: Bool = false) {
        self.explicitNullability = explicitNullability
        self.inNonnullContext = inNonnull
    }
    
    public init(
        nullabilitySpecs: [ObjcNullabilitySpecifierNode],
        alwaysNonnull: Bool = false,
        inNonnull: Bool = false
    ) {
        
        self.nullabilitySpecifiers = nullabilitySpecs
        self.alwaysNonnull = alwaysNonnull
        self.inNonnullContext = inNonnull
    }
    
    public init(inNonnull: Bool = false) {
        self.inNonnullContext = inNonnull
    }
    
    public func asAlwaysClass(isOn: Bool = true) -> TypeMappingContext {
        var copy = self
        copy.alwaysClass = isOn
        return copy
    }
    
    public func asAlwaysNonNull(isOn: Bool = true) -> TypeMappingContext {
        var copy = self
        copy.alwaysNonnull = isOn
        return copy
    }
    
    public func withExplicitNullability(_ nullability: ObjcNullabilitySpecifier?) -> TypeMappingContext {
        var copy = self
        copy.explicitNullability = nullability
        return copy
    }
    
    public func withSpecifiers(_ specifiers: [ObjcTypeSpecifier]) -> TypeMappingContext {
        var copy = self
        copy.specifiers = specifiers
        return copy
    }
    
    public func withExtraSpecifiers(_ specifiers: [ObjcTypeSpecifier]) -> TypeMappingContext {
        var copy = self
        copy.specifiers += specifiers
        return copy
    }
    
    public func withQualifiers(_ qualifiers: [ObjcTypeQualifier]) -> TypeMappingContext {
        var copy = self
        copy.qualifiers = qualifiers
        return copy
    }
    
    public func withExtraQualifiers(_ qualifiers: [ObjcTypeQualifier]) -> TypeMappingContext {
        var copy = self
        copy.qualifiers += qualifiers
        return copy
    }
    
    public func withUnspecifiedNullability(_ nullability: ObjcNullabilitySpecifier?) -> TypeMappingContext {
        guard let nullability else {
            return self
        }

        var copy = self
        copy.unspecifiedNullability = nullability
        return copy
    }
    
    /// Returns whether a modifier with a given name can be found within this
    /// type mapping context
    public func hasPropertyModifier(named name: String) -> Bool {
        guard let mods = modifiers?.keywordAttributes else {
            return false
        }
        
        return mods.contains(name)
    }
    
    /// Returns whether a type qualifier with a given name can be found within
    /// this type mapping context
    public func hasQualifierModifier(_ qualifier: ObjcTypeQualifier) -> Bool {
        qualifiers.contains(qualifier)
    }
    
    /// Returns whether a type specifier with a given name can be found within
    /// this type mapping context
    public func hasSpecifierModifier(_ specifier: ObjcTypeSpecifier) -> Bool {
        specifiers.contains(specifier)
    }
    
    /// Returns whether a type-signature nullability specifier with a given
    /// name can be found within this type mapping context
    public func hasMethodNullabilitySpecifier(named name: String) -> Bool {
        nullabilitySpecifiers.contains { $0.name == name }
    }
    
    /// Returns whether any of the @property modifiers is a `nonnull` modifier,
    /// or it the type pointer within has a `_Nonnull` specifier.
    public func hasNonnullModifier() -> Bool {
        hasPropertyModifier(named: "nonnull")
            || hasMethodNullabilitySpecifier(named: "nonnull")
    }
    
    /// Returns whether any of the @property modifiers is a `nullable` modifier,
    /// or it the type pointer within has a `_Nullable` specifier.
    public func hasNullableModifier() -> Bool {
        hasPropertyModifier(named: "nullable")
            || hasMethodNullabilitySpecifier(named: "nullable")
    }
    
    /// Returns whether any of the @property modifiers is a `null_unspecified`
    /// modifier
    /// or it the type pointer within has a `_Null_unspecified` specifier.
    public func hasUnspecifiedNullabilityModifier() -> Bool {
        hasPropertyModifier(named: "null_unspecified")
            || hasMethodNullabilitySpecifier(named: "null_unspecified")
    }
    
    /// Gets the nullability for the current type context
    public func nullability() -> ObjcNullabilitySpecifier {
        if alwaysNonnull {
            return .nonnull
        }
        
        if let explicit = explicitNullability {
            return explicit
        }
        
        // Weak assumes nullable
        if hasSpecifierModifier(.weak) || hasPropertyModifier(named: "weak") {
            return .nullable
        }
        
        if hasNonnullModifier() {
            return .nonnull
        }
        if hasNullableModifier() {
            return .nullable
        }
        
        if inNonnullContext {
            return .nonnull
        }
        
        return unspecifiedNullability
    }
}

public class DefaultTypeMapper: TypeMapper {
    let typeSystem: TypeSystem
    
    public init(typeSystem: TypeSystem = TypeSystem.defaultTypeSystem) {
        self.typeSystem = typeSystem
    }
    
    public func swiftType(forObjcType type: ObjcType, context: TypeMappingContext) -> SwiftType {
        sugarizeSwiftType(_internalSwiftType(forObjcType: type, context: context))
    }
    
    public func typeNameString(for swiftType: SwiftType) -> String {
        innerTypeNameString(for: swiftType, isBlockContext: false)
    }
    
    public func typeNameString(for composition: ProtocolCompositionComponent) -> String {
        switch composition {
        case .nested(let types):
            return types.map { typeNameString(for: $0) }.joined(separator: ".")
            
        case .nominal(let nominal):
            return typeNameString(for: nominal)
        }
    }
    
    public func typeNameString(for nominal: NominalSwiftType) -> String {
        switch nominal {
        case .typeName(let name):
            return name
            
        case let .generic(type, parameters):
            return type + "<" + parameters.map(typeNameString(for:)).joined(separator: ", ") + ">"
        }
    }
    
    public func typeNameString(for objcType: ObjcType, context: TypeMappingContext) -> String {
        let type = swiftType(forObjcType: objcType, context: context)
        return typeNameString(for: type)
    }
    
    /// Transforms a given SwiftType into a sugarized version of the type, converting
    /// array and dictionary into the sugar equivalents
    public func sugarizeSwiftType(_ type: SwiftType) -> SwiftType {
        switch type {
            
        // Simplify known generic types
        case .nominal(.generic("Array", let parameters)) where parameters.count == 1:
            return .array(parameters[0])
            
        case .nominal(.generic("Dictionary", let parameters)) where parameters.count == 2:
            return .dictionary(key: parameters[0], value: parameters[1])
            
        default:
            return type
        }
    }
    
    private func innerTypeNameString(
        for swiftType: SwiftType,
        isBlockContext: Bool
    ) -> String {
        
        switch swiftType {
        case let .block(blockType):
            let returnType = blockType.returnType
            let parameters = blockType.parameters
            let attributes = blockType.attributes

            let sortedAttributes =
                attributes.sorted { $0.description < $1.description }
            
            let attributeString =
                sortedAttributes.map(\.description).joined(separator: " ")
            
            let paramsString =
                parameters.map {
                    innerTypeNameString(for: $0, isBlockContext: true)
                }.joined(separator: ", ")
            
            return 
                (attributeString.isEmpty ? "" : attributeString + " ")
                    + "("
                    + paramsString
                    + ") -> "
                    + innerTypeNameString(for: returnType, isBlockContext: true)
            
        case .nominal(let nominal):
            return typeNameString(for: nominal)
            
        case .optional(let type):
            var typeName = typeNameString(for: type)
            if type.requiresSurroundingParens {
                typeName = "(" + typeName + ")"
            }
            
            return typeName + "?"
            
        case .implicitUnwrappedOptional(let type):
            var typeName = typeNameString(for: type)
            if type.requiresSurroundingParens {
                typeName = "(" + typeName + ")"
            }
            
            return typeName + "!"
            
        case .nullabilityUnspecified(let type):
            var typeName = typeNameString(for: type)
            if type.requiresSurroundingParens {
                typeName = "(" + typeName + ")"
            }
            
            return typeName + (isBlockContext ? "?" : "!")
            
        case let .protocolComposition(types):
            return Array(types).map(typeNameString(for:)).joined(separator: " & ")
            
        case let .metatype(type):
            let inner = typeNameString(for: type)
            if type.requiresSurroundingParens {
                return "(" + inner + ").self"
            }
            
            return inner + ".self"
        
        case .tuple(.empty):
            return "Void"
            
        case .tuple(.types(let inner)):
            return "(" + inner.map(typeNameString).joined(separator: ", ") + ")"
            
        case let .nested(types):
            return types.map { typeNameString(for: $0) }.joined(separator: ".")
            
        case .array(let type):
            return "[\(typeNameString(for: type))]"
            
        case let .dictionary(key, value):
            return "[\(typeNameString(for: key)): \(typeNameString(for: value))]"
        }
    }
    
    private func _internalSwiftType(forObjcType type: ObjcType, context: TypeMappingContext) -> SwiftType {
        switch type {
        case .void:
            return .void
            
        case .instancetype:
            let type: SwiftType
            if let instanceType = context.instanceTypeAlias {
                type = instanceType
            } else {
                type = .instancetype
            }
            
            return swiftType(type: type, withNullability: context.nullability())
        
        case .anonymousEnum, .anonymousStruct:
            return swiftType(type: .any, withNullability: context.nullability())
        
        case .typeName(let str):
            return swiftType(forObjcStructType: str, context: context)
            
        case .id(let protocols):
            return swiftType(forIdWithProtocols: protocols, context: context)
            
        case let .genericTypeName(name, parameters):
            return swiftType(forGenericObjcType: name, parameters: parameters, context: context)
            
        case .incompleteStruct(let name):
            return swiftType(forObjcStructType: name, context: context)

        case .pointer(let type, let qualifiers, let nullability):
            let type = swiftType(
                forObjcPointerType: type,
                context: context.withExtraQualifiers(qualifiers)
            )

            if let nullability {
                return swiftType(type: type, replacingNullability: nullability)
            }

            return type
            
        case let .specified(spec, type):
            return swiftType(forObjcType: type, withSpecifiers: spec, context: context)
            
        case let .qualified(type, qualifiers):
            return swiftType(forObjcType: type, withQualifiers: qualifiers, context: context)
        
        case let .nullabilitySpecified(specifier, type):
            let type = swiftType(forObjcType: type)

            if type.isOptional {
                return swiftType(type: type, replacingNullability: specifier)
            }

            return type
            
        case let .blockType(_, returnType, parameters, nullability):
            let type = swiftBlockType(
                forReturnType: returnType,
                parameters: parameters,
                attributes: [],
                context: context
            )

            if let nullability {
                return swiftType(type: type, replacingNullability: nullability)
            }

            return type
            
        case let .functionPointer(_, returnType, parameters):
            return swiftBlockType(
                forReturnType: returnType,
                parameters: parameters,
                attributes: [.convention(.c)],
                context: context
            )
            
        case let .fixedArray(inner, length):
            if length <= 0 {
                return .void
            }
            
            return swiftTuple(type: inner, count: length, context: context)
        }
    }
    
    private func swiftType(forObjcStructType structType: String, context: TypeMappingContext) -> SwiftType {
        // Check scalars first
        if let scalar = DefaultTypeMapper._scalarMappings[structType] {
            return scalar
        }
        
        return _verifyTypeNameCanBeNullable(.typeName(structType), context: context)
    }
    
    private func swiftType(forIdWithProtocols protocols: [String], context: TypeMappingContext) -> SwiftType {
        let type: SwiftType
        
        if protocols.isEmpty {
            type = .anyObject
        } else if protocols.count == 1 {
            type = .typeName(protocols[0])
        } else {
            type = .protocolComposition(.fromCollection(protocols.map { .nominal(.typeName($0)) }))
        }
        
        return swiftType(type: type, withNullability: context.nullability())
    }
    
    private func swiftType(
        forGenericObjcType name: String,
        parameters: [ObjcGenericTypeParameter],
        context: TypeMappingContext
    ) -> SwiftType {
        
        if parameters.isEmpty {
            return .typeName(name)
        }

        let typeParameters = parameters.map(\.type)
        
        // NSArray<> -> Array<> conversion
        if name == "NSArray" && typeParameters.count == 1 {
            let inner =
                swiftType(
                    forObjcType: typeParameters[0],
                    // We pass a non-null context because it's not applicable
                    // to generic types in Objective-C (they always map to non-null).
                    context: context.asAlwaysNonNull().asAlwaysClass()
                )
            
            return .array(inner)
        }
        // NSMutableArray<type> -> NSMutableArray
        if name == "NSMutableArray" && typeParameters.count == 1 {
            return .typeName(name)
        }
        
        // NSDictionary<,> -> Dictionary<,> conversion
        if name == "NSDictionary" && typeParameters.count == 2 {
            let inner0 =
                swiftType(
                    forObjcType: typeParameters[0],
                    // See above
                    context: context.asAlwaysNonNull().asAlwaysClass()
                )
            let inner1 =
                swiftType(
                    forObjcType: typeParameters[1],
                    context: context.asAlwaysNonNull().asAlwaysClass()
                )
            
            return .dictionary(key: inner0, value: inner1)
        }
        
        // NSMutableDictionary<type> -> NSMutableDictionary conversion
        if name == "NSMutableDictionary" && parameters.count == 2 {
            return .typeName(name)
        }
        
        let types =
            typeParameters.map {
                swiftType(
                    forObjcType: $0,
                    context: context.asAlwaysNonNull().asAlwaysClass()
                )
            }
        
        if isPointerOnly(types: typeParameters) {
            return swiftType(genericTypeName: name, parameters: types)
        } else {
            var foundNonNominal = false
            let nominalTypes =
                types.map { type -> NominalSwiftType in
                    switch type {
                    case .nominal(let nominal):
                        return nominal
                    default:
                        foundNonNominal = true
                        return .typeName("Type")
                    }
                }
            
            if foundNonNominal {
                return swiftType(genericTypeName: name, parameters: types)
            }
            
            let composition = nominalTypes.map(ProtocolCompositionComponent.nominal)
            
            return .protocolComposition(.fromCollection([.nominal(.typeName(name))] + composition))
        }
    }
    
    private func swiftType(forObjcPointerType type: ObjcType, context: TypeMappingContext) -> SwiftType {
        let final: SwiftType

        let isConst = context.hasQualifierModifier(.const) || isConstQualified(type)
        let unwrappedType = type.unspecifiedUnqualified

        if case .incompleteStruct = unwrappedType {
            final = "OpaquePointer"
        } else if unwrappedType == .anonymousStruct {
            final = "OpaquePointer"
        } else if let inner = typeNameIn(objcType: unwrappedType) {

            if let ptr = DefaultTypeMapper._pointerMappings[inner] {
                final = ptr
                
            } else if let scalar = DefaultTypeMapper._scalarMappings[inner] {
                // Pointers of scalar types are converted to 'UnsafeMutablePointer<TypeName>'
                final = swiftPointer(parameter: scalar, const: isConst)
                
            } else if context.alwaysClass || typeSystem.isClassInstanceType(inner) {
                // Assume it's a class type here
                final = .typeName(inner)
                
            } else {
                // Pointers of value types are converted to 'UnsafeMutablePointer<TypeName>'
                let pointeeType = swiftType(
                    forObjcType: .typeName(inner),
                    context: .alwaysNonnull
                )
                
                final = swiftPointer(parameter: pointeeType, const: isConst)
            }
        } else if case .void = unwrappedType {
            final = swiftRawPointer(const: isConst)
        } else if case .fixedArray(let base, let length) = unwrappedType {
            let pointee = swiftTuple(type: base, count: length, context: context)
            
            final = swiftPointer(parameter: pointee, const: isConst)
        } else if case .pointer(_, let qualifiers, _) = unwrappedType {
            final = swiftPointer(
                parameter: swiftType(forObjcType: type, context: context),
                const: qualifiers.contains(.const)
            )
        } else {
            final = swiftType(forObjcType: type, context: context)
        }
        
        return swiftType(type: final, withNullability: context.nullability())
    }

    private func swiftPointer(parameter: SwiftType, const: Bool) -> SwiftType {
        if const {
            return swiftType(genericTypeName: "UnsafePointer", parameters: [parameter])
        } else {
            return swiftType(genericTypeName: "UnsafeMutablePointer", parameters: [parameter])
        }
    }

    private func swiftRawPointer(const: Bool) -> SwiftType {
        if const {
            return .typeName("UnsafeRawPointer")
        } else {
            return .typeName("UnsafeMutableRawPointer")
        }
    }
    
    private func swiftType(
        forObjcType type: ObjcType,
        withSpecifiers specifiers: [ObjcTypeSpecifier],
        context: TypeMappingContext
    ) -> SwiftType {
        
        let locSpecifiers = context.withSpecifiers(specifiers)
        
        let final = swiftType(forObjcType: type, context: context.asAlwaysNonNull())
        
        switch type {
        case .void:
            return final
            
        case .typeName:
            return _verifyTypeNameCanBeNullable(final, context: locSpecifiers)
            
        case .qualified:
            return swiftType(forObjcType: type, context: locSpecifiers)
            
        default:
            return swiftType(type: final, withNullability: locSpecifiers.nullability())
        }
    }
    
    private func swiftType(
        forObjcType type: ObjcType,
        withQualifiers qualifiers: [ObjcTypeQualifier],
        context: TypeMappingContext
    ) -> SwiftType {
        
        let locQualifiers = context.withExtraQualifiers(qualifiers)
        
        let final = swiftType(forObjcType: type, context: context.asAlwaysNonNull())
        
        switch type {
        case .void:
            return final
        
        case .typeName, .genericTypeName:
            return _verifyTypeNameCanBeNullable(final, context: locQualifiers)
        
        case .specified,
            .pointer,
            .fixedArray,
            .functionPointer,
            .blockType,
            .nullabilitySpecified:
            return swiftType(forObjcType: type, context: locQualifiers)
        
        default:
            return swiftType(type: final, withNullability: locQualifiers.nullability())
        }
    }
    
    private func _verifyTypeNameCanBeNullable(
        _ type: SwiftType,
        context: TypeMappingContext
    ) -> SwiftType {
        
        if typeSystem.resolveAlias(in: type).isBlock {
            return swiftType(type: type, withNullability: context.nullability())
        }
        
        return type
    }
    
    private func swiftBlockType(
        forReturnType returnType: ObjcType,
        parameters: [ObjcType],
        attributes: Set<BlockTypeAttribute>,
        context: TypeMappingContext
    ) -> SwiftType {
        
        let ctx = context
            .asAlwaysNonNull(isOn: false)
            .withExplicitNullability(nil)
        
        let swiftParameters: [SwiftType]
        
        // 'void' parameter is the same as no parameter list
        if parameters == [.void] {
            swiftParameters = []
        } else {
            swiftParameters = parameters.map {
                swiftType(forObjcType: $0, context: ctx)
            }
        }
        
        let type: SwiftType =
            .block(
                returnType: swiftType(forObjcType: returnType, context: ctx),
                parameters: swiftParameters,
                attributes: attributes
            )
        
        return swiftType(type: type, withNullability: context.nullability())
    }
    
    private func swiftTuple(type: ObjcType, count: Int, context: TypeMappingContext) -> SwiftType {
        swiftTuple(types: .init(repeating: type, count: count), context: context)
    }
    
    private func swiftTuple(types: [ObjcType], context: TypeMappingContext) -> SwiftType {
        let types = types.map {
            swiftType(forObjcType: $0, context: context)
        }
        
        return .tuple(.types(.fromCollection(types)))
    }
    
    private func swiftType(type: SwiftType, withNullability nullability: ObjcNullabilitySpecifier) -> SwiftType {
        switch nullability {
        case .nonnull:
            return type
        case .nullable:
            return .optional(type)
        case .nullResettable:
            return .implicitUnwrappedOptional(type)
        case .nullUnspecified:
            return .nullabilityUnspecified(type)
        }
    }
    
    /// Explicitly replaces the root nullability of a type with a new nullability
    /// kind.
    /// If `type` is an optional type, its optionality is replaced; otherwise
    /// it is wrapped into a optional type specified by `nullability`.
    private func swiftType(type: SwiftType, replacingNullability nullability: ObjcNullabilitySpecifier) -> SwiftType {
        switch type {
        case .optional(let type), .implicitUnwrappedOptional(let type), .nullabilityUnspecified(let type):
            switch nullability {
            case .nonnull:
                return type
            case .nullable:
                return .optional(type)
            case .nullResettable:
                return .implicitUnwrappedOptional(type)
            case .nullUnspecified:
                return .nullabilityUnspecified(type)
            }

        default:
            return swiftType(type: type, withNullability: nullability)
        }
    }

    /// Creates a new generic Swift type name from a specified set of parameters.
    ///
    /// - precondition: `parameters.count > 0`
    private func swiftType(genericTypeName: String, parameters: [SwiftType]) -> SwiftType {
        .generic(genericTypeName, parameters: .fromCollection(parameters))
    }
    
    private func isPointerOnly(types: [ObjcType]) -> Bool {
        if types.isEmpty {
            return false
        }
        
        return types.contains(where: \.isPointer)
    }

    /// Returns `true` if `type` is `const` qualified at its root level.
    private func isConstQualified(_ type: ObjcType) -> Bool {
        switch type {
        case .qualified(let type, let qualifiers):
            if qualifiers.contains(.const) {
                return true
            }

            return isConstQualified(type)

        case .pointer(_, let qualifiers, _):
            return qualifiers.contains(.const)

        case .specified(_, let type), .nullabilitySpecified(_, let type):
            return isConstQualified(type)

        default:
            return false
        }
    }
    
    // TODO: Improve handling of multiple type specifier patterns that map to the
    // same type

    private static let _scalarMappings: [String: SwiftType] = [
        // Objective-C-specific types
        "BOOL": .bool,
        "NSInteger": .int,
        "NSUInteger": .uint,
        "CGFloat": .cgFloat,
        "instancetype": .instancetype,
        
        // C scalar types
        "bool": .bool,
        "char": .typeName("CChar"),
        "signed": .typeName("CInt"),
        "unsigned": .typeName("CUnsignedInt"),
        "unsigned char": .typeName("CUnsignedChar"),
        "unsigned short": .typeName("CUnsignedShort"),
        "unsigned short int": .typeName("CUnsignedShort"),
        "unsigned int": .typeName("CUnsignedInt"),
        "unsigned long": .typeName("CUnsignedLong"),
        "unsigned long int": .typeName("CUnsignedLong"),
        "unsigned long long": .typeName("CUnsignedLongLong"),
        "unsigned long long int": .typeName("CUnsignedLongLong"),
        "signed char": .typeName("CSignedChar"),
        "short": .typeName("CShort"),
        "short int": .typeName("CShort"),
        "signed short": .typeName("CShort"),
        "signed short int": .typeName("CShort"),
        "int": .typeName("CInt"),
        "signed int": .typeName("CInt"),
        "long": .typeName("CLong"),
        "long int": .typeName("CLong"),
        "signed long": .typeName("CLong"),
        "signed long int": .typeName("CLong"),
        "long long": .typeName("CLongLong"),
        "long long int": .typeName("CLongLong"),
        "signed long long": .typeName("CLongLong"),
        "signed long long int": .typeName("CLongLong"),
        "float": .typeName("CFloat"),
        "double": .typeName("CDouble"),
        "long double": .typeName("CDouble"), // TODO: Validate this conversion in Xcode
        "wchar_t": .typeName("CWideChar"),
        "char16_t": .typeName("CChar16"),
        "char32_t": .typeName("CChar32"),
        "Bool": .typeName("CBool"),
        "NSTimeInterval": .typeName("TimeInterval"),
        "NSComparisonResult": .typeName("ComparisonResult")
    ]
    
    /// For mapping pointer-reference structs (could be Objc-C classes) into
    /// known Swift types
    private static let _pointerMappings: [String: SwiftType] = [
        "NSObject": .typeName("NSObject"),
        "NSNumber": .typeName("NSNumber"),
        "NSArray": .typeName("NSArray"),
        "NSMutableArray": .typeName("NSMutableArray"),
        "NSString": .string,
        "NSDate": .typeName("Date"),
        "NSCalendar": .typeName("Calendar"),
        "NSURL": .typeName("URL"),
        "NSURLComponents": .typeName("URLComponents"),
        "NSError": .typeName("Error"),
        "NSIndexPath": .typeName("IndexPath"),
        "NSIndexSet": .typeName("IndexSet"),
        "NSNotificationCenter": .typeName("NotificationCenter"),
        "NSNotification": .typeName("Notification"),
        "NSLocale": .typeName("Locale"),
        "NSTimeZone": .typeName("TimeZone"),
        "NSDateFormatter": .typeName("DateFormatter"),
        "NSNumberFormatter": .typeName("NumberFormatter")
    ]
}
