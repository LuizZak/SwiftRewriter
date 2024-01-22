/// A base class for creating syntax node visitors that contains boilerplate
/// visiting code.
///
/// Inheriting from this class and overriding each `visit<>` call intercepts the
/// traversal into the syntax nodes, and allows customization of said traversal.
/// Calling `node.accept(self)` resumes crawling into a syntax node.
open class BaseSyntaxNodeVisitor: ExpressionVisitor, StatementVisitor {
    public typealias ExprResult = Void
    public typealias StmtResult = Void

    public init() {
        
    }
    
    /// Visits an expression node
    ///
    /// - Parameter exp: An Expression to visit
    open func visitExpression(_ exp: Expression) {
        exp.accept(self)
    }
    
    /// Visits an assignment operation node
    ///
    /// - Parameter exp: An AssignmentExpression to visit
    open func visitAssignment(_ exp: AssignmentExpression) {
        visitExpression(exp.lhs)
        visitExpression(exp.rhs)
    }
    
    /// Visits a binary operation node
    ///
    /// - Parameter exp: A BinaryExpression to visit
    open func visitBinary(_ exp: BinaryExpression) {
        visitExpression(exp.lhs)
        visitExpression(exp.rhs)
    }
    
    /// Visits a unary operation node
    ///
    /// - Parameter exp: A UnaryExpression to visit
    open func visitUnary(_ exp: UnaryExpression) {
        visitExpression(exp.exp)
    }
    
    /// Visits a sizeof expression
    ///
    /// - Parameter exp: A SizeOfExpression to visit
    open func visitSizeOf(_ exp: SizeOfExpression) {
        switch exp.value {
        case .expression(let innerExp):
            visitExpression(innerExp)
            
        case .type: break
        }
    }
    
    /// Visits a prefix operation node
    ///
    /// - Parameter exp: A PrefixExpression to visit
    open func visitPrefix(_ exp: PrefixExpression) {
        visitExpression(exp.exp)
    }
    
    /// Visits a postfix operation node
    ///
    /// - Parameter exp: A PostfixExpression to visit
    open func visitPostfix(_ exp: PostfixExpression) {
        visitExpression(exp.exp)
        
        switch exp.op {
        case let fc as FunctionCallPostfix:
            fc.arguments.forEach { visitExpression($0.expression) }
            
        case let sub as SubscriptPostfix:
            sub.arguments.forEach { visitExpression($0.expression) }
            
        default:
            break
        }
    }
    
    /// Visits a constant node
    ///
    /// - Parameter exp: A ConstantExpression to visit
    open func visitConstant(_ exp: ConstantExpression) {
        
    }
    
    /// Visits a parenthesized expression node
    ///
    /// - Parameter exp: A ParensExpression to visit
    open func visitParens(_ exp: ParensExpression) {
        visitExpression(exp.exp)
    }
    
    /// Visits an identifier node
    ///
    /// - Parameter exp: An IdentifierExpression to visit
    open func visitIdentifier(_ exp: IdentifierExpression) {

    }
    
    /// Visits a type-casting expression node
    ///
    /// - Parameter exp: A CastExpression to visit
    open func visitCast(_ exp: CastExpression) {
        visitExpression(exp.exp)
    }
    
    /// Visits a type-check expression node
    ///
    /// - Parameter exp: A type check expression to visit
    open func visitTypeCheck(_ exp: TypeCheckExpression) {
        visitExpression(exp.exp)
    }
    
    /// Visits an array literal node
    ///
    /// - Parameter exp: An ArrayLiteralExpression to visit
    open func visitArray(_ exp: ArrayLiteralExpression) {
        exp.items.forEach(visitExpression)
    }
    
    /// Visits a dictionary literal node
    ///
    /// - Parameter exp: A DictionaryLiteralExpression to visit
    open func visitDictionary(_ exp: DictionaryLiteralExpression) {
        exp.pairs.forEach { pair in
            visitExpression(pair.key)
            visitExpression(pair.value)
        }
    }
    
    /// Visits a block expression
    ///
    /// - Parameter exp: A BlockLiteralExpression to visit
    open func visitBlock(_ exp: BlockLiteralExpression) {
        visitStatement(exp.body)
    }
    
    /// Visits a ternary operation node
    ///
    /// - Parameter exp: A TernaryExpression to visit
    open func visitTernary(_ exp: TernaryExpression) {
        visitExpression(exp.exp)
        visitExpression(exp.ifTrue)
        visitExpression(exp.ifFalse)
    }
    
    /// Visits a tuple node
    ///
    /// - Parameter exp: A tuple expression to visit
    /// - Returns: Result of visiting this tuple node
    open func visitTuple(_ exp: TupleExpression) {
        exp.elements.forEach(visitExpression)
    }
    
    /// Visits a selector reference node
    ///
    /// - Parameter exp: A selector reference expression to visit
    /// - Returns: Result of visiting this tuple node
    open func visitSelector(_ exp: SelectorExpression) {
        
    }
    
    /// Visits a try expression node
    ///
    /// - Parameter exp: A try expression to visit
    open func visitTry(_ exp: TryExpression) {
        
    }

    /// Visits an unknown expression node
    ///
    /// - Parameter exp: An UnknownExpression to visit
    open func visitUnknown(_ exp: UnknownExpression) {
        
    }
    
    /// Visits a pattern from an expression
    ///
    /// - Parameter ptn: A Pattern to visit
    open func visitPattern(_ ptn: Pattern) {
        switch ptn {
        case .expression(let exp):
            visitExpression(exp)
            
        case .tuple(let patterns):
            patterns.forEach(visitPattern)
            
        case .identifier, .wildcard:
            break
        }
    }
    
    /// Visits a statement node
    ///
    /// - Parameter stmt: A Statement to visit
    open func visitStatement(_ stmt: Statement) {
        stmt.accept(self)
    }
    
    /// Visits a compound statement with this visitor
    ///
    /// - Parameter stmt: A CompoundStatement to visit
    open func visitCompound(_ stmt: CompoundStatement) {
        stmt.statements.forEach(visitStatement)
    }
    
    /// Visits an `if` statement with this visitor
    ///
    /// - Parameter stmt: An IfStatement to visit
    open func visitIf(_ stmt: IfStatement) {
        visitExpression(stmt.exp)
        visitStatement(stmt.body)
        stmt.elseBody.map(visitStatement)
    }
    
    /// Visits a `switch` statement with this visitor
    ///
    /// - Parameter stmt: A SwitchStatement to visit
    open func visitSwitch(_ stmt: SwitchStatement) {
        visitExpression(stmt.exp)
        
        stmt.cases.forEach { visitSwitchCase($0) }

        if let defaultCase = stmt.defaultCase {
            visitSwitchDefaultCase(defaultCase)
        }
    }
    
    /// Visits a `case` block from a `SwitchStatement`.
    ///
    /// - Parameter switchCase: A switch case block to visit
    open func visitSwitchCase(_ switchCase: SwitchCase) {
        switchCase.patterns.forEach(visitPattern)
        switchCase.statements.forEach(visitStatement)
    }
    
    /// Visits a `default` block from a `SwitchStatement`.
    ///
    /// - Parameter defaultCase: A switch default case block to visit
    open func visitSwitchDefaultCase(_ defaultCase: SwitchDefaultCase) {
        defaultCase.statements.forEach(visitStatement)
    }
    
    /// Visits a `while` statement with this visitor
    ///
    /// - Parameter stmt: A WhileStatement to visit
    open func visitWhile(_ stmt: WhileStatement) {
        visitExpression(stmt.exp)
        visitStatement(stmt.body)
    }
    
    /// Visits a `do/while` statement with this visitor
    ///
    /// - Parameter stmt: A DoWhileStatement to visit
    open func visitRepeatWhile(_ stmt: RepeatWhileStatement) {
        visitExpression(stmt.exp)
        visitStatement(stmt.body)
    }
    
    /// Visits a `for` loop statement with this visitor
    ///
    /// - Parameter stmt: A ForStatement to visit
    open func visitFor(_ stmt: ForStatement) {
        visitPattern(stmt.pattern)
        visitExpression(stmt.exp)
        visitStatement(stmt.body)
    }
    
    /// Visits a `do` statement node
    ///
    /// - Parameter stmt: A DoStatement to visit
    open func visitDo(_ stmt: DoStatement) {
        visitStatement(stmt.body)
        // NOTE: This should call visitCatchBlock for the catch blocks attached!
    }
    
    /// Visits a `catch` block from a `DoStatement`.
    ///
    /// - Parameter stmt: A catch block to visit
    open func visitCatchBlock(_ block: CatchBlock) {
        if let pattern = block.pattern {
            visitPattern(pattern)
        }

        visitCompound(block.body)
    }
    
    /// Visits a `defer` statement node
    ///
    /// - Parameter stmt: A DeferStatement to visit
    open func visitDefer(_ stmt: DeferStatement) {
        visitStatement(stmt.body)
    }
    
    /// Visits a return statement
    ///
    /// - Parameter stmt: A ReturnStatement to visit
    open func visitReturn(_ stmt: ReturnStatement) {
        stmt.exp.map(visitExpression)
    }
    
    /// Visits a break statement
    ///
    /// - Parameter stmt: A BreakStatement to visit
    open func visitBreak(_ stmt: BreakStatement) {
        
    }

    /// Visits a fallthrough statement
    ///
    /// - Parameter stmt: A FallthroughStatement to visit
    open func visitFallthrough(_ stmt: FallthroughStatement) {
        
    }

    /// Visits a continue statement
    ///
    /// - Parameter stmt: A ContinueStatement to visit
    open func visitContinue(_ stmt: ContinueStatement) {
        
    }
    
    /// Visits an expression sequence statement
    ///
    /// - Parameter stmt: An ExpressionsStatement to visit
    open func visitExpressions(_ stmt: ExpressionsStatement) {
        stmt.expressions.forEach(visitExpression)
    }
    
    /// Visits a variable declaration statement
    ///
    /// - Parameter stmt: A VariableDeclarationsStatement to visit
    open func visitVariableDeclarations(_ stmt: VariableDeclarationsStatement) {
        for i in 0..<stmt.decl.count {
            stmt.decl[i].initialization.map(visitExpression)
        }
    }
    
    /// Visits a variable declaration statement's element
    ///
    /// - Parameter stmt: A variable declaration statement's element to visit
    open func visitStatementVariableDeclaration(_ decl: StatementVariableDeclaration) {
        decl.initialization.map(self.visitExpression(_:))
    }

    /// Visits a local function statement
    ///
    /// - Parameter stmt: A LocalFunctionStatement to visit
    open func visitLocalFunction(_ stmt: LocalFunctionStatement) {
        visitStatement(stmt.function.body)
    }
    
    /// Visits a throw statement
    ///
    /// - Parameter stmt: A ThrowStatement to visit
    open func visitThrow(_ stmt: ThrowStatement) {
        visitExpression(stmt.exp)
    }
    
    /// Visits an unknown statement node
    ///
    /// - Parameter stmt: An UnknownStatement to visit
    open func visitUnknown(_ stmt: UnknownStatement) {
        
    }
}
