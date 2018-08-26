public typealias SyntaxMatcher<T> = ValueMatcher<T> where T: SyntaxNode

public extension ValueMatcher where T: SyntaxNode {
    
    public func anySyntaxNode() -> ValueMatcher<SyntaxNode> {
        return ValueMatcher<SyntaxNode>().match { (value) -> Bool in
            if let value = value as? T {
                return self.matches(value)
            }
            
            return false
        }
    }
    
}

public func ident(_ string: String) -> SyntaxMatcher<IdentifierExpression> {
    return SyntaxMatcher().keyPath(\.identifier, equals: string)
}

public func ident(_ matcher: MatchRule<String>) -> SyntaxMatcher<IdentifierExpression> {
    return SyntaxMatcher().keyPath(\.identifier, matcher)
}

public extension ValueMatcher where T: Expression {
    
    public func isTyped(_ type: SwiftType) -> ValueMatcher {
        return keyPath(\.resolvedType, equals: type)
    }
    
    public func isTyped(expected type: SwiftType) -> ValueMatcher {
        return keyPath(\.expectedType, equals: type)
    }
    
    public func dot<S>(_ member: S) -> SyntaxMatcher<PostfixExpression>
        where S: ValueMatcherConvertible, S.Target == String {
        
        return SyntaxMatcher<PostfixExpression>()
            .match(.closure { postfix -> Bool in
                guard let exp = postfix.exp as? T else {
                    return false
                }
                
                return self.matches(exp)
            })
            .keyPath(\.op.asMember?.name, member.asMatcher())
    }
    
    public func subscribe<E>(_ matcher: E) -> SyntaxMatcher<PostfixExpression>
        where E: ValueMatcherConvertible, E.Target == Expression {
            
        return SyntaxMatcher<PostfixExpression>()
            .match(.closure { postfix -> Bool in
                guard let exp = postfix.exp as? T else {
                    return false
                }
                
                return self.matches(exp)
            })
            .keyPath(\.op.asSubscription?.expression, matcher.asMatcher())
    }
    
    public func call(_ args: [FunctionArgument]) -> SyntaxMatcher<PostfixExpression> {
        return SyntaxMatcher<PostfixExpression>()
            .match { postfix -> Bool in
                guard let exp = postfix.exp as? T else {
                    return false
                }
                
                return self.matches(exp)
            }
            .keyPath(\.op.asFunctionCall?.arguments, equals: args)
    }
    
    public func call(arguments matchers: [ValueMatcher<FunctionArgument>]) -> SyntaxMatcher<PostfixExpression> {
        return SyntaxMatcher<PostfixExpression>()
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
                        if !matcher.matches(arg) {
                            return false
                        }
                    }
                    
                    return true
                })
            }
    }
    
    public func call(_ method: String) -> SyntaxMatcher<PostfixExpression> {
        return dot(method).call([])
    }
    
    public func binary<E>(op: SwiftOperator, rhs: E) -> SyntaxMatcher<BinaryExpression>
        where E: ValueMatcherConvertible, E.Target == Expression {
                
        return SyntaxMatcher<BinaryExpression>()
            .keyPath(\.op, .equals(op))
            .keyPath(\.rhs, rhs.asMatcher())
    }
    
    public func assignment<E>(op: SwiftOperator, rhs: E) -> SyntaxMatcher<AssignmentExpression>
        where E: ValueMatcherConvertible, E.Target == Expression {
        
        return SyntaxMatcher<AssignmentExpression>()
            .keyPath(\.op, .equals(op))
            .keyPath(\.rhs, rhs.asMatcher())
    }
}

public extension ValueMatcher where T == FunctionArgument {
    public static func isLabeled(as label: String) -> ValueMatcher {
        return ValueMatcher().keyPath(\.label, equals: label)
    }
    
    public static var isNotLabeled: ValueMatcher {
        return ValueMatcher().keyPath(\.label, isNil())
    }
}

public extension ValueMatcher where T: PostfixExpression {
    
    public typealias PostfixMatcher = ValueMatcher<[PostfixChainInverter.Postfix]>
    
    /// Matches if the postfix is a function invocation.
    public static var isFunctionCall: ValueMatcher<T> {
        return ValueMatcher<T>()
            .keyPath(\.op, .isType(FunctionCallPostfix.self))
    }
    
    /// Matches if the postfix is a member access.
    public static var isMemberAccess: ValueMatcher<T> {
        return ValueMatcher<T>()
            .keyPath(\.op, .isType(MemberPostfix.self))
    }
    
    /// Matches if the postfix is a subscription.
    public static var isSubscription: ValueMatcher<T> {
        return ValueMatcher<T>()
            .keyPath(\.op, .isType(SubscriptPostfix.self))
    }
    
    public static func isMemberAccess(forMember name: String) -> ValueMatcher<T> {
        return ValueMatcher<T>()
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
    public func inverted(_ closure: (PostfixMatcher) -> PostfixMatcher) -> ValueMatcher<T> {
        
        let matcher = closure(PostfixMatcher())
        
        return match { value -> Bool in
            let chain = PostfixChainInverter(expression: value).invert()
            
            return matcher.matches(chain)
        }
    }
}

public extension ValueMatcher where T == PostfixChainInverter.Postfix {
    
    /// Matches if the postfix is a function invocation.
    public static var isFunctionCall: ValueMatcher<T> {
        return ValueMatcher<T>()
            .keyPath(\.postfix, .isType(FunctionCallPostfix.self))
    }
    
    /// Matches if the postfix is a member access.
    public static var isMemberAccess: ValueMatcher<T> {
        return ValueMatcher<T>()
            .keyPath(\.postfix, .isType(MemberPostfix.self))
    }
    
    /// Matches if the postfix is a subscription.
    public static var isSubscription: ValueMatcher<T> {
        return ValueMatcher<T>()
            .keyPath(\.postfix, .isType(SubscriptPostfix.self))
    }
    
}

public extension ValueMatcher where T: Expression {
    
    public func anyExpression() -> ValueMatcher<Expression> {
        return ValueMatcher<Expression>().match { (value) -> Bool in
            if let value = value as? T {
                return self.matches(value)
            }
            
            return false
        }
    }
    
}

public extension ValueMatcher where T: Expression {
    
    public static var `nil`: ValueMatcher<Expression> {
        return ValueMatcher<Expression>().match { exp in
            guard let constant = exp as? ConstantExpression else {
                return false
            }
            
            return constant.constant == .nil
        }
    }
    
    // TODO: Revert implementation from both methods bellow to use `exp.asMatchable()`
    // and comparisons with dynamic matchers.
    // Currently, they crash the compiler on Xcode 10 beta 5.
    
    public static func nilCheck(against value: Expression) -> ValueMatcher<Expression> {
        return ValueMatcher<Expression>().match { exp in
            let valueCopy = value.copy()
            
            // <exp> != nil
            if exp == .binary(lhs: valueCopy, op: .unequals, rhs: .constant(.nil)) {
                return true
            }
            // nil != <exp>
            if exp == .binary(lhs: .constant(.nil), op: .unequals, rhs: valueCopy) {
                return true
            }
            // <exp>
            if exp == valueCopy {
                return true
            }
            
            return false
        }
    }
    
    public static func nilCompare(against value: Expression) -> ValueMatcher<Expression> {
        return ValueMatcher<Expression>().match { exp in
            let valueCopy = value.copy()
            
            // <exp> == nil
            if exp == .binary(lhs: valueCopy, op: .equals, rhs: .constant(.nil)) {
                return true
            }
            // nil == <exp>
            if exp == .binary(lhs: .constant(.nil), op: .equals, rhs: valueCopy) {
                return true
            }
            // !<exp>
            if exp == .unary(op: .negate, valueCopy) {
                return true
            }
            
            return false
        }
    }
    
    public static func findAny(thatMatches matcher: ValueMatcher) -> ValueMatcher {
        return ValueMatcher().match { exp in
            
            let sequence = SyntaxNodeSequence(node: exp, inspectBlocks: false)
            
            for e in sequence.compactMap({ $0 as? T }) {
                if matcher.matches(e) {
                    return true
                }
            }
            
            return false
        }
    }
    
}

public extension ValueMatcher where T == Expression {
    
    public static func unary<O, E>(op: O, _ exp: E) -> ValueMatcher<Expression>
        where O: ValueMatcherConvertible, E: ValueMatcherConvertible, O.Target == SwiftOperator, E.Target == Expression {
        
        return
            ValueMatcher<UnaryExpression>()
                .keyPath(\.op, op.asMatcher())
                .keyPath(\.exp, exp.asMatcher())
                .anyExpression()
    }
    
    public static func binary<O, E>(lhs: E, op: O, rhs: E) -> ValueMatcher<Expression>
        where O: ValueMatcherConvertible, E: ValueMatcherConvertible, O.Target == SwiftOperator, E.Target == Expression {
        
        return
            ValueMatcher<BinaryExpression>()
                .keyPath(\.lhs, lhs.asMatcher())
                .keyPath(\.op, op.asMatcher())
                .keyPath(\.rhs, rhs.asMatcher())
                .anyExpression()
    }
    
}

public extension Expression {
    
    public func asMatchable() -> ExpressionMatchable {
        return ExpressionMatchable(exp: self)
    }
    
    public static func matcher<T: Expression>(_ matcher: SyntaxMatcher<T>) -> SyntaxMatcher<T> {
        return matcher
    }
    
}

public struct ExpressionMatchable {
    public var exp: Expression
    
    public static func ==(lhs: ExpressionMatchable, rhs: ValueMatcher<Expression>) -> Bool {
        return lhs.exp.matches(rhs)
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
