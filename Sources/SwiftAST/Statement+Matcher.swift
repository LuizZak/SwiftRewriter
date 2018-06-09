public protocol Matchable {
    
}

public extension Matchable {
    
    public static func matcher() -> ValueMatcher<Self> {
        return ValueMatcher()
    }
    
}

public extension Statement {
    
    public static func matcher<T: Statement>(_ matcher: SyntaxMatcher<T>) -> SyntaxMatcher<T> {
        return matcher
    }
    
}

public func hasElse() -> SyntaxMatcher<IfStatement> {
    return SyntaxMatcher().keyPath(\.elseBody, !isNil())
}

extension Statement: Matchable {
    
}
