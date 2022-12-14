/// Postfix access that invokes an expression as a function.
public final class FunctionCallPostfix: Postfix {
    private let _subExpressions: [Expression]
    public let arguments: [FunctionArgument]
    
    public override var description: String {
        "\(super.description)(\(arguments.map(\.description).joined(separator: ", ")))"
    }
    
    public override var subExpressions: [Expression] {
        _subExpressions
    }
    
    /// Gets the list of keywords for the arguments passed to this function call.
    public var argumentKeywords: [String?] {
        arguments.map(\.label)
    }
    
    /// A block Swift type signature for this function call postfix.
    public var callableSignature: BlockSwiftType?
    
    public init(arguments: [FunctionArgument]) {
        self.arguments = arguments
        self._subExpressions = arguments.map(\.expression)
        
        super.init()
    }
    
    public required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        try self.init(arguments: container.decode([FunctionArgument].self, forKey: .arguments))
    }
    
    public override func copy() -> FunctionCallPostfix {
        let copy =
            FunctionCallPostfix(arguments: arguments.map { $0.copy() })
                .copyTypeAndMetadata(from: self)
        copy.callableSignature = callableSignature
        return copy
    }
    
    /// Returns a new function call postfix with the arguments replaced to a given
    /// arguments array, while keeping argument labels and resolved type information.
    ///
    /// The number of arguments passed must match the number of arguments present
    /// in this function call postfix.
    ///
    /// - precondition: `expressions.count == self.arguments.count`
    public func replacingArguments(_ expressions: [Expression]) -> FunctionCallPostfix {
        precondition(expressions.count == arguments.count)
        
        let newArgs: [FunctionArgument] =
            zip(arguments, expressions).map { tuple in
                let (arg, exp) = tuple
                
                return FunctionArgument(label: arg.label, expression: exp)
            }
        
        let new =
            FunctionCallPostfix(arguments: newArgs)
                .copyTypeAndMetadata(from: self)
        new.callableSignature = callableSignature
        
        return new
    }
    
    public override func isEqual(to other: Postfix) -> Bool {
        switch other {
        case let rhs as FunctionCallPostfix:
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
    
    public static func == (lhs: FunctionCallPostfix, rhs: FunctionCallPostfix) -> Bool {
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
    static func functionCall(arguments: [FunctionArgument] = []) -> FunctionCallPostfix {
        FunctionCallPostfix(arguments: arguments)
    }
    
    @inlinable
    var asFunctionCall: FunctionCallPostfix? {
        self as? FunctionCallPostfix
    }

    @inlinable
    var isFunctionCall: Bool {
        asFunctionCall != nil
    }
}
// Helper casting getter extensions to postfix expression
public extension PostfixExpression {
    @inlinable
    var functionCall: FunctionCallPostfix? {
        op as? FunctionCallPostfix
    }

    @inlinable
    var isFunctionCall: Bool {
        functionCall != nil
    }
}

// TODO: Rename to `FunctionCallArgument`
/// A function argument kind from a function call expression
public struct FunctionArgument: Codable, Equatable {
    public var label: String?
    public var expression: Expression
    
    public var isLabeled: Bool {
        label != nil
    }
    
    public init(label: String?, expression: Expression) {
        self.label = label
        self.expression = expression
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.label = try container.decodeIfPresent(String.self, forKey: .label)
        self.expression = try container.decodeExpression(forKey: .expression)
    }
    
    @inlinable
    public func copy() -> FunctionArgument {
        FunctionArgument(label: label, expression: expression.copy())
    }
    
    public static func unlabeled(_ exp: Expression) -> FunctionArgument {
        FunctionArgument(label: nil, expression: exp)
    }
    
    public static func labeled(_ label: String, _ exp: Expression) -> FunctionArgument {
        FunctionArgument(label: label, expression: exp)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeIfPresent(label, forKey: .label)
        try container.encodeExpression(expression, forKey: .expression)
    }
    
    private enum CodingKeys: String, CodingKey {
        case label
        case expression
    }
}

extension FunctionArgument: CustomStringConvertible {
    public var description: String {
        if let label = label {
            return "\(label): \(expression)"
        }
        
        return expression.description
    }
}

extension FunctionCallPostfix {
    @inlinable
    public func copyTypeAndMetadata(from other: FunctionCallPostfix) -> Self {
        _ = (self as Postfix).copyTypeAndMetadata(from: other)
        
        self.callableSignature = callableSignature
        
        return self
    }
}
