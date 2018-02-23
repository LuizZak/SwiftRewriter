/// Protocol for visitors of `Statement` nodes
public protocol StatementVisitor {
    associatedtype StmtResult
    
    /// Visits a statement node
    ///
    /// - Parameter statement: Statement to visit
    /// - Returns: Result of visiting the statement node
    func visitStatement(_ statement: Statement) -> StmtResult
    
    /// Visits a semicolon node
    ///
    /// - Returns: Result of visiting a semicolon with this visitor
    func visitSemicolon(_ stmt: SemicolonStatement) -> StmtResult
    
    /// Visits a compound statement with this visitor
    ///
    /// - Parameter compoundStatement: Compound statement for the statement
    /// - Returns: Result of visiting the compound statement
    func visitCompound(_ stmt: CompoundStatement) -> StmtResult
    
    /// Visits an `if` statement with this visitor
    ///
    /// - Parameters:
    ///   - expression: The `if`'s control expression
    ///   - body: Body to execute if the control expression evaluates to true
    ///   - elseBody: Body to execute if the control expression evaluates to false
    /// - Returns: Result of visiting the `if` statement node
    func visitIf(_ stmt: IfStatement) -> StmtResult
    
    /// Visits a `switch` statement with this visitor
    ///
    /// - Parameters:
    ///   - expression: The `switch`'s control expression
    ///   - cases: The `switch`'s cases
    ///   - cases: Cases to match with the switch
    ///   - default: An optional set of statements to fill the default body with.
    /// - Returns: Result of visiting the `switch` statement node
    func visitSwitch(_ stmt: SwitchStatement) -> StmtResult
    
    /// Visits a `while` statement with this visitor
    ///
    /// - Parameters:
    ///   - expression: The `while`'s control expression
    ///   - body: Body to execute while the control expression evaluates to true
    /// - Returns: Result of visiting the `while` statement node
    func visitWhile(_ stmt: WhileStatement) -> StmtResult
    
    /// Visits a `for` loop statement with this visitor
    ///
    /// - Parameters:
    ///   - pattern: The pattern that matches each item from the expression which
    /// is being looped over
    ///   - expression: Expression that evaluates to the iterator the `for` loop
    /// consumes
    ///   - compoundStatement: Statements executed for each item being looped over
    /// - Returns: Result of visiting the `for` node
    func visitFor(_ stmt: ForStatement) -> StmtResult
    
    /// Visits a `do` statement node
    ///
    /// - Parameter body: Statements to be executed within the `do` statement
    /// - Returns: Result of visiting the `do` statement
    func visitDo(_ stmt: DoStatement) -> StmtResult
    
    /// Visits a `defer` statement node
    ///
    /// - Parameter body: Statements to be executed when the `defer` statement
    /// leaves the scope
    /// - Returns: Result of visiting the `defer` statement
    func visitDefer(_ stmt: DeferStatement) -> StmtResult
    
    /// Visits a return statement
    ///
    /// - Parameter expression: An optional expression that evaluates to the return
    /// value of the containing scope of the `return` statement
    /// - Returns: Result of visiting the `return` statement
    func visitReturn(_ stmt: ReturnStatement) -> StmtResult
    
    /// Visits a break statement
    ///
    /// - Returns: Result of visiting the break statement
    func visitBreak(_ stmt: BreakStatement) -> StmtResult
    
    /// Visits a continue statement
    ///
    /// - Returns: Result of visiting the continue statement
    func visitContinue(_ stmt: ContinueStatement) -> StmtResult
    
    /// Visits an expression sequence statement
    ///
    /// - Parameter expressions: Expressions to be executed
    /// - Returns: Result of visiting the expressions statement
    func visitExpressions(_ stmt: ExpressionsStatement) -> StmtResult
    
    /// Visits a variable declaration statement
    ///
    /// - Parameter variables: Variables being declared within the statement
    /// - Returns: Result of visiting the variables statement
    func visitVariableDeclarations(_ stmt: VariableDeclarationsStatement) -> StmtResult
    
    /// Visits an unknown statement node
    ///
    /// - Parameter context: Context for the unknown node
    /// - Returns: Result of visiting the unknown statement context
    func visitUnknown(_ stmt: UnknownStatement) -> StmtResult
}

