import Antlr4
import GrammarModels
import ObjcParserAntlr
import ObjcParser

/// Main frontend class for performing Swift-conversion of Objective-C statements
/// and expressions.
class SwiftStmtRewriter {
    var expressionPasses: [ExpressionPass] = []
    
    public init(expressionPasses: [ExpressionPass]) {
        self.expressionPasses = expressionPasses
    }
    
    public func parseStatements(compoundStatement: ObjectiveCParser.CompoundStatementContext) -> CompoundStatement {
        let parser = SwiftStatementASTReader.CompoundStatementVisitor(expressionReader: SwiftExprASTReader())
        guard let result = compoundStatement.accept(parser) else {
            return [.unknown(UnknownASTContext(context: compoundStatement))]
        }
        
        return result
    }
    
    public func parseExpression(expression: ObjectiveCParser.ExpressionContext) -> Expression {
        let parser = SwiftExprASTReader()
        guard let result = expression.accept(parser) else {
            return .unknown(UnknownASTContext(context: expression))
        }
        
        return result
    }
    
    public func rewrite(compoundStatement: CompoundStatement, into target: RewriterOutputTarget) {
        let rewriter = StatementWriter(target: target, expressionPasses: expressionPasses)
        rewriter.visitStatement(.compound(compoundStatement))
    }
    
    public func rewrite(expression: Expression, into target: RewriterOutputTarget) {
        let rewriter = ExpressionWriter(target: target, expressionPasses: expressionPasses)
        rewriter.rewrite(expression)
    }
    
    public func rewrite(compoundStatement: ObjectiveCParser.CompoundStatementContext, into target: RewriterOutputTarget) {
        let result = parseStatements(compoundStatement: compoundStatement)
        rewrite(compoundStatement: result, into: target)
    }
    
    public func rewrite(expression: ObjectiveCParser.ExpressionContext, into target: RewriterOutputTarget) {
        let result = parseExpression(expression: expression)
        rewrite(expression: result, into: target)
    }
}

fileprivate class ExpressionWriter {
    var target: RewriterOutputTarget
    var expressionPasses: [ExpressionPass]
    
    init(target: RewriterOutputTarget, expressionPasses: [ExpressionPass]) {
        self.target = target
        self.expressionPasses = expressionPasses
    }
    
    func rewrite(_ expression: Expression) {
        let exp = expressionPasses.reduce(into: expression, { (exp, pass) in
            exp = pass.applyPass(on: exp)
        })
        
        visitExpression(exp)
    }
    
    private func visitExpression(_ expression: Expression, parens: Bool = false) {
        if parens {
            target.outputInline("(")
        }
        
        switch expression {
        case let .assignment(lhs, op, rhs):
            visitAssignment(lhs: lhs, op: op, rhs: rhs)
        case let .binary(lhs, op, rhs):
            visitBinary(lhs: lhs, op: op, rhs: rhs)
        case let .unary(op, expr):
            visitUnary(op: op, expr)
        case let .prefix(op, expr):
            visitPrefix(op: op, expr)
        case let .postfix(expr, post):
            visitPostfix(expr, op: post)
        case .constant(let constant):
            visitConstant(constant)
        case let .parens(expr):
            visitParens(expr)
        case .identifier(let ident):
            visitIdentifier(ident)
        case let .cast(expr, type):
            visitCast(expr, type: type)
        case .arrayLiteral(let expressions):
            visitArray(expressions)
        case .dictionaryLiteral(let pairs):
            visitDictionary(pairs)
        case let .ternary(exp, ifTrue, ifFalse):
            visitTernary(exp, ifTrue, ifFalse)
        case let .block(parameters, returnType, body):
            visitBlock(parameters, returnType, body)
        case .unknown(let context):
            target.outputInline("/*", style: .comment)
            target.outputInline(context.description, style: .comment)
            target.outputInline("*/", style: .comment)
        }
        
        if parens {
            target.outputInline(")")
        }
    }
    
    private func visitAssignment(lhs: Expression, op: SwiftOperator, rhs: Expression) {
        visitExpression(lhs)
        
        if op.requiresSpacing {
            target.outputInline(" \(op.description) ")
        } else {
            target.outputInline("\(op.description)")
        }
        
        visitExpression(rhs)
    }
    
    private func visitBinary(lhs: Expression, op: SwiftOperator, rhs: Expression) {
        visitExpression(lhs)
        
        if op.requiresSpacing {
            target.outputInline(" \(op.description) ")
        } else {
            target.outputInline("\(op.description)")
        }
        
        visitExpression(rhs)
    }
    
    private func visitUnary(op: SwiftOperator, _ exp: Expression) {
        target.outputInline(op.description)
        visitExpression(exp, parens: exp.requiresParens)
    }
    
    private func visitPrefix(op: SwiftOperator, _ exp: Expression) {
        target.outputInline(op.description)
        visitExpression(exp, parens: exp.requiresParens)
    }
    
    private func visitPostfix(_ exp: Expression, op: Postfix) {
        visitExpression(exp, parens: exp.requiresParens)
        
        switch op {
        case .member(let member):
            target.outputInline(".")
            target.outputInline(member, style: .memberName)
        
        case .optionalAccess:
            target.outputInline("?")
        
        case .subscript(let exp):
            target.outputInline("[")
            visitExpression(exp)
            target.outputInline("]")
            
        case .functionCall(let arguments):
            target.outputInline("(")
            
            commaSeparated(arguments) { arg in
                switch arg {
                case let .labeled(lbl, expr):
                    target.outputInline(lbl)
                    target.outputInline(": ")
                    visitExpression(expr)
                case let .unlabeled(expr):
                    visitExpression(expr)
                }
            }
            
            target.outputInline(")")
        }
    }
    
    private func visitConstant(_ constant: Constant) {
        switch constant {
        case .binary, .hexadecimal, .int, .octal, .float:
            target.outputInline(constant.description, style: .numberLiteral)
            
        case .nil:
            target.outputInline(constant.description, style: .keyword)
            
        case .string:
            target.outputInline(constant.description, style: .stringLiteral)
            
        default:
            target.outputInline(constant.description)
        }
    }
    
    private func visitParens(_ exp: Expression) {
        target.outputInline("(")
        visitExpression(exp)
        target.outputInline(")")
    }
    
    private func visitIdentifier(_ identifier: String) {
        if identifier == "self" || identifier == "super" {
            target.outputInline(identifier, style: .keyword)
        } else {
            target.outputInline(identifier)
        }
    }
    
    private func visitCast(_ exp: Expression, type: SwiftType) {
        visitExpression(exp)
        
        let context = TypeContext()
        let typeMapper = TypeMapper(context: context)
        let typeName = typeMapper.typeNameString(for: type)
        
        target.outputInline(" ")
        target.outputInline("as?", style: .keyword)
        target.outputInline(" ")
        target.outputInline("\(typeName)", style: .typeName)
    }
    
    private func visitArray(_ array: [Expression]) {
        target.outputInline("[")
        
        commaSeparated(array) { exp in
            visitExpression(exp)
        }
        
        target.outputInline("]")
    }
    
    private func visitDictionary(_ dictionary: [ExpressionDictionaryPair]) {
        if dictionary.count == 0 {
            target.outputInline("[:]")
            return
        }
        
        target.outputInline("[")
        
        commaSeparated(dictionary) { value in
            visitExpression(value.key)
            target.outputInline(": ")
            visitExpression(value.value)
        }
        
        target.outputInline("]")
    }
    
    private func visitTernary(_ exp: Expression, _ ifTrue: Expression, _ ifFalse: Expression) {
        visitExpression(exp)
        target.outputInline(" ? ")
        visitExpression(ifTrue)
        target.outputInline(" : ")
        visitExpression(ifFalse)
    }
    
    private func visitBlock(_ parameters: [BlockParameter], _ returnType: SwiftType, _ body: CompoundStatement) {
        let visitor = StatementWriter(target: target, expressionPasses: expressionPasses)
        let typeMapper = TypeMapper(context: TypeContext())
        
        // Print signature
        target.outputInline("{ ")
        
        target.outputInline("(")
        for (i, param) in parameters.enumerated() {
            if i > 0 {
                target.outputInline(", ")
            }
            
            target.outputInline(param.name)
            target.outputInline(": ")
            target.outputInline(typeMapper.typeNameString(for: param.type), style: .typeName)
        }
        target.outputInline(")")
        
        target.outputInline(" -> ")
        target.outputInline(typeMapper.typeNameString(for: returnType), style: .typeName)
        
        target.outputInline(" in", style: .keyword)
        
        if body.isEmpty {
            target.outputInline(" }")
            return
        }
        
        target.outputLineFeed()
        
        target.idented {
            // Print each statement now
            for statement in body.statements {
                visitor.visitStatement(statement)
            }
        }
        
        target.outputIdentation()
        target.outputInline("}")
    }
    
    private func commaSeparated<T>(_ values: [T], do block: (T) -> ()) {
        for (i, value) in values.enumerated() {
            if i > 0 {
                target.outputInline(", ")
            }
            
            block(value)
        }
    }
}

fileprivate class StatementWriter {
    var target: RewriterOutputTarget
    var expressionPasses: [ExpressionPass] = []
    
    init(target: RewriterOutputTarget, expressionPasses: [ExpressionPass]) {
        self.target = target
        self.expressionPasses = expressionPasses
    }
    
    fileprivate func visitStatement(_ statement: Statement) {
        switch statement {
        case .semicolon:
            target.output(line: ";")
        case let .compound(body):
            visitCompound(body)
        case let .if(exp, body, elseBody):
            visitIf(exp, body, elseBody: elseBody)
        case let .switch(exp, cases, def):
            visitSwitch(exp, cases, def)
        case let .while(exp, body):
            visitWhile(exp, body)
        case let .for(pattern, exp, body):
            visitForIn(pattern, exp, body)
        case let .do(body):
            visitDo(body)
        case let .defer(body):
            visitDefer(body)
        case let .return(expr):
            visitReturn(expr)
        case .break:
            visitBreak()
        case .continue:
            visitContinue()
        case let .expressions(exp):
            visitExpressions(exp)
        case .variableDeclarations(let variables):
            visitVariableDeclarations(variables)
        case .unknown(let context):
            target.output(line: "/*", style: .comment)
            target.output(line: context.description, style: .comment)
            target.output(line: "*/", style: .comment)
        }
    }
    
    private func visitCompound(_ compound: CompoundStatement, lineFeedAfter: Bool = true) {
        target.outputInline(" {")
        target.outputLineFeed()
        target.increaseIdentation()
        
        compound.statements.forEach(visitStatement)
        
        target.decreaseIdentation()
        if lineFeedAfter {
            target.output(line: "}")
        } else {
            target.outputIdentation()
            target.outputInline("}")
        }
    }
    
    private func visitIf(_ exp: Expression, _ body: CompoundStatement, elseBody: CompoundStatement?, _ withIdent: Bool = true) {
        if withIdent {
            target.outputIdentation()
        }
        target.outputInlineWithSpace("if", style: .keyword)
        emitExpr(exp)
        
        visitCompound(body, lineFeedAfter: elseBody == nil)
        
        if let elseBody = elseBody {
            target.outputInline(" else", style: .keyword)
            
            if elseBody.statements.count == 1,
                case let .if(exp, body, elseBody) = elseBody.statements[0] {
                target.outputInline(" ")
                visitIf(exp, body, elseBody: elseBody, false)
            } else {
                visitCompound(elseBody)
            }
        }
    }
    
    private func visitSwitch(_ exp: Expression, _ cases: [SwitchCase], _ def: [Statement]?) {
        target.outputIdentation()
        target.outputInlineWithSpace("switch", style: .keyword)
        emitExpr(exp)
        target.outputInline(" {")
        target.outputLineFeed()
        
        for cs in cases {
            target.outputIdentation()
            target.outputInlineWithSpace("case", style: .keyword)
            for (i, pattern) in cs.patterns.enumerated() {
                if i > 0 {
                    target.outputInline(", ")
                }
                emitPattern(pattern)
            }
            target.outputInline(":")
            target.outputLineFeed()
            
            target.idented {
                for (i, stmt) in cs.statements.enumerated() {
                    // No need to emit the last break statement
                    if i > 0 && i == cs.statements.count - 1 && stmt == .break {
                        break
                    }
                    
                    visitStatement(stmt)
                }
                
                let hasBreak = cs.statements.last == .break
                if !hasBreak {
                    target.output(line: "fallthrough", style: .keyword)
                }
            }
        }
        
        if let def = def {
            target.outputIdentation()
            target.outputInline("default", style: .keyword)
            target.outputInline(":")
            target.outputLineFeed()
            
            target.idented {
                for (i, stmt) in def.enumerated() {
                    // No need to emit the last break statement
                    if i > 0 && i == def.count - 1 && stmt == .break {
                        break
                    }
                    
                    visitStatement(stmt)
                }
            }
        }
        
        if cases.count == 0 && def == nil {
            target.outputLineFeed()
        }
        
        target.output(line: "}")
    }
    
    private func visitWhile(_ exp: Expression, _ body: CompoundStatement) {
        target.outputIdentation()
        target.outputInlineWithSpace("while", style: .keyword)
        emitExpr(exp)
        
        visitCompound(body)
    }
    
    private func visitForIn(_ pattern: Pattern, _ exp: Expression, _ body: CompoundStatement) {
        target.outputIdentation()
        target.outputInlineWithSpace("for", style: .keyword)
        emitPattern(pattern)
        target.outputInline(" in ", style: .keyword)
        emitExpr(exp)
        
        visitCompound(body)
    }
    
    private func visitDo(_ body: CompoundStatement) {
        target.outputIdentation()
        target.outputInline("do", style: .keyword)
        visitCompound(body)
    }
    
    private func visitDefer(_ body: CompoundStatement) {
        target.outputIdentation()
        target.outputInline("defer", style: .keyword)
        visitCompound(body)
    }
    
    private func visitReturn(_ exp: Expression?) {
        if let exp = exp {
            target.outputIdentation()
            target.outputInline("return ", style: .keyword)
            emitExpr(exp)
            target.outputLineFeed()
        } else {
            target.output(line: "return", style: .keyword)
        }
    }
    
    private func visitContinue() {
        target.output(line: "continue", style: .keyword)
    }
    
    private func visitBreak() {
        target.output(line: "break", style: .keyword)
    }
    
    private func visitExpressions(_ expr: [Expression]) {
        for exp in expr {
            target.outputIdentation()
            emitExpr(exp)
            target.outputLineFeed()
        }
    }
    
    private func visitVariableDeclarations(_ declarations: [StatementVariableDeclaration]) {
        func emitDeclaration(_ declaration: StatementVariableDeclaration) {
            let mapper = TypeMapper(context: TypeContext())
            
            let typeString = mapper.typeNameString(for: declaration.type)
            
            target.outputInline(declaration.identifier)
            
            if let initial = declaration.initialization {
                target.outputInline(" = ")
                
                emitExpr(initial)
            } else {
                target.outputInline(": ")
                target.outputInline(typeString, style: .typeName)
            }
        }
        
        if declarations.count == 0 {
            return
        }
        
        let ownership = declarations[0].ownership
        
        target.outputIdentation()
        
        if ownership != .strong {
            target.outputInlineWithSpace(ownership.rawValue, style: .keyword)
        }
        target.outputInlineWithSpace(declarations[0].isConstant ? "let" : "var", style: .keyword)
        
        for (i, decl) in declarations.enumerated() {
            if i > 0 {
                target.outputInline(", ")
            }
            
            emitDeclaration(decl)
        }
        
        target.outputLineFeed()
    }
    
    private func emitPattern(_ pattern: Pattern) {
        switch pattern.simplified {
        case .expression(let exp):
            emitExpr(exp)
        case .tuple(let patterns):
            target.outputInline("(")
            for (i, pattern) in patterns.enumerated() {
                if i > 0 {
                    target.outputInline(", ")
                }
                emitPattern(pattern)
            }
            target.outputInline(")")
        case .identifier(let ident):
            target.outputInline(ident)
        }
    }
    
    private func emitExpr(_ expr: Expression) {
        let rewriter = ExpressionWriter(target: target, expressionPasses: expressionPasses)
        rewriter.rewrite(expr)
    }
}

class VarDeclarationIdentifierNameExtractor: ObjectiveCParserBaseVisitor<String> {
    // MARK: Static shortcuts
    public static func extract(from ctx: ObjectiveCParser.TypeVariableDeclaratorOrNameContext) -> String? {
        return ctx.accept(VarDeclarationIdentifierNameExtractor())
    }
    public static func extract(from ctx: ObjectiveCParser.TypeDeclaratorContext) -> String? {
        return ctx.accept(VarDeclarationIdentifierNameExtractor())
    }
    public static func extract(from ctx: ObjectiveCParser.TypeVariableDeclaratorContext) -> String? {
        return ctx.accept(VarDeclarationIdentifierNameExtractor())
    }
    public static func extract(from ctx: ObjectiveCParser.DeclaratorContext) -> String? {
        return ctx.accept(VarDeclarationIdentifierNameExtractor())
    }
    public static func extract(from ctx: ObjectiveCParser.DirectDeclaratorContext) -> String? {
        return ctx.accept(VarDeclarationIdentifierNameExtractor())
    }
    public static func extract(from ctx: ObjectiveCParser.IdentifierContext) -> String? {
        return ctx.accept(VarDeclarationIdentifierNameExtractor())
    }
    
    // MARK: Members
    override func visitTypeVariableDeclaratorOrName(_ ctx: ObjectiveCParser.TypeVariableDeclaratorOrNameContext) -> String? {
        return ctx.typeVariableDeclarator()?.accept(self)
    }
    override func visitTypeDeclarator(_ ctx: ObjectiveCParser.TypeDeclaratorContext) -> String? {
        return ctx.directDeclarator()?.accept(self)
    }
    override func visitTypeVariableDeclarator(_ ctx: ObjectiveCParser.TypeVariableDeclaratorContext) -> String? {
        return ctx.declarator()?.accept(self)
    }
    override func visitDeclarator(_ ctx: ObjectiveCParser.DeclaratorContext) -> String? {
        return ctx.directDeclarator()?.accept(self)
    }
    override func visitDirectDeclarator(_ ctx: ObjectiveCParser.DirectDeclaratorContext) -> String? {
        return ctx.identifier()?.accept(self)
    }
    override func visitIdentifier(_ ctx: ObjectiveCParser.IdentifierContext) -> String? {
        return ctx.getText()
    }
}
