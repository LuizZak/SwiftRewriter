import SwiftAST
import GrammarModels

/// Provides type-transforming support for a Swift rewritter
public class TypeMapper {
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
    
    public func typeNameString(for objcType: ObjcType, context: TypeMappingContext = .empty) -> String {
        let type = swiftType(forObjcType: objcType, context: context)
        return typeNameString(for: type)
    }
    
    public func swiftType(forObjcType type: ObjcType, context: TypeMappingContext = .empty) -> SwiftType {
        switch type {
        case .void:
            return .void
            
        case .instancetype:
            return swiftType(type: .anyObject, withNullability: context.nullability())
            
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
        if let scalar = TypeMapper._scalarMappings[structType] {
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
                          context: context.asAlwaysNonNull())
            
            return .array(inner)
        }
        
        // NSDictionary<,> -> Dictionary<,> conversion
        if name == "NSDictionary" && parameters.count == 2 {
            let inner0 =
                swiftType(forObjcType: parameters[0],
                          // See above
                          context: context.asAlwaysNonNull())
            let inner1 =
                swiftType(forObjcType: parameters[1],
                          context: context.asAlwaysNonNull())
            
            return .dictionary(key: inner0, value: inner1)
        }
        
        let types =
            parameters.map {
                swiftType(forObjcType: $0,
                          context: context.asAlwaysNonNull())
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
            if let ptr = TypeMapper._pointerMappings[inner] {
                final = ptr
            } else {
                // Assume it's a class type here
                final = .typeName(inner)
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
            return final;
            
        case .qualified:
            return swiftType(forObjcType: type, context: locSpecifiers)
            
        default:
            return swiftType(type: final, withNullability: locSpecifiers.nullability())
        }
    }
    
    private func swiftType(forObjcType type: ObjcType, withQualifiers qualifiers: [String], context: TypeMappingContext) -> SwiftType {
        let locQualifiers = context.withQualifiers(qualifiers)
        
        let final = swiftType(forObjcType: type, context: context.asAlwaysNonNull())
        
        return
            swiftType(type: final, withNullability: locQualifiers.nullability())
    }
    
    private func swiftBlockType(forReturnType returnType: ObjcType, parameters: [ObjcType], context: TypeMappingContext) -> SwiftType {
        return .block(returnType: swiftType(forObjcType: returnType, context: context),
                      parameters: parameters.map { swiftType(forObjcType: $0) })
    }
    
    private func shouldParenthesize(type: ObjcType) -> Bool {
        switch type {
        case .generic(_, let params):
            return !isPointerOnly(types: params)
        case .pointer(let inner):
            return shouldParenthesize(type: inner)
        default:
            return false
        }
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
        "BOOL": .bool,
        "NSInteger": .int,
        "NSUInteger": .uint,
        "int": .int,
        "float": .float,
        "double": .double,
        "CGFloat": .cgFloat,
        // TODO: Create a special SwiftType case for `instancetype` types, as it
        // is its own thing in Objective-C and better means the dynamic instance
        // type of the class it is situated in.
        "instancetype": .anyObject
    ]
    
    /// For mapping pointer-reference structs (could be Objc-C classes) into
    /// known Swift types
    private static let _pointerMappings: [String: SwiftType] = [
        "NSObject": .typeName("NSObject"),
        "NSNumber": .typeName("NSNumber"),
        "NSArray": .typeName("NSArray"),
        "NSMutableArray": .typeName("NSMutableArray"),
        "NSString": .string
    ]
    
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
        
        public func asAlwaysNonNull() -> TypeMappingContext {
            var copy = self
            copy.alwaysNonnull = true
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
}

/// One of the possible nullability specifiers that can be found in Objective-C
public enum TypeNullability {
    case nonnull
    case nullable
    case unspecified
    case nullResettable // Only applicable to Obj-C @properties
}
