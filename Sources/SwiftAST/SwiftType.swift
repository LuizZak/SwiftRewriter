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
    
    /// Returns a normalized version of this type, getting rid of redundancies.
    public var normalized: SwiftType {
        switch self {
        // Normalizations
            
        // Protocol compositions of a single type should be decomposed into the
        // singular type
        case .protocolComposition(let comp) where comp.count == 1:
            return comp[0].normalized
            
        // Protocol compositions with directly nested protocol compositions should
        // be unwrapped into a single composed protocol composition
        case .protocolComposition(let inner) where inner.contains(where: { $0.isProtocolComposition }):
            let normalizedInner = inner.flatMap { type -> [SwiftType] in
                switch type {
                case .protocolComposition(let inner):
                    return inner.map { $0.normalized }
                default:
                    return [type]
                }
            }
            
            return SwiftType.protocolComposition(normalizedInner).normalized
            
        // Generic types with no parameters should be made non-generic
        case let .generic(name, params) where params.isEmpty:
            return .typeName(name)
            
        // Tuples of one type should be unwrapped as the single type
        case .tuple(let values) where values.count == 1:
            return values[0].normalized
            
        // Nested type non-normalization
        case let .nested(.nested(nll, nlr), .nested(nrl, nrr)):
            return
                SwiftType.nested(
                    SwiftType.nested(
                        SwiftType.nested(
                            nll.normalized, nlr.normalized),
                        nrl).normalized,
                    nrr).normalized
            
        // Nested type normalization
        case let .nested(nonNested, .nested(nl, nr)):
            return SwiftType.nested(SwiftType.nested(nonNested, nl).normalized,
                                    nr.normalized).normalized
            
        // Nested normalizations
        case .protocolComposition(let subtypes):
            return .protocolComposition(subtypes.map { $0.normalized })
        case let .generic(name, subtypes):
            return .generic(name, parameters: subtypes.map { $0.normalized })
        case .tuple(let subtypes):
            return .tuple(subtypes.map { $0.normalized })
        case let .block(returnType, parameters):
            return .block(returnType: returnType.normalized,
                          parameters: parameters.map({ $0.normalized }))
        case .metatype(let inner):
            return .metatype(for: inner.normalized)
        case .optional(let inner):
            return .optional(inner.normalized)
        case .implicitUnwrappedOptional(let inner):
            return .implicitUnwrappedOptional(inner.normalized)
        case .nested(let base, let type):
            return .nested(base.normalized, type.normalized)
        default:
            return self
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
    /// Except for blocks, metatypes and tuples, all types are considered nominal
    /// types.
    public var isNominal: Bool {
        switch self {
        case .block, .metatype, .tuple:
            return false
        default:
            return true
        }
    }
    
    /// Returns `true` iff this SwiftType is a `.protocolComposition` case.
    public var isProtocolComposition: Bool {
        switch self {
        case .protocolComposition:
            return true
        default:
            return false
        }
    }
    
    /// Returns `true` if this type is a `.typeName`, a `.genericTypeName`, or a
    /// `.protocolComposition` type.
    public var isProtocolComposable: Bool {
        switch self {
        case .typeName, .generic, .protocolComposition:
            return true
        default:
            return false
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
    /// no optionality.
    public func withSameOptionalityAs(_ type: SwiftType) -> SwiftType {
        return type.wrappingOther(self.deepUnwrapped)
    }
    
    /// In case this type represents an optional value, returns a new optional
    /// type with the same optionality as this type, but wrapping over a given
    /// type.
    ///
    /// If this type is not optional, `type` is returned, instead.
    ///
    /// Lookup is deep, and returns the same optionality chain as this type's.
    public func wrappingOther(_ type: SwiftType) -> SwiftType {
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
    case tuple([SwiftType])
    case nested(SwiftType, SwiftType)
    
    public static let void = SwiftType.tuple([])
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
    
    /// Returns a type that is the same as the input, but with any .optional or
    /// .implicitUnwrappedOptional types unwrapped to non optional, inclusing
    /// block parameters.
    ///
    /// - Parameter type: The input type
    /// - Returns: The deeply unwrapped version of the input type.
    public static func asNonnullDeep(_ type: SwiftType) -> SwiftType {
        var result = type.deepUnwrapped
        
        switch result {
        case let .block(returnType, parameters):
            result = .block(returnType: asNonnullDeep(returnType),
                            parameters: parameters.map(asNonnullDeep))
        default:
            break
        }
        
        return result
    }
}

extension SwiftType: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self = .typeName(value)
    }
}

/// Defines the ownership of a variable storage
public enum Ownership: String, Equatable, Codable {
    case strong
    case weak
    case unownedSafe = "unowned(safe)"
    case unownedUnsafe = "unowned(unsafe)"
}

extension SwiftType: CustomStringConvertible {
    public var description: String {
        switch self {
        case .typeName(let name):
            return name
            
        case let .block(returnType, parameters):
            return "(" + parameters.map { $0.description }.joined(separator: ", ") + ") -> " + returnType.description
            
        case .optional(let type):
            return type.descriptionWithParens + "?"
            
        case .implicitUnwrappedOptional(let type):
            return type.descriptionWithParens + "!"
            
        case .generic("Array", let params) where params.count == 1:
            return "[" + params[0].description + "]"
            
        case .generic("Dictionary", let params) where params.count == 2:
            return "[\(params[0]): \(params[1])]"
            
        case let .generic(type, parameters):
            return type + "<" + parameters.map { $0.description }.joined(separator: ", ") + ">"
            
        case let .protocolComposition(types):
            return types.map { $0.descriptionWithParens }.joined(separator: " & ")
            
        case let .metatype(innerType):
            return innerType.descriptionWithParens + ".Type"
            
        case .tuple([]):
            return "Void"
            
        case let .tuple(inner):
            return "(" + inner.map { $0.description }.joined(separator: ", ") + ")"
            
        case let .nested(outer, inner):
            return "\(outer).\(inner)"
        }
    }
    
    private var descriptionWithParens: String {
        if requiresParens {
            return "(\(self))"
        }
        
        return self.description
    }
}

extension SwiftType: Codable {
    public init(from decoder: Decoder) throws {
        let string: String
        
        if decoder.codingPath.isEmpty {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            string = try container.decode(String.self, forKey: .type)
        } else {
            let container = try decoder.singleValueContainer()
            string = try container.decode(String.self)
        }
        
        self = try SwiftTypeParser.parse(from: string)
    }
    
    public func encode(to encoder: Encoder) throws {
        if encoder.codingPath.isEmpty {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(description, forKey: .type)
        } else {
            var container = encoder.singleValueContainer()
            try container.encode(description)
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case type
    }
}
