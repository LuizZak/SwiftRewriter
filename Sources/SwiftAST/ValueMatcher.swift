public protocol ValueMatcherProtocol {
    associatedtype Value
    
    func matches(_ value: Value) -> Bool
}

/// A matcher that can be used to check if a value matches an expected structure.
public struct ValueMatcher<T>: ValueMatcherProtocol {
    
    var matchers: [AnyASTMatcherRule]
    
    public init() {
        self.matchers = []
    }
    
    /// Returns `true` if this matcher matches on the given value.
    public func matches(_ value: T) -> Bool {
        for matcher in matchers {
            if !matcher.matches(value) {
                return false
            }
        }
        
        return true
    }
    
    /// Returns a new matcher with the given closure matching rule appended to
    /// the existing rules of this matcher.
    ///
    /// - Parameter closure: The closure to apply to candidate values to decide
    /// whether they match.
    /// - Returns: A new matcher with all rules from this matcher, including the
    /// new closure matcher rule added in.
    public func match(closure: @escaping (T) -> Bool) -> ValueMatcher<T> {
        let rule = ClosureMatcher(matcher: closure)
        
        var copy = self
        copy.matchers.append(AnyASTMatcherRule(rule))
        return copy
    }
    
    /// Returns a new matcher with the given matcher appended to the existing
    /// rules of this matcher.
    ///
    /// - Parameter matcher: A sub-matcher that will be applied alongside all
    /// rules on this matcher.
    /// - Returns: A new matcher with all rules from this matcher, including the
    /// new value matcher added in.
    public func match(if matcher: ValueMatcher<T>) -> ValueMatcher<T> {
        var copy = self
        copy.matchers.append(AnyASTMatcherRule(matcher))
        return copy
    }
    
    /// Creates a branched matcher from this matcher such that further matching
    /// is only performed if the fed value was non-nil, failing otherwise.
    public func matchNil() -> ValueMatcher<T?> {
        let closure = ClosureMatcher<T?> { value -> Bool in
            guard let value = value else {
                return false
            }
            
            return self.matches(value)
        }
        
        var vm = ValueMatcher<T?>()
        vm.matchers.append(ValueMatcher<T?>.AnyASTMatcherRule(closure))
        return vm
    }
}

public extension ValueMatcher {
    
    /// Returns a new matcher with the given keypath matching rule appended to
    /// the existing rules of this matcher.
    ///
    /// - Parameters:
    ///   - keyPath: The keypath onto the value to retrieve the value to match.
    ///   - value: A value to match under equality.
    /// - Returns: A new matcher with the specified matcher rule appended along
    /// with all existing rules for this matcher.
    public func keyPath<U: Equatable>(_ kp: KeyPath<T, U>, equals value: U) -> ValueMatcher {
        
        return keyPath(kp, .equals(value))
    }
    
    /// Returns a new matcher with the given keypath matching rule appended to
    /// the existing rules of this matcher.
    ///
    /// - Parameters:
    ///   - keyPath: The keypath onto the value to retrieve the value to match.
    ///   - value: A value to match under equality.
    /// - Returns: A new matcher with the specified matcher rule appended along
    /// with all existing rules for this matcher.
    public func keyPath<U: Equatable>(_ kp: KeyPath<T, U?>, equals value: U) -> ValueMatcher {
        
        return keyPath(kp, .equals(value))
    }
    
    /// Returns a new matcher with the given keypath matching rule appended to
    /// the existing rules of this matcher.
    ///
    /// - Parameters:
    ///   - keyPath: The keypath onto the value to retrieve the value to match.
    ///   - rule: A rule to match the value with.
    /// - Returns: A new matcher with the specified matcher rule appended along
    /// with all existing rules for this matcher.
    public func keyPath<U: Equatable>(_ kp: KeyPath<T, U>, _ rule: MatchRule<U>) -> ValueMatcher {
        let matcher = KeyPathMatcher(keyPath: kp, rule: rule)
        let anyMatcher = AnyASTMatcherRule(matcher)
        
        var copy = self
        copy.matchers.append(anyMatcher)
        return copy
    }
    
    /// Returns a new matcher with the given keypath matcher appended to the
    /// existing rules of this matcher.
    ///
    /// - Parameters:
    ///   - keyPath: The keypath onto the value to retrieve the value to match.
    ///   - matcher: A matcher to apply to the keypath.
    /// - Returns: A new matcher with the specified matcher appended along with
    /// all existing rules for this matcher.
    public func keyPath<U>(_ kp: KeyPath<T, U>, _ matcher: ValueMatcher<U>) -> ValueMatcher {
        let matcher = KeyPathValueMatcher(keyPath: kp, matcher: matcher)
        let anyMatcher = AnyASTMatcherRule(matcher)
        
        var copy = self
        copy.matchers.append(anyMatcher)
        return copy
    }
    
    /// Returns a new matcher with the given keypath matcher appended to the
    /// existing rules of this matcher.
    ///
    /// - Parameters:
    ///   - keyPath: The keypath onto the value to retrieve the value to match.
    ///   - matcher: A matcher to apply to the keypath.
    /// - Returns: A new matcher with the specified matcher appended along with
    /// all existing rules for this matcher.
    public func keyPath<U>(_ kp: KeyPath<T, U?>, _ matcher: ValueMatcher<U>) -> ValueMatcher {
        let matcher = KeyPathValueMatcher(keyPath: kp, matcher: matcher.matchNil())
        let anyMatcher = AnyASTMatcherRule(matcher)
        
        var copy = self
        copy.matchers.append(anyMatcher)
        return copy
    }
    
    /// Returns a new matcher with the given optional-valued keypath matcher to
    /// use with a specifically-built matcher that is only triggered if the value
    /// for the key-path is non-nil at the time of evaluation.
    ///
    /// - Parameters:
    ///   - kp: The keypath to evaluate.
    ///   - closure: A closure that receives an empty value-matcher, and must
    /// return a newly constructed value matcher that will work on the non-nil
    /// value of the key-path.
    /// - Returns: A new matcher with the specified matcher appended along with
    /// all existing rules for this matcher.
    public func keyPath<U>(_ kp: KeyPath<T, U?>, _ closure: (ValueMatcher<U>) -> ValueMatcher<U>) -> ValueMatcher {
        let valueMatcher = closure(ValueMatcher<U>())
        let closureMatcher = ClosureMatcher<T> { value in
            guard let value = value[keyPath: kp] else {
                return false
            }
            
            return valueMatcher.matches(value)
        }
        
        let anyMatcher = AnyASTMatcherRule(closureMatcher)
        
        var copy = self
        copy.matchers.append(anyMatcher)
        return copy
    }
    
    /// Returns a new matcher with the given keypath matching rule.
    ///
    /// - Parameters:
    ///   - keyPath: The keypath onto the value to retrieve the value to match.
    ///   - value: A value to match under equality.
    /// - Returns: A new matcher with the specified matcher rule.
    public static func keyPath<U: Equatable>(_ kp: KeyPath<T, U>, equals value: U) -> ValueMatcher {
        return ValueMatcher().keyPath(kp, equals: value)
    }
    
    /// Returns a new matcher with the given keypath matching rule.
    ///
    /// - Parameters:
    ///   - keyPath: The keypath onto the value to retrieve the value to match.
    ///   - rule: A rule to match the value with.
    /// - Returns: A new matcher with the specified matcher rule.
    public static func keyPath<U: Equatable>(_ kp: KeyPath<T, U>, _ rule: MatchRule<U>) -> ValueMatcher {
        return ValueMatcher().keyPath(kp, rule)
    }
    
    /// Returns a new matcher with the given keypath matcher.
    ///
    /// - Parameters:
    ///   - keyPath: The keypath onto the value to retrieve the value to match.
    ///   - matcher: A matcher to apply to the keypath.
    /// - Returns: A new matcher with the specified matcher.
    public static func keyPath<U>(_ kp: KeyPath<T, U>, _ matcher: ValueMatcher<U>) -> ValueMatcher {
        return ValueMatcher().keyPath(kp, matcher)
    }
    
    /// Returns a new matcher with the given keypath matcher.
    ///
    /// - Parameters:
    ///   - keyPath: The keypath onto the value to retrieve the value to match.
    ///   - matcher: A matcher to apply to the keypath.
    /// - Returns: A new matcher with the specified matcher.
    public static func keyPath<U>(_ kp: KeyPath<T, U?>, _ matcher: ValueMatcher<U>) -> ValueMatcher {
        return ValueMatcher().keyPath(kp, matcher)
    }
    
    /// Returns a new matcher with the given optional-valued keypath matcher to
    /// use with a specifically-built matcher that is only triggered if the value
    /// for the key-path is non-nil at the time of evaluation.
    ///
    /// - Parameters:
    ///   - kp: The keypath to evaluate.
    ///   - closure: A closure that receives an empty value-matcher, and must
    /// return a newly constructed value matcher that will work on the non-nil
    /// value of the key-path.
    /// - Returns: A new matcher with the specified matcher.
    public static func keyPath<U>(_ kp: KeyPath<T, U?>, _ closure: (ValueMatcher<U>) -> ValueMatcher<U>) -> ValueMatcher {
        return ValueMatcher().keyPath(kp, closure)
    }
}

extension ValueMatcher {
    
    public static func isType(_ type: T.Type) -> ValueMatcher<T> {
        return ValueMatcher().match(closure: { Swift.type(of: $0) == type })
    }
    
}

extension ValueMatcher {
    
    struct KeyPathValueMatcher<U>: ValueMatcherProtocol {
        var keyPath: KeyPath<T, U>
        var matcher: ValueMatcher<U>
        
        func matches(_ value: T) -> Bool {
            return matcher.matches(value[keyPath: keyPath])
        }
    }
    
    struct KeyPathMatcher<U: Equatable>: ValueMatcherProtocol {
        var keyPath: KeyPath<T, U>
        var rule: MatchRule<U>
        
        func matches(_ value: T) -> Bool {
            return rule.evaluate(value[keyPath: keyPath])
        }
    }
}

public extension ValueMatcher {
    
    public static var any: ValueMatcher {
        return ValueMatcher()
    }
    
}

extension ValueMatcher {
    
    public func bind<U>(keyPath: KeyPath<T, U>, to target: UnsafeMutablePointer<U>) -> ValueMatcher {
        return self.match { value -> Bool in
            target.pointee = value[keyPath: keyPath]
            
            return true
        }
    }
    
    public func bind<U>(keyPath: KeyPath<T, U>, to target: UnsafeMutablePointer<U?>) -> ValueMatcher {
        return self.match { value -> Bool in
            target.pointee = value[keyPath: keyPath]
            
            return true
        }
    }
    
}

extension ValueMatcher where T: Equatable {
    
    /// Returns a new matcher that matches the tested value against a given matcher.
    ///
    /// - Parameter match: The matcher to apply to testing objects.
    /// - Returns: A new matcher with the specified matcher rule appended along
    /// with all existing rules for this matcher.
    public func match(_ match: MatchRule<T>) -> ValueMatcher {
        let anyMatcher = AnyASTMatcherRule(SelfMatcher(rule: match))
        
        var copy = self
        copy.matchers.append(anyMatcher)
        return copy
    }
    
    /// Returns a new matcher that matches the tested value against a given matcher.
    ///
    /// - Parameter match: The matcher to apply to testing objects.
    /// - Returns: A new matcher with the specified matcher rule appended along
    /// with all existing rules for this matcher.
    public func match(if rule: MatchRule<T>) -> ValueMatcher {
        return match(rule)
    }
    
    public func bind(to target: UnsafeMutablePointer<T>) -> ValueMatcher {
        return self.match(.extract(.any, target))
    }
    
    public func bind(to target: UnsafeMutablePointer<T?>) -> ValueMatcher {
        return self.match(.extractOptional(.any, target))
    }
    
    struct SelfMatcher: ValueMatcherProtocol {
        var rule: MatchRule<T>
        
        func matches(_ value: T) -> Bool {
            return rule.evaluate(value)
        }
    }
    
    public static func ->> (lhs: ValueMatcher, rhs: UnsafeMutablePointer<T>) -> ValueMatcher {
        return lhs.match(.any ->> rhs)
    }
    
    public static func ->> (lhs: ValueMatcher, rhs: UnsafeMutablePointer<T?>) -> ValueMatcher {
        return lhs.match(.any ->> rhs)
    }
}

extension ValueMatcher {
    
    struct AnyASTMatcherRule {
        private var _matcher: (T) -> Bool
        
        init<M: ValueMatcherProtocol>(_ matcher: M) where M.Value == T {
            _matcher = matcher.matches
        }
        
        func matches(_ value: T) -> Bool {
            return _matcher(value)
        }
    }
}

private struct ClosureMatcher<T>: ValueMatcherProtocol {
    var matcher: (T) -> Bool
    
    func matches(_ value: T) -> Bool {
        return matcher(value)
    }
}

public enum MatchRule<U: Equatable> {
    case any
    case none
    case equals(U)
    case equalsNullable(U?)
    case lazyEquals(() -> U)
    case lazyEqualsNullable(() -> U?)
    case isType(U.Type)
    indirect case all([MatchRule])
    indirect case anyOf([MatchRule])
    indirect case negated(MatchRule)
    case closure((U) -> Bool)
    indirect case extract(MatchRule, UnsafeMutablePointer<U>)
    indirect case extractOptional(MatchRule, UnsafeMutablePointer<U?>)
    
    public static func differentThan(_ value: U) -> MatchRule {
        return .negated(.equals(value))
    }
    
    public static func differentThan(_ value: U?) -> MatchRule {
        return .negated(.equalsNullable(value))
    }
    
    public func evaluate(_ value: U) -> Bool {
        switch self {
        case .any:
            return true
            
        case .none:
            return false
            
        case .equals(let v):
            return value == v
            
        case .equalsNullable(let v):
            return value == v
        
        case .lazyEquals(let v):
            return value == v()
            
        case .lazyEqualsNullable(let v):
            return value == v()
            
        case .isType(let t):
            return type(of: value) == t
            
        case .all(let rules):
            for r in rules {
                if !r.evaluate(value) {
                    return false
                }
            }
            
            return true
            
        case .anyOf(let rules):
            for r in rules {
                if r.evaluate(value) {
                    return true
                }
            }
            
            return false
            
        case .negated(let rule):
            return !rule.evaluate(value)
            
        case .closure(let closure):
            return closure(value)
            
        case let .extract(rule, pointer):
            guard rule.evaluate(value) else {
                return false
            }
            
            pointer.pointee = value
            
            return true
            
        case let .extractOptional(rule, pointer):
            guard rule.evaluate(value) else {
                return false
            }
            
            pointer.pointee = value
            
            return true
        }
    }
    
    public static func ->> (lhs: MatchRule, rhs: UnsafeMutablePointer<U>) -> MatchRule {
        return .extract(lhs, rhs)
    }
    
    public static func ->> (lhs: MatchRule, rhs: UnsafeMutablePointer<U?>) -> MatchRule {
        return .extractOptional(lhs, rhs)
    }
    
    public static func && (lhs: MatchRule, rhs: MatchRule) -> MatchRule {
        switch (lhs, rhs) {
        case (.all(let l), .all(let r)):
            return .all(l + r)
        case (.all(let l), let r):
            return .all(l + [r])
        case (let l, .all(let r)):
            return .all([l] + r)
        default:
            return .all([lhs, rhs])
        }
    }
    
    public static func || (lhs: MatchRule, rhs: MatchRule) -> MatchRule {
        switch (lhs, rhs) {
        case (.anyOf(let l), .anyOf(let r)):
            return .anyOf(l + r)
        case (.anyOf(let l), let r):
            return .anyOf(l + [r])
        case (let l, .anyOf(let r)):
            return .anyOf([l] + r)
        default:
            return .anyOf([lhs, rhs])
        }
    }
    
}

extension MatchRule {
    
    public static func ->> <Z>(lhs: MatchRule, rhs: UnsafeMutablePointer<Z>) -> MatchRule where U == Z? {
        return .closure { v in
            if let value = v, lhs.evaluate(v) {
                rhs.pointee = value
                
                return true
            }
            
            return false
        }
    }
    
}

extension MatchRule: ExpressibleByIntegerLiteral where U == Int {
    public typealias IntegerLiteralType = U
    
    public init(integerLiteral value: U) {
        self = .equals(value)
    }
}

extension MatchRule: ExpressibleByFloatLiteral where U == Float {
    public typealias FloatLiteralType = U
    
    public init(floatLiteral value: U) {
        self = .equals(value)
    }
}

extension MatchRule: ExpressibleByUnicodeScalarLiteral where U == String {
    public typealias UnicodeScalarLiteralType = U
}

extension MatchRule: ExpressibleByExtendedGraphemeClusterLiteral where U == String {
    public typealias ExtendedGraphemeClusterLiteralType = U
}

extension MatchRule: ExpressibleByStringLiteral where U == String {
    public typealias StringLiteralType = U
    
    public init(stringLiteral value: U) {
        self = .equals(value)
    }
}

infix operator ->>: AssignmentPrecedence
