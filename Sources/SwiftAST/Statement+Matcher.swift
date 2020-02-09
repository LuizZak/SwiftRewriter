public protocol Matchable {
    
}

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

public extension Matchable {
    
    static func matcher() -> ValueMatcher<Self> {
        ValueMatcher()
    }
    
    func matches(_ matcher: ValueMatcher<Self>) -> Bool {
        matcher(matches: self)
    }
    
}

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
