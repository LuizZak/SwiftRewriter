public class SizeOfExpression: Expression {
    public var value: Value {
        didSet {
            switch oldValue {
            case .expression(let exp):
                exp.parent = nil
            case .type: break
            }
            
            switch value {
            case .expression(let exp):
                exp.parent = self
            case .type: break
            }
        }
    }
    
    /// If this `SizeOfExpression`'s value is an expression input value, returns
    /// that expression, otherwise returns `nil`
    public var exp: Expression? {
        switch value {
        case .expression(let exp):
            return exp
        case .type:
            return nil
        }
    }
    
    public override var subExpressions: [Expression] {
        switch value {
        case .expression(let exp):
            return [exp]
        case .type:
            return []
        }
    }
    
    public init(value: Value) {
        self.value = value
        super.init()
    }
    
    public override func copy() -> SizeOfExpression {
        return SizeOfExpression(value: value.copy()).copyTypeAndMetadata(from: self)
    }
    
    public override func accept<V>(_ visitor: V) -> V.ExprResult where V : ExpressionVisitor {
        return visitor.visitSizeOf(self)
    }
    
    public override func isEqual(to other: Expression) -> Bool {
        switch other {
        case let rhs as SizeOfExpression:
            return self == rhs
        default:
            return false
        }
    }
    
    public static func == (lhs: SizeOfExpression, rhs: SizeOfExpression) -> Bool {
        return lhs.value == rhs.value
    }
    
    /// Inner expression value for this SizeOfExpression
    public enum Value: Equatable {
        case type(SwiftType)
        case expression(Expression)
        
        public func copy() -> Value {
            switch self {
            case .type:
                return self
            case .expression(let exp):
                return .expression(exp.copy())
            }
        }
    }
}
extension Expression {
    public var asSizeOf: SizeOfExpression? {
        return cast()
    }
}
