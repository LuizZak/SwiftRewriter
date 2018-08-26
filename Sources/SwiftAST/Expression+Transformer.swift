public extension ValueTransformer where U: Expression {
    
    public func decompose() -> ValueTransformer<T, [Expression]> {
        return transforming { $0.subExpressions }
    }
    
    public func removingMemberAccess() -> ValueTransformer<T, Expression> {
        return transforming { value in
            guard let postfix = value.asPostfix, postfix.op is MemberPostfix else {
                return nil
            }
            
            return postfix.exp.copy()
        }
    }
    
    public func typed(_ type: SwiftType) -> ValueTransformer {
        return transforming { exp in
            exp.resolvedType = type
            return exp
        }
    }
    
    public func typed(expectedType type: SwiftType) -> ValueTransformer {
        return transforming { exp in
            exp.expectedType = type
            return exp
        }
    }
    
    public func anyExpression() -> ValueTransformer<T, Expression> {
        return transforming { $0 }
    }
}

public extension ValueTransformer where U == [Expression] {
    
    public func asBinaryExpression(operator op: SwiftOperator) -> ValueTransformer<T, BinaryExpression> {
        return transforming { exp -> BinaryExpression? in
            if exp.count != 2 {
                return nil
            }
            
            return BinaryExpression(lhs: exp[0].copy(),
                                    op: op,
                                    rhs: exp[1].copy())
        }
    }
    
    public func asFunctionCall(labels: [String?]) -> ValueTransformer<T, PostfixExpression> {
        return transforming { exp -> PostfixExpression? in
            if exp.count != labels.count + 1 {
                return nil
            }
            
            let arguments =
                zip(labels, exp.dropFirst().map { $0.copy() })
                    .map(FunctionArgument.init)
            
            return PostfixExpression(exp: exp[0].copy(),
                                     op: .functionCall(arguments: arguments))
        }
    }
}
