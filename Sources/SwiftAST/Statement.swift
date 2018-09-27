open class Statement: SyntaxNode, Equatable {
    /// Returns `true` if this statement resolve to an unconditional jump out
    /// of the current context.
    ///
    /// Returns true for `.break`, `.continue` and `.return` statements.
    public var isUnconditionalJump: Bool {
        return false
    }
    
    /// This statement label's (parsed from C's goto labels), if any.
    public var label: String?
    
    open override func copy() -> Statement {
        fatalError("Must be overriden by subclasses")
    }
    
    /// Accepts the given visitor instance, calling the appropriate visiting method
    /// according to this statement's type.
    ///
    /// - Parameter visitor: The visitor to accept
    /// - Returns: The result of the visitor's `visit-` call when applied to this
    /// statement
    public func accept<V: StatementVisitor>(_ visitor: V) -> V.StmtResult {
        return visitor.visitStatement(self)
    }
    
    public func isEqual(to other: Statement) -> Bool {
        return false
    }
    
    public static func == (lhs: Statement, rhs: Statement) -> Bool {
        if lhs === rhs {
            return true
        }
        
        return lhs.isEqual(to: rhs)
    }
    
    final func cast<T: Statement>() -> T? {
        return self as? T
    }
}

public extension Statement {
    public static var semicolon: SemicolonStatement {
        return SemicolonStatement()
    }
    public static func compound(_ cpd: [Statement]) -> CompoundStatement {
        return CompoundStatement(statements: cpd)
    }
    public static func `if`(_ exp: Expression,
                            body: CompoundStatement,
                            else elseBody: CompoundStatement?) -> IfStatement {
        
        return IfStatement(exp: exp, body: body, elseBody: elseBody)
    }
    public static func ifLet(_ pattern: Pattern,
                             _ exp: Expression,
                             body: CompoundStatement,
                             else elseBody: CompoundStatement?) -> IfStatement {
        
        let stmt = IfStatement(exp: exp, body: body, elseBody: elseBody)
        stmt.pattern = pattern
        
        return stmt
    }
    public static func `while`(_ exp: Expression, body: CompoundStatement) -> WhileStatement {
        return WhileStatement(exp: exp, body: body)
    }
    public static func doWhile(_ exp: Expression, body: CompoundStatement) -> DoWhileStatement {
        return DoWhileStatement(exp: exp, body: body)
    }
    public static func `for`(_ pattern: Pattern, _ exp: Expression, body: CompoundStatement) -> ForStatement {
        return ForStatement(pattern: pattern, exp: exp, body: body)
    }
    public static func `switch`(_ exp: Expression,
                                cases: [SwitchCase],
                                default defaultCase: [Statement]?) -> SwitchStatement {
        
        return SwitchStatement(exp: exp, cases: cases, defaultCase: defaultCase)
    }
    public static func `do`(_ stmt: CompoundStatement) -> DoStatement {
        return DoStatement(body: stmt)
    }
    public static func `defer`(_ stmt: CompoundStatement) -> DeferStatement {
        return DeferStatement(body: stmt)
    }
    public static func `return`(_ exp: Expression?) -> ReturnStatement {
        return ReturnStatement(exp: exp)
    }
    public static var `break`: BreakStatement {
        return BreakStatement()
    }
    public static var `continue`: ContinueStatement {
        return ContinueStatement()
    }
    public static func expressions(_ exp: [Expression]) -> ExpressionsStatement {
        return ExpressionsStatement(expressions: exp)
    }
    public static func variableDeclarations(_ decl: [StatementVariableDeclaration]) -> VariableDeclarationsStatement {
        return VariableDeclarationsStatement(decl: decl)
    }
    public static func unknown(_ context: UnknownASTContext) -> UnknownStatement {
        return UnknownStatement(context: context)
    }
    public static func expression(_ expr: Expression) -> Statement {
        return .expressions([expr])
    }
    
    public static func variableDeclaration(identifier: String,
                                           type: SwiftType,
                                           ownership: Ownership = .strong,
                                           isConstant: Bool = false,
                                           initialization: Expression?) -> Statement {
        
        return .variableDeclarations([
            StatementVariableDeclaration(identifier: identifier,
                                         type: type,
                                         ownership: ownership,
                                         isConstant: isConstant,
                                         initialization: initialization)
        ])
    }
}

public extension Statement {
    
    func copyMetadata(from other: Statement) -> Self {
        self.label = other.label
        
        return self
    }
    
}
