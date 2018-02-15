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
    
    public func rewrite(compoundStatement: ObjectiveCParser.CompoundStatementContext, into target: RewriterOutputTarget) {
        let parser = SwiftStatementASTReader()
        guard let result = compoundStatement.accept(parser) else {
            target.output(line: "// Failed to parse method.")
            return
        }
        
        let rewriter = StatementWriter(target: target, expressionPasses: expressionPasses)
        rewriter.visitStatement(result)
    }
    
    public func rewrite(expression: ObjectiveCParser.ExpressionContext, into target: RewriterOutputTarget) {
        let parser = SwiftExprASTReader()
        guard let result = expression.accept(parser) else {
            target.output(line: "// Failed to parse method.")
            return
        }
        
        let rewriter = ExpressionWriter(target: target)
        rewriter.rewrite(result, passes: expressionPasses)
    }
}

fileprivate class ExpressionWriter {
    var target: RewriterOutputTarget
    
    init(target: RewriterOutputTarget) {
        self.target = target
    }
    
    func rewrite(_ expression: Expression, passes: [ExpressionPass]) {
        let exp = passes.reduce(into: expression, { (exp, pass) in
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
            target.outputInline(member)
        
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
        target.outputInline(constant.description)
    }
    
    private func visitParens(_ exp: Expression) {
        target.outputInline("(")
        visitExpression(exp)
        target.outputInline(")")
    }
    
    private func visitIdentifier(_ identifier: String) {
        target.outputInline(identifier)
    }
    
    private func visitCast(_ exp: Expression, type: ObjcType) {
        visitExpression(exp)
        
        let context = TypeContext()
        let typeMapper = TypeMapper(context: context)
        let typeName = typeMapper.swiftType(forObjcType: type, context: .alwaysNonnull)
        
        target.outputInline(" as? \(typeName)")
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
        case let .while(exp, body):
            visitWhile(exp, body)
        case let .for(pattern, exp, body):
            visitForIn(pattern, exp, body)
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
        target.outputInline("if ")
        emitExpr(exp)
        
        visitCompound(body, lineFeedAfter: elseBody == nil)
        
        if let elseBody = elseBody {
            target.outputInline(" else")
            
            if elseBody.statements.count == 1,
                case let .if(exp, body, elseBody) = elseBody.statements[0] {
                target.outputInline(" ")
                visitIf(exp, body, elseBody: elseBody, false)
            } else {
                visitCompound(elseBody)
            }
        }
    }
    
    private func visitWhile(_ exp: Expression, _ body: CompoundStatement) {
        target.outputIdentation()
        target.outputInline("while ")
        emitExpr(exp)
        
        visitCompound(body)
    }
    
    private func visitForIn(_ pattern: Pattern, _ exp: Expression, _ body: CompoundStatement) {
        target.outputIdentation()
        target.outputInline("for ")
        target.outputInline(pattern.simplified.description)
        target.outputInline(" in ")
        emitExpr(exp)
        
        visitCompound(body)
    }
    
    private func visitDefer(_ body: CompoundStatement) {
        target.outputIdentation()
        target.outputInline("defer")
        visitCompound(body)
    }
    
    private func visitReturn(_ exp: Expression?) {
        if let exp = exp {
            target.outputIdentation()
            target.outputInline("return ")
            emitExpr(exp)
            target.outputLineFeed()
        } else {
            target.output(line: "return")
        }
    }
    
    private func visitContinue() {
        target.output(line: "continue")
    }
    
    private func visitBreak() {
        target.output(line: "break")
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
            let null = SwiftWriter._typeNullability(inType: declaration.type)
            
            let mapper = TypeMapper(context: TypeContext())
            
            let typeString =
                mapper.swiftType(forObjcType: declaration.type,
                                 context: .init(explicitNullability: null))
            
            target.outputInline(declaration.identifier)
            
            if let initial = declaration.initialization {
                target.outputInline(" = ")
                
                emitExpr(initial)
            } else {
                target.outputInline(": \(typeString)")
            }
        }
        
        if declarations.count == 0 {
            return
        }
        
        let owner = SwiftWriter._ownershipPrefix(inType: declarations[0].type)
        let varOrLet = SwiftWriter._varOrLet(fromType: declarations[0].type)
        
        target.outputIdentation()
        
        if !owner.isEmpty {
            target.outputInline(owner)
            target.outputInline(" ")
        }
        target.outputInline(varOrLet)
        target.outputInline(" ")
        
        for (i, decl) in declarations.enumerated() {
            if i > 0 {
                target.outputInline(", ")
            }
            
            emitDeclaration(decl)
        }
        
        target.outputLineFeed()
    }
    
    private func emitExpr(_ expr: Expression) {
        let rewriter = ExpressionWriter(target: target)
        rewriter.rewrite(expr, passes: expressionPasses)
    }
}

class VarDeclarationIdentifierNameExtractor: ObjectiveCParserBaseVisitor<String> {
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
