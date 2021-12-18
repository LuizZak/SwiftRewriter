/// Acts as a facilitator when analyzing a postfix expression in a left-to-right
/// fashion.
public final class PostfixChainInverter {
    private var expression: PostfixExpression
    
    public init(expression: PostfixExpression) {
        self.expression = expression
    }
    
    public func invert() -> [Postfix] {
        var stack: [PostfixExpression] = []
        
        var next: PostfixExpression? = expression
        var last: Expression = expression
        
        while let current = next {
            stack.append(current)
            
            last = current.exp
            next = current.exp.asPostfix
        }
        
        // Unwind and prepare stack
        var result: [Postfix] = []
        
        result.append(.root(last))
        
        loop:
            while let pop = stack.popLast() {
                switch pop.op {
                case let op as MemberPostfix:
                    result.append(.member(op.name, original: op, pop))
                    
                case let op as SubscriptPostfix:
                    result.append(.subscript(op.arguments, original: op, pop))
                    
                case let op as FunctionCallPostfix:
                    result.append(.call(op.arguments, original: op, pop))
                    
                default:
                    break loop
                }
            }
        
        return result
    }
    
    public static func invert(expression: PostfixExpression) -> [Postfix] {
        let inverter = PostfixChainInverter(expression: expression)
        return inverter.invert()
    }
    
    public enum Postfix: Equatable {
        case root(Expression)
        case member(String, original: MemberPostfix, PostfixExpression)
        case `subscript`([FunctionArgument], original: SubscriptPostfix, PostfixExpression)
        case call([FunctionArgument], original: FunctionCallPostfix, PostfixExpression)
        
        public var postfix: SwiftAST.Postfix? {
            switch self {
            case .root:
                return nil
                
            case .member(_, let original, _):
                return original
                
            case .call(_, let original, _):
                return original
                
            case .subscript(_, let original, _):
                return original
            }
        }
        
        public var postfixExpression: PostfixExpression? {
            switch self {
            case .root:
                return nil
                
            case .member(_, _, let exp),
                 .subscript(_, _, let exp),
                 .call(_, _, let exp):
                return exp
            }
        }
        
        public var expression: Expression? {
            switch self {
            case .root(let exp):
                return exp
                
            default:
                return nil
            }
        }
        
        public var resolvedType: SwiftType? {
            switch self {
            case .root(let exp):
                return exp.resolvedType
                
            default:
                return postfix?.returnType
            }
        }
    }
}
