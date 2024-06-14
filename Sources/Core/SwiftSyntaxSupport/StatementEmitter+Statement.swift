import SwiftAST

extension StatementEmitter: StatementVisitor {
    func visitPattern(_ ptn: Pattern) {
        switch ptn {
        case .expression(let exp):
            visitExpression(exp)

        case .tuple(let patterns):
            emit("(")
            producer.emitWithSeparators(
                patterns,
                separator: ", ",
                visitPattern
            )
            emit(")")

        case .identifier(let ident):
            emit(ident)

        case .asType(let pattern, let type):
            visitPattern(pattern)
            emit(" as ")
            emit(type)

        case .valueBindingPattern(true, let pattern):
            emit("let ")
            visitPattern(pattern)

        case .valueBindingPattern(false, let pattern):
            emit("var ")
            visitPattern(pattern)

        case .wildcard:
            emit("_")
        }
    }

    func visitStatement(_ stmt: Statement) {
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
        stmt.accept(self)
        if let trailing = stmt.trailingComment {
            producer.backtrackWhitespace()
            emitSpaceSeparator()
            producer.emit(trailing)
        }
        producer.ensureNewline()
    }

    func visitCompound(_ stmt: CompoundStatement) {
        emitComments(stmt.comments)

        if !stmt.comments.isEmpty && !stmt.statements.isEmpty {
            producer.ensureEmptyLine()
        }

        emitStatements(stmt.statements)
    }

    func visitConditionalClauses(_ clauses: ConditionalClauses) {
        for (i, element) in clauses.clauses.enumerated() {
            if i > 0 {
                emit(", ")
            }

            visitConditionalClauseElement(element)
        }
    }

    func visitConditionalClauseElement(_ clause: ConditionalClauseElement) {
        if let pattern = clause.pattern {
            visitPattern(pattern)
            emit(" = ")
        }
        visitExpression(clause.expression)
    }

    func visitIf(_ stmt: IfStatement) {
        emit("if ")
        visitConditionalClauses(stmt.conditionalClauses)

        emitSpaceSeparator()

        emitCodeBlock(stmt.body)

        if let elseBody = stmt.elseBody {
            visitElseBody(elseBody)
        }
    }

    func visitElseBody(_ stmt: IfStatement.ElseBody) {
        producer.backtrackWhitespace()
        emit(" else ")

        switch stmt {
        case .else(let stmts):
            emitCodeBlock(stmts)

        case .elseIf(let elseIf):
            visitIf(elseIf)
        }
    }

    func visitGuard(_ stmt: GuardStatement) {
        emit("guard ")
        visitConditionalClauses(stmt.conditionalClauses)

        emit(" else ")
        emitCodeBlock(stmt.elseBody)
    }

    func visitSwitch(_ stmt: SwitchStatement) {
        emit("switch ")
        visitExpression(stmt.exp)
        emitLine(" {")

        stmt.cases.forEach { visitSwitchCase($0) }

        if let defaultCase = stmt.defaultCase {
            visitSwitchDefaultCase(defaultCase)
        }

        producer.ensureNewline()
        emitLine("}")
    }

    func visitSwitchCase(_ switchCase: SwitchCase) {
        emit("case ")
        producer.emitWithSeparators(switchCase.casePatterns, separator: ", ", visitSwitchCasePattern)
        emitLine(":")
        producer.indented {
            pushClosureStack()
            emitStatements(switchCase.statements)
            popClosureStack()
        }
    }

    func visitSwitchCasePattern(_ casePattern: SwitchCase.CasePattern) {
        visitPattern(casePattern.pattern)

        if let whereClause = casePattern.whereClause {
            emit(" where ")
            visitExpression(whereClause)
        }
    }

    func visitSwitchDefaultCase(_ defaultCase: SwitchDefaultCase) {
        emitLine("default:")
        producer.indented {
            pushClosureStack()
            emitStatements(defaultCase.statements)
            popClosureStack()
        }
    }

    func visitWhile(_ stmt: WhileStatement) {
        emit("while ")
        visitConditionalClauses(stmt.conditionalClauses)
        producer.emitSpaceSeparator()
        emitCodeBlock(stmt.body)
    }

    func visitRepeatWhile(_ stmt: RepeatWhileStatement) {
        emit("repeat ")
        emitCodeBlock(stmt.body)
        producer.backtrackWhitespace()
        emit(" while ")
        visitExpression(stmt.exp)
    }

    func visitFor(_ stmt: ForStatement) {
        emit("for ")

        switch stmt.pattern {
        case .identifier(let ident):
            emit(ident)
        default:
            visitPattern(stmt.pattern)
        }

        emit(" in ")
        visitExpression(stmt.exp)
        emitSpaceSeparator()

        emitCodeBlock(stmt.body)
    }

    func visitDo(_ stmt: DoStatement) {
        emit("do ")
        emitCodeBlock(stmt.body)

        for catchBlock in stmt.catchBlocks {
            visitCatchBlock(catchBlock)
        }
    }

    func visitCatchBlock(_ block: CatchBlock) {
        producer.backtrackWhitespace()
        emit(" catch ")

        if let pattern = block.pattern {
            visitPattern(pattern)
            emitSpaceSeparator()
        }

        emitCodeBlock(block.body)
    }

    func visitDefer(_ stmt: DeferStatement) {
        emit("defer ")
        emitCodeBlock(stmt.body)
    }

    func visitReturn(_ stmt: ReturnStatement) {
        emit("return")
        if let exp = stmt.exp {
            emitSpaceSeparator()
            visitExpression(exp)
        }
    }

    func visitBreak(_ stmt: BreakStatement) {
        emit("break")
        if let targetLabel = stmt.targetLabel {
            emitSpaceSeparator()
            emit(targetLabel)
        }
    }

    func visitFallthrough(_ stmt: FallthroughStatement) {
        emit("fallthrough")
    }

    func visitContinue(_ stmt: ContinueStatement) {
        emit("continue")
        if let targetLabel = stmt.targetLabel {
            emitSpaceSeparator()
            emit(targetLabel)
        }
    }

    func visitExpressions(_ stmt: ExpressionsStatement) {
        producer.emitWithSeparators(stmt.expressions, separator: "\n") { exp in
            if producer.settings.outputExpressionTypes {
                emitComments([
                    .line("// type: \(exp.resolvedType?.description ?? "<nil>")")
                ])
            }

            visitExpression(exp)
        }
    }

    func visitVariableDeclarations(_ stmt: VariableDeclarationsStatement) {
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

    func visitStatementVariableDeclaration(_ decl: StatementVariableDeclaration) {

    }

    func visitLocalFunction(_ stmt: LocalFunctionStatement) {
        emit("func ")
        producer.emit(stmt.function.signature)
        emitSpaceSeparator()
        emitCodeBlock(stmt.function.body)
    }

    func visitThrow(_ stmt: ThrowStatement) {
        emit("throw ")
        visitExpression(stmt.exp)
    }

    func visitUnknown(_ stmt: UnknownStatement) {
        emitLine("/*")
        emitLine(stmt.context.context)
        emitLine("*/")
    }
}
