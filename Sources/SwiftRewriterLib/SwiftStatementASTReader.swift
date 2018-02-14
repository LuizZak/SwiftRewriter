import GrammarModels
import ObjcParserAntlr
import ObjcParser
import Antlr4

public class SwiftStatementASTReader: ObjectiveCParserBaseVisitor<Statement> {
    public override func visitDeclaration(_ ctx: ObjectiveCParser.DeclarationContext) -> Statement? {
        if let varDecl = ctx.varDeclaration()?.accept(self) {
            return varDecl
        }
        
        return nil
    }
    
    public override func visitVarDeclaration(_ ctx: ObjectiveCParser.VarDeclarationContext) -> Statement? {
        guard let stmts = ctx.accept(VarDeclarationExtractor()) else {
            return nil
        }
        
        if stmts.count == 1 {
            return stmts[0]
        }
        
        return .compound(CompoundStatement(statements: stmts))
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
        
        return nil
    }
    
    public override func visitExpressions(_ ctx: ObjectiveCParser.ExpressionsContext) -> Statement? {
        let visitor = SwiftExprASTReader()
        let expressions = ctx.expression().compactMap { $0.accept(visitor) }
        
        return .expressions(expressions)
    }
    
    public override func visitCompoundStatement(_ ctx: ObjectiveCParser.CompoundStatementContext) -> Statement? {
        guard let compound = ctx.accept(CompoundStatementVisitor()) else {
            return nil
        }
        
        return .compound(compound)
    }
    
    // MARK: - if / select
    public override func visitSelectionStatement(_ ctx: ObjectiveCParser.SelectionStatementContext) -> Statement? {
        if let expression = ctx.expression() {
            guard let expr = expression.accept(SwiftExprASTReader()) else {
                return nil
            }
            guard let body = ctx.ifBody?.accept(CompoundStatementVisitor()) else {
                return nil
            }
            
            let elseStmt = ctx.elseBody?.accept(CompoundStatementVisitor())
            
            return .if(expr, body: body, else: elseStmt)
        }
        
        return nil
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
        
        return nil
    }
    
    public override func visitWhileStatement(_ ctx: ObjectiveCParser.WhileStatementContext) -> Statement? {
        guard let expr = ctx.expression()?.accept(SwiftExprASTReader()) else {
            return nil
        }
        guard let body = ctx.statement()?.accept(CompoundStatementVisitor()) else {
            return nil
        }
        
        return .while(expr, body: body)
    }
    
    public override func visitForStatement(_ ctx: ObjectiveCParser.ForStatementContext) -> Statement? {
        guard let compoundStatement = ctx.statement()?.accept(CompoundStatementVisitor()) else {
            return nil
        }
        
        // Do a trickery here: We bloat the loop by unrolling it into a plain while
        // loop that is compatible with the original for-loop's behavior
        
        // for(<initExprs>; <condition>; <iteration>)
        let initExprs = ctx.forLoopInitializer()?.accept(VarDeclarationExtractor()) ?? []
        
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
        if initExprs.count > 0 {
            var body = CompoundStatement()
            body.statements.append(contentsOf: initExprs)
            body.statements.append(whileBody)
            
            bodyWithWhile = .compound(body)
        } else {
            bodyWithWhile = whileBody
        }
        
        return bodyWithWhile
    }
    
    public override func visitForInStatement(_ ctx: ObjectiveCParser.ForInStatementContext) -> Statement? {
        guard let identifier = ctx.typeVariableDeclarator()?.accept(VarDeclarationIdentifierNameExtractor()) else {
            return nil
        }
        guard let expression = ctx.expression()?.accept(SwiftExprASTReader()) else {
            return nil
        }
        guard let body = ctx.statement()?.accept(CompoundStatementVisitor()) else {
            return nil
        }
        
        return Statement.for(.identifier(identifier), expression, body: body)
    }
    
    // MARK: Compound statement visitor
    private class CompoundStatementVisitor: ObjectiveCParserBaseVisitor<CompoundStatement> {
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
            
            return CompoundStatement(statements: rules.compactMap { stmt in
                if let stmt = stmt as? ObjectiveCParser.StatementContext {
                    return reader.visitStatement(stmt)
                }
                if let declaration = stmt as? ObjectiveCParser.DeclarationContext {
                    return reader.visitDeclaration(declaration)
                }
                return nil
            })
        }
    }
    
    private class VarDeclarationExtractor: ObjectiveCParserBaseVisitor<[Statement]> {
        override func visitForLoopInitializer(_ ctx: ObjectiveCParser.ForLoopInitializerContext) -> [Statement]? {
            guard let initDeclarators = ctx.initDeclaratorList()?.initDeclarator() else {
                return nil
            }
            
            let types = VarDeclarationTypeExtractor.extractAll(from: ctx)
            
            var stmts: [Statement] = []
            
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
                
                stmts.append(Statement.variableDeclaration(identifier: identifier, type: type, initialization: expr))
            }
            
            return stmts
            
        }
        
        override func visitVarDeclaration(_ ctx: ObjectiveCParser.VarDeclarationContext) -> [Statement]? {
            guard let initDeclarators = ctx.initDeclaratorList()?.initDeclarator() else {
                return nil
            }
            
            let types = VarDeclarationTypeExtractor.extractAll(from: ctx)
            
            var stmts: [Statement] = []
            
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
                
                stmts.append(Statement.variableDeclaration(identifier: identifier, type: type, initialization: expr))
            }
            
            return stmts
        }
    }
}
