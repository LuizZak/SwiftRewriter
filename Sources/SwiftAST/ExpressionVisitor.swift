/// Represents the base protocol for visitors of an expression tree.
/// Visitors visit nodes while performing operations on each node along the way,
/// returning the resulting value after done traversing.
public protocol ExpressionVisitor {
    associatedtype ExprResult
    
    /// Visits an expression node
    ///
    /// - Parameter expression: Expression to visit
    /// - Returns: Result of visiting this expression node
    func visitExpression(_ expression: Expression) -> ExprResult
    
    /// Visits an assignment operation node
    ///
    /// - Parameters:
    ///   - lhs: Expression's left-hand side
    ///   - op: Expression's operator
    ///   - rhs: Expression's right-hand side
    /// - Returns: Result of visiting this assignment operation node
    func visitAssignment(_ exp: AssignmentExpression) -> ExprResult
    
    /// Visits a binary operation node
    ///
    /// - Parameters:
    ///   - lhs: Expression's left-hand side
    ///   - op: Expression's operator
    ///   - rhs: Expression's right-hand side
    /// - Returns: Result of visiting this binary operation node
    func visitBinary(_ exp: BinaryExpression) -> ExprResult
    
    /// Visits a unary operation node
    ///
    /// - Parameters:
    ///   - op: The unary operator for the expression
    ///   - exp: The operand for the expression
    /// - Returns: Result of visiting this unary operation node
    func visitUnary(_ exp: UnaryExpression) -> ExprResult
    
    /// Visits a sizeof expression
    ///
    /// - Parameter exp: Expression to visit
    /// - Returns: Result of visiting the size of expression
    func visitSizeOf(_ exp: SizeOfExpression) -> ExprResult
    
    /// Visits a prefix operation node
    ///
    /// - Parameters:
    ///   - op: The prefix operator for the expression
    ///   - exp: The operand for the expression
    /// - Returns: Result of visiting this prefix operation node
    func visitPrefix(_ exp: PrefixExpression) -> ExprResult
    
    /// Visits a postfix operation node
    ///
    /// - Parameters:
    ///   - exp: The operand for the expression
    ///   - op: The postfix operator for the expression
    /// - Returns: Result of visiting this postfix operation node
    func visitPostfix(_ exp: PostfixExpression) -> ExprResult
    
    /// Visits a constant node
    ///
    /// - Parameter constant: The constant contained within the node
    /// - Returns: Result of visiting this constant node
    func visitConstant(_ exp: ConstantExpression) -> ExprResult
    
    /// Visits a parenthesized expression node
    ///
    /// - Parameter exp: The expression contained within the parenthesis
    /// - Returns: Result of visiting this parenthesis node
    func visitParens(_ exp: ParensExpression) -> ExprResult
    
    /// Visits an identifier node
    ///
    /// - Parameter identifier: The identifier contained within the node
    /// - Returns: Result of visiting this identifier node
    func visitIdentifier(_ exp: IdentifierExpression) -> ExprResult
    
    /// Visits a type-casting expression node
    ///
    /// - Parameters:
    ///   - exp: The expression being casted
    ///   - type: The target casting type
    /// - Returns: Result of visiting this cast node
    func visitCast(_ exp: CastExpression) -> ExprResult
    
    /// Visits an array literal node
    ///
    /// - Parameter array: The list of expressions that make up the array literal
    /// - Returns: Result of visiting this array literal node
    func visitArray(_ exp: ArrayLiteralExpression) -> ExprResult
    
    /// Visits a dictionary literal node
    ///
    /// - Parameter dictionary: The list of dictionary entry pairs that make up
    /// the dictionary literal
    /// - Returns: Result of visiting this dictionary literal node
    func visitDictionary(_ exp: DictionaryLiteralExpression) -> ExprResult
    
    /// Visits a block expression
    ///
    /// - Parameters:
    ///   - parameters: Parameters for the block's invocation
    ///   - returnType: The return type of the block
    ///   - body: The block's statements body
    /// - Returns: Result of visiting this block expression node
    func visitBlock(_ exp: BlockLiteralExpression) -> ExprResult
    
    /// Visits a ternary operation node
    ///
    /// - Parameters:
    ///   - exp: The control expression
    ///   - ifTrue: The expression executed when the control expression evaluates
    /// to true
    ///   - ifFalse: The expression executed when the control expression evaluates
    /// to false
    /// - Returns: Result of visiting this ternary expression node
    func visitTernary(_ exp: TernaryExpression) -> ExprResult
    
    /// Visits an unknown expression node
    ///
    /// - Parameter context: Context for unknown expression node
    /// - Returns: Result of visiting this unknown expression node
    func visitUnknown(_ exp: UnknownExpression) -> ExprResult
}
