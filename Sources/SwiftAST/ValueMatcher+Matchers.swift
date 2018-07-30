public func not<T>(_ rule: ValueMatcher<T>) -> ValueMatcher<T> {
    return ValueMatcher().match(closure: { !rule.matches($0) })
}

public func not<T>(_ rule: MatchRule<T>) -> MatchRule<T> {
    return .negated(rule)
}

public func equals<T: Equatable>(_ value: T) -> MatchRule<T> {
    return MatchRule.equals(value)
}

public func equals<T: Equatable>(_ value: T?) -> MatchRule<T> {
    return MatchRule.equalsNullable(value)
}

public func lazyEquals<T: Equatable>(_ value: @autoclosure @escaping () -> T) -> MatchRule<T> {
    return MatchRule.lazyEquals(value)
}

public func lazyEquals<T: Equatable>(_ value: @autoclosure @escaping () -> T?) -> MatchRule<T> {
    return MatchRule.lazyEqualsNullable(value)
}

public func isNil<T>() -> MatchRule<T?> {
    return MatchRule.equals(nil)
}

public func hasCount<C: Collection>(_ count: MatchRule<Int>) -> ValueMatcher<C> {
    return ValueMatcher().keyPath(\.count, count)
}

public extension ValueMatcher where T: Collection {
    
    public func hasCount(_ count: MatchRule<Int>) -> ValueMatcher<T> {
        return keyPath(\.count, count)
    }
    
}

public extension ValueMatcher where T: Collection, T.Index == Int {
    
    public func atIndex(_ index: Int, matcher: ValueMatcher<T.Element>) -> ValueMatcher<T> {
        return match { value in
            guard index < value.count else {
                return false
            }
            
            return matcher.matches(value[index])
        }
    }
    
}

public extension ValueMatcher where T: Collection, T.Element: Equatable, T.Index == Int {
    
    public func atIndex(_ index: Int, equals value: T.Element) -> ValueMatcher<T> {
        return atIndex(index, rule: .equals(value))
    }
    
    public func atIndex(_ index: Int, rule: MatchRule<T.Element>) -> ValueMatcher<T> {
        return match { value in
            guard index < value.count else {
                return false
            }
            
            return rule.evaluate(value[index])
        }
    }
    
}

public extension ValueMatcher {
    @inlinable
    public static prefix func ! (lhs: ValueMatcher) -> ValueMatcher {
        return not(lhs)
    }
}

public extension MatchRule {
    @inlinable
    public static prefix func ! (lhs: MatchRule) -> MatchRule {
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
    public static func == (lhs: Bool, rhs: ValueMatcher) -> ValueMatcher {
        return lhs ? rhs : !rhs
    }
    
    @inlinable
    public static func == (lhs: ValueMatcher, rhs: Bool) -> ValueMatcher {
        return rhs ? lhs : !lhs
    }
}
