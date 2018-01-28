/// Specifies an objetive-c type for a property or local.
/// For objc class pointers, they are always specified as pointers to structs,
/// like `.pointerType(.structType("NSObject"))`
public enum ObjcType: Equatable, CustomStringConvertible {
    /// Objective-c's `id` type, with optional protocol array specifiers
    case id(protocols: [String])
    
    /// A struct-type.
    /// May be any type that is not an `id`.
    case `struct`(String)
    
    /// A special `void` type that indicates an empty value.
    case void
    
    /// A composed pointer, like `NSObject*` or `int*`.
    /// May be an objc class or a struct-type pointer.
    indirect case pointer(ObjcType)
    
    /// A generic objc type- e.g. `NSArray<NSNumber*>`
    indirect case generic(String, parameters: [ObjcType])
    
    /// An Objc type that has associated pointer qualifiers, such as `NSObject *_Nonnull`,
    /// which is a pointer to a struct NSObject with _Nonnull qualifier.
    indirect case qualified(ObjcType, qualifiers: [String])
    
    /// An Objc type that has associated specifiers, such as `__weak NSObject*`,
    /// which is a __weak-tagged type of a pointer to a struct NSObject.
    indirect case specified(specifiers: [String], ObjcType)
    
    /// Gets the plain string definition for this type.
    /// Always maps to valid objc type
    public var description: String {
        switch self {
        case .void:
            return "void"
        case .struct(let s):
            return s
        case let .generic(cl, parameters):
            let typeNames = parameters.map { $0.description }.joined(separator: ", ")
            
            if typeNames.count > 0 {
                return "\(cl)<\(typeNames)>"
            } else {
                return cl
            }
        case .id(let protocols):
            if protocols.count > 0 {
                let protocolNames = protocols.joined(separator: ", ")
                return "id<\(protocolNames)>"
            } else {
                return "id"
            }
        case .pointer(let type):
            return "\(type.description)*"
        case let .qualified(type, qualifiers):
            return "\(type.description) \(qualifiers.joined(separator: " "))"
        case let .specified(specifiers, type):
            return "\(specifiers.joined(separator: " ")) \(type.description)"
        }
    }
    
    /// Returns a normalized type for this type.
    /// Normalizes qualified types with empty qualifiers to their base type.
    public var normalized: ObjcType {
        switch self {
        case let .pointer(ptr):
            return ptr.normalized
        case let .generic(type, parameters):
            return .generic(type, parameters: parameters.map { $0.normalized })
        case let .qualified(type, qualifiers) where qualifiers.isEmpty:
            return type.normalized
        case let .specified(specifiers, type) where specifiers.isEmpty:
            return type.normalized
        default:
            return self
        }
    }
}
