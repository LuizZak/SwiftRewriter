/// Protocol for visitors of `Statement` nodes that can pass a state object
/// for nested visits.
///
/// Visitors visit nodes while performing operations on each node along the way,
/// returning the resulting value after done traversing.
public protocol StatementStatefulVisitor {
    /// The type for the state passed to nested visits.
    associatedtype State

    associatedtype StmtResult
    associatedtype SwitchCaseResult = StmtResult
    associatedtype SwitchDefaultCaseResult = StmtResult
    associatedtype CatchBlockResult = StmtResult
    associatedtype StatementVariableDeclarationResult = StmtResult
    
    /// Visits a statement node
    ///
    /// - Parameter statement: Statement to visit
    /// - Returns: Result of visiting the statement node
    func visitStatement(_ statement: Statement, state: State) -> StmtResult
    
    /// Visits a compound statement with this visitor
    ///
    /// - Parameter stmt: A compound statement to visit
    /// - Returns: Result of visiting the compound statement
    func visitCompound(_ stmt: CompoundStatement, state: State) -> StmtResult
    
    /// Visits an `if` statement with this visitor
    ///
    /// - Parameter stmt: An `if` statement to visit
    /// - Returns: Result of visiting the `if` statement node
    func visitIf(_ stmt: IfStatement, state: State) -> StmtResult
    
    /// Visits a `while` statement with this visitor
    ///
    /// - Parameter stmt: A while statement to visit
    /// - Returns: Result of visiting the `while` statement node
    func visitWhile(_ stmt: WhileStatement, state: State) -> StmtResult
    
    /// Visits a `switch` statement with this visitor
    ///
    /// - Parameter stmt: A switch statement to visit
    /// - Returns: Result of visiting the `switch` statement node
    func visitSwitch(_ stmt: SwitchStatement, state: State) -> StmtResult
    
    /// Visits a `case` block from a `SwitchStatement`.
    ///
    /// - Parameter switchCase: A switch case block to visit
    /// - Returns: Result of visiting the switch case block
    func visitSwitchCase(_ switchCase: SwitchCase, state: State) -> SwitchCaseResult
    
    /// Visits a `default` block from a `SwitchStatement`.
    ///
    /// - Parameter defaultCase: A switch default case block to visit
    /// - Returns: Result of visiting the switch default case block
    func visitSwitchDefaultCase(_ defaultCase: SwitchDefaultCase, state: State) -> SwitchDefaultCaseResult
    
    /// Visits a `do/while` statement with this visitor
    ///
    /// - Parameter stmt: A while statement to visit
    /// - Returns: Result of visiting the `do/while` statement node
    func visitRepeatWhile(_ stmt: RepeatWhileStatement, state: State) -> StmtResult
    
    /// Visits a `for` loop statement with this visitor
    ///
    /// - Parameter stmt: A for statement to visit
    /// - Returns: Result of visiting the `for` node
    func visitFor(_ stmt: ForStatement, state: State) -> StmtResult
    
    /// Visits a `do` statement node
    ///
    /// - Parameter stmt: A do statement to visit
    /// - Returns: Result of visiting the `do` statement
    func visitDo(_ stmt: DoStatement, state: State) -> StmtResult
    
    /// Visits a `catch` block from a `DoStatement`.
    ///
    /// - Parameter block: A catch block to visit
    /// - Returns: Result of visiting the catch block
    func visitCatchBlock(_ block: CatchBlock, state: State) -> CatchBlockResult

    /// Visits a `defer` statement node
    ///
    /// - Parameter stmt: A defer statement to visit
    /// - Returns: Result of visiting the `defer` statement
    func visitDefer(_ stmt: DeferStatement, state: State) -> StmtResult
    
    /// Visits a return statement
    ///
    /// - Parameter stmt: A return statement to visit
    /// - Returns: Result of visiting the `return` statement
    func visitReturn(_ stmt: ReturnStatement, state: State) -> StmtResult
    
    /// Visits a break statement
    ///
    /// - Parameter stmt: A break statement to visit
    /// - Returns: Result of visiting the break statement
    func visitBreak(_ stmt: BreakStatement, state: State) -> StmtResult

    /// Visits a fallthrough statement
    ///
    /// - Parameter stmt: A fallthrough statement to visit
    /// - Returns: Result of visiting the fallthrough statement
    func visitFallthrough(_ stmt: FallthroughStatement, state: State) -> StmtResult

    /// Visits a continue statement
    ///
    /// - Parameter stmt: A continue statement to visit
    /// - Returns: Result of visiting the continue statement
    func visitContinue(_ stmt: ContinueStatement, state: State) -> StmtResult
    
    /// Visits an expression sequence statement
    ///
    /// - Parameter stmt: An expression sequence statement to visit
    /// - Returns: Result of visiting the expressions statement
    func visitExpressions(_ stmt: ExpressionsStatement, state: State) -> StmtResult
    
    /// Visits a variable declaration statement
    ///
    /// - Parameter stmt: A variable declaration statement to visit
    /// - Returns: Result of visiting the variables statement
    func visitVariableDeclarations(_ stmt: VariableDeclarationsStatement, state: State) -> StmtResult

    /// Visits a variable declaration statement's element
    ///
    /// - Parameter stmt: A variable declaration statement's element to visit
    /// - Returns: Result of visiting the variable declaration statement's element
    func visitStatementVariableDeclaration(_ decl: StatementVariableDeclaration, state: State) -> StatementVariableDeclarationResult

    /// Visits a local function statement
    ///
    /// - Parameter stmt: A local function statement to visit
    /// - Returns: Result of visiting the local function statement node
    func visitLocalFunction(_ stmt: LocalFunctionStatement, state: State) -> StmtResult
    
    /// Visits a throw statement
    ///
    /// - Parameter stmt: A throw statement to visit
    /// - Returns: Result of visiting the throw statement node
    func visitThrow(_ stmt: ThrowStatement, state: State) -> StmtResult
    
    /// Visits an unknown statement node
    ///
    /// - Parameter stmt: An unknown statement to visit
    /// - Returns: Result of visiting the unknown statement context
    func visitUnknown(_ stmt: UnknownStatement, state: State) -> StmtResult
}
