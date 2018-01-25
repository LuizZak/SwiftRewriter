import GrammarModels

/// Provides type-transforming support for a Swift rewritter
public class TypeMapper {
    let context: TypeContext
    
    public init(context: TypeContext) {
        self.context = context
    }
    
    public func swiftType(forObjcType type: ObjcType, context: TypeMappingContext = .empty) -> String {
        switch type {
        case .void:
            return "Void"
            
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
        }
    }
    
    private func swiftType(forObjcStructType structType: String, context: TypeMappingContext) -> String {
        // Check scalars first
        if let scalar = TypeMapper._scalarMappings[structType] {
            return scalar
        }
        
        return "<unkown scalar type>"
    }
    
    private func swiftType(forIdWithProtocols protocols: [String], context: TypeMappingContext) -> String {
        return "<unknown id<protocols>>"
    }
    
    private func swiftType(forGenericObjcType name: String, parameters: [ObjcType], context: TypeMappingContext) -> String {
        // Array conversion
        if name == "NSArray" && parameters.count == 1 {
            let inner =
                swiftType(forObjcType: parameters[0],
                          // We pass a non-null context because it's not appliable
                          // to generic types in Objective-C (they always map to non-null).
                          context: context.asAlwaysNonNull())
            
            return "[\(inner)]"
        }
        
        return "<unknown generic \(name)>"
    }
    
    private func swiftType(forObjcPointerType type: ObjcType, context: TypeMappingContext) -> String {
        let final: String
        
        if case .struct(let inner) = type {
            if let ptr = TypeMapper._pointerMappings[inner] {
                final = ptr
            } else {
                // Assume it's a class type here
                final = inner
            }
            
            return swiftType(name: final, withNullability: context.nullability())
        }
        
        final = swiftType(forObjcType: type, context: context)
        
        return swiftType(name: final, withNullability: context.nullability())
    }
    
    private func swiftType(name: String, withNullability nullability: TypeNullability) -> String {
        switch nullability {
        case .nonnull:
            return name
        case .nullable:
            return name + "?"
        case .nullResettable, .unspecified:
            return name + "!"
        }
    }
    
    private func swiftType(forObjcType type: ObjcType, withSpecifiers specifiers: [String], context: TypeMappingContext) -> String {
        let final = swiftType(forObjcType: type, context: context)
        
        return swiftType(name: final, withNullability: context.nullability())
    }
    
    private func swiftType(forObjcType type: ObjcType, withQualifiers qualifiers: [String], context: TypeMappingContext) -> String {
        let locQualifiers = context.withQualifiers(qualifiers)
        
        let final = swiftType(forObjcType: type, context: context.asAlwaysNonNull())
        
        return swiftType(name: final, withNullability: locQualifiers.nullability())
    }
    
    private static let _scalarMappings: [String: String] = [
        "BOOL": "Bool",
        "NSInteger": "Int",
        "NSUInteger": "UInt",
        "CGFloat": "CGFloat"
    ]
    
    /// For mapping pointer-reference structs (could be Objc-C classes) into
    /// known Swift types
    private static let _pointerMappings: [String: String] = [
        "NSObject": "NSObject",
        "NSNumber": "NSNumber",
        "NSArray": "NSArray",
        "NSString": "String"
    ]
    
    /// Contexts used during type mapping.
    public struct TypeMappingContext {
        /// Gets an empty type mapping context
        public static let empty = TypeMappingContext(modifiers: nil, qualifiers: [], alwaysNonnull: false)
        
        /// Gets a type mapping context that always maps to a non-null type
        public static let alwaysNonnull = TypeMappingContext(modifiers: nil, qualifiers: [], alwaysNonnull: true)
        
        /// Modifiers fetched from a @property declaraion
        public var modifiers: PropertyModifierList?
        /// Nullability specifiers from a method definition's type decl
        public var nullabilitySpecifiers: [NullabilitySpecifier] = []
        
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
        
        public init(modifiers: PropertyModifierList?) {
            self.modifiers = modifiers
        }
        
        public init(modifiers: PropertyModifierList?, qualifiers: [String], alwaysNonnull: Bool) {
            self.modifiers = modifiers
            self.qualifiers = qualifiers
            self.alwaysNonnull = alwaysNonnull
        }
        
        public init(explicitNullability: TypeNullability) {
            self.explicitNullability = explicitNullability
        }
        
        public init(nullabilitySpecs: [NullabilitySpecifier], alwaysNonnull: Bool = false) {
            self.nullabilitySpecifiers = nullabilitySpecs
            self.alwaysNonnull = alwaysNonnull
        }
        
        public func asAlwaysNonNull() -> TypeMappingContext {
            var copy = self
            copy.alwaysNonnull = true
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
            guard let mods = modifiers?.modifiers else {
                return false
            }
            
            return mods.contains { $0.name == name }
        }
        
        /// Returns whether a type qualifier with a given name can be found within
        /// this type mapping context
        public func hasQualifierModifier(named name: String) -> Bool {
            return qualifiers.contains(name)
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
        }
        
        /// Returns whether any of the @property modifiers is a `nullable` modifier,
        /// or it the type pointer within has a `_Nullable` specifier.
        public func hasNullableModifier() -> Bool {
            return hasPropertyModifier(named: "nullable")
                || hasMethodNullabilitySpecifier(named: "nullable")
                || hasQualifierModifier(named: "_Nullable")
        }
        
        /// Returns whether any of the @property modifiers is a `null_unspecified`
        /// modifier
        /// or it the type pointer within has a `_Null_unspecified` specifier.
        public func hasUnspecifiedNullabilityModifier() -> Bool {
            return hasPropertyModifier(named: "null_unspecified")
                || hasMethodNullabilitySpecifier(named: "null_unspecified")
                || hasQualifierModifier(named: "_Null_unspecified")
        }
        
        /// Gets the nullability for the current type context
        public func nullability() -> TypeNullability {
            if alwaysNonnull {
                return .nonnull
            }
            
            if let explicit = explicitNullability {
                return explicit
            }
            
            if hasNonnullModifier() {
                return .nonnull
            }
            if hasNullableModifier() {
                return .nullable
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
    case nullResettable // Only applicable to Obj-c @properties
}
