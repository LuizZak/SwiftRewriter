/// Provides a facility to analyze a postfix expression in left-to-right fashion.
public final class PostfixChainInverter {
    private var expression: PostfixExpression
    
    public init(expression: PostfixExpression) {
        self.expression = expression
    }
    
    public func invert() -> [Postfix] {
        var stack: [SwiftAST.Postfix] = []
        
        var next: PostfixExpression? = expression
        var last: Expression = expression
        
        while let current = next {
            stack.append(current.op)
            
            last = current.exp
            next = current.exp.asPostfix
        }
        
        // Unwind and prepare stack
        var result: [Postfix] = []
        
        result.append(.root(last))
        
        loop:
            while let pop = stack.popLast() {
                switch pop {
                case let op as MemberPostfix:
                    result.append(.member(op.name, original: op))
                    
                case let op as SubscriptPostfix:
                    result.append(.subscript(op.expression, original: op))
                    
                case let op as FunctionCallPostfix:
                    result.append(.call(op.arguments, original: op))
                    
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
        case member(String, original: MemberPostfix)
        case `subscript`(Expression, original: SubscriptPostfix)
        case call([FunctionArgument], original: FunctionCallPostfix)
        
        public var postfix: SwiftAST.Postfix? {
            switch self {
            case .root:
                return nil
            case .member(_, let original):
                return original
            case .call(_, let original):
                return original
            case .subscript(_, let original):
                return original
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
