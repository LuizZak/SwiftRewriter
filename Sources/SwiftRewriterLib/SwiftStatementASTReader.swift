import GrammarModels
import ObjcParserAntlr
import ObjcParser
import Antlr4
import SwiftAST

public class SwiftStatementASTReader: ObjectiveCParserBaseVisitor<Statement> {
    var expressionReader: SwiftExprASTReader
    
    public init(expressionReader: SwiftExprASTReader) {
        self.expressionReader = expressionReader
    }
    
    public override func visitDeclaration(_ ctx: ObjectiveCParser.DeclarationContext) -> Statement? {
        if let varDecl = ctx.varDeclaration()?.accept(self) {
            return varDecl
        }
        if let funcCall = ctx.functionCallExpression()?.accept(self) {
            return funcCall
        }
        
        return .unknown(UnknownASTContext(context: ctx.getText()))
    }
    
    public override func visitFunctionCallExpression(_ ctx: ObjectiveCParser.FunctionCallExpressionContext) -> Statement? {
        guard let ident = ctx.identifier() else {
            return .unknown(UnknownASTContext(context: ctx.getText()))
        }
        guard let directDeclarator = ctx.directDeclarator() else {
            return .unknown(UnknownASTContext(context: ctx.getText()))
        }
        
        guard let param = VarDeclarationIdentifierNameExtractor.extract(from: directDeclarator) else {
            return .unknown(UnknownASTContext(context: ctx.getText()))
        }
        
        return
            .expression(
                .postfix(.identifier(ident.getText()),
                         .functionCall(arguments: [.unlabeled(.identifier(param))]
                    ))
            )
    }
    
    public override func visitVarDeclaration(_ ctx: ObjectiveCParser.VarDeclarationContext) -> Statement? {
        return ctx.accept(VarDeclarationExtractor(expressionReader: expressionReader))
    }
    
    public override func visitStatement(_ ctx: ObjectiveCParser.StatementContext) -> Statement? {
        if let cpd = ctx.compoundStatement(), let compound = cpd.accept(compoundStatementVisitor()) {
            return compound
        }
        
        return acceptFirst(from: ctx.selectionStatement(),
                           ctx.iterationStatement(),
                           ctx.expressions(),
                           ctx.jumpStatement(),
                           ctx.synchronizedStatement(),
                           ctx.autoreleaseStatement())
            ?? .unknown(UnknownASTContext(context: ctx.getText()))
    }
    
    public override func visitExpressions(_ ctx: ObjectiveCParser.ExpressionsContext) -> Statement? {
        let expressions = ctx.expression().compactMap { $0.accept(expressionReader) }
        
        return .expressions(expressions)
    }
    
    public override func visitCompoundStatement(_ ctx: ObjectiveCParser.CompoundStatementContext) -> Statement? {
        guard let compound = ctx.accept(compoundStatementVisitor()) else {
            return .unknown(UnknownASTContext(context: ctx.getText()))
        }
        
        return compound
    }
    
    // MARK: @synchronized / @autoreleasepool
    public override func visitSynchronizedStatement(_ ctx: ObjectiveCParser.SynchronizedStatementContext) -> Statement? {
        guard let expression = ctx.expression()?.accept(expressionReader) else {
            return .unknown(UnknownASTContext(context: ctx.getText()))
        }
        guard let compoundStatement = ctx.compoundStatement()?.accept(compoundStatementVisitor()) else {
            return .unknown(UnknownASTContext(context: ctx.getText()))
        }
        
        let doBody: CompoundStatement = []
        
        // Generate an equivalent locking structure as follows:
        
        // do {
        //   let _lockTarget = <expression>
        //   objc_sync_enter(_lockTarget)
        //   defer {
        //     objc_sync_exit(_lockTarget)
        //   }
        //   <statements>
        // }
        
        let lockIdent = "_lockTarget"
        doBody.statements.append(
            .variableDeclaration(identifier: lockIdent, type: .any,
                                 ownership: .strong, isConstant: true,
                                 initialization: expression)
        )
        doBody.statements.append(
            .expression(.postfix(.identifier("objc_sync_enter"),
                                 .functionCall(arguments: [.unlabeled(.identifier(lockIdent))])))
        )
        doBody.statements.append(
            .defer([
                .expression(.postfix(.identifier("objc_sync_exit"),
                                     .functionCall(arguments: [.unlabeled(.identifier(lockIdent))])))
            ])
        )
        
        doBody.statements.append(contentsOf: compoundStatement.statements)
        
        return .do(doBody)
    }
    
    public override func visitAutoreleaseStatement(_ ctx: ObjectiveCParser.AutoreleaseStatementContext) -> Statement? {
        guard let compoundStatement = ctx.compoundStatement()?.accept(compoundStatementVisitor()) else {
            return .unknown(UnknownASTContext(context: ctx.getText()))
        }
        
        let expression: Expression =
            .postfix(.identifier("autoreleasepool"),
                     .functionCall(arguments: [
                        .unlabeled(.block(parameters: [],
                                          return: .void,
                                          body: compoundStatement))
                        ]))
        
        return .expression(expression)
    }
    
    // MARK: - return / continue / break
    public override func visitJumpStatement(_ ctx: ObjectiveCParser.JumpStatementContext) -> Statement? {
        if ctx.RETURN() != nil {
            return .return(ctx.expression()?.accept(expressionReader))
        }
        if ctx.CONTINUE() != nil {
            return .continue
        }
        if ctx.BREAK() != nil {
            return .break
        }
        
        return .unknown(UnknownASTContext(context: ctx.getText()))
    }
    
    // MARK: - if / switch
    public override func visitSelectionStatement(_ ctx: ObjectiveCParser.SelectionStatementContext) -> Statement? {
        if let expression = ctx.expression() {
            guard let expr = expression.accept(expressionReader) else {
                return .unknown(UnknownASTContext(context: ctx.getText()))
            }
            guard let body = ctx.ifBody?.accept(compoundStatementVisitor()) else {
                return .unknown(UnknownASTContext(context: ctx.getText()))
            }
            
            let elseStmt = ctx.elseBody?.accept(compoundStatementVisitor())
            
            return .if(expr, body: body, else: elseStmt)
        }
        if let switchStmt = ctx.switchStatement() {
            return visitSwitchStatement(switchStmt)
        }
        
        return .unknown(UnknownASTContext(context: ctx.getText()))
    }
    
    public override func visitSwitchStatement(_ ctx: ObjectiveCParser.SwitchStatementContext) -> Statement? {
        guard let exp = ctx.expression()?.accept(expressionReader) else {
            return .unknown(UnknownASTContext(context: ctx.getText()))
        }
        
        var cases: [SwitchCase] = []
        var def: [Statement]?
        
        if let sections = ctx.switchBlock()?.switchSection() {
            for section in sections {
                var statements = section.statement().compactMap { $0.accept(self) }
                
                if statements.count == 1, let stmt = statements[0].asCompound {
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
                                label.accept(expressionReader)
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
        
        return .switch(exp, cases: cases, default: def)
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
        
        return .unknown(UnknownASTContext(context: ctx.getText()))
    }
    
    public override func visitWhileStatement(_ ctx: ObjectiveCParser.WhileStatementContext) -> Statement? {
        guard let expr = ctx.expression()?.accept(expressionReader) else {
            return .unknown(UnknownASTContext(context: ctx.getText()))
        }
        guard let body = ctx.statement()?.accept(compoundStatementVisitor()) else {
            return .unknown(UnknownASTContext(context: ctx.getText()))
        }
        
        return .while(expr, body: body)
    }
    
    public override func visitForStatement(_ ctx: ObjectiveCParser.ForStatementContext) -> Statement? {
        guard let compoundStatement = ctx.statement()?.accept(compoundStatementVisitor()) else {
            return .unknown(UnknownASTContext(context: ctx.getText()))
        }
        
        // Do a trickery here: We bloat the loop by unrolling it into a plain while
        // loop that is compatible with the original for-loop's behavior
        
        // for(<initExprs>; <condition>; <iteration>)
        let initExpr =
            ctx.forLoopInitializer()?
                .accept(VarDeclarationExtractor(expressionReader: expressionReader))
        
        let condition = ctx.expression()?.accept(expressionReader)
        
        // for(<loop>; <condition>; <iteration>)
        let iteration = ctx.expressions()?.accept(self)
        
        // Try to come up with a clean for-in loop with a range
        simplifyFor:
        if let initExpr = initExpr, let condition = condition, let iteration = iteration {
            // Search for inits like 'int i = <value>'
            guard let decl = initExpr.asVariableDeclaration?.decl, decl.count == 1 else {
                break simplifyFor
            }
            let loopVar = decl[0]
            if loopVar.type != .int {
                break simplifyFor
            }
            guard let loopStart = (loopVar.initialization as? ConstantExpression)?.constant else {
                break simplifyFor
            }
            
            // Look for conditions of the form 'i < <value>'
            guard let binary = condition.asBinary, let loopEnd = binary.rhs.asConstant?.constant else {
                break simplifyFor
            }
            let op = binary.op
            guard binary.lhs.asIdentifier?.identifier == loopVar.identifier else {
                break simplifyFor
            }
            
            if !loopEnd.isInteger || (op != .lessThan && op != .lessThanOrEqual) {
                break simplifyFor
            }
            
            // Look for loop iterations of the form 'i++'
            guard let exps = iteration.asExpressions?.expressions, exps.count == 1 else {
                break simplifyFor
            }
            guard exps[0].asAssignment == .assignment(lhs: .identifier(loopVar.identifier), op: .addAssign, rhs: .constant(1)) else {
                break simplifyFor
            }
            
            // Check if the loop variable is not being modified within the loop's
            // body
            for exp in expressions(in: compoundStatement, inspectBlocks: true) {
                if exp.asAssignment?.lhs.asIdentifier?.identifier == loopVar.identifier {
                    break simplifyFor
                }
            }
            
            // All good! Simplify now.
            let rangeOp: SwiftOperator = op == .lessThan ? .openRange : .closedRange
            
            return .for(.identifier(loopVar.identifier),
                        .binary(lhs: .constant(loopStart),
                                op: rangeOp,
                                rhs: .constant(loopEnd)),
                        body: compoundStatement)
        }
        
        // Come up with a while loop, now
        
        // Loop body
        let body = CompoundStatement()
        if let iteration = iteration {
            body.statements.append(
                .defer([iteration]
                )
            )
        }
        
        body.statements.append(contentsOf: compoundStatement.statements)
        
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
    
    public override func visitForInStatement(_ ctx: ObjectiveCParser.ForInStatementContext) -> Statement? {
        guard let identifier = ctx.typeVariableDeclarator()?.accept(VarDeclarationIdentifierNameExtractor()) else {
            return .unknown(UnknownASTContext(context: ctx.getText()))
        }
        guard let expression = ctx.expression()?.accept(expressionReader) else {
            return .unknown(UnknownASTContext(context: ctx.getText()))
        }
        guard let body = ctx.statement()?.accept(compoundStatementVisitor()) else {
            return .unknown(UnknownASTContext(context: ctx.getText()))
        }
        
        return .for(.identifier(identifier), expression, body: body)
    }
    
    // MARK: - Helper methods
    func compoundStatementVisitor() -> CompoundStatementVisitor {
        return CompoundStatementVisitor(expressionReader: expressionReader)
    }
    
    private func expressions(in statement: Statement, inspectBlocks: Bool) -> AnySequence<Expression> {
        let sequence = SyntaxNodeSequence(statement: statement, inspectBlocks: inspectBlocks)
        
        return AnySequence(sequence.lazy.compactMap { $0 as? Expression })
    }
    
    private func acceptFirst(from rules: ParserRuleContext?...) -> Statement? {
        for rule in rules {
            if let expr = rule?.accept(self) {
                return expr
            }
        }
        
        return nil
    }
    
    // MARK: - Compound statement visitor
    class CompoundStatementVisitor: ObjectiveCParserBaseVisitor<CompoundStatement> {
        var expressionReader: SwiftExprASTReader
        
        init(expressionReader: SwiftExprASTReader) {
            self.expressionReader = expressionReader
        }
        
        override func visitStatement(_ ctx: ObjectiveCParser.StatementContext) -> CompoundStatement? {
            if let compoundStatement = ctx.compoundStatement() {
                return compoundStatement.accept(self)
            }
            
            let reader = SwiftStatementASTReader(expressionReader: expressionReader)
            reader.expressionReader = expressionReader
            
            if let stmt = reader.visitStatement(ctx) {
                return CompoundStatement(statements: [stmt])
            }
            
            return nil
        }
        
        override func visitCompoundStatement(_ ctx: ObjectiveCParser.CompoundStatementContext) -> CompoundStatement? {
            let reader = SwiftStatementASTReader(expressionReader: expressionReader)
            reader.expressionReader = expressionReader
            
            let rules: [ParserRuleContext] = ctx.children?.compactMap {
                $0 as? ParserRuleContext
            } ?? []
            
            return CompoundStatement(statements: rules.map { stmt -> Statement in
                let unknown = UnknownStatement.unknown(UnknownASTContext(context: stmt.getText()))
                
                if let stmt = stmt as? ObjectiveCParser.StatementContext {
                    return reader.visitStatement(stmt) ?? unknown
                }
                if let declaration = stmt as? ObjectiveCParser.DeclarationContext {
                    return reader.visitDeclaration(declaration) ?? unknown
                }
                
                return unknown
            }.flatMap { stmt -> [Statement] in
                // Free compound blocks cannot be declared in Swift
                if let inner = stmt.asCompound {
                    return inner.statements
                }
                
                return [stmt]
            })
        }
    }
    
    // MARK: - Variable declaration extractor visitor
    private class VarDeclarationExtractor: ObjectiveCParserBaseVisitor<Statement> {
        var expressionReader: SwiftExprASTReader
        
        init(expressionReader: SwiftExprASTReader) {
            self.expressionReader = expressionReader
        }
        
        override func visitForLoopInitializer(_ ctx: ObjectiveCParser.ForLoopInitializerContext) -> Statement? {
            guard let initDeclarators = ctx.initDeclaratorList()?.initDeclarator() else {
                return .unknown(UnknownASTContext(context: ctx.getText()))
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
                
                let expr = initDeclarator.initializer()?.expression()?.accept(expressionReader)
                
                let swiftType = expressionReader.typeMapper.swiftType(forObjcType: type)
                
                let ownership = evaluateOwnershipPrefix(inType: type)
                let isConstant = InternalSwiftWriter._isConstant(fromType: type)
                
                let declaration =
                    StatementVariableDeclaration(identifier: identifier,
                                                 type: swiftType,
                                                 ownership: ownership,
                                                 isConstant: isConstant,
                                                 initialization: expr)
                declarations.append(declaration)
            }
            
            return .variableDeclarations(declarations)
        }
        
        override func visitVarDeclaration(_ ctx: ObjectiveCParser.VarDeclarationContext) -> Statement? {
            guard let declarationSpecifiers = ctx.declarationSpecifiers() else {
                return .unknown(UnknownASTContext(context: ctx.getText()))
            }
            guard let initDeclarators = ctx.initDeclaratorList()?.initDeclarator() else {
                return .unknown(UnknownASTContext(context: ctx.getText()))
            }
            
            var declarations: [StatementVariableDeclaration] = []
            
            for initDeclarator in initDeclarators {
                guard let declarator = initDeclarator.declarator() else {
                    continue
                }
                guard let directDeclarator = initDeclarator.declarator()?.directDeclarator() else {
                    continue
                }
                guard let identifier = directDeclarator.identifier()?.getText() else {
                    continue
                }
                guard let type = expressionReader.typeParser.parseObjcType(inDeclarationSpecifiers: declarationSpecifiers,declarator: declarator) else {
                    continue
                }
                
                let expr = initDeclarator.initializer()?.expression()?.accept(expressionReader)
                
                let swiftType = expressionReader.typeMapper.swiftType(forObjcType: type)
                
                let ownership = evaluateOwnershipPrefix(inType: type)
                let isConstant = InternalSwiftWriter._isConstant(fromType: type)
                
                let declaration =
                    StatementVariableDeclaration(identifier: identifier,
                                                 type: swiftType,
                                                 ownership: ownership,
                                                 isConstant: isConstant,
                                                 initialization: expr)
                declarations.append(declaration)
            }
            
            return .variableDeclarations(declarations)
        }
    }
}
