public extension ValueTransformer where U: Expression {
    
    func decompose(file: String = #file,
                   line: Int = #line) -> ValueTransformer<T, [Expression]> {
        
        transforming(file: file, line: line) { $0.subExpressions }
    }
    
    func removingMemberAccess(file: String = #file,
                              line: Int = #line) -> ValueTransformer<T, Expression> {
        
        transforming(file: file, line: line) { value in
            guard let postfix = value.asPostfix, postfix.op is MemberPostfix else {
                return nil
            }
            
            return postfix.exp.copy()
        }
    }
    
    func typed(_ type: SwiftType, file: String = #file, line: Int = #line) -> ValueTransformer {
        transforming(file: file, line: line) { exp in
            exp.resolvedType = type
            return exp
        }
    }
    
    func typed(expectedType type: SwiftType,
               file: String = #file,
               line: Int = #line) -> ValueTransformer {
        
        transforming(file: file, line: line) { exp in
            exp.expectedType = type
            return exp
        }
    }
    
    func anyExpression(file: String = #file, line: Int = #line) -> ValueTransformer<T, Expression> {
        transforming(file: file, line: line) { $0 }
    }
}

public extension ValueTransformer where U == [Expression] {
    
    func asBinaryExpression(operator op: SwiftOperator,
                            file: String = #file,
                            line: Int = #line) -> ValueTransformer<T, BinaryExpression> {
        
        transforming(file: file, line: line) { exp -> BinaryExpression? in
            if exp.count != 2 {
                return nil
            }
            
            return BinaryExpression(lhs: exp[0].copy(),
                                    op: op,
                                    rhs: exp[1].copy())
        }
    }
    
    func asFunctionCall(labels: [String?],
                        file: String = #file,
                        line: Int = #line) -> ValueTransformer<T, PostfixExpression> {
        
        transforming(file: file, line: line) { exp -> PostfixExpression? in
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
