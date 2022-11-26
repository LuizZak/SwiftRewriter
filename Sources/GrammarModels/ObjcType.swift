/// Specifies an objetive-c type for a property or local.
/// For objc class pointers, they are always specified as pointers to structs,
/// like `.pointerType(.structType("NSObject"))`
public enum ObjcType: Equatable, Codable, CustomStringConvertible {
    /// Objective-c's `id` type, with optional protocol array specifiers
    case id(protocols: [String] = [])
    
    /// Special 'generic'-like specifier.
    /// Closely related to `id` type.
    case instancetype
    
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
    
    /// An objective-C block type.
    /// Block types may specify names, or not (in case of block literals).
    indirect case blockType(name: String? = nil, returnType: ObjcType, parameters: [ObjcType] = [])
    
    /// A C function pointer.
    /// Function pointer types may specify names, or not (in case of pointer literals).
    indirect case functionPointer(name: String? = nil, returnType: ObjcType, parameters: [ObjcType] = [])
    
    /// A fixed array type
    indirect case fixedArray(ObjcType, length: Int)
    
    /// Gets the plain string definition for this type.
    /// Always maps to valid objc type
    public var description: String {
        switch self {
        case .instancetype:
            return "instancetype"
            
        case .void:
            return "void"
            
        case .struct(let s):
            return s
            
        case let .generic(cl, parameters):
            let typeNames = parameters.map(\.description).joined(separator: ", ")
            
            if !typeNames.isEmpty {
                return "\(cl)<\(typeNames)>"
            } else {
                return cl
            }
            
        case .id(let protocols):
            if !protocols.isEmpty {
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
            
        case let .blockType(name, returnType, parameters):
            return "\(returnType)(^\(name ?? ""))(\(parameters.map(\.description).joined(separator: ", ")))"
            
        case let .functionPointer(name, returnType, parameters):
            return "\(returnType)(*\(name ?? ""))(\(parameters.map(\.description).joined(separator: ", ")))"
            
        case let .fixedArray(type, length):
            return "\(type)[\(length)]"
        }
    }
    
    /// Returns true if this is a pointer type
    public var isPointer: Bool {
        switch self {
        case .pointer, .id, .instancetype, .blockType, .functionPointer, .fixedArray:
            return true
            
        case .specified(_, let type):
            return type.isPointer
            
        case .qualified(let type, _):
            return type.isPointer
            
        default:
            return false
        }
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let discriminator = try container.decode(Discriminator.self, forKey: .discriminator)
        
        switch discriminator {
        case .id:
            self = .id(protocols: try container.decode([String].self, forKey: .payload0))
            
        case .instancetype:
            self = .instancetype
            
        case .struct:
            self = .struct(try container.decode(String.self, forKey: .payload0))
            
        case .void:
            self = .void
            
        case .pointer:
            self = .pointer(try container.decode(ObjcType.self, forKey: .payload0))
            
        case .generic:
            let name = try container.decode(String.self, forKey: .payload0)
            let parameters = try container.decode([ObjcType].self, forKey: .payload1)
            
            self = .generic(name, parameters: parameters)
            
        case .qualified:
            let type = try container.decode(ObjcType.self, forKey: .payload0)
            let qualifiers = try container.decode([String].self, forKey: .payload1)
            
            self = .qualified(type, qualifiers: qualifiers)
            
        case .specified:
            let specifiers = try container.decode([String].self, forKey: .payload0)
            let type = try container.decode(ObjcType.self, forKey: .payload1)
            
            self = .specified(specifiers: specifiers, type)
            
        case .blockType:
            let name = try container.decodeIfPresent(String.self, forKey: .payload0)
            let returnType = try container.decode(ObjcType.self, forKey: .payload1)
            let parameters = try container.decode([ObjcType].self, forKey: .payload2)
            
            self = .blockType(name: name, returnType: returnType, parameters: parameters)
            
        case .functionPointer:
            let name = try container.decodeIfPresent(String.self, forKey: .payload0)
            let returnType = try container.decode(ObjcType.self, forKey: .payload1)
            let parameters = try container.decode([ObjcType].self, forKey: .payload2)
            
            self = .functionPointer(name: name, returnType: returnType, parameters: parameters)
            
        case .fixedArray:
            let type = try container.decode(ObjcType.self, forKey: .payload0)
            let length = try container.decode(Int.self, forKey: .payload1)
            
            self = .fixedArray(type, length: length)
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case .id(let protocols):
            try container.encode(Discriminator.id, forKey: .discriminator)
            try container.encode(protocols, forKey: .payload0)
            
        case .instancetype:
            try container.encode(Discriminator.instancetype, forKey: .discriminator)
            
        case .struct(let name):
            try container.encode(Discriminator.struct, forKey: .discriminator)
            try container.encode(name, forKey: .payload0)
            
        case .void:
            try container.encode(Discriminator.void, forKey: .discriminator)
            
        case .pointer(let type):
            try container.encode(Discriminator.pointer, forKey: .discriminator)
            try container.encode(type, forKey: .payload0)
            
        case let .generic(name, parameters):
            try container.encode(Discriminator.generic, forKey: .discriminator)
            try container.encode(name, forKey: .payload0)
            try container.encode(parameters, forKey: .payload1)
            
        case let .qualified(name, qualifiers):
            try container.encode(Discriminator.qualified, forKey: .discriminator)
            try container.encode(name, forKey: .payload0)
            try container.encode(qualifiers, forKey: .payload1)
            
        case let .specified(specifiers, name):
            try container.encode(Discriminator.specified, forKey: .discriminator)
            try container.encode(specifiers, forKey: .payload0)
            try container.encode(name, forKey: .payload1)
            
        case let .blockType(name, returnType, parameters):
            try container.encode(Discriminator.blockType, forKey: .discriminator)
            try container.encodeIfPresent(name, forKey: .payload0)
            try container.encode(returnType, forKey: .payload1)
            try container.encode(parameters, forKey: .payload2)
            
        case let .functionPointer(name, returnType, parameters):
            try container.encode(Discriminator.functionPointer, forKey: .discriminator)
            try container.encodeIfPresent(name, forKey: .payload0)
            try container.encode(returnType, forKey: .payload1)
            try container.encode(parameters, forKey: .payload2)
            
        case let .fixedArray(type, length):
            try container.encode(Discriminator.fixedArray, forKey: .discriminator)
            try container.encode(type, forKey: .payload0)
            try container.encode(length, forKey: .payload1)
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case discriminator
        case payload0
        case payload1
        case payload2
    }
    
    private enum Discriminator: String, Codable {
        case id
        case instancetype
        case `struct`
        case void
        case pointer
        case generic
        case qualified
        case specified
        case blockType
        case functionPointer
        case fixedArray
    }
}

extension ObjcType: ExpressibleByStringLiteral {
    /// Initializes a `ObjcType.struct()` case with the given string literal
    /// as its type.
    public init(stringLiteral value: String) {
        if value == "void" {
            self = .void
        } else {
            self = .struct(value)
        }
    }
}
