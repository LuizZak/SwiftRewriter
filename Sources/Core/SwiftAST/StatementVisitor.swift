/// Protocol for visitors of `Statement` nodes
public protocol StatementVisitor {
    associatedtype StmtResult
    
    /// Visits a statement node
    ///
    /// - Parameter statement: Statement to visit
    /// - Returns: Result of visiting the statement node
    func visitStatement(_ statement: Statement) -> StmtResult
    
    /// Visits a compound statement with this visitor
    ///
    /// - Parameter stmt: A compound statement to visit
    /// - Returns: Result of visiting the compound statement
    func visitCompound(_ stmt: CompoundStatement) -> StmtResult
    
    /// Visits an `if` statement with this visitor
    ///
    /// - Parameter stmt: An if expression statement to visit
    /// - Returns: Result of visiting the `if` statement node
    func visitIf(_ stmt: IfStatement) -> StmtResult
    
    /// Visits a `while` statement with this visitor
    ///
    /// - Parameter stmt: A while statement to visit
    /// - Returns: Result of visiting the `while` statement node
    func visitWhile(_ stmt: WhileStatement) -> StmtResult
    
    /// Visits a `switch` statement with this visitor
    ///
    /// - Parameter stmt: A switch statement to visit
    /// - Returns: Result of visiting the `switch` statement node
    func visitSwitch(_ stmt: SwitchStatement) -> StmtResult
    
    /// Visits a `do/while` statement with this visitor
    ///
    /// - Parameter stmt: A while statement to visit
    /// - Returns: Result of visiting the `do/while` statement node
    func visitDoWhile(_ stmt: DoWhileStatement) -> StmtResult
    
    /// Visits a `for` loop statement with this visitor
    ///
    /// - Parameter stmt: A for statement to visit
    /// - Returns: Result of visiting the `for` node
    func visitFor(_ stmt: ForStatement) -> StmtResult
    
    /// Visits a `do` statement node
    ///
    /// - Parameter stmt: A do statement to visit
    /// - Returns: Result of visiting the `do` statement
    func visitDo(_ stmt: DoStatement) -> StmtResult
    
    /// Visits a `defer` statement node
    ///
    /// - Parameter stmt: A defer statement to visit
    /// - Returns: Result of visiting the `defer` statement
    func visitDefer(_ stmt: DeferStatement) -> StmtResult
    
    /// Visits a return statement
    ///
    /// - Parameter stmt: A return statement to visit
    /// - Returns: Result of visiting the `return` statement
    func visitReturn(_ stmt: ReturnStatement) -> StmtResult
    
    /// Visits a break statement
    ///
    /// - Parameter stmt: A break statement to visit
    /// - Returns: Result of visiting the break statement
    func visitBreak(_ stmt: BreakStatement) -> StmtResult

    /// Visits a fallthrough statement
    ///
    /// - Parameter stmt: A fallthrough statement to visit
    /// - Returns: Result of visiting the fallthrough statement
    func visitFallthrough(_ stmt: FallthroughStatement) -> StmtResult

    /// Visits a continue statement
    ///
    /// - Parameter stmt: A continue statement to visit
    /// - Returns: Result of visiting the continue statement
    func visitContinue(_ stmt: ContinueStatement) -> StmtResult
    
    /// Visits an expression sequence statement
    ///
    /// - Parameter stmt: An expression sequence statement to visit
    /// - Returns: Result of visiting the expressions statement
    func visitExpressions(_ stmt: ExpressionsStatement) -> StmtResult
    
    /// Visits a variable declaration statement
    ///
    /// - Parameter stmt: A variable declaration statement to visit
    /// - Returns: Result of visiting the variables statement
    func visitVariableDeclarations(_ stmt: VariableDeclarationsStatement) -> StmtResult
    
    /// Visits an unknown statement node
    ///
    /// - Parameter stmt: An unknown statement to visit
    /// - Returns: Result of visiting the unknown statement context
    func visitUnknown(_ stmt: UnknownStatement) -> StmtResult
}
