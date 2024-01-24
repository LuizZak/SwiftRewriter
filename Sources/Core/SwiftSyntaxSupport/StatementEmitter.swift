import SwiftAST
import Intentions

// MARK: - Internals

class StatementEmitter {
    /// A reference to the last statement emitted at the current block level.
    //private var _latestStatement: Statement?

    /// A stack of latest statements seen.
    /// Each entry is the latest statement seen across closure boundaries.
    private var _latestStatementsStack: [Statement?] = [nil]

    let producer: SwiftProducer

    internal init(producer: SwiftProducer) {
        self.producer = producer
    }

    // MARK: Alternative syntax checkers

    /// Checks whether a function call operation is a candidate for trailing
    /// closure syntax transformation.
    ///
    /// Closure parameters can only be trailed if they are the last parameter
    /// of a call, and don't immediately succeed another closure parameter.
    func isTrailingClosureCandidate(_ op: FunctionCallPostfix) -> Bool {
        guard !op.arguments.isEmpty else {
            return false
        }
        guard op.arguments.last?.expression.isBlock == true else {
            return false
        }

        if op.arguments.count > 1 {
            if op.arguments[op.arguments.count - 2].expression.isBlock == true {
                return false
            }
        }

        return true
    }

    func isShorthandClosureCandidate(_ exp: BlockLiteralExpression) -> Bool {
        let hasParameters = !exp.parameters.isEmpty
        
        return !closureRequiresSignature(exp) && hasParameters
    }

    func closureRequiresSignature(_ exp: BlockLiteralExpression) -> Bool {
        exp.resolvedType == nil || exp.resolvedType != exp.expectedType
    }

    func _latestStatement() -> Statement? {
        return _latestStatementsStack[_latestStatementsStack.count - 1]
    }

    func _shouldEmitSpacing(_ nextStmt: Statement) -> Bool {
        guard let latest = _latestStatement() else {
            return false
        }

        if (latest is ExpressionsStatement) && (nextStmt is ExpressionsStatement) {
            return false
        }
        if (latest is VariableDeclarationsStatement) && (nextStmt is VariableDeclarationsStatement) {
            return false
        }

        return true
    }

    func shouldEmitSpacing(_ stmt1: Statement?, _ stmt2: Statement) -> Bool {
        guard var stmt1 else {
            return false
        }
        var stmt2 = stmt2

        // If one of the statements is a compound statement, use the statements
        // at each end for the check
        if let compound = stmt1.asCompound {
            guard let last = compound.statements.last else {
                return false
            }

            stmt1 = last
        }
        if let compound = stmt2.asCompound {
            guard let first = compound.statements.first else {
                return false
            }

            stmt2 = first
        }

        if (stmt1 is ExpressionsStatement) && (stmt2 is ExpressionsStatement) {
            return false
        }
        if (stmt1 is VariableDeclarationsStatement) && (stmt2 is VariableDeclarationsStatement) {
            return false
        }

        return true
    }

    func pushClosureStack() {
        _latestStatementsStack.append(nil)
    }

    func popClosureStack() {
        _latestStatementsStack.removeLast()
    }

    func recordLatest(_ nextStmt: Statement) {
        if _shouldEmitSpacing(nextStmt) {
            emitNewline()
        }

        _latestStatementsStack[_latestStatementsStack.count - 1] = nextStmt
    }

    // MARK: Convenience wrappers

    func emit(_ text: String) {
        producer.emit(text)
    }

    func emitLine(_ text: String) {
        producer.emitLine(text)
    }

    func emit(_ type: SwiftType) {
        producer.emit(type)
    }

    func emitReturnType(_ type: SwiftType) {
        producer.emitReturnType(type)
    }

    func emitSpaceSeparator() {
        producer.emitSpaceSeparator()
    }

    func emitNewline() {
        producer.emitNewline()
    }

    func emitStatements(_ stmts: [Statement]) {
        for stmt in stmts {
            visitStatement(stmt)
        }
    }

    func emitComments(_ comments: [SwiftComment]) {
        comments.forEach(producer.emit)
    }

    func emitCodeBlock(_ stmt: CompoundStatement) {
        pushClosureStack()
        defer { popClosureStack() }

        producer.emitBlock {
            visitCompound(stmt)
        }
    }
}
