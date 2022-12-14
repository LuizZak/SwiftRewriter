/// A swift `try` expression.
public class TryExpression: Expression, ExpressionKindType {
    public var expressionKind: ExpressionKind {
        .tryExpression(self)
    }

    public var mode: Mode
    public var exp: Expression {
        didSet { oldValue.parent = nil; exp.parent = self; }
    }
    
    public override var subExpressions: [Expression] {
        [exp]
    }
    
    public override var isLiteralExpression: Bool {
        false
    }
    
    public override var description: String {
        "\(mode) \(exp)"
    }
    
    public init(mode: Mode, exp: Expression) {
        self.mode = mode
        self.exp = exp
        
        super.init()
        
        exp.parent = self
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        mode = try container.decode(Mode.self, forKey: .mode)
        exp = try container.decodeExpression(Expression.self, forKey: .exp)
        
        try super.init(from: container.superDecoder())
        
        exp.parent = self
    }
    
    @inlinable
    public override func copy() -> TryExpression {
        TryExpression(mode: mode, exp: exp.copy()).copyTypeAndMetadata(from: self)
    }
    
    @inlinable
    public override func accept<V: ExpressionVisitor>(_ visitor: V) -> V.ExprResult {
        visitor.visitTry(self)
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(mode, forKey: .mode)
        try container.encodeExpression(exp, forKey: .exp)
        
        try super.encode(to: container.superEncoder())
    }
    
    public override func isEqual(to other: Expression) -> Bool {
        switch other {
        case let rhs as TryExpression:
            return self == rhs
        default:
            return false
        }
    }
    
    public static func == (lhs: TryExpression, rhs: TryExpression) -> Bool {
        if lhs === rhs {
            return true
        }
        
        return lhs.mode == rhs.mode && lhs.exp == rhs.exp
    }
    
    private enum CodingKeys: String, CodingKey {
        case exp
        case mode
    }

    /// Defines the mode of the try expression.
    public enum Mode: String, Codable, CustomStringConvertible {
        /// A throwable try; `try <exp>`.
        case throwable

        /// A nil-returning try; `try? <exp>`.
        case optional

        /// A force-try; `try! <exp>`.
        case forced

        public var description: String {
            switch self {
            case .throwable:
                return "try"
            case .optional:
                return "try?"
            case .forced:
                return "try!"
            }
        }
    }
}
public extension Expression {
    @inlinable
    var asTry: TryExpression? {
        cast()
    }

    @inlinable
    var isTry: Bool {
        asTry != nil
    }

    static func `try`(
        _ exp: Expression,
        mode: TryExpression.Mode = .throwable
    ) -> TryExpression {
        TryExpression(mode: mode, exp: exp)
    }
}

