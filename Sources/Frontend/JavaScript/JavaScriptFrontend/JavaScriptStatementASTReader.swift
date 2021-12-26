import JsGrammarModels
import JsParserAntlr
import JsParser
import Antlr4
import SwiftAST

public final class JavaScriptStatementASTReader: JavaScriptParserBaseVisitor<Statement> {
    public typealias Parser = JavaScriptParser
    
    var expressionReader: JavaScriptExprASTReader
    var context: JavaScriptASTReaderContext
    public weak var delegate: JavaScriptASTReaderDelegate?
    
    public init(expressionReader: JavaScriptExprASTReader,
                context: JavaScriptASTReaderContext,
                delegate: JavaScriptASTReaderDelegate?) {

        self.expressionReader = expressionReader
        self.context = context
        self.delegate = delegate
    }

    public override func visitBlock(_ ctx: JavaScriptParser.BlockContext) -> Statement? {
        compoundVisitor().visitBlock(ctx)
    }

    public override func visitVariableStatement(_ ctx: JavaScriptParser.VariableStatementContext) -> Statement? {
        ctx.variableDeclarationList()?.accept(self)
    }

    public override func visitVariableDeclarationList(_ ctx: JavaScriptParser.VariableDeclarationListContext) -> Statement? {
        guard let declarations = variableDeclarations(from: ctx) else {
            return unknown(ctx)
        }

        return .variableDeclarations(declarations)
    }

    public override func visitExpressionStatement(_ ctx: JavaScriptParser.ExpressionStatementContext) -> Statement? {
        ctx.expressionSequence()?.accept(self)
    }

    public override func visitExpressionSequence(_ ctx: JavaScriptParser.ExpressionSequenceContext) -> Statement? {
        guard let expression = ctx.accept(expressionReader) else {
            return unknown(ctx)
        }

        return .expression(expression)
    }

    public override func visitIfStatement(_ ctx: JavaScriptParser.IfStatementContext) -> Statement? {
        guard let expression = ctx.expressionSequence()?.accept(expressionReader) else {
            return unknown(ctx)
        }
        guard let statement = ctx.statement(0)?.accept(compoundVisitor()) else {
            return unknown(ctx)
        }

        return .if(
            expression,
            body: statement,
            else: ctx.statement(1)?.accept(compoundVisitor())
        )
    }

    public override func visitDoStatement(_ ctx: JavaScriptParser.DoStatementContext) -> Statement? {
        guard let expression = ctx.expressionSequence()?.accept(expressionReader) else {
            return unknown(ctx)
        }
        guard let statement = ctx.statement()?.accept(compoundVisitor()) else {
            return unknown(ctx)
        }

        return .doWhile(expression, body: statement)
    }

    public override func visitWhileStatement(_ ctx: JavaScriptParser.WhileStatementContext) -> Statement? {
        guard let expression = ctx.expressionSequence()?.accept(expressionReader) else {
            return unknown(ctx)
        }
        guard let statement = ctx.statement()?.accept(compoundVisitor()) else {
            return unknown(ctx)
        }

        return .while(expression, body: statement)
    }

    public override func visitForStatement(_ ctx: JavaScriptParser.ForStatementContext) -> Statement? {
        let generator = ForStatementGenerator(reader: self, context: context)
        
        return generator.generate(ctx)
    }

    public override func visitForInStatement(_ ctx: JavaScriptParser.ForInStatementContext) -> Statement? {
        // TODO: Improve support for tuple-based for-in loops.

        let identifier: String?

        if let singleExpression = ctx.singleExpression() {
            identifier = singleExpression.accept(expressionReader)?.asIdentifier?.identifier
        } else if let declList = ctx.variableDeclarationList() {
            let decl = variableDeclarations(from: declList)

            identifier = decl?.first?.identifier
        } else {
            return unknown(ctx)
        }

        let expression = ctx.expressionSequence()?.accept(expressionReader)
        let body = ctx.statement()?.accept(compoundVisitor())
        
        if let identifier = identifier, let expression = expression, let body = body {
            return .for(
                .identifier(identifier),
                expression,
                body: body
            )
        }

        return unknown(ctx)
    }
    
    public override func visitForOfStatement(_ ctx: JavaScriptParser.ForOfStatementContext) -> Statement? {
        // TODO: Support for-of statement
        unknown(ctx)
    }

    public override func visitContinueStatement(_ ctx: JavaScriptParser.ContinueStatementContext) -> Statement? {
        .continue(targetLabel: ctx.identifier()?.getText())
    }

    public override func visitBreakStatement(_ ctx: JavaScriptParser.BreakStatementContext) -> Statement? {
        .break(targetLabel: ctx.identifier()?.getText())
    }

    public override func visitReturnStatement(_ ctx: JavaScriptParser.ReturnStatementContext) -> Statement? {
        .return(ctx.expressionSequence()?.accept(expressionReader))
    }

    public override func visitYieldExpression(_ ctx: JavaScriptParser.YieldExpressionContext) -> Statement? {
        // TODO: Support yield statement
        unknown(ctx)
    }
    
    public override func visitWithStatement(_ ctx: JavaScriptParser.WithStatementContext) -> Statement? {
        // TODO: Support with statement
        unknown(ctx)
    }

    public override func visitLabelledStatement(_ ctx: JavaScriptParser.LabelledStatementContext) -> Statement? {
        ctx.statement()?.accept(self)?.labeled(ctx.identifier()?.getText())
    }

    public override func visitSwitchStatement(_ ctx: JavaScriptParser.SwitchStatementContext) -> Statement? {
        guard let exp = ctx.expressionSequence()?.accept(expressionReader) else { return unknown(ctx) }
        guard let block = ctx.caseBlock() else { return unknown(ctx) }

        let cases = block.caseClauses().flatMap(causeClauses(_:))
        var defaultCase = block.defaultClause().flatMap(defaultClause(_:))

        // If no default is present, always emit a `default: break` statement,
        // since switches in Swift must be exhaustive.
        if defaultCase == nil {
            defaultCase = [.break()]
        }
        
        return .switch(
            exp,
            cases: cases,
            default: defaultCase
        )
    }

    public override func visitThrowStatement(_ ctx: JavaScriptParser.ThrowStatementContext) -> Statement? {
        // TODO: Support throw statement
        unknown(ctx)
    }

    public override func visitTryStatement(_ ctx: JavaScriptParser.TryStatementContext) -> Statement? {
        // TODO: Support try statement
        unknown(ctx)
    }

    public override func visitFunctionDeclaration(_ ctx: JavaScriptParser.FunctionDeclarationContext) -> Statement? {
        // TODO: Support inline function declaration.
        unknown(ctx)
    }

    // MARK: - Helper generators

    private func causeClauses(_ ctx: JavaScriptParser.CaseClausesContext) -> [SwitchCase] {
        var cases: [SwitchCase] = []

        for clause in ctx.caseClause() {
            context.pushDefinitionContext()
            defer { context.popDefinitionContext() }
            
            guard let labels = clause.expressionSequence() else {
                continue
            }
            guard let expr = labels.accept(expressionReader) else {
                continue
            }
            
            let patterns: [Pattern] = [.expression(expr)]
            var statements = clause.statementList()?.accept(compoundVisitor())?.statements ?? []
            
            if statements.count == 1, let stmt = statements[0].asCompound {
                statements = stmt.statements
            }

            // Merge sequential switch cases that have empty statements
            if cases.count > 0, let last = cases.last {
                if last.statements.isEmpty {
                    cases[cases.count - 1].patterns.append(contentsOf: patterns)
                    cases[cases.count - 1].statements.append(contentsOf: statements)
                    continue
                }
            }

            cases.append(
                SwitchCase(
                    patterns: [.expression(expr)],
                    statements: statements
                )
            )
        }

        // Append a default fallthrough to empty cases, in case the last statement
        // is not a jump stmt to somewhere else (`return`, `continue` or
        // `break`)
        return cases.map { caseClause in
            var statements = caseClause.statements

            let hasBreak = statements.last?.isUnconditionalJump ?? false
            if !hasBreak {
                statements.append(.fallthrough)
            }

            return .init(patterns: caseClause.patterns, statements: statements)
        }
    }

    private func defaultClause(_ ctx: JavaScriptParser.DefaultClauseContext) -> [Statement]? {
        ctx.statementList()?.accept(compoundVisitor())?.statements
    }

    fileprivate func variableDeclarations(from ctx: JavaScriptParser.VariableDeclarationListContext) -> [StatementVariableDeclaration]? {
        guard let modifier = ctx.varModifier().map(varModifier(from:)) else {
            return nil
        }

        var declarations: [StatementVariableDeclaration] = []

        for declaration in ctx.variableDeclaration() {
            if let decl = variableDeclaration(from: declaration, modifier: modifier) {
                declarations.append(decl)
            }
        }

        return declarations
    }

    fileprivate func variableDeclaration(from ctx: JavaScriptParser.VariableDeclarationContext, modifier: JsVariableDeclarationListNode.VarModifier) -> StatementVariableDeclaration? {
        guard let identifier = ctx.assignable()?.identifier() else {
            return nil
        }

        var initialization: Expression?
        let type: SwiftType = .any
        let isConstant = modifier == .const

        if let singleExpression = ctx.singleExpression() {
            initialization = singleExpression.accept(expressionReader)
        }

        return .init(identifier: identifier.getText(), type: type, isConstant: isConstant, initialization: initialization)
    }

    fileprivate func varModifier(from ctx: JavaScriptParser.VarModifierContext) -> JsVariableDeclarationListNode.VarModifier {
        JsParser.varModifier(from: ctx)
    }

    fileprivate func unknown(_ ctx: ParserRuleContext) -> Statement {
        .unknown(UnknownASTContext(context: _sourceText(for: ctx)))
    }
    
    private func _sourceText(for ctx: ParserRuleContext) -> String {
        return self.context.sourceCode(for: ctx).map(String.init) ?? ""
    }

    // MARK: - AST reader factories

    fileprivate func compoundVisitor() -> CompoundStatementVisitor {
        CompoundStatementVisitor(
            expressionReader: expressionReader,
            context: context,
            delegate: delegate
        )
    }

    // MARK: - Compound statement visitor
    class CompoundStatementVisitor: JavaScriptParserBaseVisitor<CompoundStatement> {
        var expressionReader: JavaScriptExprASTReader
        var context: JavaScriptASTReaderContext
        weak var delegate: JavaScriptASTReaderDelegate?
        
        init(expressionReader: JavaScriptExprASTReader,
             context: JavaScriptASTReaderContext,
             delegate: JavaScriptASTReaderDelegate?) {

            self.expressionReader = expressionReader
            self.context = context
            self.delegate = delegate
        }

        override func visitFunctionBody(_ ctx: JavaScriptParser.FunctionBodyContext) -> CompoundStatement? {
            guard let sourceElements = ctx.sourceElements() else {
                return CompoundStatement()
            }

            return sourceElements.accept(self)
        }
        
        override func visitStatement(_ ctx: Parser.StatementContext) -> CompoundStatement? {
            if let block = ctx.block() {
                return block.accept(self)
            }
            
            let reader = statementReader()
            
            if let stmt = reader.visitStatement(ctx) {
                return CompoundStatement(statements: [stmt])
            }
            
            return nil
        }

        override func visitSourceElements(_ ctx: JavaScriptParser.SourceElementsContext) -> CompoundStatement? {
            context.pushDefinitionContext()
            defer { context.popDefinitionContext() }
            
            let reader = statementReader()

            let statements: [Statement] = ctx.sourceElement().map { element in
                let unknown = UnknownStatement.unknown(UnknownASTContext(context: element.getText()))

                return element.statement().flatMap { $0.accept(reader) } ?? unknown
            }
            
            return makeCompoundStatement(statements)
        }

        override func visitArrowFunctionBody(_ ctx: JavaScriptParser.ArrowFunctionBodyContext) -> CompoundStatement? {
            if let singleExpression = ctx.singleExpression(), let expression = singleExpression.accept(expressionReader) {
                return [
                    .expression(expression)
                ]
            }
            if let functionBody = ctx.functionBody() {
                return functionBody.accept(self)
            }

            return nil
        }
        
        override func visitBlock(_ ctx: Parser.BlockContext) -> CompoundStatement? {
            context.pushDefinitionContext()
            defer { context.popDefinitionContext() }
            
            let reader = statementReader()

            let statements: [Statement] = ctx.statementList()?.statement().map { stmt in
                let unknown = UnknownStatement.unknown(UnknownASTContext(context: stmt.getText()))

                return stmt.accept(reader) ?? unknown
            } ?? []
            
            return makeCompoundStatement(statements)
        }

        private func makeCompoundStatement(_ statements: [Statement]) -> CompoundStatement {
            return CompoundStatement(statements: statements.flatMap { stmt -> [Statement] in
                // Free compound blocks cannot be declared in Swift
                if let inner = stmt.asCompound {
                    // Label the first statement with the compound's label, as
                    // well
                    inner.statements.first?.label = stmt.label
                    
                    return inner.statements.map { $0.copy() }
                }
                
                return [stmt]
            })
        }

        private func statementReader() -> JavaScriptStatementASTReader {
            JavaScriptStatementASTReader(
                expressionReader: expressionReader,
                context: context,
                delegate: delegate
            )
        }
    }
}

private class ForStatementGenerator {
    typealias Parser = JavaScriptParser
    
    var reader: JavaScriptStatementASTReader
    var context: JavaScriptASTReaderContext
    
    init(reader: JavaScriptStatementASTReader, context: JavaScriptASTReaderContext) {
        self.reader = reader
        self.context = context
    }
    
    func generate(_ ctx: Parser.ForStatementContext) -> Statement {
        guard let compoundStatement = ctx.statement()?.accept(reader.compoundVisitor()) else {
            return reader.unknown(ctx)
        }
        
        // Do a trickery here: We bloat the loop by unrolling it into a plain while
        // loop that is compatible with the original for-loop's behavior
        
        // for(<initExprs>; <condition>; <iteration>)
        let initExpr: Statement?
        let condition: Expression?
        let iteration: Statement?
        
        let expressions = ctx.expressionSequence()

        if expressions.count == 3 {
            initExpr = expressions[0].accept(reader)
            condition = expressions[1].accept(reader.expressionReader)
            iteration = expressions[2].accept(reader)
        } else if expressions.count == 2 {
            initExpr = ctx.variableDeclarationList()?.accept(reader)
            condition = expressions[0].accept(reader.expressionReader)
            iteration = expressions[1].accept(reader)
        } else {
            return reader.unknown(ctx)
        }
        
        // Try to come up with a clean for-in loop with a range
        if let initExpr = initExpr, let condition = condition, let iteration = iteration {
            let result = genSimplifiedFor(initExpr:
                initExpr,
                condition: condition,
                iteration: iteration,
                body: compoundStatement
            )
            
            if let result = result {
                return result
            }
        }
        
        return genWhileLoop(initExpr, condition, iteration, compoundStatement)
    }
    
    private func genWhileLoop(_ initExpr: Statement?,
                              _ condition: Expression?,
                              _ iteration: Statement?,
                              _ compoundStatement: CompoundStatement) -> Statement {
        
        // Come up with a while loop, now
        
        // Loop body
        let body = CompoundStatement()
        if let iteration = iteration {
            body.statements.append(.defer([iteration]))
        }
        
        body.statements.append(contentsOf: compoundStatement.statements.map { $0.copy() })
        
        let whileBody = Statement.while(condition ?? .constant(true),
                                        body: body)
        
        // Loop init (pre-loop)
        let bodyWithWhile: Statement
        if let initExpr = initExpr {
            let body = CompoundStatement()
            body.statements.append(initExpr)
            body.statements.append(whileBody)
            
            bodyWithWhile = body
        } else {
            bodyWithWhile = whileBody
        }
        
        return bodyWithWhile
    }
    
    private func genSimplifiedFor(initExpr: Statement,
                                  condition: Expression,
                                  iteration: Statement,
                                  body compoundStatement: CompoundStatement) -> Statement? {
        
        // Search for inits like 'int i = <value>'
        guard let decl = initExpr.asVariableDeclaration?.decl, decl.count == 1 else {
            return nil
        }
        let loopVar = decl[0]
        if loopVar.type != .int {
            return nil
        }
        guard let loopStart = (loopVar.initialization as? ConstantExpression)?.constant else {
            return nil
        }
        
        // Look for conditions of the form 'i < <value>'
        guard let binary = condition.asBinary else {
            return nil
        }
        
        let op = binary.op
        guard binary.lhs.asIdentifier?.identifier == loopVar.identifier else {
            return nil
        }
        
        guard op == .lessThan || op == .lessThanOrEqual else {
            return nil
        }
        
        // Look for loop iterations of the form 'i++'
        guard let exps = iteration.asExpressions?.expressions, exps.count == 1 else {
            return nil
        }
        guard exps[0].asAssignment ==
            .assignment(lhs: .identifier(loopVar.identifier), op: .addAssign, rhs: .constant(1)) else {
                return nil
        }
        
        // Check if the loop variable is not being modified within the loop's
        // body
        if ASTAnalyzer(compoundStatement).isLocalMutated(localName: loopVar.identifier) {
            return nil
        }
        
        let loopEnd: Expression
        let counter = loopCounter(in: binary.rhs)
        
        switch counter {
        case let .literal(int, type)?:
            loopEnd = .constant(.int(int, type))
            
        case .local(let local)?:
            // Check if the local is not modified within the loop's body
            if !local.storage.isConstant {
                if ASTAnalyzer(compoundStatement).isLocalMutated(localName: local.name) {
                    return nil
                }
            }
            
            loopEnd = .identifier(local.name)
            
        case let .propertyAccess(local, member)?:
            if ASTAnalyzer(compoundStatement).isLocalMutated(localName: local.name) {
                return nil
            }
            
            loopEnd = .identifier(local.name).dot(member)
            
        case nil:
            return nil
        }
        
        // All good! Simplify now.
        let rangeOp: SwiftOperator = op == .lessThan ? .openRange : .closedRange
        
        return .for(
            .identifier(loopVar.identifier),
            .binary(lhs: .constant(loopStart),
                    op: rangeOp,
                    rhs: loopEnd),
            body: compoundStatement
        )
    }
    
    func loopCounter(in expression: Expression) -> LoopCounter? {
        switch expression {
        case let constant as ConstantExpression:
            switch constant.constant {
            case let .int(value, type):
                return .literal(value, type)
            default:
                return nil
            }
            
        case let ident as IdentifierExpression:
            if let local = context.localNamed(ident.identifier) {
                return .local(local)
            }
            
        case let postfix as PostfixExpression:
            guard let identifier = postfix.exp.asIdentifier else {
                return nil
            }
            guard let member = postfix.op.asMember else {
                return nil
            }
            guard let local = context.localNamed(identifier.identifier) else {
                return nil
            }
            
            return .propertyAccess(local, property: member.name)
            
        default:
            return nil
        }
        
        return nil
    }
    
    enum LoopCounter {
        case literal(Int, Constant.IntegerType)
        case local(JavaScriptASTReaderContext.Local)
        case propertyAccess(JavaScriptASTReaderContext.Local, property: String)
    }
}

private class ASTAnalyzer {
    let node: SyntaxNode
    
    init(_ node: SyntaxNode) {
        self.node = node
    }
    
    func isLocalMutated(localName: String) -> Bool {
        var sequence: AnySequence<Expression>
        
        switch node {
        case let exp as Expression:
            sequence = expressions(in: exp, inspectBlocks: true)
            
        case let stmt as Statement:
            sequence = expressions(in: stmt, inspectBlocks: true)
            
        default:
            return false
        }
        
        return sequence.contains { exp in
            exp.asAssignment?.lhs.asIdentifier?.identifier == localName
        }
    }
}

private func expressions(in statement: Statement, inspectBlocks: Bool) -> AnySequence<Expression> {
    let sequence =
        SyntaxNodeSequence(node: statement,
                           inspectBlocks: inspectBlocks)
    
    return AnySequence(sequence.lazy.compactMap { $0 as? Expression })
}

private func expressions(in expression: Expression, inspectBlocks: Bool) -> AnySequence<Expression> {
    let sequence =
        SyntaxNodeSequence(node: expression,
                           inspectBlocks: inspectBlocks)
    
    return AnySequence(sequence.lazy.compactMap { $0 as? Expression })
}
