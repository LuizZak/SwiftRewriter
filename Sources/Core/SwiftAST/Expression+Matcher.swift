public typealias SyntaxMatcher<T> = ValueMatcher<T> where T: SyntaxNode

public extension ValueMatcher where T: SyntaxNode {
    
    @inlinable
    func anySyntaxNode() -> ValueMatcher<SyntaxNode> {
        ValueMatcher<SyntaxNode>().match { (value) -> Bool in
            if let value = value as? T {
                return self.matches(value)
            }
            
            return false
        }
    }
    
}

@inlinable
public func ident(_ string: String) -> SyntaxMatcher<IdentifierExpression> {
    SyntaxMatcher().keyPath(\.identifier, equals: string)
}

@inlinable
public func ident(_ matcher: MatchRule<String>) -> SyntaxMatcher<IdentifierExpression> {
    SyntaxMatcher().keyPath(\.identifier, matcher)
}

public extension ValueMatcher where T: Expression {

    @inlinable
    func isTyped(_ type: SwiftType, ignoringNullability: Bool = false) -> ValueMatcher {
        if !ignoringNullability {
            return keyPath(\.resolvedType, equals: type)
        }
        
        return keyPath(\.resolvedType, .closure { $0?.deepUnwrapped == type })
    }

    @inlinable
    func isTyped(expected type: SwiftType, ignoringNullability: Bool = false) -> ValueMatcher {
        if !ignoringNullability {
            return keyPath(\.expectedType, equals: type)
        }
        
        return keyPath(\.expectedType, .closure { $0?.deepUnwrapped == type })
    }

    @inlinable
    func dot<S>(_ member: S) -> SyntaxMatcher<PostfixExpression>
        where S: ValueMatcherConvertible, S.Target == String {
        
        SyntaxMatcher<PostfixExpression>()
            .match(.closure { postfix -> Bool in
                guard let exp = postfix.exp as? T else {
                    return false
                }
                
                return self.matches(exp)
            })
            .keyPath(\.op.asMember?.name, member.asMatcher())
    }

    @inlinable
    func subscribe(arguments matchers: [ValueMatcher<FunctionArgument>]) -> SyntaxMatcher<PostfixExpression> {
            
        SyntaxMatcher<PostfixExpression>()
            .match(.closure { postfix -> Bool in
                guard let exp = postfix.exp as? T else {
                    return false
                }
                
                return self.matches(exp)
            })
            .keyPath(\.op.asSubscription?.arguments.count, equals: matchers.count)
            .keyPath(\.op.asSubscription?.arguments) { args -> ValueMatcher<[FunctionArgument]> in
                args.match(closure: { args -> Bool in
                    for (matcher, arg) in zip(matchers, args) {
                        if !matcher(matches: arg) {
                            return false
                        }
                    }
                    
                    return true
                })
            }
    }

    @inlinable
    func call(_ args: [FunctionArgument]) -> SyntaxMatcher<PostfixExpression> {
        SyntaxMatcher<PostfixExpression>()
            .match { postfix -> Bool in
                guard let exp = postfix.exp as? T else {
                    return false
                }
                
                return self.matches(exp)
            }
            .keyPath(\.op.asFunctionCall?.arguments, equals: args)
    }

    @inlinable
    func call(arguments matchers: [ValueMatcher<FunctionArgument>]) -> SyntaxMatcher<PostfixExpression> {
        SyntaxMatcher<PostfixExpression>()
            .match { postfix -> Bool in
                guard let exp = postfix.exp as? T else {
                    return false
                }
                
                return self.matches(exp)
            }
            .keyPath(\.op.asFunctionCall?.arguments.count, equals: matchers.count)
            .keyPath(\.op.asFunctionCall?.arguments) { args -> ValueMatcher<[FunctionArgument]> in
                args.match(closure: { args -> Bool in
                    for (matcher, arg) in zip(matchers, args) {
                        if !matcher(matches: arg) {
                            return false
                        }
                    }
                    
                    return true
                })
            }
    }

    @inlinable
    func call(_ method: String) -> SyntaxMatcher<PostfixExpression> {
        dot(method).call([])
    }

    @inlinable
    func binary<E>(op: SwiftOperator, rhs: E) -> SyntaxMatcher<BinaryExpression>
        where E: ValueMatcherConvertible, E.Target == Expression {
                
        SyntaxMatcher<BinaryExpression>()
            .keyPath(\.op, .equals(op))
            .keyPath(\.rhs, rhs.asMatcher())
    }

    @inlinable
    func assignment<E>(op: SwiftOperator, rhs: E) -> SyntaxMatcher<AssignmentExpression>
        where E: ValueMatcherConvertible, E.Target == Expression {
        
        SyntaxMatcher<AssignmentExpression>()
            .keyPath(\.op, .equals(op))
            .keyPath(\.rhs, rhs.asMatcher())
    }
}

public extension ValueMatcher where T == FunctionArgument {
    @inlinable
    static func isLabeled(as label: String) -> ValueMatcher {
        ValueMatcher().keyPath(\.label, equals: label)
    }

    @inlinable
    static var isNotLabeled: ValueMatcher {
        ValueMatcher().keyPath(\.label, isNil())
    }
}

public extension ValueMatcher where T: PostfixExpression {
    
    typealias PostfixMatcher = ValueMatcher<[PostfixChainInverter.Postfix]>
    
    /// Matches if the postfix is a function invocation.
    @inlinable
    static var isFunctionCall: ValueMatcher<T> {
        ValueMatcher<T>()
            .keyPath(\.op, .isType(FunctionCallPostfix.self))
    }
    
    /// Matches if the postfix is a member access.
    @inlinable
    static var isMemberAccess: ValueMatcher<T> {
        ValueMatcher<T>()
            .keyPath(\.op, .isType(MemberPostfix.self))
    }
    
    /// Matches if the postfix is a subscription.
    @inlinable
    static var isSubscription: ValueMatcher<T> {
        ValueMatcher<T>()
            .keyPath(\.op, .isType(SubscriptPostfix.self))
    }

    @inlinable
    static func isMemberAccess(forMember name: String) -> ValueMatcher<T> {
        ValueMatcher<T>()
            .keyPath(\.op, .isType(MemberPostfix.self))
    }
    
    /// Opens a context for matching postfix operation chains using an inverted
    /// traversal method (left-most to right-most).
    ///
    /// Inversion is required due to the disposition of the syntax tree of postfix
    /// expressions: the top node is always the last postfix invocation of the
    /// chain, while the bottom-most postfix node is the first invocation.
    ///
    /// - Parameter closure: A closure that matches postfix expressions from
    /// leftmost to rightmost.
    /// - Returns: A new `PostfixExpression` matcher with the left-to-right
    /// postfix matcher constructed using the closure.
    @inlinable
    func inverted(_ closure: (PostfixMatcher) -> PostfixMatcher) -> ValueMatcher<T> {
        
        let matcher = closure(PostfixMatcher())
        
        return match { value -> Bool in
            let chain = PostfixChainInverter(expression: value).invert()
            
            return matcher.matches(chain)
        }
    }
}

public extension ValueMatcher where T == PostfixChainInverter.Postfix {
    
    /// Matches if the postfix is a function invocation.
    @inlinable
    static var isFunctionCall: ValueMatcher<T> {
        ValueMatcher<T>()
            .keyPath(\.postfix, .isType(FunctionCallPostfix.self))
    }
    
    /// Matches if the postfix is a member access.
    @inlinable
    static var isMemberAccess: ValueMatcher<T> {
        ValueMatcher<T>()
            .keyPath(\.postfix, .isType(MemberPostfix.self))
    }
    
    /// Matches if the postfix is a subscription.
    @inlinable
    static var isSubscription: ValueMatcher<T> {
        ValueMatcher<T>()
            .keyPath(\.postfix, .isType(SubscriptPostfix.self))
    }
    
}

public extension ValueMatcher where T: Expression {

    @inlinable
    func anyExpression() -> ValueMatcher<Expression> {
        ValueMatcher<Expression>().match { (value) -> Bool in
            if let value = value as? T {
                return self(matches: value)
            }
            
            return false
        }
    }
    
}

public extension ValueMatcher where T: Expression {

    @inlinable
    static var `nil`: ValueMatcher<Expression> {
        ValueMatcher<Expression>().match { exp in
            guard let constant = exp as? ConstantExpression else {
                return false
            }
            
            return constant.constant == .nil
        }
    }

    @inlinable
    static func nilCheck(against value: Expression) -> ValueMatcher<Expression> {
        ValueMatcher<Expression>().match { exp in
            // <exp> != nil
            if exp.asMatchable() == .binary(lhs: value, op: SwiftOperator.unequals, rhs: .constant(.nil)) {
                return true
            }
            // nil != <exp>
            if exp.asMatchable() == .binary(lhs: .constant(.nil), op: SwiftOperator.unequals, rhs: value) {
                return true
            }
            // <exp>
            if exp == value {
                return true
            }
            
            return false
        }
    }

    @inlinable
    static func nilCompare(against value: Expression) -> ValueMatcher<Expression> {
        ValueMatcher<Expression>().match { exp in
            // <exp> == nil
            if exp.asMatchable() == .binary(lhs: value, op: SwiftOperator.equals, rhs: .constant(.nil)) {
                return true
            }
            // nil == <exp>
            if exp.asMatchable() == .binary(lhs: .constant(.nil), op: SwiftOperator.equals, rhs: value) {
                return true
            }
            // !<exp>
            if exp.asMatchable() == .unary(op: SwiftOperator.negate, value) {
                return true
            }
            
            return false
        }
    }

    @inlinable
    static func findAny(thatMatches matcher: ValueMatcher) -> ValueMatcher {
        ValueMatcher().match { exp in
            
            let sequence = SyntaxNodeSequence(node: exp, inspectBlocks: false)
            
            for e in sequence.compactMap({ $0 as? T }) {
                if matcher(matches: e) {
                    return true
                }
            }
            
            return false
        }
    }
    
}

public extension ValueMatcher where T == Expression {

    @inlinable
    static func unary<O, E>(op: O, _ exp: E) -> ValueMatcher<Expression>
        where O: ValueMatcherConvertible, E: ValueMatcherConvertible,
        O.Target == SwiftOperator, E.Target == Expression {
        
        ValueMatcher<UnaryExpression>()
                .keyPath(\.op, op.asMatcher())
                .keyPath(\.exp, exp.asMatcher())
                .anyExpression()
    }

    @inlinable
    static func binary<O, E>(lhs: E, op: O, rhs: E) -> ValueMatcher<Expression>
        where O: ValueMatcherConvertible, E: ValueMatcherConvertible,
        O.Target == SwiftOperator, E.Target == Expression {
        
        ValueMatcher<BinaryExpression>()
                .keyPath(\.lhs, lhs.asMatcher())
                .keyPath(\.op, op.asMatcher())
                .keyPath(\.rhs, rhs.asMatcher())
                .anyExpression()
    }
    
}

public extension Expression {
    
    func asMatchable() -> ExpressionMatchable {
        ExpressionMatchable(exp: self)
    }

    @inlinable
    static func matcher<T: Expression>(_ matcher: SyntaxMatcher<T>) -> SyntaxMatcher<T> {
        matcher
    }
    
}

public struct ExpressionMatchable {
    public var exp: Expression
    
    @inlinable
    public static func == (lhs: ExpressionMatchable, rhs: ValueMatcher<Expression>) -> Bool {
        rhs(matches: lhs.exp)
    }
}

extension Expression: Matchable {
    
}

extension Expression: ValueMatcherConvertible {
    
}
extension SwiftOperator: ValueMatcherConvertible {
    
}
extension SwiftType: ValueMatcherConvertible {
    
}
extension String: ValueMatcherConvertible {
    
}
