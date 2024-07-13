import SwiftAST

extension StatementEmitter: StatementStatefulVisitor {
    func visitPattern(_ ptn: Pattern) {
        visitPattern(ptn, state: .default)
    }

    func visitPattern(_ ptn: Pattern, state: StatementEmitterContext) {
        switch ptn {
        case .expression(let exp):
            visitExpression(exp)

        case .tuple(let patterns):
            emit("(")
            producer.emitWithSeparators(patterns, separator: ", ") {
                visitPattern($0, state: state)
            }
            emit(")")

        case .identifier(let ident):
            if !state.patternContextIsBinding {
                emit("let ")
            }
            emit(ident)

        case .wildcard:
            emit("_")
        }
    }

    func visitStatement(_ stmt: Statement) {
        visitStatement(stmt, state: .default)
    }

    func visitStatement(_ stmt: Statement, state: StatementEmitterContext) {
        if !stmt.isCompound {
            recordLatest(stmt)
            emitComments(stmt.comments)
        }
        if let label = stmt.label {
            if stmt.isLabelableStatementType {
                emitLine("\(label):")
            } else {
                emitLine("// \(label):")
            }
        }
        stmt.accept(self, state: state)
        if let trailing = stmt.trailingComment {
            producer.backtrackWhitespace()
            emitSpaceSeparator()
            producer.emit(trailing)
        }
        producer.ensureNewline()
    }

    func visitCompound(_ stmt: CompoundStatement) {
        visitCompound(stmt, state: .default)
    }

    func visitCompound(_ stmt: CompoundStatement, state: StatementEmitterContext) {
        emitComments(stmt.comments)

        if !stmt.comments.isEmpty && !stmt.statements.isEmpty {
            producer.ensureEmptyLine()
        }

        emitStatements(stmt.statements)
    }

    func visitIf(_ stmt: IfStatement, state: StatementEmitterContext) {
        emit("if ")
        if let pattern = stmt.pattern {
            visitPattern(pattern, state: state)
            emit(" = ")
        }
        visitExpression(stmt.exp)
        emitSpaceSeparator()

        emitCodeBlock(stmt.body)

        if let elseBody = stmt.elseBody {
            // Backtrack to closing brace
            producer.backtrackWhitespace()
            emit(" else ")

            // Collapse else-if chains
            if
                elseBody.statements.count == 1,
                let elseIf = elseBody.statements.first?.asIf
            {
                visitIf(elseIf, state: state)
            } else {
                emitCodeBlock(elseBody)
            }
        }
    }

    func visitSwitch(_ stmt: SwitchStatement, state: StatementEmitterContext) {
        emit("switch ")
        visitExpression(stmt.exp)
        emitLine(" {")

        stmt.cases.forEach { visitSwitchCase($0, state: state) }

        if let defaultCase = stmt.defaultCase {
            visitSwitchDefaultCase(defaultCase, state: state)
        }

        producer.ensureNewline()
        emitLine("}")
    }

    func visitSwitchCase(_ switchCase: SwitchCase, state: StatementEmitterContext) {
        emit("case ")
        producer.emitWithSeparators(switchCase.patterns, separator: ", ") {
            visitPattern($0, state: state)
        }
        emitLine(":")
        producer.indented {
            pushClosureStack()
            emitStatements(switchCase.statements)
            popClosureStack()
        }
    }

    func visitSwitchDefaultCase(_ defaultCase: SwitchDefaultCase, state: StatementEmitterContext) {
        emitLine("default:")
        producer.indented {
            pushClosureStack()
            emitStatements(defaultCase.statements)
            popClosureStack()
        }
    }

    func visitWhile(_ stmt: WhileStatement, state: StatementEmitterContext) {
        emit("while ")
        visitExpression(stmt.exp)
        producer.emitSpaceSeparator()
        emitCodeBlock(stmt.body)
    }

    func visitRepeatWhile(_ stmt: RepeatWhileStatement, state: StatementEmitterContext) {
        emit("repeat ")
        emitCodeBlock(stmt.body)
        producer.backtrackWhitespace()
        emit(" while ")
        visitExpression(stmt.exp)
    }

    func visitFor(_ stmt: ForStatement, state: StatementEmitterContext) {
        emit("for ")

        switch stmt.pattern {
        case .identifier(let ident):
            emit(ident)
        default:
            visitPattern(
                stmt.pattern,
                state: state.with(\.patternContextIsBinding, value: true)
            )
        }

        emit(" in ")
        visitExpression(stmt.exp)
        emitSpaceSeparator()

        emitCodeBlock(stmt.body)
    }

    func visitDo(_ stmt: DoStatement, state: StatementEmitterContext) {
        emit("do ")
        emitCodeBlock(stmt.body)

        for catchBlock in stmt.catchBlocks {
            visitCatchBlock(catchBlock, state: state)
        }
    }

    func visitCatchBlock(_ block: CatchBlock, state: StatementEmitterContext) {
        producer.backtrackWhitespace()
        emit(" catch ")

        if let pattern = block.pattern {
            visitPattern(pattern, state: state)
            emitSpaceSeparator()
        }

        emitCodeBlock(block.body)
    }

    func visitDefer(_ stmt: DeferStatement, state: StatementEmitterContext) {
        emit("defer ")
        emitCodeBlock(stmt.body)
    }

    func visitReturn(_ stmt: ReturnStatement, state: StatementEmitterContext) {
        emit("return")
        if let exp = stmt.exp {
            emitSpaceSeparator()
            visitExpression(exp)
        }
    }

    func visitBreak(_ stmt: BreakStatement, state: StatementEmitterContext) {
        emit("break")
        if let targetLabel = stmt.targetLabel {
            emitSpaceSeparator()
            emit(targetLabel)
        }
    }

    func visitFallthrough(_ stmt: FallthroughStatement, state: StatementEmitterContext) {
        emit("fallthrough")
    }

    func visitContinue(_ stmt: ContinueStatement, state: StatementEmitterContext) {
        emit("continue")
        if let targetLabel = stmt.targetLabel {
            emitSpaceSeparator()
            emit(targetLabel)
        }
    }

    func visitExpressions(_ stmt: ExpressionsStatement, state: StatementEmitterContext) {
        producer.emitWithSeparators(stmt.expressions, separator: "\n") { exp in
            if producer.settings.outputExpressionTypes {
                emitComments([
                    .line("// type: \(exp.resolvedType?.description ?? "<nil>")")
                ])
            }

            visitExpression(exp)
        }
    }

    func visitVariableDeclarations(_ stmt: VariableDeclarationsStatement, state: StatementEmitterContext) {
        let declarations = group(stmt.decl.map(producer.makeDeclaration))

        for (i, decl) in declarations.enumerated() {
            if producer.settings.outputExpressionTypes {
                let declType = stmt.decl[i].type
                producer.emitComment("decl type: \(declType)")

                if let exp = stmt.decl[i].initialization {
                    producer.emitComment("init type: \(exp.resolvedType ?? "<nil>")")
                }
            }

            producer.emit(decl)
        }
    }

    func visitStatementVariableDeclaration(_ decl: StatementVariableDeclaration, state: StatementEmitterContext) {

    }

    func visitLocalFunction(_ stmt: LocalFunctionStatement, state: StatementEmitterContext) {
        emit("func ")
        producer.emit(stmt.function.signature)
        emitSpaceSeparator()
        emitCodeBlock(stmt.function.body)
    }

    func visitThrow(_ stmt: ThrowStatement, state: StatementEmitterContext) {
        emit("throw ")
        visitExpression(stmt.exp)
    }

    func visitUnknown(_ stmt: UnknownStatement, state: StatementEmitterContext) {
        emitLine("/*")
        emitLine(stmt.context.context)
        emitLine("*/")
    }

    struct StatementEmitterContext {
        /// A default state to provide for entry-point statement visiting functions
        /// when no special context is available.
        static let `default` = StatementEmitterContext()

        /// Whether the current pattern binding context is already binding, and
        /// no `let` keyword is required.
        var patternContextIsBinding = false

        /// Returns a copy of `self` with the value at a specified keypath changed
        /// to a specified value.
        func with<Value>(_ keyPath: WritableKeyPath<Self, Value>, value: Value) -> Self {
            var copy = self
            copy[keyPath: keyPath] = value
            return copy
        }
    }
}
