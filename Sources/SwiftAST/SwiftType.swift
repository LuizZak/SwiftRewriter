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
    
    public var isNullable: Bool {
        switch self {
        case .optional, .implicitUnwrappedOptional:
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
    
    case typeName(String)
    case optional(SwiftType)
    case implicitUnwrappedOptional(SwiftType)
    case generic(String, parameters: [SwiftType])
    case protocolComposition([SwiftType])
    case block(returnType: SwiftType, parameters: [SwiftType])
    
    public static var void = SwiftType.typeName("Void")
    public static var int = SwiftType.typeName("Int")
    public static var uint = SwiftType.typeName("UInt")
    public static var string = SwiftType.typeName("String")
    public static var bool = SwiftType.typeName("Bool")
    public static var float = SwiftType.typeName("Float")
    public static var double = SwiftType.typeName("Double")
    public static var cgFloat = SwiftType.typeName("CGFloat")
    public static var any = SwiftType.typeName("Any")
    public static var anyObject = SwiftType.typeName("AnyObject")
    
    public static var nsArray = SwiftType.typeName("NSArray")
    public static var nsDictionary = SwiftType.typeName("NSDictionary")
    
    /// A special type used in place of definitions with improper typing
    public static var errorType = SwiftType.typeName("<<error type>>")
    
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
        }
    }
    
    internal var descriptionWithParens: String {
        if requiresParens {
            return "(\(self))"
        }
        
        return self.description
    }
}
