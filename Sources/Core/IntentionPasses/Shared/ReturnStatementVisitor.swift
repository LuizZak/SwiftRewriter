import SwiftAST

/// Visitor that collects return statements within the scope of a starting
/// statement.
struct ReturnStatementVisitor: StatementVisitor {
    typealias StmtResult = [ReturnStatement]

    func visitStatement(_ statement: Statement) -> [ReturnStatement] {
        statement.accept(self)
    }

    func visitReturn(_ stmt: ReturnStatement) -> [ReturnStatement] {
        return [stmt]
    }

    func visitCompound(_ stmt: CompoundStatement) -> [ReturnStatement] {
        stmt.statements.flatMap { $0.accept(self) }
    }

    func visitConditionalClauses(_ clauses: ConditionalClauses) -> [ReturnStatement] {
        return []
    }

    func visitConditionalClauseElement(_ clause: ConditionalClauseElement) -> [ReturnStatement] {
        return []
    }

    func visitIf(_ stmt: IfStatement) -> [ReturnStatement] {
        return stmt.body.accept(self)
    }

    func visitGuard(_ stmt: GuardStatement) -> [ReturnStatement] {
        return stmt.elseBody.accept(self)
    }

    func visitWhile(_ stmt: WhileStatement) -> [ReturnStatement] {
        return stmt.body.accept(self)
    }

    func visitSwitch(_ stmt: SwitchStatement) -> [ReturnStatement] {
        var result = stmt.cases.flatMap(visitSwitchCase)
        if let defaultCase = stmt.defaultCase {
            result.append(contentsOf: visitSwitchDefaultCase(defaultCase))
        }

        return result
    }

    func visitSwitchCase(_ switchCase: SwitchCase) -> [ReturnStatement] {
        switchCase.statements.flatMap(visitStatement)
    }

    /// Visits a `default` block from a `SwitchStatement`.
    ///
    /// - Parameter defaultCase: A switch default case block to visit
    /// - Returns: Result of visiting the switch default case block
    func visitSwitchDefaultCase(_ defaultCase: SwitchDefaultCase) -> [ReturnStatement] {
        defaultCase.statements.flatMap(visitStatement)
    }

    func visitRepeatWhile(_ stmt: RepeatWhileStatement) -> [ReturnStatement] {
        return stmt.body.accept(self)
    }

    func visitFor(_ stmt: ForStatement) -> [ReturnStatement] {
        return stmt.body.accept(self)
    }

    func visitDo(_ stmt: DoStatement) -> [ReturnStatement] {
        return stmt.body.accept(self)
    }

    func visitCatchBlock(_ block: CatchBlock) -> [ReturnStatement] {
        return block.body.accept(self)
    }

    func visitDefer(_ stmt: DeferStatement) -> [ReturnStatement] {
        return []
    }

    func visitBreak(_ stmt: BreakStatement) -> [ReturnStatement] {
        return []
    }

    func visitFallthrough(_ stmt: FallthroughStatement) -> [ReturnStatement] {
        return []
    }

    func visitContinue(_ stmt: ContinueStatement) -> [ReturnStatement] {
        return []
    }

    func visitExpressions(_ stmt: ExpressionsStatement) -> [ReturnStatement] {
        return []
    }

    func visitVariableDeclarations(_ stmt: VariableDeclarationsStatement) -> [ReturnStatement] {
        return []
    }

    func visitStatementVariableDeclaration(_ decl: StatementVariableDeclaration) -> [ReturnStatement] {
        return []
    }

    func visitLocalFunction(_ stmt: LocalFunctionStatement) -> [ReturnStatement] {
        return []
    }

    func visitThrow(_ stmt: ThrowStatement) -> [ReturnStatement] {
        return []
    }

    func visitUnknown(_ stmt: UnknownStatement) -> [ReturnStatement] {
        return []
    }
}
