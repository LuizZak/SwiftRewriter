

@inlinable
public func not<T>(_ rule: ValueMatcher<T>) -> ValueMatcher<T> {
    return ValueMatcher().match(closure: { !rule.matches($0) })
}

@inlinable
public func not<T>(_ rule: MatchRule<T>) -> MatchRule<T> {
    return .negated(rule)
}

@inlinable
public func equals<T: Equatable>(_ value: T) -> MatchRule<T> {
    return MatchRule.equals(value)
}

@inlinable
public func equals<T: Equatable>(_ value: T?) -> MatchRule<T> {
    return MatchRule.equalsNullable(value)
}

@inlinable
public func lazyEquals<T: Equatable>(_ value: @autoclosure @escaping () -> T) -> MatchRule<T> {
    return MatchRule.lazyEquals(value)
}

@inlinable
public func lazyEquals<T: Equatable>(_ value: @autoclosure @escaping () -> T?) -> MatchRule<T> {
    return MatchRule.lazyEqualsNullable(value)
}

@inlinable
public func isNil<T>() -> MatchRule<T?> {
    return MatchRule.equals(nil)
}

@inlinable
public func hasCount<C: Collection>(_ count: MatchRule<Int>) -> ValueMatcher<C> {
    return ValueMatcher().keyPath(\.count, count)
}

public extension ValueMatcher where T: Equatable {
    @inlinable
    static func equals(to value: T) -> ValueMatcher<T> {
        return ValueMatcher().match(if: SwiftAST.equals(value))
    }
    
}

public extension ValueMatcher where T: Collection {
    @inlinable
    func hasCount(_ count: MatchRule<Int>) -> ValueMatcher<T> {
        return keyPath(\.count, count)
    }
    
}

public extension ValueMatcher where T: Collection {
    @inlinable
    func atIndex(_ index: T.Index, matcher: ValueMatcher<T.Element>) -> ValueMatcher<T> {
        return match { value in
            guard index < value.endIndex else {
                return false
            }
            
            return matcher.matches(value[index])
        }
    }
    
}

public extension ValueMatcher where T: Collection, T.Element: Equatable {
    @inlinable
    func atIndex(_ index: T.Index, equals value: T.Element) -> ValueMatcher<T> {
        return atIndex(index, rule: .equals(value))
    }
    
    @inlinable
    func atIndex(_ index: T.Index, rule: MatchRule<T.Element>) -> ValueMatcher<T> {
        return match { value in
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
        return not(lhs)
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
        return lhs ? rhs : !rhs
    }
    
    @inlinable
    static func == (lhs: ValueMatcher, rhs: Bool) -> ValueMatcher {
        return rhs ? lhs : !lhs
    }
}
