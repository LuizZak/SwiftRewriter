/// Represents a Swift type
indirect public enum SwiftType: Equatable {
    public var requiresParens: Bool {
        switch self {
        case .protocolComposition(let types) where types.count > 1:
            return true
        case .block:
            return true
        default:
            return false
        }
    }
    
    /// Returns `true` if this type is a block type
    public var isBlock: Bool {
        switch self {
        case .block:
            return true
        default:
            return false
        }
    }
    
    /// Returns `true` if this type is either an optional or implicitly unwrapped
    /// optional.
    public var isOptional: Bool {
        switch self {
        case .optional, .implicitUnwrappedOptional:
            return true
        default:
            return false
        }
    }
    
    public var isMetatype: Bool {
        switch self {
        case .metatype:
            return true
        default:
            return false
        }
    }
    
    public var isImplicitlyUnwrapped: Bool {
        switch self {
        case .implicitUnwrappedOptional:
            return true
        default:
            return false
        }
    }
    
    /// Returns `true` if this type represents a nominal type.
    /// Blocks and meta-types are not considered nominal types, whereas any other
    /// type is considered nominal.
    public var isNominal: Bool {
        switch self {
        case .block, .metatype:
            return false
        default:
            return true
        }
    }
    
    /// If this type is an `.optional` or `.implicitUnwrappedOptional` type, returns
    /// an unwrapped version of self.
    /// The return is unwrapped only once.
    public var unwrapped: SwiftType {
        switch self {
        case .optional(let type), .implicitUnwrappedOptional(let type):
            return type
        default:
            return self
        }
    }
    
    /// If this type is an `.optional` or `.implicitUnwrappedOptional` type, returns
    /// an unwrapped version of self.
    /// The return is then recursively unwrapped again until a non-optional base
    /// type is reached.
    public var deepUnwrapped: SwiftType {
        switch self {
        case .optional(let type), .implicitUnwrappedOptional(let type):
            return type.deepUnwrapped
        default:
            return self
        }
    }
    
    /// Returns `self` wrapped over an `.optional` case.
    public var asOptional: SwiftType {
        return .optional(self)
    }
    
    /// Returns `self` wrapped over an `.implicitUnwrappedOptional` case.
    public var asImplicitUnwrapped: SwiftType {
        return .implicitUnwrappedOptional(self)
    }
    
    /// Returns this type, wrapped in the same optionality depth as another given
    /// type.
    ///
    /// In case the other type is not an optional type, returns this type with
    /// no optionality laters.
    public func withSameOptionalityAs(_ type: SwiftType) -> SwiftType {
        return type.wrappingOther(self.deepUnwrapped)
    }
    
    /// In case this type represents an optional value, returns a new optional type
    /// with the same optionality as this type, but wrapping over a given type.
    ///
    /// If this type is not optional, `type` is returned, instead.
    ///
    /// Lookup is deep, and returns the same optionality chain as this type's.
    private func wrappingOther(_ type: SwiftType) -> SwiftType {
        switch self {
        case .optional(let inner):
            return .optional(inner.wrappingOther(type))
        case .implicitUnwrappedOptional(let inner):
            return .implicitUnwrappedOptional(inner.wrappingOther(type))
        default:
            return type
        }
    }
    
    case typeName(String)
    case optional(SwiftType)
    case implicitUnwrappedOptional(SwiftType)
    case generic(String, parameters: [SwiftType])
    case protocolComposition([SwiftType])
    case block(returnType: SwiftType, parameters: [SwiftType])
    case metatype(for: SwiftType)
    
    public static let void = SwiftType.typeName("Void")
    public static let int = SwiftType.typeName("Int")
    public static let uint = SwiftType.typeName("UInt")
    public static let string = SwiftType.typeName("String")
    public static let bool = SwiftType.typeName("Bool")
    public static let float = SwiftType.typeName("Float")
    public static let double = SwiftType.typeName("Double")
    public static let cgFloat = SwiftType.typeName("CGFloat")
    public static let any = SwiftType.typeName("Any")
    public static let anyObject = SwiftType.typeName("AnyObject")
    
    public static let selector = SwiftType.typeName("Selector")
    
    public static let nsArray = SwiftType.typeName("NSArray")
    public static let nsDictionary = SwiftType.typeName("NSDictionary")
    
    /// A special type name to use to represent instancetype's from Objective-C.
    public static let instancetype = SwiftType.typeName("__instancetype")
    
    /// A special type used in place of definitions with improper typing
    public static let errorType = SwiftType.typeName("<<error type>>")
    
    public static func array(_ type: SwiftType) -> SwiftType {
        return .generic("Array", parameters: [type])
    }
    
    public static func dictionary(key: SwiftType, value: SwiftType) -> SwiftType {
        return .generic("Dictionary", parameters: [key, value])
    }
}

/// Defines the ownership of a variable storage
public enum Ownership: String, Equatable {
    case strong
    case weak
    case unownedSafe = "unowned(safe)"
    case unownedUnsafe = "unowned(unsafe)"
}

extension SwiftType: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .block(returnType, parameters):
            return "(" + parameters.map { $0.description }.joined(separator: ", ") + ") -> " + returnType.description
        case .typeName(let name):
            return name
        case .optional(let type):
            return type.descriptionWithParens + "?"
        case .implicitUnwrappedOptional(let type):
            return type.descriptionWithParens + "!"
        case let .generic(type, parameters):
            return type + "<" + parameters.map { $0.description }.joined(separator: ", ") + ">"
        case let .protocolComposition(types):
            return types.map { $0.descriptionWithParens }.joined(separator: " & ")
        case let .metatype(innerType):
            return innerType.descriptionWithParens + ".self"
        }
    }
    
    private var descriptionWithParens: String {
        if requiresParens {
            return "(\(self))"
        }
        
        return self.description
    }
}
