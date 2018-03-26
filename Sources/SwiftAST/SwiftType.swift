/// Represents a Swift type structure
indirect public enum SwiftType: Equatable {
    case nested(NestedSwiftType)
    case nominal(NominalSwiftType)
    case protocolComposition(ProtocolCompositionSwiftType)
    case tuple(TupleSwiftType)
    case block(returnType: SwiftType, parameters: [SwiftType])
    case metatype(for: SwiftType)
    case optional(SwiftType)
    case implicitUnwrappedOptional(SwiftType)
}

extension SwiftType: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self = .nominal(.typeName(value))
    }
}

/// A nominal Swift type, which is either a plain typename or a generic type.
public enum NominalSwiftType: Equatable {
    case typeName(String)
    case generic(String, parameters: GenericArgumentSwiftType)
}

/// A tuple swift type, which either represents an empty tuple or two or more
/// Swift types.
public enum TupleSwiftType: Equatable {
    case types(TwoOrMore<SwiftType>)
    case empty
}

public typealias ProtocolCompositionSwiftType = TwoOrMore<NominalSwiftType>
public typealias NestedSwiftType = TwoOrMore<NominalSwiftType>
public typealias GenericArgumentSwiftType = OneOrMore<SwiftType>

public extension SwiftType {
    /// If this Swift type is a nominal typename, returns the inner type name as
    /// a string, otherwise returns nil.
    public var typeName: String? {
        switch self {
        case .nominal(.typeName(let name)):
            return name
        default:
            return nil
        }
    }
    
    /// Whether this type requires trailing parenthesis when this type is used
    /// within an optional or metatype.
    public var requiresTrailingParens: Bool {
        switch self {
        case .protocolComposition, .block:
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
        case .nominal(.typeName), .nominal(.generic), .protocolComposition:
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
    
    public static let void = SwiftType.tuple(.empty)
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
        return .nominal(.generic("Array", parameters: .tail(type)))
    }
    
    public static func dictionary(key: SwiftType, value: SwiftType) -> SwiftType {
        return .nominal(.generic("Dictionary", parameters: .list(key, .tail(value))))
    }
    
    public static func typeName(_ name: String) -> SwiftType {
        return .nominal(.typeName(name))
    }
    
    public static func generic(_ name: String, parameters: GenericArgumentSwiftType) -> SwiftType {
        return .nominal(.generic(name, parameters: parameters))
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

extension NominalSwiftType: CustomStringConvertible {
    public var description: String {
        switch self {
        case .typeName(let name):
            return name
            
        case let .generic(name, params):
            let params = Array(params)
            
            switch name {
            case "Array" where params.count == 1:
                return "[" + params[0].description + "]"
                
            case "Dictionary" where params.count == 2:
                return "[\(params[0]): \(params[1])]"
                
            default:
                return name + "<" + params.map { $0.description }.joined(separator: ", ") + ">"
            }
        }
    }
}

extension SwiftType: CustomStringConvertible {
    public var description: String {
        switch self {
        case .nominal(let type):
            return type.description
            
        case let .block(returnType, parameters):
            return "(" + parameters.map { $0.description }.joined(separator: ", ") + ") -> " + returnType.description
            
        case .optional(let type):
            return type.descriptionWithParens + "?"
            
        case .implicitUnwrappedOptional(let type):
            return type.descriptionWithParens + "!"
            
        case let .protocolComposition(types):
            return types.map { $0.description }.joined(separator: " & ")
            
        case let .metatype(innerType):
            return innerType.descriptionWithParens + ".Type"
            
        case .tuple(.empty):
            return "Void"
            
        case let .tuple(.types(inner)):
            return "(" + inner.map { $0.description }.joined(separator: ", ") + ")"
            
        case .nested(let items):
            return items.map { $0.description }.joined(separator: ".")
        }
    }
    
    private var descriptionWithParens: String {
        if requiresTrailingParens {
            return "(\(self))"
        }
        
        return self.description
    }
}

// MARK: - Codable compliance
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

// MARK: - Building structures

/// An enum representing a list of zero or more chained items
public enum ZeroOrMore<T: Equatable>: Equatable {
    indirect case list(T, ZeroOrMore)
    case tail
    
    /// Creates a ZeroOrMore enum list with a given sequence.
    public static func fromSequence<S: Sequence>(_ sequence: S) -> ZeroOrMore where S.Element == T {
        var current = ZeroOrMore.tail
        
        for item in sequence.reversed() {
            current = .list(item, current)
        }
        
        return current
    }
    
    public static var empty: ZeroOrMore {
        return .tail
    }
}

/// An enum representing a list of one or more chained items
public enum OneOrMore<T: Equatable>: Equatable {
    indirect case list(T, OneOrMore)
    case tail(T)
    
    /// Creates a OneOrMore enum list with a given collection.
    /// The collection must have at least one element.
    ///
    /// - precondition: Collection is not empty
    public static func fromCollection<C>(_ collection: C) -> OneOrMore where C: BidirectionalCollection, C.Element == T {
        precondition(!collection.isEmpty)
        
        var current = OneOrMore.tail(collection.last!)
        
        for item in collection.dropLast().reversed() {
            current = .list(item, current)
        }
        
        return current
    }
    
    public static func one(_ value: T) -> OneOrMore {
        return .tail(value)
    }
}

/// An enum representing a list of two or more chained items
public enum TwoOrMore<T: Equatable>: Equatable {
    indirect case list(T, TwoOrMore)
    case tail(T, T)
    
    /// Creates a TwoOrMore enum list with a given collection.
    /// The collection must have at least two elements.
    ///
    /// - precondition: `collection.count >= 2`
    public static func fromCollection<C>(_ collection: C) -> TwoOrMore where C: BidirectionalCollection, C.Element == T, C.Index == Int {
        precondition(collection.count >= 2)
        
        var current = TwoOrMore.tail(collection[collection.count - 2], collection[collection.count - 1])
        
        for item in collection.dropLast(2).reversed() {
            current = .list(item, current)
        }
        
        return current
    }
    
    public static func two(_ value1: T, _ value2: T) -> TwoOrMore {
        return .tail(value1, value2)
    }
}

// MARK: Sequence protocol conformances

extension ZeroOrMore: Sequence {
    public func makeIterator() -> Iterator {
        return Iterator(current: self)
    }
    
    public struct Iterator: IteratorProtocol {
        private var current: ZeroOrMore
        
        init(current: ZeroOrMore) {
            self.current = current
        }
        
        public mutating func next() -> T? {
            switch current {
            case let .list(item, next):
                current = next
                
                return item
            case .tail:
                return nil
            }
        }
    }
}

extension OneOrMore: Sequence {
    public func makeIterator() -> Iterator {
        return Iterator(current: self)
    }
    
    public struct Iterator: IteratorProtocol {
        private var current: OneOrMore?
        
        init(current: OneOrMore?) {
            self.current = current
        }
        
        public mutating func next() -> T? {
            switch current {
            case let .list(item, next)?:
                current = next
                
                return item
            case .tail(let item)?:
                current = nil
                
                return item
            case nil:
                return nil
            }
        }
    }
}

extension TwoOrMore: Sequence {
    public func makeIterator() -> Iterator {
        return Iterator(current: self)
    }
    
    public struct Iterator: IteratorProtocol {
        private var current: TwoOrMore?
        private var rem: T?
        
        init(current: TwoOrMore?) {
            self.current = current
        }
        
        public mutating func next() -> T? {
            switch current {
            case let .list(item, next)?:
                current = next
                
                return item
            case .tail(let item, let next)?:
                current = nil
                
                rem = next
                
                return item
            case nil:
                defer {
                    rem = nil
                }
                
                return rem
            }
        }
    }
}

// MARK: Array initialization

extension ZeroOrMore: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: T...) {
        self = .fromSequence(elements)
    }
}

extension OneOrMore: ExpressibleByArrayLiteral {
    /// Initializes a OneOrMore list with a given array of items.
    ///
    /// - Parameter elements: Elements to create the array out of.
    /// - precondition: At least one array element must be provided
    public init(arrayLiteral elements: T...) {
        self = .fromCollection(elements)
    }
}

extension TwoOrMore: ExpressibleByArrayLiteral {
    /// Initializes a TwoOrMore list with a given array of items.
    ///
    /// - Parameter elements: Elements to create the list out of.
    /// - precondition: At least two array elements must be provided.
    public init(arrayLiteral elements: T...) {
        self = .fromCollection(elements)
    }
}
