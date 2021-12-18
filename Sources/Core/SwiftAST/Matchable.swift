public protocol Matchable {
    
}

public extension Matchable {
    static func matcher() -> ValueMatcher<Self> {
        ValueMatcher()
    }
    
    func matches(_ matcher: ValueMatcher<Self>) -> Bool {
        matcher(matches: self)
    }
}
