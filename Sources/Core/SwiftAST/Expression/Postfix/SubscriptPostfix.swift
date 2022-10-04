/// Postfix access that invokes a subscription into a value or type.
public final class SubscriptPostfix: Postfix {
    private let _subExpressions: [Expression]
    public let arguments: [FunctionArgument]
    
    public override var description: String {
        "\(super.description)[\(arguments.map(\.description).joined(separator: ", "))]"
    }
    
    public override var subExpressions: [Expression] {
        _subExpressions
    }
    
    /// Gets the list of keywords for the arguments passed to this function call.
    public var argumentKeywords: [String?] {
        arguments.map(\.label)
    }
    
    public init(arguments: [FunctionArgument]) {
        self.arguments = arguments
        self._subExpressions = arguments.map(\.expression)
        
        super.init()
    }
    
    public convenience init(expressions: [Expression]) {
        self.init(arguments: expressions.map {
            FunctionArgument(label: nil, expression: $0)
        })
    }
    
    public convenience init(expression: Expression) {
        self.init(arguments: [
            FunctionArgument(label: nil, expression: expression)
        ])
    }
    
    public required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        try self.init(arguments: container.decode([FunctionArgument].self, forKey: .arguments))
    }
    
    public override func copy() -> SubscriptPostfix {
        SubscriptPostfix(arguments: arguments.map { $0.copy() })
            .copyTypeAndMetadata(from: self)
    }
    
    /// Returns a new subscript call postfix with the arguments replaced to a
    /// given arguments array, while keeping argument labels and resolved type
    /// information.
    ///
    /// The number of arguments passed must match the number of arguments present
    /// in this subscript call postfix.
    ///
    /// - precondition: `expressions.count == self.arguments.count`
    public func replacingArguments(_ expressions: [Expression]) -> SubscriptPostfix {
        precondition(expressions.count == arguments.count)
        
        let newArgs: [FunctionArgument] =
            zip(arguments, expressions).map { tuple in
                let (arg, exp) = tuple
                
                return FunctionArgument(label: arg.label, expression: exp)
            }
        
        let new =
            SubscriptPostfix(arguments: newArgs)
                .copyTypeAndMetadata(from: self)
        
        return new
    }
    
    public override func isEqual(to other: Postfix) -> Bool {
        switch other {
        case let rhs as SubscriptPostfix:
            return self == rhs
        default:
            return false
        }
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(arguments, forKey: .arguments)
        
        try super.encode(to: container.superEncoder())
    }
    
    public static func == (lhs: SubscriptPostfix, rhs: SubscriptPostfix) -> Bool {
        if lhs === rhs {
            return true
        }
        
        return lhs.optionalAccessKind == rhs.optionalAccessKind
            && lhs.arguments == rhs.arguments
    }
    
    private enum CodingKeys: String, CodingKey {
        case arguments
    }
}
public extension Postfix {
    static func `subscript`(_ exp: Expression) -> SubscriptPostfix {
        SubscriptPostfix(expression: exp)
    }
    
    static func `subscript`(expressions: [Expression]) -> SubscriptPostfix {
        SubscriptPostfix(expressions: expressions)
    }
    
    static func `subscript`(arguments: [FunctionArgument]) -> SubscriptPostfix {
        SubscriptPostfix(arguments: arguments)
    }
    
    @inlinable
    var asSubscription: SubscriptPostfix? {
        self as? SubscriptPostfix
    }

    @inlinable
    var isSubscription: Bool {
        asSubscription != nil
    }
}
// Helper casting getter extensions to postfix expression
public extension PostfixExpression {
    @inlinable
    var subscription: SubscriptPostfix? {
        op as? SubscriptPostfix
    }

    @inlinable
    var isSubscription: Bool {
        subscription != nil
    }
}
