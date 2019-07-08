public protocol Matchable {
    
}

public protocol ValueMatcherConvertible {
    associatedtype Target
    
    func asMatcher() -> ValueMatcher<Target>
}

extension ValueMatcher: ValueMatcherConvertible {
    public func asMatcher() -> ValueMatcher<T> {
        return self
    }
}

extension ValueMatcherConvertible where Target == Self, Self: Equatable {
    public func asMatcher() -> ValueMatcher<Self> {
        return ValueMatcher<Self>().match { $0 == self }
    }
}

public extension Matchable {
    
    static func matcher() -> ValueMatcher<Self> {
        return ValueMatcher()
    }
    
    func matches(_ matcher: ValueMatcher<Self>) -> Bool {
        return matcher.matches(self)
    }
    
}

public extension Statement {
    
    static func matcher<T: Statement>(_ matcher: SyntaxMatcher<T>) -> SyntaxMatcher<T> {
        return matcher
    }
    
}

public extension ValueMatcher where T: Statement {
    @inlinable
    func anyStatement() -> ValueMatcher<Statement> {
        return ValueMatcher<Statement>().match { (value) -> Bool in
            if let value = value as? T {
                return self.matches(value)
            }
            
            return false
        }
    }
    
}

// FIXME: Inline again once Linux bug is corrected
// https://dev.azure.com/luiz-fs/SwiftRewriter/_build/results?buildId=375&view=logs&jobId=0da5d1d9-276d-5173-c4c4-9d4d4ed14fdb&taskId=8ef82b3b-1feb-5bbd-06f6-b1f7b5467f03&lineStart=71&lineEnd=71&colStart=243&colEnd=301
// @inlinable
public func hasElse() -> SyntaxMatcher<IfStatement> {
    return SyntaxMatcher().keyPath(\.elseBody, !isNil())
}

extension Statement: Matchable {
    
}
