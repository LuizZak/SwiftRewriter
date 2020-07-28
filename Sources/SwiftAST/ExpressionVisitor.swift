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
    /// - Parameter exp: An assignment expression to visit
    /// - Returns: Result of visiting this assignment operation node
    func visitAssignment(_ exp: AssignmentExpression) -> ExprResult
    
    /// Visits a binary operation node
    ///
    /// - Parameter exp: A binary expression to visit
    /// - Returns: Result of visiting this binary operation node
    func visitBinary(_ exp: BinaryExpression) -> ExprResult
    
    /// Visits a unary operation node
    ///
    /// - Parameter exp: A unary expression to visit
    /// - Returns: Result of visiting this unary operation node
    func visitUnary(_ exp: UnaryExpression) -> ExprResult
    
    /// Visits a sizeof expression
    ///
    /// - Parameter exp: A sizeof expression to visit
    /// - Returns: Result of visiting the size of expression
    func visitSizeOf(_ exp: SizeOfExpression) -> ExprResult
    
    /// Visits a prefix operation node
    ///
    /// - Parameter exp: A prefix expression to visit
    /// - Returns: Result of visiting this prefix operation node
    func visitPrefix(_ exp: PrefixExpression) -> ExprResult
    
    /// Visits a postfix operation node
    ///
    /// - Parameter exp: A postfix expression to visit
    /// - Returns: Result of visiting this postfix operation node
    func visitPostfix(_ exp: PostfixExpression) -> ExprResult
    
    /// Visits a constant node
    ///
    /// - Parameter exp: A constant expression to visit
    /// - Returns: Result of visiting this constant node
    func visitConstant(_ exp: ConstantExpression) -> ExprResult
    
    /// Visits a parenthesized expression node
    ///
    /// - Parameter exp: A parenthesized expression to visit
    /// - Returns: Result of visiting this parenthesis node
    func visitParens(_ exp: ParensExpression) -> ExprResult
    
    /// Visits an identifier node
    ///
    /// - Parameter exp: An identifier expression to visit
    /// - Returns: Result of visiting this identifier node
    func visitIdentifier(_ exp: IdentifierExpression) -> ExprResult
    
    /// Visits a type-casting expression node
    ///
    /// - Parameter exp: A cast expression to visit
    /// - Returns: Result of visiting this cast node
    func visitCast(_ exp: CastExpression) -> ExprResult
    
    /// Visits an array literal node
    ///
    /// - Parameter exp: An array literal expression to visit
    /// - Returns: Result of visiting this array literal node
    func visitArray(_ exp: ArrayLiteralExpression) -> ExprResult
    
    /// Visits a dictionary literal node
    ///
    /// - Parameter exp: A dictionary literal expression to visit
    /// - Returns: Result of visiting this dictionary literal node
    func visitDictionary(_ exp: DictionaryLiteralExpression) -> ExprResult
    
    /// Visits a block expression
    ///
    /// - Parameter exp: A block literal expression to visit
    /// - Returns: Result of visiting this block expression node
    func visitBlock(_ exp: BlockLiteralExpression) -> ExprResult
    
    /// Visits a ternary operation node
    ///
    /// - Parameter exp: A ternary expression to visit
    /// - Returns: Result of visiting this ternary expression node
    func visitTernary(_ exp: TernaryExpression) -> ExprResult
    
    /// Visits a tuple node
    ///
    /// - Parameter exp: A tuple expression to visit
    /// - Returns: Result of visiting this tuple node
    func visitTuple(_ exp: TupleExpression) -> ExprResult
    
    /// Visits a selector reference node
    ///
    /// - Parameter exp: A selector reference expression to visit
    /// - Returns: Result of visiting this tuple node
    func visitSelector(_ exp: SelectorExpression) -> ExprResult
    
    /// Visits an unknown expression node
    ///
    /// - Parameter exp: An unknown expression to visit
    /// - Returns: Result of visiting this unknown expression node
    func visitUnknown(_ exp: UnknownExpression) -> ExprResult
}
