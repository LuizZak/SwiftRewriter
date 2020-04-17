public extension Statement {
    static func matcher<T: Statement>(_ matcher: SyntaxMatcher<T>) -> SyntaxMatcher<T> {
        matcher
    }
}

public extension ValueMatcher where T: Statement {
    @inlinable
    func anyStatement() -> ValueMatcher<Statement> {
        ValueMatcher<Statement>().match { (value) -> Bool in
            if let value = value as? T {
                return self(matches: value)
            }
            
            return false
        }
    }
    
}

@inlinable
public func hasElse() -> SyntaxMatcher<IfStatement> {
    SyntaxMatcher().keyPath(\.elseBody, !isNil())
}

extension Statement: Matchable {
    
}
