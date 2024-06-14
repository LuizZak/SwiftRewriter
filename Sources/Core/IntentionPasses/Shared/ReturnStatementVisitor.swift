import SwiftAST

/// Visitor that collects return statements within the scope of a starting
/// statement.
struct ReturnStatementVisitor: StatementVisitor {
    typealias StmtResult = [ReturnStatement]

    func visitStatement(_ statement: Statement) -> [ReturnStatement] {
        return statement.accept(self)
    }

    func visitReturn(_ stmt: ReturnStatement) -> [ReturnStatement] {
        return [stmt]
    }

    func visitCompound(_ stmt: CompoundStatement) -> [ReturnStatement] {
        return stmt.statements.flatMap { $0.accept(self) }
    }

    func visitConditionalClauses(_ clauses: ConditionalClauses) -> [ReturnStatement] {
        return []
    }

    func visitConditionalClauseElement(_ clause: ConditionalClauseElement) -> [ReturnStatement] {
        return []
    }

    func visitIf(_ stmt: IfStatement) -> [ReturnStatement] {
        if let elseBody = stmt.elseBody {
            return stmt.body.accept(self) + visitElseBody(elseBody)
        }

        return stmt.body.accept(self)
    }

    func visitElseBody(_ stmt: IfStatement.ElseBody) -> [ReturnStatement] {
        switch stmt {
        case .else(let body):
            return visitCompound(body)

        case .elseIf(let elseIf):
            return visitIf(elseIf)
        }
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
        return switchCase.statements.flatMap(visitStatement)
    }

    func visitSwitchCasePattern(_ casePattern: SwitchCase.CasePattern) -> [ReturnStatement] {
        return []
    }

    func visitSwitchDefaultCase(_ defaultCase: SwitchDefaultCase) -> [ReturnStatement] {
        return defaultCase.statements.flatMap(visitStatement)
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
