extension Sequence {
    /// Returns a dictionary containing elements grouped by a specified key.
    ///
    /// The `key` closure is assumed to always return the same key value for any
    /// element in this sequence.
    @inlinable
    public func groupBy<Key: Hashable>(_ key: (Iterator.Element) -> Key) -> [Key: [Iterator.Element]] {
        Dictionary(grouping: self, by: key)
    }
}

extension Set {
    /// Returns a dictionary of sets containing elements grouped by a specified
    /// key.
    ///
    /// The `key` closure is assumed to always return the same key value for any
    /// element in this set.
    @inlinable
    public func groupBy<Key: Hashable>(_ key: (Element) -> Key) -> [Key: Set<Element>] {
        var result: [Key: Set<Element>] = [:]

        for value in self {
            result[key(value), default: []].insert(value)
        }

        return result
    }
}

extension Sequence {
    /// Returns `true` iff any elements from this sequence pass a given predicate.
    /// Returns `false` if sequence is empty.
    @inlinable
    public func any(_ predicate: (Element) -> Bool) -> Bool {
        for element in self {
            if predicate(element) {
                return true
            }
        }
        
        return false
    }
}
