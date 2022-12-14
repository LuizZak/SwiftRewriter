public protocol ValueMatcherConvertible {
    associatedtype Target
    
    func asMatcher() -> ValueMatcher<Target>
}

extension ValueMatcher: ValueMatcherConvertible {
    public func asMatcher() -> ValueMatcher<T> {
        self
    }
}

extension ValueMatcherConvertible where Target == Self, Self: Equatable {
    public func asMatcher() -> ValueMatcher<Self> {
        ValueMatcher<Self>().match { $0 == self }
    }
}
