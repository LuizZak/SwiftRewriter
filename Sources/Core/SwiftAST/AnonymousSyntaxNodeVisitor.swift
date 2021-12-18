/// An anomymous syntax visitor that reports visits to `SyntaxNode` objects to
/// an external listener closure.
public final class AnonymousSyntaxNodeVisitor: ExpressionVisitor, StatementVisitor {
    public typealias ExprResult = Void
    public typealias StmtResult = Void
    
    public let listener: (SyntaxNode) -> Void
    
    public init(listener: @escaping (SyntaxNode) -> Void) {
        self.listener = listener
    }
    
    /// Visits an expression node
    ///
    /// - Parameter exp: An Expression to visit
    public func visitExpression(_ exp: Expression) {
        exp.accept(self)
    }
    
    /// Visits an assignment operation node
    ///
    /// - Parameter exp: An AssignmentExpression to visit
    public func visitAssignment(_ exp: AssignmentExpression) {
        listener(exp)
        
        visitExpression(exp.lhs)
        visitExpression(exp.rhs)
    }
    
    /// Visits a binary operation node
    ///
    /// - Parameter exp: A BinaryExpression to visit
    public func visitBinary(_ exp: BinaryExpression) {
        listener(exp)
        
        visitExpression(exp.lhs)
        visitExpression(exp.rhs)
    }
    
    /// Visits a unary operation node
    ///
    /// - Parameter exp: A UnaryExpression to visit
    public func visitUnary(_ exp: UnaryExpression) {
        listener(exp)
        
        visitExpression(exp.exp)
    }
    
    /// Visits a sizeof expression
    ///
    /// - Parameter exp: A SizeOfExpression to visit
    public func visitSizeOf(_ exp: SizeOfExpression) {
        listener(exp)
        
        switch exp.value {
        case .expression(let innerExp):
            visitExpression(innerExp)
            
        case .type: break
        }
    }
    
    /// Visits a prefix operation node
    ///
    /// - Parameter exp: A PrefixExpression to visit
    public func visitPrefix(_ exp: PrefixExpression) {
        listener(exp)
        
        visitExpression(exp.exp)
    }
    
    /// Visits a postfix operation node
    ///
    /// - Parameter exp: A PostfixExpression to visit
    public func visitPostfix(_ exp: PostfixExpression) {
        listener(exp)
        
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
    public func visitConstant(_ exp: ConstantExpression) {
        listener(exp)
    }
    
    /// Visits a parenthesized expression node
    ///
    /// - Parameter exp: A ParensExpression to visit
    public func visitParens(_ exp: ParensExpression) {
        listener(exp)
        
        visitExpression(exp.exp)
    }
    
    /// Visits an identifier node
    ///
    /// - Parameter exp: An IdentifierExpression to visit
    public func visitIdentifier(_ exp: IdentifierExpression) {
        listener(exp)
    }
    
    /// Visits a type-casting expression node
    ///
    /// - Parameter exp: A CastExpression to visit
    public func visitCast(_ exp: CastExpression) {
        listener(exp)
        
        visitExpression(exp.exp)
    }
    
    /// Visits an array literal node
    ///
    /// - Parameter exp: An ArrayLiteralExpression to visit
    public func visitArray(_ exp: ArrayLiteralExpression) {
        listener(exp)
        
        exp.items.forEach(visitExpression)
    }
    
    /// Visits a dictionary literal node
    ///
    /// - Parameter exp: A DictionaryLiteralExpression to visit
    public func visitDictionary(_ exp: DictionaryLiteralExpression) {
        listener(exp)
        
        exp.pairs.forEach { pair in
            visitExpression(pair.key)
            visitExpression(pair.value)
        }
    }
    
    /// Visits a block expression
    ///
    /// - Parameter exp: A BlockLiteralExpression to visit
    public func visitBlock(_ exp: BlockLiteralExpression) {
        listener(exp)
        
        visitStatement(exp.body)
    }
    
    /// Visits a ternary operation node
    ///
    /// - Parameter exp: A TernaryExpression to visit
    public func visitTernary(_ exp: TernaryExpression) {
        listener(exp)
        
        visitExpression(exp.exp)
        visitExpression(exp.ifTrue)
        visitExpression(exp.ifFalse)
    }
    
    /// Visits a tuple node
    ///
    /// - Parameter exp: A tuple expression to visit
    /// - Returns: Result of visiting this tuple node
    public func visitTuple(_ exp: TupleExpression) {
        listener(exp)
        
        exp.elements.forEach(visitExpression)
    }
    
    /// Visits a selector reference node
    ///
    /// - Parameter exp: A selector reference expression to visit
    /// - Returns: Result of visiting this tuple node
    public func visitSelector(_ exp: SelectorExpression) {
        listener(exp)
    }
    
    /// Visits an unknown expression node
    ///
    /// - Parameter exp: An UnknownExpression to visit
    public func visitUnknown(_ exp: UnknownExpression) {
        listener(exp)
    }
    
    /// Visits a pattern from an expression
    ///
    /// - Parameter ptn: A Pattern to visit
    public func visitPattern(_ ptn: Pattern) {
        switch ptn {
        case .expression(let exp):
            visitExpression(exp)
            
        case .tuple(let patterns):
            patterns.forEach(visitPattern)
            
        case .identifier:
            break
        }
    }
    
    /// Visits a statement node
    ///
    /// - Parameter stmt: A Statement to visit
    public func visitStatement(_ stmt: Statement) {
        stmt.accept(self)
    }
    
    /// Visits a compound statement with this visitor
    ///
    /// - Parameter stmt: A CompoundStatement to visit
    public func visitCompound(_ stmt: CompoundStatement) {
        listener(stmt)
        
        stmt.statements.forEach(visitStatement)
    }
    
    /// Visits an `if` statement with this visitor
    ///
    /// - Parameter stmt: An IfStatement to visit
    public func visitIf(_ stmt: IfStatement) {
        listener(stmt)
        
        visitExpression(stmt.exp)
        visitStatement(stmt.body)
        stmt.elseBody.map(visitStatement)
    }
    
    /// Visits a `switch` statement with this visitor
    ///
    /// - Parameter stmt: A SwitchStatement to visit
    public func visitSwitch(_ stmt: SwitchStatement) {
        listener(stmt)
        
        visitExpression(stmt.exp)
        
        stmt.cases.forEach {
            $0.patterns.forEach(visitPattern)
            $0.statements.forEach(visitStatement)
        }
        if let def = stmt.defaultCase {
            def.forEach(visitStatement)
        }
    }
    
    /// Visits a `while` statement with this visitor
    ///
    /// - Parameter stmt: A WhileStatement to visit
    public func visitWhile(_ stmt: WhileStatement) {
        listener(stmt)
        
        visitExpression(stmt.exp)
        visitStatement(stmt.body)
    }
    
    /// Visits a `do/while` statement with this visitor
    ///
    /// - Parameter stmt: A DoWhileStatement to visit
    public func visitDoWhile(_ stmt: DoWhileStatement) {
        listener(stmt)
        
        visitExpression(stmt.exp)
        visitStatement(stmt.body)
    }
    
    /// Visits a `for` loop statement with this visitor
    ///
    /// - Parameter stmt: A ForStatement to visit
    public func visitFor(_ stmt: ForStatement) {
        listener(stmt)
        
        visitPattern(stmt.pattern)
        visitExpression(stmt.exp)
        visitStatement(stmt.body)
    }
    
    /// Visits a `do` statement node
    ///
    /// - Parameter stmt: A DoStatement to visit
    public func visitDo(_ stmt: DoStatement) {
        listener(stmt)
        
        visitStatement(stmt.body)
    }
    
    /// Visits a `defer` statement node
    ///
    /// - Parameter stmt: A DeferStatement to visit
    public func visitDefer(_ stmt: DeferStatement) {
        listener(stmt)
        
        visitStatement(stmt.body)
    }
    
    /// Visits a return statement
    ///
    /// - Parameter stmt: A ReturnStatement to visit
    public func visitReturn(_ stmt: ReturnStatement) {
        listener(stmt)
        
        stmt.exp.map(visitExpression)
    }
    
    /// Visits a break statement
    ///
    /// - Parameter stmt: A BreakStatement to visit
    public func visitBreak(_ stmt: BreakStatement) {
        listener(stmt)
    }

    /// Visits a fallthrough statement
    ///
    /// - Parameter stmt: A FallthroughStatement to visit
    public func visitFallthrough(_ stmt: FallthroughStatement) {
        listener(stmt)
    }

    /// Visits a continue statement
    ///
    /// - Parameter stmt: A ContinueStatement to visit
    public func visitContinue(_ stmt: ContinueStatement) {
        listener(stmt)
    }
    
    /// Visits an expression sequence statement
    ///
    /// - Parameter stmt: An ExpressionsStatement to visit
    public func visitExpressions(_ stmt: ExpressionsStatement) {
        listener(stmt)
        
        stmt.expressions.forEach(visitExpression)
    }
    
    /// Visits a variable declaration statement
    ///
    /// - Parameter stmt: A VariableDeclarationsStatement to visit
    public func visitVariableDeclarations(_ stmt: VariableDeclarationsStatement) {
        listener(stmt)
        
        for i in 0..<stmt.decl.count {
            stmt.decl[i].initialization.map(visitExpression)
        }
    }
    
    /// Visits an unknown statement node
    ///
    /// - Parameter stmt: An UnknownStatement to visit
    public func visitUnknown(_ stmt: UnknownStatement) {
        listener(stmt)
    }
}
