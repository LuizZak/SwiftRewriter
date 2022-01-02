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

    func visitIf(_ stmt: IfStatement) -> [ReturnStatement] {
        return stmt.body.accept(self)
    }

    func visitWhile(_ stmt: WhileStatement) -> [ReturnStatement] {
        return stmt.body.accept(self)
    }

    func visitSwitch(_ stmt: SwitchStatement) -> [ReturnStatement] {
        var result: [ReturnStatement] = []

        for caseClause in stmt.cases {
            result.append(contentsOf: caseClause.statements.flatMap { $0.accept(self) })
        }

        if let def = stmt.defaultCase {
            result.append(contentsOf: def.flatMap { $0.accept(self) })
        }

        return result
    }

    func visitDoWhile(_ stmt: DoWhileStatement) -> [ReturnStatement] {
        return stmt.body.accept(self)
    }

    func visitFor(_ stmt: ForStatement) -> [ReturnStatement] {
        return stmt.body.accept(self)
    }

    func visitDo(_ stmt: DoStatement) -> [ReturnStatement] {
        return stmt.body.accept(self)
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

    func visitLocalFunction(_ stmt: LocalFunctionStatement) -> [ReturnStatement] {
        return []
    }

    func visitUnknown(_ stmt: UnknownStatement) -> [ReturnStatement] {
        return []
    }
}
