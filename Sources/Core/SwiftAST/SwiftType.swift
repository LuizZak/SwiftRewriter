/// Represents a Swift type structure
public indirect enum SwiftType: Hashable {
    case nested(NestedSwiftType)
    case nominal(NominalSwiftType)
    case protocolComposition(ProtocolCompositionSwiftType)
    case tuple(TupleSwiftType)
    case block(BlockSwiftType)
    case metatype(for: SwiftType)
    case optional(SwiftType)
    case implicitUnwrappedOptional(SwiftType)
    case nullabilityUnspecified(SwiftType)
    case array(SwiftType)
    case dictionary(key: SwiftType, value: SwiftType)
}

extension SwiftType: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self = .nominal(.typeName(value))
    }
}

/// A nominal Swift type, which is either a plain typename or a generic type.
public enum NominalSwiftType: Hashable {
    case typeName(String)
    indirect case generic(String, parameters: GenericArgumentSwiftType)
}

extension NominalSwiftType: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self = .typeName(value)
    }
}

/// A component for a protocol composition
public indirect enum ProtocolCompositionComponent: Hashable {
    case nominal(NominalSwiftType)
    case nested(NestedSwiftType)
}

/// A tuple swift type, which either represents an empty tuple or two or more
/// Swift types.
public enum TupleSwiftType: Hashable {
    /// An empty tuple type, or `Void`.
    case empty

    /// A tuple type containing two or more types.
    indirect case types(TwoOrMore<SwiftType>)

    /// Returns the array of types that compose this tuple type.
    public var elementTypes: [SwiftType] {
        switch self {
        case .empty:
            return []
        case .types(let types):
            return Array(types)
        }
    }
}

extension TupleSwiftType: ExpressibleByArrayLiteral {
    /// - precondition: `elements.isEmpty || elements.count >= 2`
    public init(arrayLiteral elements: SwiftType...) {
        if elements.isEmpty {
            self = .empty
        }

        self = .types(.fromCollection(elements))
    }
}

extension TupleSwiftType: Collection {
    public var startIndex: Int {
        0
    }

    public var endIndex: Int {
        switch self {
        case .empty:
            return 1
        case .types(let types):
            return types.count
        }
    }

    public subscript(index: Int) -> SwiftType {
        switch self {
        case .empty:
            fatalError("Index is out of bounds for TupleSwiftType.empty: \(index)")

        case .types(let types):
            return types[index]
        }
    }

    public func index(after i: Int) -> Int {
        i + 1
    }
}

/// A type that describes a Swift function.
public struct BlockSwiftType: Hashable, CustomStringConvertible {
    /// The return type for this block type.
    public var returnType: SwiftType

    /// The type for each parameter for this block type.
    public var parameters: [SwiftType]

    /// A set of attributes that decorate this block type.
    public var attributes: Set<BlockTypeAttribute> = []

    public var description: String {
        let sortedAttributes = attributes.sorted {
            $0.description < $1.description
        }
        
        let attributeString = sortedAttributes
            .map(\.description)
            .joined(separator: " ")
        
        let parameterList = parameters
            .map(\.description)
            .joined(separator: ", ")
        
        return (attributeString.isEmpty ? "" : attributeString + " ")
            + "("
            + parameterList
            + ") -> "
            + returnType.description
    }

    public init(
        returnType: SwiftType,
        parameters: [SwiftType],
        attributes: Set<BlockTypeAttribute> = []
    ) {
        
        self.returnType = returnType
        self.parameters = parameters
        self.attributes = attributes
    }
    
    public static func swiftBlock(
        returnType: SwiftType,
        parameters: [SwiftType] = []
    ) -> BlockSwiftType {

        .init(returnType: returnType, parameters: parameters, attributes: [])
    }
    
    /// Returns a block type that is the same as the input, but with any .optional
    /// or .implicitUnwrappedOptional types unwrapped to non optional, including
    /// any block parameters.
    ///
    /// - Parameters:
    ///   - type: The input block type
    ///   - removeUnspecifiedNullabilityOnly: Whether to only remove unspecified
    /// nullability optionals, keeping optionals in place.
    /// - Returns: The deeply unwrapped version of the input block type.
    public static func asNonnullDeep(
        type: BlockSwiftType,
        removeUnspecifiedNullabilityOnly: Bool = false
    ) -> BlockSwiftType {

        let returnType = SwiftType.asNonnullDeep(
            type.returnType,
            removeUnspecifiedNullabilityOnly: removeUnspecifiedNullabilityOnly
        )
        
        let parameters = type.parameters.map {
            SwiftType.asNonnullDeep(
                $0,
                removeUnspecifiedNullabilityOnly: removeUnspecifiedNullabilityOnly
            )
        }
        
        return .init(
            returnType: returnType,
            parameters: parameters,
            attributes: type.attributes
        )
    }
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
    var typeName: String? {
        switch self {
        case .nominal(.typeName(let name)):
            return name
        default:
            return nil
        }
    }
    
    /// If this Swift type is a nominal typename, returns the inner type name as
    /// a string, and if it's a nested type, returns the last nominal type's name
    var lastNominalTypeName: String? {
        switch self {
        case .nominal(.typeName(let name)):
            return name
        case .nested(let names):
            return names.last.typeNameValue
        default:
            return nil
        }
    }
    
    /// Whether this type requires surrounding parenthesis when this type is used
    /// within an optional or metatype.
    var requiresSurroundingParens: Bool {
        switch self {
        case .protocolComposition, .block:
            return true
        default:
            return false
        }
    }
    
    /// Returns `true` if this type is a block type
    var isBlock: Bool {
        switch self {
        case .block:
            return true
        default:
            return false
        }
    }
    
    /// Returns `true` if this type is either an optional, an implicitly unwrapped
    /// optional, or a 'nullability-unspecified' optional.
    var isOptional: Bool {
        switch self {
        case .optional, .implicitUnwrappedOptional, .nullabilityUnspecified:
            return true
        default:
            return false
        }
    }
    
    var isMetatype: Bool {
        switch self {
        case .metatype:
            return true
        default:
            return false
        }
    }
    
    var isImplicitlyUnwrapped: Bool {
        switch self {
        case .implicitUnwrappedOptional:
            return true
        default:
            return false
        }
    }
    
    var canBeImplicitlyUnwrapped: Bool {
        switch self {
        case .implicitUnwrappedOptional, .nullabilityUnspecified:
            return true
        default:
            return false
        }
    }
    
    var isNullabilityUnspecified: Bool {
        switch self {
        case .nullabilityUnspecified:
            return true
        default:
            return false
        }
    }
    
    /// Returns `true` if this type represents a nominal type.
    /// Except for blocks, meta-types and tuples, all types are considered nominal
    /// types.
    var isNominal: Bool {
        switch self {
        case .block, .metatype, .tuple:
            return false
        default:
            return true
        }
    }
    
    /// Returns `true` iff this SwiftType is a `.protocolComposition` case.
    var isProtocolComposition: Bool {
        switch self {
        case .protocolComposition:
            return true
        default:
            return false
        }
    }
    
    /// Returns `true` if this type is a `.typeName`, a `.genericTypeName`, or a
    /// `.protocolComposition` type.
    var isProtocolComposable: Bool {
        switch self {
        case .nominal(.typeName), .nominal(.generic), .protocolComposition:
            return true
        default:
            return false
        }
    }
    
    /// If this type is an `.optional`, `.implicitUnwrappedOptional`, or
    /// `.nullabilityUnspecified` type, returns an unwrapped version of self.
    /// The return is unwrapped only once.
    var unwrapped: SwiftType {
        switch self {
        case .optional(let type),
             .implicitUnwrappedOptional(let type),
             .nullabilityUnspecified(let type):
            return type
            
        default:
            return self
        }
    }
    
    /// If this type is an `.optional`, `.implicitUnwrappedOptional`, or
    /// `.nullabilityUnspecified` type, returns an unwrapped version of self.
    /// The return is then recursively unwrapped again until a non-optional base
    /// type is reached.
    var deepUnwrapped: SwiftType {
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
    var asOptional: SwiftType {
        .optional(self)
    }
    
    /// Returns `self` wrapped over an `.implicitUnwrappedOptional` case.
    var asImplicitUnwrapped: SwiftType {
        .implicitUnwrappedOptional(self)
    }
    
    /// Returns `self` wrapped over an `.nullabilityUnspecified` case.
    var asNullabilityUnspecified: SwiftType {
        .nullabilityUnspecified(self)
    }
    
    /// Returns a greater than zero number that indicates how many layers of
    /// optional types this type contains until the first non-optional type.
    var optionalityDepth: Int {
        return isOptional ? 1 + unwrapped.optionalityDepth : 0
    }
    
    /// Returns this type, wrapped in the same optionality depth as another given
    /// type.
    ///
    /// In case the other type is not an optional type, returns this type with
    /// no optionality.
    func withSameOptionalityAs(_ type: SwiftType) -> SwiftType {
        type.wrappingOther(self.deepUnwrapped)
    }
    
    /// In case this type represents an optional value, returns a new optional
    /// type with the same optionality as this type, but wrapping over a given
    /// type.
    ///
    /// If this type is not optional, `type` is returned, instead.
    ///
    /// Lookup is deep, and returns the same optionality chain as this type's.
    func wrappingOther(_ type: SwiftType) -> SwiftType {
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
    
    static func typeName(_ name: String) -> SwiftType {
        .nominal(.typeName(name))
    }

    static func block(returnType: SwiftType, parameters: [SwiftType], attributes: Set<BlockTypeAttribute> = []) -> Self {
        .block(
            BlockSwiftType(
                returnType: returnType,
                parameters: parameters,
                attributes: attributes
            )
        )
    }
    
    static func swiftBlock(
        returnType: SwiftType,
        parameters: [SwiftType] = []
    ) -> SwiftType {

        .block(.swiftBlock(returnType: returnType, parameters: parameters))
    }
    
    /// Convenience for `SwiftType.nominal(.generic(name, parameters: parameters))`
    static func generic(_ name: String, parameters: GenericArgumentSwiftType) -> SwiftType {
        .nominal(.generic(name, parameters: parameters))
    }
    
    /// Returns a type that is the same as the input, but with any .optional or
    /// .implicitUnwrappedOptional types unwrapped to non optional, including
    /// block parameters.
    ///
    /// - Parameters:
    ///   - type: The input type
    ///   - removeUnspecifiedNullabilityOnly: Whether to only remove unspecified
    /// nullability optionals, keeping optionals in place.
    /// - Returns: The deeply unwrapped version of the input type.
    static func asNonnullDeep(
        _ type: SwiftType,
        removeUnspecifiedNullabilityOnly: Bool = false
    ) -> SwiftType {
        
        var result: SwiftType = type
        
        if removeUnspecifiedNullabilityOnly {
            if case .nullabilityUnspecified(let inner) = type {
                result = inner
            }
        } else {
            result = type.deepUnwrapped
        }
        
        switch result {
        case let .block(blockType):
            result = .block(
                .asNonnullDeep(
                    type: blockType,
                    removeUnspecifiedNullabilityOnly: removeUnspecifiedNullabilityOnly
                )
            )
            
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
            return name + "<" + params.map(\.description).joined(separator: ", ") + ">"
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
            return items.map(\.description).joined(separator: ".")
        case .nominal(let nominal):
            return nominal.description
        }
    }
    
    public static func typeName(_ name: String) -> ProtocolCompositionComponent {
        .nominal(.typeName(name))
    }
}

extension ProtocolCompositionComponent: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self = .typeName(value)
    }
}

extension SwiftType: CustomStringConvertible {
    public var description: String {
        switch self {
        case .nominal(let type):
            return type.description
            
        case let .block(block):
            return block.description
            
        case .optional(let type):
            return type.descriptionWithParens + "?"
            
        case .implicitUnwrappedOptional(let type):
            return type.descriptionWithParens + "!"
            
        case .nullabilityUnspecified(let type):
            return type.descriptionWithParens + "!"
            
        case let .protocolComposition(types):
            return types.map(\.description).joined(separator: " & ")
            
        case let .metatype(innerType):
            return innerType.descriptionWithParens + ".Type"
            
        case .tuple(.empty):
            return "Void"
            
        case let .tuple(.types(inner)):
            return "(" + inner.map(\.description).joined(separator: ", ") + ")"
            
        case .nested(let items):
            return items.map(\.description).joined(separator: ".")
            
        case .array(let type):
            return "[\(type)]"
            
        case let .dictionary(key, value):
            return "[\(key): \(value)]"
        }
    }
    
    private var descriptionWithParens: String {
        if requiresSurroundingParens {
            return "(\(self))"
        }
        
        return self.description
    }
}

// MARK: - Codable conformance
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
public struct OneOrMore<T> {
    public var first: T
    var remaining: [T]
    
    /// Returns the number of items on this `OneOrMore` list.
    ///
    /// Due to semantics of this list type, this value is always `>= 1`.
    public var count: Int {
        remaining.count + 1
    }
    
    public var last: T {
        remaining.last ?? first
    }
    
    public init(first: T, remaining: [T]) {
        self.first = first
        self.remaining = remaining
    }
    
    /// Creates a `OneOrMore` enum list with a given collection.
    /// The collection must have at least two elements.
    ///
    /// - precondition: `collection.count >= 1`
    public static func fromCollection<C>(_ collection: C) -> OneOrMore
        where C: BidirectionalCollection, C.Element == T, C.Index == Int {
            
        precondition(collection.count >= 1)
        
        return OneOrMore(first: collection[0], remaining: Array(collection.dropFirst(1)))
    }
    
    /// Shortcut for creating a `OneOrMore` list with a given item
    public static func one(_ value: T) -> OneOrMore {
        OneOrMore(first: value, remaining: [])
    }
}

public struct TwoOrMore<T> {
    public var first: T
    public var second: T
    var remaining: [T]
    
    /// Returns the number of items on this `TwoOrMore` list.
    ///
    /// Due to semantics of this list type, this value is always `>= 2`.
    public var count: Int {
        remaining.count + 2
    }
    
    public var last: T {
        remaining.last ?? second
    }
    
    public init(first: T, second: T, remaining: [T]) {
        self.first = first
        self.second = second
        self.remaining = remaining
    }
    
    /// Creates a `TwoOrMore` enum list with a given collection.
    /// The collection must have at least two elements.
    ///
    /// - precondition: `collection.count >= 2`
    public static func fromCollection<C>(
        _ collection: C
    ) -> TwoOrMore where C: BidirectionalCollection, C.Element == T, C.Index == Int {
        
        precondition(collection.count >= 2)
        
        return TwoOrMore(first: collection[0], second: collection[1], remaining: Array(collection.dropFirst(2)))
    }
    
    /// Shortcut for creating a `TwoOrMore` list with two given items
    public static func two(_ value1: T, _ value2: T) -> TwoOrMore {
        TwoOrMore(first: value1, second: value2, remaining: [])
    }
}

// MARK: Sequence protocol conformances
extension OneOrMore: Sequence {
    public func makeIterator() -> Iterator {
        Iterator(current: self)
    }
    
    public struct Iterator: IteratorProtocol {
        private var current: OneOrMore
        private var index: Index = 0
        
        init(current: OneOrMore) {
            self.current = current
        }
        
        public mutating func next() -> T? {
            defer {
                index += 1
            }
            
            return index < current.endIndex ? current[index] : nil
        }
    }
}

extension TwoOrMore: Sequence {
    public func makeIterator() -> Iterator {
        Iterator(current: self)
    }
    
    public struct Iterator: IteratorProtocol {
        private var current: TwoOrMore
        private var index: Index = 0
        
        init(current: TwoOrMore) {
            self.current = current
        }
        
        public mutating func next() -> T? {
            defer {
                index += 1
            }
            
            return index < current.endIndex ? current[index] : nil
        }
    }
}

// MARK: Collection conformance
extension OneOrMore: Collection {
    public var startIndex: Int {
        return 0
    }
    public var endIndex: Int {
        remaining.count + 1
    }
    
    public subscript(index: Int) -> T {
        switch index {
        case 0:
            return first
        case let rem:
            return remaining[rem - 1]
        }
    }
    
    public func index(after i: Int) -> Int {
        return i + 1
    }
}

extension TwoOrMore: Collection {
    public var startIndex: Int {
        return 0
    }
    public var endIndex: Int {
        return remaining.count + 2
    }
    
    public subscript(index: Int) -> T {
        switch index {
        case 0:
            return first
        case 1:
            return second
        case let rem:
            return remaining[rem - 2]
        }
    }
    
    public func index(after i: Int) -> Int {
        i + 1
    }
}

// MARK: Equatable conditional conformance
extension OneOrMore: Equatable where T: Equatable { }
extension OneOrMore: Hashable where T: Hashable { }

extension TwoOrMore: Equatable where T: Equatable { }
extension TwoOrMore: Hashable where T: Hashable { }

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

// MARK: Operators
public extension OneOrMore {
    static func + (lhs: OneOrMore, rhs: OneOrMore) -> OneOrMore {
        let remaining = lhs.remaining + [rhs.first] + rhs.remaining
        
        return .init(first: lhs.first, remaining: remaining)
    }
    
    static func + (lhs: [T], rhs: OneOrMore) -> OneOrMore {
        let remaining = [rhs.first] + rhs.remaining
        
        if lhs.count > 1 {
            return .init(first: lhs[0], remaining: [lhs[1]] + remaining)
        }
        if lhs.count == 1 {
            return .init(first: lhs[0], remaining: remaining)
        }
        
        return rhs
    }
    
    static func + (lhs: OneOrMore, rhs: [T]) -> OneOrMore {
        return .init(first: lhs.first, remaining: lhs.remaining + rhs)
    }
}

public extension TwoOrMore {
    static func + (lhs: TwoOrMore, rhs: TwoOrMore) -> TwoOrMore {
        let remaining = lhs.remaining + [rhs.first, rhs.second] + rhs.remaining
        
        return .init(first: lhs.first, second: lhs.second, remaining: remaining)
    }
    
    static func + (lhs: [T], rhs: TwoOrMore) -> TwoOrMore {
        let remaining = [rhs.first, rhs.second] + rhs.remaining
        
        if lhs.count >= 2 {
            return .init(first: lhs[0],
                         second: lhs[1],
                         remaining: remaining)
        }
        
        if lhs.count == 1 {
            return .init(first: lhs[0],
                         second: remaining[0],
                         remaining: Array(remaining.dropFirst()))
        }
        
        return rhs
    }
    
    static func + (lhs: TwoOrMore, rhs: [T]) -> TwoOrMore {
        return .init(first: lhs.first, second: lhs.second, remaining: lhs.remaining + rhs)
    }
}
