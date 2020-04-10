

@inlinable
public func not<T>(_ rule: ValueMatcher<T>) -> ValueMatcher<T> {
    ValueMatcher().match(closure: { !rule(matches: $0) })
}

@inlinable
public func not<T>(_ rule: MatchRule<T>) -> MatchRule<T> {
    .negated(rule)
}

@inlinable
public func equals<T: Equatable>(_ value: T) -> MatchRule<T> {
    MatchRule.equals(value)
}

@inlinable
public func equals<T: Equatable>(_ value: T?) -> MatchRule<T> {
    MatchRule.equalsNullable(value)
}

@inlinable
public func lazyEquals<T: Equatable>(_ value: @autoclosure @escaping () -> T) -> MatchRule<T> {
    MatchRule.lazyEquals(value)
}

@inlinable
public func lazyEquals<T: Equatable>(_ value: @autoclosure @escaping () -> T?) -> MatchRule<T> {
    MatchRule.lazyEqualsNullable(value)
}

@inlinable
public func isNil<T>() -> MatchRule<T?> {
    MatchRule.equals(nil)
}

@inlinable
public func hasCount<C: Collection>(_ count: MatchRule<Int>) -> ValueMatcher<C> {
    ValueMatcher().keyPath(\.count, count)
}

public extension ValueMatcher where T: Equatable {
    @inlinable
    static func equals(to value: T) -> ValueMatcher<T> {
        ValueMatcher().match(if: SwiftAST.equals(value))
    }
    
}

public extension ValueMatcher where T: Collection {
    @inlinable
    func hasCount(_ count: MatchRule<Int>) -> ValueMatcher<T> {
        keyPath(\.count, count)
    }
    
}

public extension ValueMatcher where T: Collection {
    @inlinable
    func atIndex(_ index: T.Index, matcher: ValueMatcher<T.Element>) -> ValueMatcher<T> {
        match { value in
            guard index < value.endIndex else {
                return false
            }
            
            return matcher(matches: value[index])
        }
    }
    
}

public extension ValueMatcher where T: Collection, T.Element: Equatable {
    @inlinable
    func atIndex(_ index: T.Index, equals value: T.Element) -> ValueMatcher<T> {
        atIndex(index, rule: .equals(value))
    }
    
    @inlinable
    func atIndex(_ index: T.Index, rule: MatchRule<T.Element>) -> ValueMatcher<T> {
        match { value in
            guard index < value.endIndex else {
                return false
            }
            
            return rule.evaluate(value[index])
        }
    }
    
}

public extension ValueMatcher {
    @inlinable
    static prefix func ! (lhs: ValueMatcher) -> ValueMatcher {
        not(lhs)
    }
}

public extension MatchRule {
    @inlinable
    static prefix func ! (lhs: MatchRule) -> MatchRule {
        switch lhs {
        case .negated(let rule):
            return rule
        default:
            return .negated(lhs)
        }
    }
}

public extension ValueMatcher {
    @inlinable
    static func == (lhs: Bool, rhs: ValueMatcher) -> ValueMatcher {
        lhs ? rhs : !rhs
    }
    
    @inlinable
    static func == (lhs: ValueMatcher, rhs: Bool) -> ValueMatcher {
        rhs ? lhs : !lhs
    }
}
