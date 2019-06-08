@dynamicMemberLookup
public struct PartialValueMatcher<T, U> {
    var keyPath: KeyPath<T, U>
    var baseMatcher: ValueMatcher<T>
    
    public subscript<Z>(dynamicMember keyPath: KeyPath<U, Z>) -> PartialValueMatcher<T, Z> {
        return PartialValueMatcher<T, Z>(keyPath: self.keyPath.appending(path: keyPath),
                                         baseMatcher: baseMatcher)
    }
}

public extension PartialValueMatcher where U: Equatable {
    static func == (lhs: Self, rhs: U) -> ValueMatcher<T> {
        return lhs.baseMatcher.keyPath(lhs.keyPath, equals: rhs)
    }
}
