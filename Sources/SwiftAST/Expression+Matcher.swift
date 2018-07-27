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

public extension ValueMatcher where T: Equatable {
    
    public func bind(to target: UnsafeMutablePointer<T>) -> ValueMatcher {
        return self.match(.extract(.any, target))
    }
    
    public func bind(to target: UnsafeMutablePointer<T?>) -> ValueMatcher {
        return self.match(.extractOptional(.any, target))
    }
    
}

public extension ValueMatcher where T: Expression {
    public func dot(_ member: String) -> SyntaxMatcher<PostfixExpression> {
        return SyntaxMatcher<PostfixExpression>()
            .match(.closure { postfix -> Bool in
                guard let exp = postfix.exp as? T else {
                    return false
                }
                
                return self.matches(exp)
            })
            .keyPath(\.op.asMember?.name, equals: member)
    }
    
    public func subscribe(_ matcher: SyntaxMatcher<Expression>) -> SyntaxMatcher<PostfixExpression> {
        return SyntaxMatcher<PostfixExpression>()
            .match(.closure { postfix -> Bool in
                guard let exp = postfix.exp as? T else {
                    return false
                }
                
                return self.matches(exp)
            })
            .keyPath(\.op.asSubscription?.expression, matcher)
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
    
    public func call(_ method: String) -> SyntaxMatcher<PostfixExpression> {
        return dot(method).call([])
    }
    
    public func binary(op: SwiftOperator, rhs: SyntaxMatcher<Expression>) -> SyntaxMatcher<BinaryExpression> {
        return SyntaxMatcher<BinaryExpression>()
            .keyPath(\.op, .equals(op))
            .keyPath(\.rhs, rhs)
    }
    
    public func assignment(op: SwiftOperator, rhs: SyntaxMatcher<Expression>) -> SyntaxMatcher<AssignmentExpression> {
        return SyntaxMatcher<AssignmentExpression>()
            .keyPath(\.op, .equals(op))
            .keyPath(\.rhs, rhs)
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
    
    public static func nilCheck(against value: Expression) -> ValueMatcher<Expression> {
        return ValueMatcher<Expression>().match { exp in
            
            // <exp> == nil
            if exp == .binary(lhs: value, op: .equals, rhs: .constant(.nil)) {
                return true
            }
            // nil == <exp>
            if exp == .binary(lhs: .constant(.nil), op: .equals, rhs: value) {
                return true
            }
            // !<exp>
            if exp == .unary(op: .negate, value) {
                return true
            }
            
            return false
        }
    }
    
    public static func findAny(thatMatches matcher: ValueMatcher<Expression>) -> ValueMatcher<Expression> {
        return ValueMatcher<Expression>().match { exp in
            
            let sequence = SyntaxNodeSequence(node: exp, inspectBlocks: false)
            
            for e in sequence.compactMap({ $0 as? Expression }) {
                if matcher.matches(e) {
                    return true
                }
            }
            
            return false
        }
    }
    
}

public extension Expression {
    
    public static func matcher<T: Expression>(_ matcher: SyntaxMatcher<T>) -> SyntaxMatcher<T> {
        return matcher
    }
    
}

extension Expression: Matchable {
    
}
