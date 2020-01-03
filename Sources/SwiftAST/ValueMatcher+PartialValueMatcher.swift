@dynamicMemberLookup
public struct PartialValueMatcher<T, U> {
    var keyPath: KeyPath<T, U>
    var baseMatcher: ValueMatcher<T>
    
    public subscript<Z>(dynamicMember keyPath: KeyPath<U, Z>) -> PartialValueMatcher<T, Z> {
        PartialValueMatcher<T, Z>(keyPath: self.keyPath.appending(path: keyPath),
                                  baseMatcher: baseMatcher)
    }
}

public extension PartialValueMatcher where U: Equatable {
    static func == (lhs: Self, rhs: U) -> ValueMatcher<T> {
        lhs.baseMatcher.keyPath(lhs.keyPath, equals: rhs)
    }
}
