/// Represents a normalized swift type, which is a `SwiftType` normalized such
/// that semantically equivalent types are represented in the same way structurally.
indirect public enum NormalizedSwiftType: Equatable {
    case nested(NestedSwiftType)
    case nominal(NominalSwiftType)
    case protocolComposition(ProtocolCompositionSwiftType)
    case tuple(TupleSwiftType)
    case block(parameters: [NormalizedSwiftType], returnType: NormalizedSwiftType)
    case metatype(NormalizedSwiftType)
}

/// A nominal Swift type, which is either a plain typename or a generic type.
public enum NominalSwiftType: Equatable {
    case typeName(String)
    case generic(String, [GenericArgumentSwiftType])
}

/// A tuple swift type, which either represents an empty tuple or two or more
/// Swift types.
public enum TupleSwiftType: Equatable {
    case types(TwoOrMore<NormalizedSwiftType>)
    case empty
}

public typealias ProtocolCompositionSwiftType = OneOrMore<NominalSwiftType>
public typealias NestedSwiftType = TwoOrMore<NominalSwiftType>
public typealias GenericArgumentSwiftType = OneOrMore<NormalizedSwiftType>

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
