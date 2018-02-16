import GrammarModels
import ObjcParserAntlr
import ObjcParser
import Antlr4

public class SwiftStatementASTReader: ObjectiveCParserBaseVisitor<Statement> {
    public override func visitDeclaration(_ ctx: ObjectiveCParser.DeclarationContext) -> Statement? {
        if let varDecl = ctx.varDeclaration()?.accept(self) {
            return varDecl
        }
        
        return .unknown(UnknownASTContext(context: ctx))
    }
    
    public override func visitVarDeclaration(_ ctx: ObjectiveCParser.VarDeclarationContext) -> Statement? {
        return ctx.accept(VarDeclarationExtractor())
    }
    
    public override func visitStatement(_ ctx: ObjectiveCParser.StatementContext) -> Statement? {
        if let sel = ctx.selectionStatement()?.accept(self) {
            return sel
        }
        if let cpd = ctx.compoundStatement(), let compound = cpd.accept(CompoundStatementVisitor()) {
            return .compound(compound)
        }
        if let iterationStatement = ctx.iterationStatement() {
            return iterationStatement.accept(self)
        }
        if let expressions = ctx.expressions() {
            return expressions.accept(self)
        }
        if let jumpStatement = ctx.jumpStatement() {
            return jumpStatement.accept(self)
        }
        
        return .unknown(UnknownASTContext(context: ctx))
    }
    
    public override func visitExpressions(_ ctx: ObjectiveCParser.ExpressionsContext) -> Statement? {
        let visitor = SwiftExprASTReader()
        let expressions = ctx.expression().compactMap { $0.accept(visitor) }
        
        return .expressions(expressions)
    }
    
    public override func visitCompoundStatement(_ ctx: ObjectiveCParser.CompoundStatementContext) -> Statement? {
        guard let compound = ctx.accept(CompoundStatementVisitor()) else {
            return .unknown(UnknownASTContext(context: ctx))
        }
        
        return .compound(compound)
    }
    
    // MARK: - return / continue / break
    public override func visitJumpStatement(_ ctx: ObjectiveCParser.JumpStatementContext) -> Statement? {
        if ctx.RETURN() != nil {
            return Statement.return(ctx.expression()?.accept(SwiftExprASTReader()))
        }
        if ctx.CONTINUE() != nil {
            return Statement.continue
        }
        if ctx.BREAK() != nil {
            return Statement.break
        }
        
        return .unknown(UnknownASTContext(context: ctx))
    }
    
    // MARK: - if / switch
    public override func visitSelectionStatement(_ ctx: ObjectiveCParser.SelectionStatementContext) -> Statement? {
        if let expression = ctx.expression() {
            guard let expr = expression.accept(SwiftExprASTReader()) else {
                return .unknown(UnknownASTContext(context: ctx))
            }
            guard let body = ctx.ifBody?.accept(CompoundStatementVisitor()) else {
                return .unknown(UnknownASTContext(context: ctx))
            }
            
            let elseStmt = ctx.elseBody?.accept(CompoundStatementVisitor())
            
            return .if(expr, body: body, else: elseStmt)
        }
        if let switchStmt = ctx.switchStatement() {
            return visitSwitchStatement(switchStmt)
        }
        
        return .unknown(UnknownASTContext(context: ctx))
    }
    
    public override func visitSwitchStatement(_ ctx: ObjectiveCParser.SwitchStatementContext) -> Statement? {
        guard let exp = ctx.expression()?.accept(SwiftExprASTReader()) else {
            return .unknown(UnknownASTContext(context: ctx))
        }
        
        var cases: [SwitchCase] = []
        var def: [Statement]?
        
        if let sections = ctx.switchBlock()?.switchSection() {
            for section in sections {
                var statements = section.statement().compactMap { $0.accept(self) }
                
                if statements.count == 1, case .compound(let stmt) = statements[0] {
                    statements = stmt.statements
                }
                
                let labels = section.switchLabel()
                // Default case
                if labels.contains(where: { $0.rangeExpression() == nil }) {
                    def = statements
                } else {
                    let expr =
                        labels
                            .compactMap { $0.rangeExpression() }
                            .compactMap { label in
                                label.accept(SwiftExprASTReader())
                            }
                    
                    let c =
                        SwitchCase(patterns: expr.map { .expression($0) },
                                   statements: statements)
                    
                    cases.append(c)
                }
            }
        }
        
        // Always emit a default break statement, since switches in Swift must
        // be exhaustive
        if def == nil {
            def = [.break]
        }
        
        return Statement.switch(exp, cases: cases, default: def)
    }
    
    // MARK: - while / do-while / for / for-in
    public override func visitIterationStatement(_ ctx: ObjectiveCParser.IterationStatementContext) -> Statement? {
        if let w = ctx.whileStatement()?.accept(self) {
            return w
        }
        if let f = ctx.forStatement()?.accept(self) {
            return f
        }
        if let forIn = ctx.forInStatement()?.accept(self) {
            return forIn
        }
        
        return .unknown(UnknownASTContext(context: ctx))
    }
    
    public override func visitWhileStatement(_ ctx: ObjectiveCParser.WhileStatementContext) -> Statement? {
        guard let expr = ctx.expression()?.accept(SwiftExprASTReader()) else {
            return .unknown(UnknownASTContext(context: ctx))
        }
        guard let body = ctx.statement()?.accept(CompoundStatementVisitor()) else {
            return .unknown(UnknownASTContext(context: ctx))
        }
        
        return .while(expr, body: body)
    }
    
    public override func visitForStatement(_ ctx: ObjectiveCParser.ForStatementContext) -> Statement? {
        guard let compoundStatement = ctx.statement()?.accept(CompoundStatementVisitor()) else {
            return .unknown(UnknownASTContext(context: ctx))
        }
        
        // Do a trickery here: We bloat the loop by unrolling it into a plain while
        // loop that is compatible with the original for-loop's behavior
        
        // for(<initExprs>; <condition>; <iteration>)
        let initExpr = ctx.forLoopInitializer()?.accept(VarDeclarationExtractor())
        
        let condition = ctx.expression()?.accept(SwiftExprASTReader()) ?? .constant(true)
        
        // for(<loop>; <condition>; <iteration>)
        let iteration = ctx.expressions()?.accept(self)
        
        // Come up with a while loop, now
        
        // Loop body
        var body = CompoundStatement()
        if let iteration = iteration {
            body.statements.append(
                .defer([
                    iteration
                    ]
                )
            )
        }
        
        body.statements.append(contentsOf: compoundStatement.statements)
        
        let whileBody = Statement.while(condition, body: body)
        
        // Loop init (pre-loop)
        let bodyWithWhile: Statement
        if let initExpr = initExpr {
            var body = CompoundStatement()
            body.statements.append(initExpr)
            body.statements.append(whileBody)
            
            bodyWithWhile = .compound(body)
        } else {
            bodyWithWhile = whileBody
        }
        
        return bodyWithWhile
    }
    
    public override func visitForInStatement(_ ctx: ObjectiveCParser.ForInStatementContext) -> Statement? {
        guard let identifier = ctx.typeVariableDeclarator()?.accept(VarDeclarationIdentifierNameExtractor()) else {
            return .unknown(UnknownASTContext(context: ctx))
        }
        guard let expression = ctx.expression()?.accept(SwiftExprASTReader()) else {
            return .unknown(UnknownASTContext(context: ctx))
        }
        guard let body = ctx.statement()?.accept(CompoundStatementVisitor()) else {
            return .unknown(UnknownASTContext(context: ctx))
        }
        
        return Statement.for(.identifier(identifier), expression, body: body)
    }
    
    // MARK: Compound statement visitor
    class CompoundStatementVisitor: ObjectiveCParserBaseVisitor<CompoundStatement> {
        override func visitStatement(_ ctx: ObjectiveCParser.StatementContext) -> CompoundStatement? {
            if let compoundStatement = ctx.compoundStatement() {
                return compoundStatement.accept(self)
            }
            
            let reader = SwiftStatementASTReader()
            
            if let stmt = reader.visitStatement(ctx) {
                return CompoundStatement(statements: [stmt])
            }
            
            return nil
        }
        
        override func visitCompoundStatement(_ ctx: ObjectiveCParser.CompoundStatementContext) -> CompoundStatement? {
            let reader = SwiftStatementASTReader()
            
            let rules: [ParserRuleContext] =
                ctx.declaration().map { $0 } + ctx.statement().map { $0 }
            
            return CompoundStatement(statements: rules.compactMap { stmt -> Statement? in
                if let stmt = stmt as? ObjectiveCParser.StatementContext {
                    return reader.visitStatement(stmt)
                }
                if let declaration = stmt as? ObjectiveCParser.DeclarationContext {
                    return reader.visitDeclaration(declaration)
                }
                return .unknown(UnknownASTContext(context: stmt))
            }.flatMap { stmt -> [Statement] in
                // Free compound blocks cannot be declared in Swift
                if case .compound(let inner) = stmt {
                    return inner.statements
                }
                
                return [stmt]
            })
        }
    }
    
    private class VarDeclarationExtractor: ObjectiveCParserBaseVisitor<Statement> {
        override func visitForLoopInitializer(_ ctx: ObjectiveCParser.ForLoopInitializerContext) -> Statement? {
            guard let initDeclarators = ctx.initDeclaratorList()?.initDeclarator() else {
                return .unknown(UnknownASTContext(context: ctx))
            }
            
            let types = VarDeclarationTypeExtractor.extractAll(from: ctx)
            
            var declarations: [StatementVariableDeclaration] = []
            
            for (typeName, initDeclarator) in zip(types, initDeclarators) {
                guard let type = try? ObjcParser(string: typeName).parseObjcType() else {
                    continue
                }
                guard let directDeclarator = initDeclarator.declarator()?.directDeclarator() else {
                    continue
                }
                guard let identifier = directDeclarator.identifier()?.getText() else {
                    continue
                }
                
                let expr = initDeclarator.initializer()?.expression()?.accept(SwiftExprASTReader())
                
                let declaration = StatementVariableDeclaration(identifier: identifier, type: type, initialization: expr)
                declarations.append(declaration)
            }
            
            return Statement.variableDeclarations(declarations)
        }
        
        override func visitVarDeclaration(_ ctx: ObjectiveCParser.VarDeclarationContext) -> Statement? {
            guard let initDeclarators = ctx.initDeclaratorList()?.initDeclarator() else {
                return .unknown(UnknownASTContext(context: ctx))
            }
            
            let types = VarDeclarationTypeExtractor.extractAll(from: ctx)
            
            var declarations: [StatementVariableDeclaration] = []
            
            for (typeName, initDeclarator) in zip(types, initDeclarators) {
                guard let type = try? ObjcParser(string: typeName).parseObjcType() else {
                    continue
                }
                guard let directDeclarator = initDeclarator.declarator()?.directDeclarator() else {
                    continue
                }
                guard let identifier = directDeclarator.identifier()?.getText() else {
                    continue
                }
                
                let expr = initDeclarator.initializer()?.expression()?.accept(SwiftExprASTReader())
                
                let declaration = StatementVariableDeclaration(identifier: identifier, type: type, initialization: expr)
                declarations.append(declaration)
            }
            
            return Statement.variableDeclarations(declarations)
        }
    }
}
