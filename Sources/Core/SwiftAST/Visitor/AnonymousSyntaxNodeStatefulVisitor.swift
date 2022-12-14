/// An anonymous syntax visitor that reports visits to `SyntaxNode` objects to
/// an external listener closure, along with a state, returning a new state that
/// is passed to nested visits.
public final class AnonymousSyntaxNodeStatefulVisitor<State>: StatementStatefulVisitor {
    public typealias StmtResult = Void
    
    public let listener: (SyntaxNode, State) -> State
    
    public init(listener: @escaping (SyntaxNode, State) -> State) {
        self.listener = listener
    }
    
    /// Visits a statement node
    ///
    /// - Parameter stmt: A Statement to visit
    public func visitStatement(_ stmt: Statement, state: State) {
        stmt.accept(self, state: state)
    }
    
    /// Visits a compound statement with this visitor
    ///
    /// - Parameter stmt: A CompoundStatement to visit
    public func visitCompound(_ stmt: CompoundStatement, state: State) {
        let state = listener(stmt, state)
        
        stmt.statements.forEach { visitStatement($0, state: state) }
    }
    
    /// Visits an `if` statement with this visitor
    ///
    /// - Parameter stmt: An IfStatement to visit
    public func visitIf(_ stmt: IfStatement, state: State) {
        let state = listener(stmt, state)
        
        visitStatement(stmt.body, state: state)
        stmt.elseBody.map { visitStatement($0, state: state) }
    }
    
    /// Visits a `switch` statement with this visitor
    ///
    /// - Parameter stmt: A SwitchStatement to visit
    public func visitSwitch(_ stmt: SwitchStatement, state: State) {
        let state = listener(stmt, state)
        
        stmt.cases.forEach { visitSwitchCase($0, state: state) }

        if let defaultCase = stmt.defaultCase {
            visitSwitchDefaultCase(defaultCase, state: state)
        }
    }
    
    /// Visits a `case` block from a `SwitchStatement`.
    ///
    /// - Parameter switchCase: A switch case block to visit
    public func visitSwitchCase(_ switchCase: SwitchCase, state: State) {
        let state = listener(switchCase, state)

        visitStatement(switchCase.body, state: state)
    }
    
    /// Visits a `default` block from a `SwitchStatement`.
    ///
    /// - Parameter defaultCase: A switch default case block to visit
    /// - Returns: Result of visiting the switch default case block
    public func visitSwitchDefaultCase(_ defaultCase: SwitchDefaultCase, state: State) {
        let state = listener(defaultCase, state)

        visitStatement(defaultCase.body, state: state)
    }
    
    /// Visits a `while` statement with this visitor
    ///
    /// - Parameter stmt: A WhileStatement to visit
    public func visitWhile(_ stmt: WhileStatement, state: State) {
        let state = listener(stmt, state)

        visitStatement(stmt.body, state: state)
    }
    
    /// Visits a `do/while` statement with this visitor
    ///
    /// - Parameter stmt: A RepeatWhileStatement to visit
    public func visitRepeatWhile(_ stmt: RepeatWhileStatement, state: State) {
        let state = listener(stmt, state)
        
        visitStatement(stmt.body, state: state)
    }
    
    /// Visits a `for` loop statement with this visitor
    ///
    /// - Parameter stmt: A ForStatement to visit
    public func visitFor(_ stmt: ForStatement, state: State) {
        let state = listener(stmt, state)
        
        visitStatement(stmt.body, state: state)
    }
    
    /// Visits a `do` statement node
    ///
    /// - Parameter stmt: A DoStatement to visit
    public func visitDo(_ stmt: DoStatement, state: State) {
        let state = listener(stmt, state)
        
        visitStatement(stmt.body, state: state)
    }
    
    /// Visits a `catch` block from a `DoStatement`.
    ///
    /// - Parameter stmt: A catch block to visit
    /// - Returns: Result of visiting the catch block
    public func visitCatchBlock(_ block: CatchBlock, state: State) {
        let state = listener(block, state)

        visitCompound(block.body, state: state)
    }
    
    /// Visits a `defer` statement node
    ///
    /// - Parameter stmt: A DeferStatement to visit
    public func visitDefer(_ stmt: DeferStatement, state: State) {
        _ = listener(stmt, state)
        
        visitStatement(stmt.body, state: state)
    }
    
    /// Visits a return statement
    ///
    /// - Parameter stmt: A ReturnStatement to visit
    public func visitReturn(_ stmt: ReturnStatement, state: State) {
        _ = listener(stmt, state)
    }
    
    /// Visits a break statement
    ///
    /// - Parameter stmt: A BreakStatement to visit
    public func visitBreak(_ stmt: BreakStatement, state: State) {
        _ = listener(stmt, state)
    }

    /// Visits a fallthrough statement
    ///
    /// - Parameter stmt: A FallthroughStatement to visit
    public func visitFallthrough(_ stmt: FallthroughStatement, state: State) {
        _ = listener(stmt, state)
    }

    /// Visits a continue statement
    ///
    /// - Parameter stmt: A ContinueStatement to visit
    public func visitContinue(_ stmt: ContinueStatement, state: State) {
        _ = listener(stmt, state)
    }
    
    /// Visits an expression sequence statement
    ///
    /// - Parameter stmt: An ExpressionsStatement to visit
    public func visitExpressions(_ stmt: ExpressionsStatement, state: State) {
        _ = listener(stmt, state)
    }
    
    /// Visits a variable declaration statement
    ///
    /// - Parameter stmt: A VariableDeclarationsStatement to visit
    public func visitVariableDeclarations(_ stmt: VariableDeclarationsStatement, state: State) {
        let state = listener(stmt, state)

        for decl in stmt.decl {
            visitStatementVariableDeclaration(decl, state: state)
        }
    }
    
    /// Visits a variable declaration statement's element
    ///
    /// - Parameter stmt: A variable declaration statement's element to visit
    public func visitStatementVariableDeclaration(_ decl: StatementVariableDeclaration, state: State) {
        _ = listener(decl, state)
    }

    /// Visits a local function statement
    ///
    /// - Parameter stmt: A LocalFunctionStatement to visit
    public func visitLocalFunction(_ stmt: LocalFunctionStatement, state: State) {
        let state = listener(stmt, state)

        stmt.function.body.accept(self, state: state)
    }
    
    /// Visits a throw statement
    ///
    /// - Parameter stmt: A ThrowStatement to visit
    public func visitThrow(_ stmt: ThrowStatement, state: State) {
        _ = listener(stmt, state)
    }
    
    /// Visits an unknown statement node
    ///
    /// - Parameter stmt: An UnknownStatement to visit
    public func visitUnknown(_ stmt: UnknownStatement, state: State) {
        _ = listener(stmt, state)
    }
}
