public class IdentifierExpression: Expression, ExpressibleByStringLiteral {
    public var identifier: String
    
    public override var description: String {
        return identifier
    }
    
    public required init(stringLiteral value: String) {
        self.identifier = value
    }
    
    public init(identifier: String) {
        self.identifier = identifier
    }
    
    public override func copy() -> IdentifierExpression {
        return IdentifierExpression(identifier: identifier).copyTypeAndMetadata(from: self)
    }
    
    public override func accept<V: ExpressionVisitor>(_ visitor: V) -> V.ExprResult {
        return visitor.visitIdentifier(self)
    }
    
    public override func isEqual(to other: Expression) -> Bool {
        switch other {
        case let rhs as IdentifierExpression:
            return self == rhs
        default:
            return false
        }
    }
    
    public static func == (lhs: IdentifierExpression, rhs: IdentifierExpression) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
public extension Expression {
    public var asIdentifier: IdentifierExpression? {
        return cast()
    }
}
