public class ExpressionTypeResolver: ExpressionVisitor {
    public typealias ExprResult = SwiftType?
    
    public func visitExpression(_ expression: Expression) -> SwiftType? {
        return expression.resolvedType
    }
    
    public func visitAssignment(_ exp: AssignmentExpression) -> SwiftType? {
        return exp.rhs.accept(self)
    }
    
    public func visitBinary(_ exp: BinaryExpression) -> SwiftType? {
        return nil
    }
    
    public func visitUnary(_ exp: UnaryExpression) -> SwiftType? {
        return exp.exp.accept(self)
    }
    
    public func visitPrefix(_ exp: PrefixExpression) -> SwiftType? {
        return exp.exp.accept(self)
    }
    
    public func visitPostfix(_ exp: PostfixExpression) -> SwiftType? {
        return exp.exp.accept(self)
    }
    
    public func visitConstant(_ exp: ConstantExpression) -> SwiftType? {
        return nil
    }
    
    public func visitParens(_ exp: ParensExpression) -> SwiftType? {
        return nil
    }
    
    public func visitIdentifier(_ exp: IdentifierExpression) -> SwiftType? {
        return nil
    }
    
    public func visitCast(_ exp: CastExpression) -> SwiftType? {
        return nil
    }
    
    public func visitArray(_ exp: ArrayLiteralExpression) -> SwiftType? {
        return SwiftType.nsArray
    }
    
    public func visitDictionary(_ exp: DictionaryLiteralExpression) -> SwiftType? {
        return SwiftType.nsDictionary
    }
    
    public func visitBlock(_ exp: BlockLiteralExpression) -> SwiftType? {
        return nil
    }
    
    public func visitTernary(_ exp: TernaryExpression) -> SwiftType? {
        return nil
    }
    
    public func visitUnknown(_ exp: UnknownExpression) -> SwiftType? {
        return nil
    }
}
