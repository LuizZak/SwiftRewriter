/// Base class for `SyntaxNode` rewriters
open class SyntaxNodeRewriter: ExpressionVisitor, StatementVisitor {
    public init() {
        
    }
    
    /// Visits an expression node
    ///
    /// - Parameter exp: An Expression to visit
    /// - Returns: Result of visiting this expression node
    open func visitExpression(_ exp: Expression) -> Expression {
        exp.accept(self)
    }
    
    /// Visits an assignment operation node
    ///
    /// - Parameter exp: An AssignmentExpression to visit
    /// - Returns: Result of visiting this assignment operation node
    open func visitAssignment(_ exp: AssignmentExpression) -> Expression {
        exp.lhs = visitExpression(exp.lhs)
        exp.rhs = visitExpression(exp.rhs)
        
        return exp
    }
    
    /// Visits a binary operation node
    ///
    /// - Parameter exp: A BinaryExpression to visit
    /// - Returns: Result of visiting this binary operation node
    open func visitBinary(_ exp: BinaryExpression) -> Expression {
        exp.lhs = visitExpression(exp.lhs)
        exp.rhs = visitExpression(exp.rhs)
        
        return exp
    }
    
    /// Visits a unary operation node
    ///
    /// - Parameter exp: A UnaryExpression to visit
    /// - Returns: Result of visiting this unary operation node
    open func visitUnary(_ exp: UnaryExpression) -> Expression {
        exp.exp = visitExpression(exp.exp)
        
        return exp
    }
    
    /// Visits a sizeof expression
    ///
    /// - Parameter exp: A SizeOfExpression to visit
    /// - Returns: Result of visiting the sizeof expression node
    open func visitSizeOf(_ exp: SizeOfExpression) -> Expression {
        switch exp.value {
        case .expression(let innerExp):
            exp.value = .expression(visitExpression(innerExp))
        case .type: break
        }
        
        return exp
    }
    
    /// Visits a prefix operation node
    ///
    /// - Parameter exp: A PrefixExpression to visit
    /// - Returns: Result of visiting this prefix operation node
    open func visitPrefix(_ exp: PrefixExpression) -> Expression {
        exp.exp = visitExpression(exp.exp)
        
        return exp
    }
    
    /// Visits a postfix operation node
    ///
    /// - Parameter exp: A PostfixExpression to visit
    /// - Returns: Result of visiting this postfix operation node
    open func visitPostfix(_ exp: PostfixExpression) -> Expression {
        exp.exp = visitExpression(exp.exp)
        
        switch exp.op {
        case let fc as FunctionCallPostfix:
            exp.op = fc.replacingArguments(fc.arguments.map { visitExpression($0.expression) })
            
        case let sub as SubscriptPostfix:
            exp.op = sub.replacingArguments(sub.arguments.map { visitExpression($0.expression) })
            
        default:
            break
        }
        
        return exp
    }
    
    /// Visits a constant node
    ///
    /// - Parameter exp: A ConstantExpression to visit
    /// - Returns: Result of visiting this constant node
    open func visitConstant(_ exp: ConstantExpression) -> Expression {
        exp
    }
    
    /// Visits a parenthesized expression node
    ///
    /// - Parameter exp: A ParensExpression to visit
    /// - Returns: Result of visiting this parenthesis node
    open func visitParens(_ exp: ParensExpression) -> Expression {
        exp.exp = visitExpression(exp.exp)
        
        return exp
    }
    
    /// Visits an identifier node
    ///
    /// - Parameter exp: An IdentifierExpression to visit
    /// - Returns: Result of visiting this identifier node
    open func visitIdentifier(_ exp: IdentifierExpression) -> Expression {
        exp
    }
    
    /// Visits a type-casting expression node
    ///
    /// - Parameter exp: A CastExpression to visit
    /// - Returns: Result of visiting this cast node
    open func visitCast(_ exp: CastExpression) -> Expression {
        exp.exp = visitExpression(exp.exp)
        
        return exp
    }
    
    /// Visits an array literal node
    ///
    /// - Parameter exp: An ArrayLiteralExpression to visit
    /// - Returns: Result of visiting this array literal node
    open func visitArray(_ exp: ArrayLiteralExpression) -> Expression {
        exp.items = exp.items.map(visitExpression)
        
        return exp
    }
    
    /// Visits a dictionary literal node
    ///
    /// - Parameter exp: A DictionaryLiteralExpression to visit
    /// - Returns: Result of visiting this dictionary literal node
    open func visitDictionary(_ exp: DictionaryLiteralExpression) -> Expression {
        exp.pairs = exp.pairs.map { pair in
            ExpressionDictionaryPair(key: visitExpression(pair.key),
                                     value: visitExpression(pair.value))
        }
        
        return exp
    }
    
    /// Visits a block expression
    ///
    /// - Parameter exp: A BlockLiteralExpression to visit
    /// - Returns: Result of visiting this block expression node
    open func visitBlock(_ exp: BlockLiteralExpression) -> Expression {
        _=visitStatement(exp.body)
        
        return exp
    }
    
    /// Visits a ternary operation node
    ///
    /// - Parameter exp: A TernaryExpression to visit
    /// - Returns: Result of visiting this ternary expression node
    open func visitTernary(_ exp: TernaryExpression) -> Expression {
        exp.exp = visitExpression(exp.exp)
        exp.ifTrue = visitExpression(exp.ifTrue)
        exp.ifFalse = visitExpression(exp.ifFalse)
        
        return exp
    }
    
    /// Visits a tuple node
    ///
    /// - Parameter exp: A tuple expression to visit
    /// - Returns: Result of visiting this tuple node
    open func visitTuple(_ exp: TupleExpression) -> Expression {
        exp.elements = exp.elements.map(visitExpression)
        
        return exp
    }
    
    /// Visits a selector reference node
    ///
    /// - Parameter exp: A selector reference expression to visit
    /// - Returns: Result of visiting this tuple node
    open func visitSelector(_ exp: SelectorExpression) -> Expression {
        return exp
    }
    
    /// Visits an unknown expression node
    ///
    /// - Parameter exp: An UnknownExpression to visit
    /// - Returns: Result of visiting this unknown expression node
    open func visitUnknown(_ exp: UnknownExpression) -> Expression {
        exp
    }
    
    /// Visits a pattern from an expression
    ///
    /// - Parameter ptn: A Pattern to visit
    /// - Returns: Result of visiting the pattern node
    open func visitPattern(_ ptn: Pattern) -> Pattern {
        switch ptn {
        case .expression(let exp):
            return .expression(visitExpression(exp))
            
        case .tuple(let patterns):
            return .tuple(patterns.map(visitPattern))
            
        case .identifier:
            return ptn
        }
    }
    
    /// Visits a statement node
    ///
    /// - Parameter stmt: A Statement to visit
    /// - Returns: Result of visiting the statement node
    open func visitStatement(_ stmt: Statement) -> Statement {
        stmt.accept(self)
    }
    
    /// Visits a compound statement with this visitor
    ///
    /// - Parameter stmt: A CompoundStatement to visit
    /// - Returns: Result of visiting the compound statement
    open func visitCompound(_ stmt: CompoundStatement) -> Statement {
        for i in 0..<stmt.statements.count {
            stmt.statements[i] = visitStatement(stmt.statements[i])
        }
        
        return stmt
    }
    
    /// Visits an `if` statement with this visitor
    ///
    /// - Parameter stmt: An IfStatement to visit
    /// - Returns: Result of visiting the `if` statement node
    open func visitIf(_ stmt: IfStatement) -> Statement {
        stmt.exp = visitExpression(stmt.exp)
        _=visitStatement(stmt.body)
        _=stmt.elseBody.map(visitStatement)
        
        return stmt
    }
    
    /// Visits a `switch` statement with this visitor
    ///
    /// - Parameter stmt: A SwitchStatement to visit
    /// - Returns: Result of visiting the `switch` statement node
    open func visitSwitch(_ stmt: SwitchStatement) -> Statement {
        stmt.exp = visitExpression(stmt.exp)
        
        stmt.cases = stmt.cases.map {
            return SwitchCase(patterns: $0.patterns.map(visitPattern),
                              statements: $0.statements.map(visitStatement))
        }
        if let def = stmt.defaultCase {
            stmt.defaultCase = def.map(visitStatement)
        }
        
        return stmt
    }
    
    /// Visits a `while` statement with this visitor
    ///
    /// - Parameter stmt: A WhileStatement to visit
    /// - Returns: Result of visiting the `while` statement node
    open func visitWhile(_ stmt: WhileStatement) -> Statement {
        stmt.exp = visitExpression(stmt.exp)
        _=visitStatement(stmt.body)
        
        return stmt
    }
    
    /// Visits a `do/while` statement with this visitor
    ///
    /// - Parameter stmt: A DoWhileStatement to visit
    /// - Returns: Result of visiting the `do/while` statement node
    open func visitDoWhile(_ stmt: DoWhileStatement) -> Statement {
        stmt.exp = visitExpression(stmt.exp)
        _=visitStatement(stmt.body)
        
        return stmt
    }
    
    /// Visits a `for` loop statement with this visitor
    ///
    /// - Parameter stmt: A ForStatement to visit
    /// - Returns: Result of visiting the `for` node
    open func visitFor(_ stmt: ForStatement) -> Statement {
        stmt.pattern = visitPattern(stmt.pattern)
        stmt.exp = visitExpression(stmt.exp)
        _=visitStatement(stmt.body)
        
        return stmt
    }
    
    /// Visits a `do` statement node
    ///
    /// - Parameter stmt: A DoStatement to visit
    /// - Returns: Result of visiting the `do` statement
    open func visitDo(_ stmt: DoStatement) -> Statement {
        _=visitStatement(stmt.body)
        
        return stmt
    }
    
    /// Visits a `defer` statement node
    ///
    /// - Parameter stmt: A DeferStatement to visit
    /// - Returns: Result of visiting the `defer` statement
    open func visitDefer(_ stmt: DeferStatement) -> Statement {
        _=visitStatement(stmt.body)
        
        return stmt
    }
    
    /// Visits a return statement
    ///
    /// - Parameter stmt: A ReturnStatement to visit
    /// - Returns: Result of visiting the `return` statement
    open func visitReturn(_ stmt: ReturnStatement) -> Statement {
        stmt.exp = stmt.exp.map(visitExpression)
        
        return stmt
    }
    
    /// Visits a break statement
    ///
    /// - Parameter stmt: A BreakStatement to visit
    /// - Returns: Result of visiting the break statement
    open func visitBreak(_ stmt: BreakStatement) -> Statement {
        stmt
    }

    /// Visits a fallthrough statement
    ///
    /// - Parameter stmt: A FallthroughStatement to visit
    /// - Returns: Result of visiting the fallthrough statement
    open func visitFallthrough(_ stmt: FallthroughStatement) -> Statement {
        stmt
    }

    /// Visits a continue statement
    ///
    /// - Parameter stmt: A ContinueStatement to visit
    /// - Returns: Result of visiting the continue statement
    open func visitContinue(_ stmt: ContinueStatement) -> Statement {
        stmt
    }
    
    /// Visits an expression sequence statement
    ///
    /// - Parameter stmt: An ExpressionsStatement to visit
    /// - Returns: Result of visiting the expressions statement
    open func visitExpressions(_ stmt: ExpressionsStatement) -> Statement {
        for i in 0..<stmt.expressions.count {
            stmt.expressions[i] = visitExpression(stmt.expressions[i])
        }
        
        return stmt
    }
    
    /// Visits a variable declaration statement
    ///
    /// - Parameter stmt: A VariableDeclarationsStatement to visit
    /// - Returns: Result of visiting the variables statement
    open func visitVariableDeclarations(_ stmt: VariableDeclarationsStatement) -> Statement {
        for i in 0..<stmt.decl.count {
            stmt.decl[i].initialization =
                stmt.decl[i].initialization.map(visitExpression)
        }
        
        return stmt
    }
    
    /// Visits an unknown statement node
    ///
    /// - Parameter stmt: An UnknownStatement to visit
    /// - Returns: Result of visiting the unknown statement context
    open func visitUnknown(_ stmt: UnknownStatement) -> Statement {
        stmt
    }
}
