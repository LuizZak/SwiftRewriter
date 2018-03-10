import SwiftAST
import GrammarModels

/// Provides type-transforming support for a Swift rewritter
public protocol TypeMapper {
    func typeNameString(for swiftType: SwiftType) -> String
    func typeNameString(for objcType: ObjcType, context: TypeMappingContext) -> String
    func swiftType(forObjcType type: ObjcType, context: TypeMappingContext) -> SwiftType
}

public extension TypeMapper {
    func typeNameString(for objcType: ObjcType) -> String {
        return typeNameString(for: objcType, context: .empty)
    }
    func swiftType(forObjcType type: ObjcType) -> SwiftType {
        return swiftType(forObjcType: type, context: .empty)
    }
}

/// Contexts used during type mapping.
public struct TypeMappingContext {
    /// Gets an empty type mapping context
    public static let empty = TypeMappingContext(modifiers: nil, qualifiers: [], alwaysNonnull: false)
    
    /// Gets a type mapping context that always maps to a non-null type
    public static let alwaysNonnull = TypeMappingContext(modifiers: nil, qualifiers: [], alwaysNonnull: true)
    
    /// Modifiers fetched from a @property declaraion
    public var modifiers: PropertyAttributesList?
    /// Nullability specifiers from a method definition's type decl
    public var nullabilitySpecifiers: [NullabilitySpecifier] = []
    
    /// If true, every struct pointer found is considered to be an Objective-C
    /// class instance.
    public var alwaysClass: Bool = false
    
    /// If true, always infers `nonnull` for otherwise unspecified nullability
    /// cases.
    public var inNonnullContext: Bool = false
    
    /// Objc type specifiers from a type name.
    /// See `ObjcType` for more information.
    public var specifiers: [String] = []
    
    /// Objc type qualifiers from a type name.
    /// See `ObjcType` for more information.
    public var qualifiers: [String] = []
    
    /// If `true`, all requests for nullability from this context object will
    /// result in `TypeNullability.nonnull` being returned.
    /// Used when traversing nested Objc generic types, which do not support
    /// nullability annotations.
    public var alwaysNonnull: Bool = false
    
    /// If non-nil, this explicit nullability specifier is used for all requests
    /// for nullability.
    ///
    /// Is overriden by `alwaysNonnull`.
    public var explicitNullability: TypeNullability?
    
    public init(modifiers: PropertyAttributesList?, specifiers: [String] = [],
                qualifiers: [String] = [], alwaysNonnull: Bool = false,
                inNonnull: Bool = false) {
        self.modifiers = modifiers
        self.specifiers = specifiers
        self.qualifiers = qualifiers
        self.alwaysNonnull = alwaysNonnull
        self.inNonnullContext = inNonnull
    }
    
    public init(explicitNullability: TypeNullability?, inNonnull: Bool = false) {
        self.explicitNullability = explicitNullability
        self.inNonnullContext = inNonnull
    }
    
    public init(nullabilitySpecs: [NullabilitySpecifier], alwaysNonnull: Bool = false,
                inNonnull: Bool = false) {
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
    
    public func withSpecifiers(_ specifiers: [String]) -> TypeMappingContext {
        var copy = self
        copy.specifiers = specifiers
        return copy
    }
    
    public func withQualifiers(_ qualifiers: [String]) -> TypeMappingContext {
        var copy = self
        copy.qualifiers = qualifiers
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
    public func hasQualifierModifier(named name: String) -> Bool {
        return qualifiers.contains(name)
    }
    
    /// Returns whether a type specifier with a given name can be found within
    /// this type mapping context
    public func hasSpecifierModifier(named name: String) -> Bool {
        return specifiers.contains(name)
    }
    
    /// Returns whether a type-signature nullability specifier with a given
    /// name can be found within this type mapping context
    public func hasMethodNullabilitySpecifier(named name: String) -> Bool {
        return nullabilitySpecifiers.contains { $0.name == name }
    }
    
    /// Returns whether any of the @property modifiers is a `nonnull` modifier,
    /// or it the type pointer within has a `_Nonnull` specifier.
    public func hasNonnullModifier() -> Bool {
        return hasPropertyModifier(named: "nonnull")
            || hasMethodNullabilitySpecifier(named: "nonnull")
            || hasQualifierModifier(named: "_Nonnull")
            || hasSpecifierModifier(named: "nonnull")
    }
    
    /// Returns whether any of the @property modifiers is a `nullable` modifier,
    /// or it the type pointer within has a `_Nullable` specifier.
    public func hasNullableModifier() -> Bool {
        return hasPropertyModifier(named: "nullable")
            || hasMethodNullabilitySpecifier(named: "nullable")
            || hasQualifierModifier(named: "_Nullable")
            || hasSpecifierModifier(named: "nullable")
    }
    
    /// Returns whether any of the @property modifiers is a `null_unspecified`
    /// modifier
    /// or it the type pointer within has a `_Null_unspecified` specifier.
    public func hasUnspecifiedNullabilityModifier() -> Bool {
        return hasPropertyModifier(named: "null_unspecified")
            || hasMethodNullabilitySpecifier(named: "null_unspecified")
            || hasQualifierModifier(named: "_Null_unspecified")
            || hasSpecifierModifier(named: "null_unspecified")
    }
    
    /// Gets the nullability for the current type context
    public func nullability() -> TypeNullability {
        if alwaysNonnull {
            return .nonnull
        }
        
        if let explicit = explicitNullability {
            return explicit
        }
        
        // Weak assumes nullable
        if hasSpecifierModifier(named: "__weak") || hasPropertyModifier(named: "weak") {
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
        
        return .unspecified
    }
}

public class DefaultTypeMapper: TypeMapper {
    let context: TypeConstructionContext
    
    public init(context: TypeConstructionContext) {
        self.context = context
    }
    
    public func typeNameString(for swiftType: SwiftType) -> String {
        switch swiftType {
        case let .block(returnType, parameters):
            return
                "(" + parameters.map(typeNameString(for:)).joined(separator: ", ")
                    + ") -> "
                    + typeNameString(for: returnType)
            
        case .typeName(let name):
            return name
            
        case .optional(let type):
            var typeName = typeNameString(for: type)
            if type.requiresParens {
                typeName = "(" + typeName + ")"
            }
            
            return typeName + "?"
            
        case .implicitUnwrappedOptional(let type):
            var typeName = typeNameString(for: type)
            if type.requiresParens {
                typeName = "(" + typeName + ")"
            }
            
            return typeName + "!"
            
        // Simplify known generic types
        case .generic("Array", let parameters) where parameters.count == 1:
            return "[" + typeNameString(for: parameters[0]) + "]"
        case .generic("Dictionary", let parameters) where parameters.count == 2:
            return "[" + typeNameString(for: parameters[0]) + ": " + typeNameString(for: parameters[1]) + "]"
            
        case let .generic(type, parameters):
            return type + "<" + parameters.map(typeNameString(for:)).joined(separator: ", ") + ">"
            
        case let .protocolComposition(types):
            return types.map(typeNameString(for:)).joined(separator: " & ")
            
        case let .metatype(type):
            let inner = typeNameString(for: type)
            if type.requiresParens {
                return "(" + inner + ").self"
            }
            
            return inner + ".self"
        }
    }
    
    public func typeNameString(for objcType: ObjcType, context: TypeMappingContext) -> String {
        let type = swiftType(forObjcType: objcType, context: context)
        return typeNameString(for: type)
    }
    
    public func swiftType(forObjcType type: ObjcType, context: TypeMappingContext) -> SwiftType {
        switch type {
        case .void:
            return .void
            
        case .instancetype:
            return swiftType(type: .instancetype, withNullability: context.nullability())
            
        case .struct(let str):
            return swiftType(forObjcStructType: str, context: context)
            
        case .id(let protocols):
            return swiftType(forIdWithProtocols: protocols, context: context)
            
        case let .generic(name, parameters):
            return swiftType(forGenericObjcType: name, parameters: parameters, context: context)
            
        case .pointer(let type):
            return swiftType(forObjcPointerType: type, context: context)
            
        case let .specified(spec, type):
            return swiftType(forObjcType: type, withSpecifiers: spec, context: context)
            
        case let .qualified(type, qualifiers):
            return swiftType(forObjcType: type, withQualifiers: qualifiers, context: context)
            
        case let .blockType(_, returnType, parameters):
            return swiftBlockType(forReturnType: returnType, parameters: parameters, context: context)
        }
    }
    
    private func swiftType(forObjcStructType structType: String, context: TypeMappingContext) -> SwiftType {
        // Check scalars first
        if let scalar = DefaultTypeMapper._scalarMappings[structType] {
            return scalar
        }
        
        return .typeName(structType)
    }
    
    private func swiftType(forIdWithProtocols protocols: [String], context: TypeMappingContext) -> SwiftType {
        let type: SwiftType
        
        if protocols.count == 0 {
            type = .anyObject
        } else {
            type = .protocolComposition(protocols.map { .typeName($0) })
        }
        
        return swiftType(type: type, withNullability: context.nullability())
    }
    
    private func swiftType(forGenericObjcType name: String, parameters: [ObjcType], context: TypeMappingContext) -> SwiftType {
        if parameters.count == 0 {
            return .typeName(name)
        }
        
        // NSArray<> -> Array<> conversion
        if name == "NSArray" && parameters.count == 1 {
            let inner =
                swiftType(forObjcType: parameters[0],
                          // We pass a non-null context because it's not appliable
                          // to generic types in Objective-C (they always map to non-null).
                          context: context.asAlwaysNonNull().asAlwaysClass())
            
            return .array(inner)
        }
        // NSMutableArray<type> -> NSMutableArray
        if name == "NSMutableArray" && parameters.count == 1 {
            return .typeName(name)
        }
        
        // NSDictionary<,> -> Dictionary<,> conversion
        if name == "NSDictionary" && parameters.count == 2 {
            let inner0 =
                swiftType(forObjcType: parameters[0],
                          // See above
                          context: context.asAlwaysNonNull().asAlwaysClass())
            let inner1 =
                swiftType(forObjcType: parameters[1],
                          context: context.asAlwaysNonNull().asAlwaysClass())
            
            return .dictionary(key: inner0, value: inner1)
        }
        
        // NSMutableDictionary<type> -> NSMutableDictionary conversion
        if name == "NSMutableDictionary" && parameters.count == 2 {
            return .typeName(name)
        }
        
        let types =
            parameters.map {
                swiftType(forObjcType: $0,
                          context: context.asAlwaysNonNull().asAlwaysClass())
            }
        
        if isPointerOnly(types: parameters) {
            return .generic(name, parameters: types)
        } else {
            return .protocolComposition([.typeName(name)] + types)
        }
    }
    
    private func swiftType(forObjcPointerType type: ObjcType, context: TypeMappingContext) -> SwiftType {
        let final: SwiftType
        
        if case .struct(let inner) = type {
            if let ptr = DefaultTypeMapper._pointerMappings[inner] {
                final = ptr
            } else if let scalar = DefaultTypeMapper._scalarMappings[inner] {
                // Pointers of scalar types are converted to 'UnsafeMutablePointer<TypeName>'
                final = .generic("UnsafeMutablePointer", parameters: [scalar])
            } else if self.context.typeSystem.isClassInstanceType(inner) || context.alwaysClass {
                // Assume it's a class type here
                final = .typeName(inner)
            } else {
                // Pointers of value types are converted to 'UnsafeMutablePointer<TypeName>'
                let pointeeType = swiftType(forObjcType: .struct(inner), context: .alwaysNonnull)
                
                final = .generic("UnsafeMutablePointer", parameters: [pointeeType])
            }
            
            return swiftType(type: final, withNullability: context.nullability())
        }
        
        final = swiftType(forObjcType: type, context: context)
        
        return swiftType(type: final, withNullability: context.nullability())
    }
    
    private func swiftType(type: SwiftType, withNullability nullability: TypeNullability) -> SwiftType {
        switch nullability {
        case .nonnull:
            return type
        case .nullable:
            return .optional(type)
        case .nullResettable, .unspecified:
            return .implicitUnwrappedOptional(type)
        }
    }
    
    private func swiftType(forObjcType type: ObjcType, withSpecifiers specifiers: [String], context: TypeMappingContext) -> SwiftType {
        let locSpecifiers = context.withSpecifiers(specifiers)
        
        let final = swiftType(forObjcType: type, context: context.asAlwaysNonNull())
        
        switch type {
        case .struct, .void:
            return final; // <- Semicolon needed to avoid a parse error
            
        case .qualified:
            return swiftType(forObjcType: type, context: locSpecifiers)
            
        default:
            return swiftType(type: final, withNullability: locSpecifiers.nullability())
        }
    }
    
    private func swiftType(forObjcType type: ObjcType, withQualifiers qualifiers: [String], context: TypeMappingContext) -> SwiftType {
        let locQualifiers = context.withQualifiers(qualifiers)
        
        let final = swiftType(forObjcType: type, context: context.asAlwaysNonNull())
        
        switch type {
        case .struct, .void:
            return final; // <- Semicolon needed to avoid a parse error
            
        case .specified:
            return swiftType(forObjcType: type, context: locQualifiers)
            
        default:
            return swiftType(type: final, withNullability: locQualifiers.nullability())
        }
    }
    
    private func swiftBlockType(forReturnType returnType: ObjcType, parameters: [ObjcType], context: TypeMappingContext) -> SwiftType {
        let type: SwiftType =
            .block(returnType: swiftType(forObjcType: returnType, context: context.asAlwaysNonNull(isOn: false)),
                   parameters: parameters.map { swiftType(forObjcType: $0) })
        
        return swiftType(type: type, withNullability: context.nullability())
    }
    
    private func isPointerOnly(types: [ObjcType]) -> Bool {
        if types.count == 0 {
            return false
        }
        
        for type in types {
            if !type.isPointer {
                return false
            }
        }
        
        return true
    }
    
    private static let _scalarMappings: [String: SwiftType] = [
        // Objective-C-specific types
        "BOOL": .bool,
        "NSInteger": .int,
        "NSUInteger": .uint,
        "CGFloat": .cgFloat,
        "instancetype": .instancetype,
        
        // C scalar types
        "char": .typeName("CChar"),
        "unsigned char": .typeName("CUnsignedChar"),
        "unsigned short": .typeName("CUnsignedShort"),
        "unsigned int": .typeName("CUnsignedInt"),
        "unsigned long": .typeName("CUnsignedLong"),
        "unsigned long long": .typeName("CUnsignedLongLong"),
        "signed char": .typeName("CSignedChar"),
        "short": .typeName("CShort"),
        "int": .typeName("CInt"),
        "long": .typeName("CLong"),
        "long long": .typeName("CLongLong"),
        "float": .typeName("CFloat"),
        "double": .typeName("CDouble"),
        "wchar_t": .typeName("CWideChar"),
        "char16_t": .typeName("CChar16"),
        "char32_t": .typeName("CChar32"),
        "Bool": .typeName("CBool"),
        "NSTimeInterval": .typeName("TimeInterval")
    ]
    
    /// For mapping pointer-reference structs (could be Objc-C classes) into
    /// known Swift types
    private static let _pointerMappings: [String: SwiftType] = [
        "NSObject": .typeName("NSObject"),
        "NSNumber": .typeName("NSNumber"),
        "NSArray": .typeName("NSArray"),
        "NSMutableArray": .typeName("NSMutableArray"),
        "NSString": .string,
        "NSDate": .typeName("Date")
    ]
}

/// One of the possible nullability specifiers that can be found in Objective-C
public enum TypeNullability {
    case nonnull
    case nullable
    case unspecified
    case nullResettable // Only applicable to Obj-C @properties
}
