/// Represents a Swift type structure
indirect public enum SwiftType: Hashable {
    case nested(NestedSwiftType)
    case nominal(NominalSwiftType)
    case protocolComposition(ProtocolCompositionSwiftType)
    case tuple(TupleSwiftType)
    case block(returnType: SwiftType, parameters: [SwiftType], attributes: Set<BlockTypeAttribute>)
    case metatype(for: SwiftType)
    case optional(SwiftType)
    case implicitUnwrappedOptional(SwiftType)
    case nullabilityUnspecified(SwiftType)
}

extension SwiftType: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self = .nominal(.typeName(value))
    }
}

/// A nominal Swift type, which is either a plain typename or a generic type.
public enum NominalSwiftType: Hashable {
    case typeName(String)
    case generic(String, parameters: GenericArgumentSwiftType)
}

extension NominalSwiftType: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self = .typeName(value)
    }
}

/// A component for a protocol composition
public enum ProtocolCompositionComponent: Hashable {
    case nominal(NominalSwiftType)
    case nested(NestedSwiftType)
}

/// A tuple swift type, which either represents an empty tuple or two or more
/// Swift types.
public enum TupleSwiftType: Hashable {
    case types(TwoOrMore<SwiftType>)
    case empty
}

/// An attribute for block types.
public enum BlockTypeAttribute: Hashable, CustomStringConvertible {
    public var description: String {
        switch self {
        case .autoclosure:
            return "@autoclosure"
            
        case .escaping:
            return "@escaping"
            
        case .convention(let c):
            return "@convention(\(c.rawValue))"
        }
    }
    
    case autoclosure
    case escaping
    case convention(Convention)
    
    public enum Convention: String, Hashable {
        case block
        case c
    }
}

public typealias ProtocolCompositionSwiftType = TwoOrMore<ProtocolCompositionComponent>
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
    
    /// Returns `true` if this type is either an optional, an implicitly unwrapped
    /// optional, or a 'nullability-unspecified' optional.
    public var isOptional: Bool {
        switch self {
        case .optional, .implicitUnwrappedOptional, .nullabilityUnspecified:
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
    
    public var canBeImplicitlyUnwrapped: Bool {
        switch self {
        case .implicitUnwrappedOptional, .nullabilityUnspecified:
            return true
        default:
            return false
        }
    }
    
    public var isNullabilityUnspecified: Bool {
        switch self {
        case .nullabilityUnspecified:
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
        case .optional(let type),
             .implicitUnwrappedOptional(let type),
             .nullabilityUnspecified(let type):
            return type
            
        default:
            return self
        }
    }
    
    /// If this type is an `.optional` or `.implicitUnwrappedOptional` type,
    /// returns an unwrapped version of self.
    /// The return is then recursively unwrapped again until a non-optional base
    /// type is reached.
    public var deepUnwrapped: SwiftType {
        switch self {
        case .optional(let type),
             .implicitUnwrappedOptional(let type),
             .nullabilityUnspecified(let type):
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
    
    /// Returns `self` wrapped over an `.nullabilityUnspecified` case.
    public var asNullabilityUnspecified: SwiftType {
        return .nullabilityUnspecified(self)
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
        case .nullabilityUnspecified(let inner):
            return .nullabilityUnspecified(inner.wrappingOther(type))
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
    
    public static func openRange(_ operand: SwiftType) -> SwiftType {
        return .nominal(.generic("Range", parameters: .tail(operand)))
    }
    
    public static func closedRange(_ operand: SwiftType) -> SwiftType {
        return .nominal(.generic("ClosedRange", parameters: .tail(operand)))
    }
    
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
    
    public static func swiftBlock(returnType: SwiftType, parameters: [SwiftType]) -> SwiftType {
        return .block(returnType: returnType, parameters: parameters, attributes: [])
    }
    
    /// Returns a type that is the same as the input, but with any .optional or
    /// .implicitUnwrappedOptional types unwrapped to non optional, inclusing
    /// block parameters.
    ///
    /// - Parameters:
    ///   - type: The input type
    ///   - removeImplicitsOnly: Whether to only remove implicit unwrapped optionals,
    /// keeping optionals in place.
    /// - Returns: The deeply unwrapped version of the input type.
    public static func asNonnullDeep(_ type: SwiftType,
                                     removeUnspecifiedsOnly: Bool = false) -> SwiftType {
        
        var result: SwiftType = type
        
        if removeUnspecifiedsOnly {
            if case .nullabilityUnspecified(let inner) = type {
                result = inner
            }
        } else {
            result = type.deepUnwrapped
        }
        
        switch result {
        case let .block(returnType, parameters, attributes):
            let returnType =
                asNonnullDeep(returnType,
                              removeUnspecifiedsOnly: removeUnspecifiedsOnly)
            
            let parameters = parameters.map {
                asNonnullDeep($0, removeUnspecifiedsOnly: removeUnspecifiedsOnly)
            }
            
            result = .block(returnType: returnType,
                            parameters: parameters,
                            attributes: attributes)
            
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
    
    public var typeNameValue: String {
        switch self {
        case .typeName(let typeName),
             .generic(let typeName, _):
            
            return typeName
        }
    }
}

extension ProtocolCompositionComponent: CustomStringConvertible {
    public var description: String {
        switch self {
        case .nested(let items):
            return items.map { $0.description }.joined(separator: ".")
        case .nominal(let nominal):
            return nominal.description
        }
    }
    
    public static func typeName(_ name: String) -> ProtocolCompositionComponent {
        return .nominal(.typeName(name))
    }
}

extension SwiftType: CustomStringConvertible {
    public var description: String {
        switch self {
        case .nominal(let type):
            return type.description
            
        case let .block(returnType, parameters, attributes):
            let sortedAttributes =
                attributes.sorted { $0.description < $1.description }
            
            let attributeString = 
                sortedAttributes.map { $0.description }.joined(separator: " ")
            
            return
                (attributeString.isEmpty ? "" : attributeString + " ")
                + "("
                + parameters.map { $0.description }.joined(separator: ", ")
                + ") -> "
                + returnType.description
            
        case .optional(let type):
            return type.descriptionWithParens + "?"
            
        case .implicitUnwrappedOptional(let type):
            return type.descriptionWithParens + "!"
            
        case .nullabilityUnspecified(let type):
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
public typealias ZeroOrMore<T> = [T]

/// An enum representing a list of one or more chained items
public enum OneOrMore<T> {
    indirect case list(T, OneOrMore)
    case tail(T)
    
    /// Returns the item contained on this `OneOrMore` list node.
    public var item: T {
        switch self {
        case .list(let item, _), .tail(let item):
            return item
        }
    }
    
    /// Returns the number of items on this `OneOrMore` list.
    ///
    /// Due to semantics of this list type, this value is always `>= 1`.
    public var count: Int {
        switch self {
        case .list(_, let next):
            return 1 + next.count
            
        case .tail:
            return 1
        }
    }
    
    /// Creates a OneOrMore enum list with a given collection.
    /// The collection must have at least one element.
    ///
    /// - precondition: Collection is not empty
    public static func fromCollection<C>(_ collection: C) -> OneOrMore
        where C: BidirectionalCollection, C.Element == T {
        
        precondition(!collection.isEmpty)
        
        var current = OneOrMore.tail(collection.last!)
        
        for item in collection.dropLast().reversed() {
            current = .list(item, current)
        }
        
        return current
    }
    
    /// Shortcut for creating a `OneOrMore` list with a single item
    public static func one(_ value: T) -> OneOrMore {
        return .tail(value)
    }
}

/// An enum representing a list of two or more chained items
public enum TwoOrMore<T> {
    indirect case list(T, TwoOrMore)
    case tail(T, T)
    
    /// Returns the number of items on this `TwoOrMore` list.
    ///
    /// Due to semantics of this list type, this value is always `>= 2`.
    public var count: Int {
        switch self {
        case .list(_, let next):
            return 1 + next.count
            
        case .tail:
            return 2
        }
    }
    
    /// Creates a TwoOrMore enum list with a given collection.
    /// The collection must have at least two elements.
    ///
    /// - precondition: `collection.count >= 2`
    public static func fromCollection<C>(_ collection: C) -> TwoOrMore
        where C: BidirectionalCollection, C.Element == T, C.Index == Int {
        
        precondition(collection.count >= 2)
        
        var current = TwoOrMore.tail(collection[collection.count - 2],
                                     collection[collection.count - 1])
        
        for item in collection.dropLast(2).reversed() {
            current = .list(item, current)
        }
        
        return current
    }
    
    /// Shortcut for creating a `TwoOrMore` list with two given items
    public static func two(_ value1: T, _ value2: T) -> TwoOrMore {
        return .tail(value1, value2)
    }
}

// MARK: Sequence protocol conformances
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
            case let .tail(item, next)?:
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

// MARK: Collection conformance
extension OneOrMore: Collection {
    public func index(after i: Int) -> Int {
        precondition(i < endIndex)
        return i + 1
    }
    
    public var startIndex: Int {
        return 0
    }
    
    public var endIndex: Int {
        switch self {
        case .list(_, let next):
            return next.endIndex + 1
        case .tail:
            return 1
        }
    }
    
    public subscript(position: Int) -> T {
        precondition(position >= 0, "position >= 0")
        
        if position == 0 {
            switch self {
            case .list(let item, _),
                 .tail(let item):
                return item
            }
        }
        
        switch self {
        case .list(_, let next):
            return next[position - 1]
        case .tail:
            fatalError("Exceeded index")
        }
    }
}

extension OneOrMore {
    public var first: T {
        return self[0]
    }
    public var last: T {
        return self[count - 1]
    }
}

extension TwoOrMore: Collection {
    public func index(after i: Int) -> Int {
        precondition(i < endIndex)
        return i + 1
    }
    
    public var startIndex: Int {
        return 0
    }
    
    public var endIndex: Int {
        switch self {
        case .list(_, let next):
            return next.endIndex + 1
        case .tail:
            return 2
        }
    }
    
    public subscript(position: Int) -> T {
        precondition(position >= 0, "position >= 0")
        
        if position == 0 {
            switch self {
            case .list(let item, _),
                 .tail(let item, _):
                return item
            }
        } else if position == 1 {
            switch self {
            case .list(_, let next):
                return next[position - 1]
            case .tail(_, let right):
                return right
            }
        }
        
        switch self {
        case .list(_, let next):
            return next[position - 1]
        case .tail:
            fatalError("Exceeded index")
        }
    }
}
extension TwoOrMore {
    public var first: T {
        return self[0]
    }
    public var last: T {
        return self[count - 1]
    }
}

// MARK: Equatable conditional conformance
extension OneOrMore: Equatable where T: Equatable {
}
extension OneOrMore: Hashable where T: Hashable {
}

extension TwoOrMore: Equatable where T: Equatable {
}
extension TwoOrMore: Hashable where T: Hashable {
}

// MARK: Array initialization
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
