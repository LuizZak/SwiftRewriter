import GrammarModels

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
    func visitSemicolon() -> StmtResult
    
    /// Visits a compound statement with this visitor
    ///
    /// - Parameter compoundStatement: Compound statement for the statement
    /// - Returns: Result of visiting the compound statement
    func visitCompound(_ compoundStatement: CompoundStatement) -> StmtResult
    
    /// Visits an `if` statement with this visitor
    ///
    /// - Parameters:
    ///   - expression: The `if`'s control expression
    ///   - body: Body to execute if the control expression evaluates to true
    ///   - elseBody: Body to execute if the control expression evaluates to false
    /// - Returns: Result of visiting the `if` statement node
    func visitIf(_ expression: Expression, _ body: CompoundStatement, _ elseBody: CompoundStatement?) -> StmtResult
    
    /// Visits a `while` statement with this visitor
    ///
    /// - Parameters:
    ///   - expression: The `while`'s control expression
    ///   - body: Body to execute while the control expression evaluates to true
    /// - Returns: Result of visiting the `while` statement node
    func visitWhile(_ expression: Expression, _ body: CompoundStatement) -> StmtResult
    
    /// Visits a `for` loop statement with this visitor
    ///
    /// - Parameters:
    ///   - pattern: The pattern that matches each item from the expression which
    /// is being looped over
    ///   - expression: Expression that evaluates to the iterator the `for` loop
    /// consumes
    ///   - compoundStatement: Statements executed for each item being looped over
    /// - Returns: Result of visiting the `for` node
    func visitFor(_ pattern: Pattern, _ expression: Expression, _ compoundStatement: CompoundStatement) -> StmtResult
    
    /// Visits a `defer` statement node
    ///
    /// - Parameter body: Statements to be executed when the `defer` statement
    /// leaves the scope
    /// - Returns: Result of visiting the `defer` statement
    func visitDefer(_ body: CompoundStatement) -> StmtResult
    
    /// Visits a return statement
    ///
    /// - Parameter expression: An optional expression that evaluates to the return
    /// value of the containing scope of the `return` statement
    /// - Returns: Result of visiting the `return` statement
    func visitReturn(_ expression: Expression?) -> StmtResult
    
    /// Visits a break statement
    ///
    /// - Returns: Result of visiting the break statement
    func visitBreak() -> StmtResult
    
    /// Visits a continue statement
    ///
    /// - Returns: Result of visiting the continue statement
    func visitContinue() -> StmtResult
    
    /// Visits an expression sequence statement
    ///
    /// - Parameter expressions: Expressions to be executed
    /// - Returns: Result of visiting the expressions statement
    func visitExpressions(_ expressions: [Expression]) -> StmtResult
    
    /// Visits a variable declaration statement
    ///
    /// - Parameter variables: Variables being declared within the statement
    /// - Returns: Result of visiting the variables statement
    func visitVariableDeclarations(_ variables: [StatementVariableDeclaration]) -> StmtResult
    
    /// Visits an unknown statement node
    ///
    /// - Parameter context: Context for the unknown node
    /// - Returns: Result of visiting the unknown statement context
    func visitUnknown(_ context: UnknownASTContext) -> StmtResult
}

public extension Statement {
    /// Accepts the given visitor instance, calling the appropriate visiting method
    /// according to this statement's type.
    ///
    /// - Parameter visitor: The visitor to accept
    /// - Returns: The result of the visitor's `visit-` call when applied to this
    /// statement
    public func accept<V: StatementVisitor>(_ visitor: V) -> V.StmtResult {
        switch self {
        case .semicolon:
            return visitor.visitSemicolon()
        case let .compound(body):
            return visitor.visitCompound(body)
        case let .if(exp, body, elseBody):
            return visitor.visitIf(exp, body, elseBody)
        case let .while(exp, body):
            return visitor.visitWhile(exp, body)
        case let .for(pattern, exp, body):
            return visitor.visitFor(pattern, exp, body)
        case let .defer(body):
            return visitor.visitDefer(body)
        case let .return(expr):
            return visitor.visitReturn(expr)
        case .break:
            return visitor.visitBreak()
        case .continue:
            return visitor.visitContinue()
        case let .expressions(exp):
            return visitor.visitExpressions(exp)
        case .variableDeclarations(let variables):
            return visitor.visitVariableDeclarations(variables)
        case .unknown(let context):
            return visitor.visitUnknown(context)
        }
    }
}

open class StatementPass: StatementVisitor {
    public init() {
        
    }
    
    open func visitStatement(_ statement: Statement) -> Statement {
        switch statement {
        case .semicolon:
            return visitSemicolon()
            
        case let .compound(body):
            return visitCompound(body)
            
        case let .if(exp, body, elseBody):
            return visitIf(exp, body, elseBody)
            
        case let .while(exp, body):
            return visitWhile(exp, body)
            
        case let .for(pattern, exp, body):
            return visitFor(pattern, exp, body)
            
        case let .defer(body):
            return visitDefer(body)
            
        case let .return(expr):
            return visitReturn(expr)
            
        case .break:
            return visitBreak()
            
        case .continue:
            return visitContinue()
            
        case let .expressions(exp):
            return visitExpressions(exp)
            
        case .variableDeclarations(let variables):
            return visitVariableDeclarations(variables)
            
        case .unknown(let context):
            return visitUnknown(context)
        }
    }
    
    open func visitSemicolon() -> Statement {
        return .semicolon
    }
    
    open func visitCompound(_ compoundStatement: CompoundStatement) -> Statement {
        return .compound(compoundStatement)
    }
    
    open func visitIf(_ expression: Expression, _ body: CompoundStatement, _ elseBody: CompoundStatement?) -> Statement {
        return .if(expression, body: body, else: elseBody)
    }
    
    open func visitWhile(_ expression: Expression, _ body: CompoundStatement) -> Statement {
        return .while(expression, body: body)
    }
    
    open func visitFor(_ pattern: Pattern, _ expression: Expression, _ compoundStatement: CompoundStatement) -> Statement {
        return .for(pattern, expression, body: compoundStatement)
    }
    
    open func visitDefer(_ body: CompoundStatement) -> Statement {
        return .defer(body)
    }
    
    open func visitReturn(_ expression: Expression?) -> Statement {
        return .return(expression)
    }
    
    open func visitBreak() -> Statement {
        return .break
    }
    
    open func visitContinue() -> Statement {
        return .continue
    }
    
    open func visitExpressions(_ expressions: [Expression]) -> Statement {
        return .expressions(expressions)
    }
    
    open func visitVariableDeclarations(_ variables: [StatementVariableDeclaration]) -> Statement {
        return .variableDeclarations(variables)
    }
    
    open func visitUnknown(_ context: UnknownASTContext) -> Statement {
        return .unknown(context)
    }
}
