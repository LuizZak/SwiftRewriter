public class UnknownExpression: Expression {
    public var context: UnknownASTContext
    
    public override var description: String {
        return context.description
    }
    
    public init(context: UnknownASTContext) {
        self.context = context
    }
    
    public override func copy() -> UnknownExpression {
        return UnknownExpression(context: context).copyTypeAndMetadata(from: self)
    }
    
    public override func accept<V: ExpressionVisitor>(_ visitor: V) -> V.ExprResult {
        return visitor.visitUnknown(self)
    }
    
    public override func isEqual(to other: Expression) -> Bool {
        return other is UnknownExpression
    }
    
    public static func == (lhs: UnknownExpression, rhs: UnknownExpression) -> Bool {
        return true
    }
}
public extension Expression {
    public var asUnknown: UnknownExpression? {
        return cast()
    }
}
