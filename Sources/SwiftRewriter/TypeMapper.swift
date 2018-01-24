import GrammarModels

/// Provides type-transforming support for a Swift rewritter
public class TypeMapper {
    let context: TypeContext
    
    public init(context: TypeContext) {
        self.context = context
    }
    
    public func swiftType(forObjcType type: ObjcType, context: TypeMappingContext = .empty) -> String {
        switch type {
        case .struct(let str):
            return swiftType(forObjcStructType: str, context: context)
            
        case .id(let protocols):
            return swiftType(forIdWithProtocols: protocols, context: context)
            
        case let .generic(name, parameters):
            return swiftType(forGenericObjcType: name, parameters: parameters, context: context)
            
        case .pointer(let type):
            return swiftType(forObjcPointerType: type, context: context)
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
                          context: .alwaysNonnull) // We do not pass context because
                                                   // it's not appliable to generic types
            
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
        public static let empty = TypeMappingContext(modifiers: nil, alwaysNonnull: false)
        
        /// Gets a type mapping context that always maps to a non-null type
        public static let alwaysNonnull = TypeMappingContext(modifiers: nil, alwaysNonnull: true)
        
        /// Modifiers fetched from a @property declaraion
        public var modifiers: ObjcClassInterface.PropertyModifierList?
        
        public var alwaysNonnull: Bool
        
        public init(modifiers: ObjcClassInterface.PropertyModifierList?) {
            self.modifiers = modifiers
            self.alwaysNonnull = false
        }
        
        public init(modifiers: ObjcClassInterface.PropertyModifierList?, alwaysNonnull: Bool) {
            self.modifiers = modifiers
            self.alwaysNonnull = alwaysNonnull
        }
        
        /// Returns whether a modified with a given name can be found within this
        /// type mapping context
        public func hasPropertyModifier(named name: String) -> Bool {
            guard let mods = modifiers?.modifiers else {
                return false
            }
            
            return mods.first { $0.name == name } != nil
        }
        
        /// Returns whether any of the @property modifiers is a `nonnull` modifier
        public func hasNonnullModifier() -> Bool {
            return hasPropertyModifier(named: "nonnull")
        }
        
        /// Returns whether any of the @property modifiers is a `nullable` modifier
        public func hasNullableModifier() -> Bool {
            return hasPropertyModifier(named: "nullable")
        }
        
        /// Returns whether any of the @property modifiers is a `null_unspecified`
        /// modifier
        public func hasUnspecifiedNullabilityModifier() -> Bool {
            return hasPropertyModifier(named: "null_unspecified")
        }
        
        /// Gets the nullability for the current type context
        public func nullability() -> TypeNullability {
            if alwaysNonnull {
                return .nonnull
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
