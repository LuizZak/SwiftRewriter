

// FIX-ME: Inline again once Linux bug is corrected
// https://dev.azure.com/luiz-fs/SwiftRewriter/_build/results?buildId=375&view=logs&jobId=0da5d1d9-276d-5173-c4c4-9d4d4ed14fdb&taskId=8ef82b3b-1feb-5bbd-06f6-b1f7b5467f03&lineStart=71&lineEnd=71&colStart=243&colEnd=301
// @inlinable
public func not<T>(_ rule: ValueMatcher<T>) -> ValueMatcher<T> {
    ValueMatcher().match(closure: { !rule.matches($0) })
}

// FIX-ME: Inline again once Linux bug is corrected
// https://dev.azure.com/luiz-fs/SwiftRewriter/_build/results?buildId=375&view=logs&jobId=0da5d1d9-276d-5173-c4c4-9d4d4ed14fdb&taskId=8ef82b3b-1feb-5bbd-06f6-b1f7b5467f03&lineStart=71&lineEnd=71&colStart=243&colEnd=301
// @inlinable
public func not<T>(_ rule: MatchRule<T>) -> MatchRule<T> {
    .negated(rule)
}

// FIX-ME: Inline again once Linux bug is corrected
// https://dev.azure.com/luiz-fs/SwiftRewriter/_build/results?buildId=375&view=logs&jobId=0da5d1d9-276d-5173-c4c4-9d4d4ed14fdb&taskId=8ef82b3b-1feb-5bbd-06f6-b1f7b5467f03&lineStart=71&lineEnd=71&colStart=243&colEnd=301
// @inlinable
public func equals<T: Equatable>(_ value: T) -> MatchRule<T> {
    MatchRule.equals(value)
}

// FIX-ME: Inline again once Linux bug is corrected
// https://dev.azure.com/luiz-fs/SwiftRewriter/_build/results?buildId=375&view=logs&jobId=0da5d1d9-276d-5173-c4c4-9d4d4ed14fdb&taskId=8ef82b3b-1feb-5bbd-06f6-b1f7b5467f03&lineStart=71&lineEnd=71&colStart=243&colEnd=301
// @inlinable
public func equals<T: Equatable>(_ value: T?) -> MatchRule<T> {
    MatchRule.equalsNullable(value)
}

// FIX-ME: Inline again once Linux bug is corrected
// https://dev.azure.com/luiz-fs/SwiftRewriter/_build/results?buildId=375&view=logs&jobId=0da5d1d9-276d-5173-c4c4-9d4d4ed14fdb&taskId=8ef82b3b-1feb-5bbd-06f6-b1f7b5467f03&lineStart=71&lineEnd=71&colStart=243&colEnd=301
// @inlinable
public func lazyEquals<T: Equatable>(_ value: @autoclosure @escaping () -> T) -> MatchRule<T> {
    MatchRule.lazyEquals(value)
}

// FIX-ME: Inline again once Linux bug is corrected
// https://dev.azure.com/luiz-fs/SwiftRewriter/_build/results?buildId=375&view=logs&jobId=0da5d1d9-276d-5173-c4c4-9d4d4ed14fdb&taskId=8ef82b3b-1feb-5bbd-06f6-b1f7b5467f03&lineStart=71&lineEnd=71&colStart=243&colEnd=301
// @inlinable
public func lazyEquals<T: Equatable>(_ value: @autoclosure @escaping () -> T?) -> MatchRule<T> {
    MatchRule.lazyEqualsNullable(value)
}

// FIX-ME: Inline again once Linux bug is corrected
// https://dev.azure.com/luiz-fs/SwiftRewriter/_build/results?buildId=375&view=logs&jobId=0da5d1d9-276d-5173-c4c4-9d4d4ed14fdb&taskId=8ef82b3b-1feb-5bbd-06f6-b1f7b5467f03&lineStart=71&lineEnd=71&colStart=243&colEnd=301
// @inlinable
public func isNil<T>() -> MatchRule<T?> {
    MatchRule.equals(nil)
}

// FIX-ME: Inline again once Linux bug is corrected
// https://dev.azure.com/luiz-fs/SwiftRewriter/_build/results?buildId=375&view=logs&jobId=0da5d1d9-276d-5173-c4c4-9d4d4ed14fdb&taskId=8ef82b3b-1feb-5bbd-06f6-b1f7b5467f03&lineStart=71&lineEnd=71&colStart=243&colEnd=301
// @inlinable
public func hasCount<C: Collection>(_ count: MatchRule<Int>) -> ValueMatcher<C> {
    ValueMatcher().keyPath(\.count, count)
}

public extension ValueMatcher where T: Equatable {
    // FIX-ME: Inline again once Linux bug is corrected
    // https://dev.azure.com/luiz-fs/SwiftRewriter/_build/results?buildId=375&view=logs&jobId=0da5d1d9-276d-5173-c4c4-9d4d4ed14fdb&taskId=8ef82b3b-1feb-5bbd-06f6-b1f7b5467f03&lineStart=71&lineEnd=71&colStart=243&colEnd=301
    // @inlinable
    static func equals(to value: T) -> ValueMatcher<T> {
        ValueMatcher().match(if: SwiftAST.equals(value))
    }
    
}

public extension ValueMatcher where T: Collection {
    // FIX-ME: Inline again once Linux bug is corrected
    // https://dev.azure.com/luiz-fs/SwiftRewriter/_build/results?buildId=375&view=logs&jobId=0da5d1d9-276d-5173-c4c4-9d4d4ed14fdb&taskId=8ef82b3b-1feb-5bbd-06f6-b1f7b5467f03&lineStart=71&lineEnd=71&colStart=243&colEnd=301
    // @inlinable
    func hasCount(_ count: MatchRule<Int>) -> ValueMatcher<T> {
        keyPath(\.count, count)
    }
    
}

public extension ValueMatcher where T: Collection {
    // FIX-ME: Inline again once Linux bug is corrected
    // https://dev.azure.com/luiz-fs/SwiftRewriter/_build/results?buildId=375&view=logs&jobId=0da5d1d9-276d-5173-c4c4-9d4d4ed14fdb&taskId=8ef82b3b-1feb-5bbd-06f6-b1f7b5467f03&lineStart=71&lineEnd=71&colStart=243&colEnd=301
    // @inlinable
    func atIndex(_ index: T.Index, matcher: ValueMatcher<T.Element>) -> ValueMatcher<T> {
        match { value in
            guard index < value.endIndex else {
                return false
            }
            
            return matcher.matches(value[index])
        }
    }
    
}

public extension ValueMatcher where T: Collection, T.Element: Equatable {
    // FIX-ME: Inline again once Linux bug is corrected
    // https://dev.azure.com/luiz-fs/SwiftRewriter/_build/results?buildId=375&view=logs&jobId=0da5d1d9-276d-5173-c4c4-9d4d4ed14fdb&taskId=8ef82b3b-1feb-5bbd-06f6-b1f7b5467f03&lineStart=71&lineEnd=71&colStart=243&colEnd=301
    // @inlinable
    func atIndex(_ index: T.Index, equals value: T.Element) -> ValueMatcher<T> {
        atIndex(index, rule: .equals(value))
    }
    
    // FIX-ME: Inline again once Linux bug is corrected
    // https://dev.azure.com/luiz-fs/SwiftRewriter/_build/results?buildId=375&view=logs&jobId=0da5d1d9-276d-5173-c4c4-9d4d4ed14fdb&taskId=8ef82b3b-1feb-5bbd-06f6-b1f7b5467f03&lineStart=71&lineEnd=71&colStart=243&colEnd=301
    // @inlinable
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
    // FIX-ME: Inline again once Linux bug is corrected
    // https://dev.azure.com/luiz-fs/SwiftRewriter/_build/results?buildId=375&view=logs&jobId=0da5d1d9-276d-5173-c4c4-9d4d4ed14fdb&taskId=8ef82b3b-1feb-5bbd-06f6-b1f7b5467f03&lineStart=71&lineEnd=71&colStart=243&colEnd=301
    // @inlinable
    static prefix func ! (lhs: ValueMatcher) -> ValueMatcher {
        not(lhs)
    }
}

public extension MatchRule {
    // FIX-ME: Inline again once Linux bug is corrected
    // https://dev.azure.com/luiz-fs/SwiftRewriter/_build/results?buildId=375&view=logs&jobId=0da5d1d9-276d-5173-c4c4-9d4d4ed14fdb&taskId=8ef82b3b-1feb-5bbd-06f6-b1f7b5467f03&lineStart=71&lineEnd=71&colStart=243&colEnd=301
    // @inlinable
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
    // FIX-ME: Inline again once Linux bug is corrected
    // https://dev.azure.com/luiz-fs/SwiftRewriter/_build/results?buildId=375&view=logs&jobId=0da5d1d9-276d-5173-c4c4-9d4d4ed14fdb&taskId=8ef82b3b-1feb-5bbd-06f6-b1f7b5467f03&lineStart=71&lineEnd=71&colStart=243&colEnd=301
    // @inlinable
    static func == (lhs: Bool, rhs: ValueMatcher) -> ValueMatcher {
        lhs ? rhs : !rhs
    }
    
    // FIX-ME: Inline again once Linux bug is corrected
    // https://dev.azure.com/luiz-fs/SwiftRewriter/_build/results?buildId=375&view=logs&jobId=0da5d1d9-276d-5173-c4c4-9d4d4ed14fdb&taskId=8ef82b3b-1feb-5bbd-06f6-b1f7b5467f03&lineStart=71&lineEnd=71&colStart=243&colEnd=301
    // @inlinable
    static func == (lhs: ValueMatcher, rhs: Bool) -> ValueMatcher {
        rhs ? lhs : !lhs
    }
}
