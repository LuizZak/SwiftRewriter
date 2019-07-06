extension Sequence {
    /// Returns a dictionary containing elements grouped by a specified key
    /// Note that the 'key' closure is required to always return the same T key
    /// for the same value passed in, so values can be grouped correctly
    @inlinable
    public func groupBy<T: Hashable>(_ key: (Iterator.Element) -> T) -> [T: [Iterator.Element]] {
        Dictionary(grouping: self, by: key)
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
