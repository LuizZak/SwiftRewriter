struct DecomposedExpression {
    var original: Expression
    var subExpressions: [Expression]
}

class ExpTransformer {
    var transformers: [([Expression]) -> [Expression]?] = []
    
    func subTransform(index: Int, transformer: ExpTransformer) -> ExpTransformer {
        _append { exp in
            var exp = exp
            if exp.count <= index {
                return nil
            }
            if let transformed = transformer.transform(expression: exp[index]) {
                exp[index] = transformed
            }
            
            return exp
        }
        
        return self
    }
    
    func removeMemberAccess() -> ExpTransformer {
        _appendUnique { exp in
            guard let postfix = exp.asPostfix, postfix.member != nil else {
                return nil
            }
            
            return [postfix.exp]
        }
        
        return self
    }
    
    func addMemberAccess(name: String) -> ExpTransformer {
        _appendUnique { exp -> [Expression]? in
            return [exp.copy().dot(name)]
        }
        
        return self
    }
    
    func reduce(functionCall arguments: [String?]) -> ExpTransformer {
        _reduce { exp in
            if exp.count != arguments.count + 1 {
                return nil
            }
            
            let arguments =
                zip(arguments, exp.dropFirst().map { $0.copy() })
                    .map(FunctionArgument.init)
            
            return PostfixExpression(
                exp: exp[0].copy(),
                op: .functionCall(arguments: arguments)
            )
        }
        
        return self
    }
    
    func transform(expression: Expression) -> Expression? {
        let exp = expression.subExpressions
        
        let reduced =
            transformers.reduce(exp) { (e, transformer) -> [Expression]? in
                return e.flatMap(transformer)
            }
        
        if let reduced = reduced, reduced.count == 1 {
            return reduced.first
        }
        
        return nil
    }
    
    private func _append(transform: @escaping ([Expression]) -> [Expression]?) {
        transformers.append(transform)
    }
    
    private func _appendUnique(transform: @escaping (Expression) -> [Expression]?) {
        _append { exp in
            guard exp.count == 1, let first = exp.first else {
                return nil
            }
            
            return transform(first)
        }
    }
    
    private func _reduce(transform: @escaping ([Expression]) -> Expression?) {
        _append { exp in
            if let exp = transform(exp) {
                return [exp]
            }
            
            return nil
        }
    }
}

protocol ExpressionTransformer {
    associatedtype Output: Expression
    
    func transform(_ decomposed: DecomposedExpression) -> Output?
}

class TernaryExpressionTransformer: ExpressionTransformer {
    func transform(_ decomposed: DecomposedExpression) -> TernaryExpression? {
        if decomposed.subExpressions.count != 3 {
            return nil
        }
        
        return TernaryExpression(exp: decomposed.subExpressions[0],
                                 ifTrue: decomposed.subExpressions[1],
                                 ifFalse: decomposed.subExpressions[2])
    }
}

class BinaryExpressionTransformer: ExpressionTransformer {
    var op: SwiftOperator
    
    init(op: SwiftOperator) {
        self.op = op
    }
    
    func transform(_ decomposed: DecomposedExpression) -> BinaryExpression? {
        if decomposed.subExpressions.count != 2 {
            return nil
        }
        
        return BinaryExpression(lhs: decomposed.subExpressions[0],
                                op: op,
                                rhs: decomposed.subExpressions[1])
    }
}

class FunctionInvocationExpressionTransformer: ExpressionTransformer {
    var argumentLabels: [String?]
    
    init(argumentLabels: [String?]) {
        self.argumentLabels = argumentLabels
    }
    
    func transform(_ decomposed: DecomposedExpression) -> PostfixExpression? {
        if decomposed.subExpressions.count != argumentLabels.count + 1 {
            return nil
        }
        
        let base = decomposed.subExpressions[0]
        
        let arguments =
            zip(argumentLabels, decomposed.subExpressions.dropFirst())
                .map(FunctionArgument.init)
        
        return PostfixExpression(
            exp: base,
            op: .functionCall(arguments: arguments)
        )
    }
}
