import Antlr4
import GrammarModels
import ObjcParserAntlr
import ObjcParser

/// Main frontend class for performing Swift-conversion of Objective-C statements
/// and expressions.
class SwiftStmtRewriter {
    public func rewrite(compoundStatement: ObjectiveCParser.CompoundStatementContext, into target: RewriterOutputTarget) {
//        let listener = StmtRewriterListener(target: target)
//        let walker = ParseTreeWalker()
//        try? walker.walk(listener, compoundStatement)
        
        let parser = SwiftStatementASTReader()
        guard let result = compoundStatement.accept(parser) else {
            target.output(line: "// Failed to parse method.")
            return
        }
        
        let rewriter = StatementRewriter(target: target)
        rewriter.visitStatement(result)
    }
    
    public func rewrite(expression: ObjectiveCParser.ExpressionContext, into target: RewriterOutputTarget) {
//        let listener = StmtRewriterListener(target: target)
//        let walker = ParseTreeWalker()
//        try? walker.walk(listener, expression)
        
        let parser = SwiftExprASTReader()
        guard let result = expression.accept(parser) else {
            target.output(line: "// Failed to parse method.")
            return
        }
        
        let rewriter = ExpressionRewriter(target: target)
        rewriter.visitExpression(result)
    }
}

fileprivate class ExpressionRewriter {
    var target: RewriterOutputTarget
    
    init(target: RewriterOutputTarget) {
        self.target = target
    }
    
    fileprivate func visitExpression(_ expression: Expression, parens: Bool = false) {
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

fileprivate class StatementRewriter {
    var target: RewriterOutputTarget
    
    init(target: RewriterOutputTarget) {
        self.target = target
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
        target.outputInline("defer ")
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
        let rewriter = ExpressionRewriter(target: target)
        rewriter.visitExpression(expr)
    }
}

fileprivate class BaseRewriter<T> where T: ParserRuleContext {
    var target: RewriterOutputTarget
    
    init(target: RewriterOutputTarget) {
        self.target = target
    }
    
    func rewrite(_ node: T) {
        
    }
}

fileprivate class StmtRewriterListener: ObjectiveCParserBaseListener {
    var target: RewriterOutputTarget
    var onFirstStatement = true
    var compoundDepth = 0
    
    var onEnterListeners: [OnRuleListener] = []
    var onExitListeners: [OnRuleListener] = []
    
    init(target: RewriterOutputTarget) {
        self.target = target
    }
    
    /// Adds an enter rule listener for a context rule that performs a given
    /// statements block when the given parser rule is entered.
    func onEnterRule(_ rule: ParserRuleContext, do block: @escaping () -> Void) {
        onEnterListeners.append(OnRuleListener(rule: rule, onRule: block))
    }
    
    /// Adds an exit rule listener for a context rule that performs a given
    /// statements block when the given parser rule is exited.
    func onExitRule(_ rule: ParserRuleContext, do block: @escaping () -> Void) {
        onExitListeners.append(OnRuleListener(rule: rule, onRule: block))
    }
    
    override func enterEveryRule(_ ctx: ParserRuleContext) {
        // Trigger enter listeners
        for listener in onEnterListeners {
            listener.checkRule(ctx)
        }
        
        onEnterListeners = onEnterListeners.filter { listener in
            return !listener.executed
        }
    }
    
    override func exitEveryRule(_ ctx: ParserRuleContext) {
        // Trigger exit listeners
        for listener in onExitListeners.reversed() {
            listener.checkRule(ctx)
        }
        
        onExitListeners = onExitListeners.filter { listener in
            return !listener.executed
        }
    }
    
    override func enterDeclaration(_ ctx: ObjectiveCParser.DeclarationContext) {
        if !onFirstStatement {
            target.outputLineFeed()
        }
        target.outputIdentation()
        
        onFirstStatement = true
    }
    
    override func enterStatement(_ ctx: ObjectiveCParser.StatementContext) {
        if ctx.compoundStatement() != nil {
            return
        }
        
        if ctx.parent is ObjectiveCParser.CompoundStatementContext {
            onExitRule(ctx) {
                self.target.outputLineFeed()
            }
        }
        
        if let parentSelection = ctx.parent as? ObjectiveCParser.SelectionStatementContext, parentSelection.ELSE() != nil, ctx.selectionStatement()?.IF() != nil {
            return
        }
        
        if !onFirstStatement {
            if ctx.parent is ObjectiveCParser.CompoundStatementContext {
                target.outputLineFeed()
            }
        }
        target.outputIdentation()
        
        onFirstStatement = true
    }
    
    override func enterCompoundStatement(_ ctx: ObjectiveCParser.CompoundStatementContext) {
        if compoundDepth > 0 {
            target.outputInline("{")
            target.outputLineFeed()
            target.increaseIdentation()
        }
        
        compoundDepth += 1
    }
    override func exitCompoundStatement(_ ctx: ObjectiveCParser.CompoundStatementContext) {
        compoundDepth -= 1
        
        if compoundDepth > 0 {
            target.decreaseIdentation()
            target.outputIdentation()
            target.outputInline("}")
        }
    }
    
    override func exitDeclaration(_ ctx: ObjectiveCParser.DeclarationContext) {
        target.outputLineFeed()
    }
    
    override func exitStatement(_ ctx: ObjectiveCParser.StatementContext) {
        
    }
    
    override func enterVarDeclaration(_ ctx: ObjectiveCParser.VarDeclarationContext) {
        guard let initDeclarators = ctx.initDeclaratorList()?.initDeclarator() else {
            return
        }
        
        let extractor = VarDeclarationTypeExtractor()
        extractor.declaratorIndex = 0
        guard let typeString = ctx.accept(extractor) else {
            return
        }
        let parser = ObjcParser(string: typeString)
        guard let type = try? parser.parseObjcType() else {
            return
        }
        
        let typeContext = TypeContext()
        let typeMapper = TypeMapper(context: typeContext)
        
        let varOrLet = SwiftWriter._varOrLet(fromType: type)
        let arc = SwiftWriter._ownershipPrefix(inType: type)
        
        if !arc.isEmpty {
            target.outputInline("\(arc) ")
        }
        
        target.outputInline("\(varOrLet) ")
        
        for (i, initDeclarator) in initDeclarators.enumerated() {
            guard let ident = initDeclarator.declarator()?.directDeclarator()?.identifier() else {
                continue
            }
            
            extractor.declaratorIndex = i
            guard let typeString = ctx.accept(extractor) else {
                continue
            }
            
            let parser = ObjcParser(string: typeString)
            guard let type = try? parser.parseObjcType() else {
                continue
            }
            
            let swiftTypeString = typeMapper.swiftType(forObjcType: type)
            
            if let initializer = initDeclarator.initializer() {
                let omitType =
                    ctx.isDesendentOf(treeType: ObjectiveCParser.CompoundStatementContext.self)
                
                onExitRule(ident) {
                    self.target.outputInline("\(ident.getText())")
                    
                    if !omitType {
                        self.target.outputInline(": \(swiftTypeString)")
                    }
                    
                    self.target.outputInline(" = ")
                }
                
                onExitRule(initializer) {
                    // Add comma between initializers
                    if i < initDeclarators.count - 1 {
                        self.target.outputInline(", ")
                    }
                }
            } else {
                onExitRule(ident) {
                    self.target.outputInline("\(ident.getText()): \(swiftTypeString)")
                    
                    // Add comma between initializers
                    if i < initDeclarators.count - 1 {
                        self.target.outputInline(", ")
                    }
                }
            }
        }
    }
    
    override func exitReceiver(_ ctx: ObjectiveCParser.ReceiverContext) {
        // Period for method call
        target.outputInline(".")
    }
    
    override func enterKeywordArgument(_ ctx: ObjectiveCParser.KeywordArgumentContext) {
        // Second argument on, print comma before printing argument
        if ctx.indexOnParent() > 0 {
            target.outputInline(", ")
        }
    }
    
    override func exitSelector(_ ctx: ObjectiveCParser.SelectorContext) {
        if ctx.parent is ObjectiveCParser.MessageSelectorContext {
            target.outputInline("(")
        }
        if let messageSelector = ctx.parent?.parent as? ObjectiveCParser.MessageSelectorContext, let parent = ctx.parent {
            if messageSelector.index(of: parent) == 0 {
                target.outputInline("(")
            } else {
                target.outputInline(": ")
            }
        }
    }
    
    override func exitMessageExpression(_ ctx: ObjectiveCParser.MessageExpressionContext) {
        target.outputInline(")")
    }
    
    override func enterPrimaryExpression(_ ctx: ObjectiveCParser.PrimaryExpressionContext) {
        if let lp = ctx.LP(), let expression = ctx.expression(), let rp = ctx.RP() {
            target.outputInline(lp.getText())
            onExitRule(expression) {
                self.target.outputInline(rp.getText())
            }
        }
    }
    
    override func enterUnaryOperator(_ ctx: ObjectiveCParser.UnaryOperatorContext) {
        target.outputInline(ctx.getText())
    }
    
    override func enterUnaryExpression(_ ctx: ObjectiveCParser.UnaryExpressionContext) {
        if let inc = ctx.INC() {
            target.outputInline(inc.getText())
        }
        if let dec = ctx.DEC() {
            target.outputInline(dec.getText())
        }
    }
    
    override func enterPostfixExpression(_ ctx: ObjectiveCParser.PostfixExpressionContext) {
        if let postfixExpression = ctx.postfixExpression(), ctx.DOT() != nil || ctx.STRUCTACCESS() != nil {
            onExitRule(postfixExpression) {
                self.target.outputInline(".")
            }
        }
    }
    
    override func enterPostfixExpr(_ ctx: ObjectiveCParser.PostfixExprContext) {
        // Function call
        if let lp = ctx.LP(), let rp = ctx.RP(0) {
            target.outputInline(lp.getText())
            
            if let argumentExpressionList = ctx.argumentExpressionList() {
                onExitRule(argumentExpressionList) {
                    self.target.outputInline(rp.getText())
                }
            } else {
                self.target.outputInline(rp.getText())
            }
        }
        
        // Subscript
        if let lb = ctx.LBRACK(), let expression = ctx.expression(), let rb = ctx.RBRACK() {
            target.outputInline(lb.getText())
            onExitRule(expression) {
                self.target.outputInline(rb.getText())
            }
        }
        
        // Increment/decrement
        if let inc = ctx.INC() {
            target.outputInline(inc.getText())
        }
        if let dec = ctx.DEC() {
            target.outputInline(dec.getText())
        }
    }
    
    override func enterArgumentExpression(_ ctx: ObjectiveCParser.ArgumentExpressionContext) {
        // Insert comma between parameters
        if ctx.indexOnParent() > 0 {
            target.outputInline(", ")
        }
    }
    
    override func enterExpression(_ ctx: ObjectiveCParser.ExpressionContext) {
        // When entering/exiting an expression, check if it's a compounded binary expression
        binaryExp: if let parentExpression = ctx.parent as? ObjectiveCParser.ExpressionContext {
            guard let op = parentExpression.op?.getText() else {
                break binaryExp
            }
            // Binary expr
            // Print operator after expression, with spaces in between
            if parentExpression.expression().count == 2 && ctx.indexOnParent() == 0 {
                onExitRule(ctx) {
                    self.target.outputInline(" ")
                    self.target.outputInline(op + " ")
                }
            }
        }
        
        // Ternary expressions
        if ctx.QUESTION() != nil, let expression = ctx.expression(0), ctx.falseExpression != nil {
            // True ternary expression
            if let trueExpression = ctx.trueExpression {
                onExitRule(expression) {
                    self.target.outputInline(" ? ")
                }
                onExitRule(trueExpression) {
                    self.target.outputInline(" : ")
                }
            } else {
                // '?:' is a null-coallesce style operator (equivalent to '??' in Swift)
                onExitRule(expression) {
                    self.target.outputInline(" ?? ")
                }
            }
        }
        
        // Assignment expression
        if let assignmentOperator = ctx.assignmentOperator(), let unaryExpression = ctx.unaryExpression() {
            onExitRule(unaryExpression) {
                self.target.outputInline(" \(assignmentOperator.getText()) ")
            }
        }
    }
    
    override func enterCastExpression(_ ctx: ObjectiveCParser.CastExpressionContext) {
        guard let castExpression = ctx.castExpression() else {
            return
        }
        guard let typeName = ctx.typeName() else {
            return
        }
        guard let typeString = StmtRewriterListener.typeStringFromTypeContext(typeName, nullability: .nonnull) else {
            return
        }
        
        onExitRule(castExpression) {
            self.target.outputInline(" as? \(typeString)")
        }
    }
    
    override func enterArrayExpression(_ ctx: ObjectiveCParser.ArrayExpressionContext) {
        guard let expressions = ctx.expressions()?.expression() else {
            target.outputInline("[]")
            return
        }
        
        target.outputInline("[")
        
        for exp in expressions.dropLast() {
            onExitRule(exp) {
                self.target.outputInline(", ")
            }
        }
        
        if let last = expressions.last {
            onExitRule(last) {
                self.target.outputInline("]")
            }
        }
    }
    
    override func enterDictionaryExpression(_ ctx: ObjectiveCParser.DictionaryExpressionContext) {
        let pairs = ctx.dictionaryPair()
        if pairs.isEmpty {
            target.outputInline("[:]")
            return
        }
        
        target.outputInline("[")
        
        for (i, pair) in pairs.enumerated() {
            guard let key = pair.castExpression() else {
                continue
            }
            guard let value = pair.expression() else{
                continue
            }
            
            onExitRule(key) {
                self.target.outputInline(": ")
            }
            
            if i < pairs.count - 1 {
                onExitRule(value) {
                    self.target.outputInline(", ")
                }
            }
        }
        
        if let last = pairs.last {
            onExitRule(last) {
                self.target.outputInline("]")
            }
        }
    }
    
    // MARK: Statements
    override func enterSelectionStatement(_ ctx: ObjectiveCParser.SelectionStatementContext) {
        if ctx.IF() != nil {
            target.outputInline("if(")
            guard let exp = ctx.expression() else {
                return
            }
            
            onExitRule(exp) {
                self.target.outputInline(") ")
            }
            
            if ctx.ELSE() != nil, let stmt = ctx.ifBody {
                onExitRule(stmt) {
                    self.target.outputInline(" else ")
                }
            }
            
            if let stmt = ctx.ifBody {
                self.ensureBraces(around: stmt)
            }
            if let elseStmt = ctx.elseBody {
                self.ensureBraces(around: elseStmt)
            }
        }
    }
    
    override func enterWhileStatement(_ ctx: ObjectiveCParser.WhileStatementContext) {
        target.outputInline("while(")
        if let exp = ctx.expression() {
            onExitRule(exp) {
                self.target.outputInline(") ")
                
                if let stmt = ctx.statement() {
                    self.ensureBraces(around: stmt)
                }
            }
        }
    }
    
    override func enterForStatement(_ ctx: ObjectiveCParser.ForStatementContext) {
        target.outputInline("for(")
    }
    
    override func enterForInStatement(_ ctx: ObjectiveCParser.ForInStatementContext) {
        guard let typeVariable = ctx.typeVariableDeclarator() else {
            return
        }
        let extractor = VarDeclarationIdentifierNameExtractor()
        guard let name = typeVariable.accept(extractor) else {
            return
        }
        
        target.outputInline("for \(name) in ")
        
        if let expression = ctx.expression() {
            onExitRule(expression) {
                self.target.outputInline(" ")
            }
        }
    }
    
    override func enterJumpStatement(_ ctx: ObjectiveCParser.JumpStatementContext) {
        if let ret = ctx.RETURN() {
            target.outputInline(ret.getText())
            if ctx.expression() != nil {
                target.outputInline(" ")
            }
        }
        else if let cnt = ctx.CONTINUE() {
            target.outputInline(cnt.getText())
        }
        else if let brk = ctx.BREAK() {
            target.outputInline(brk.getText())
        }
    }
    
    // MARK: Primitives
    override func enterIdentifier(_ ctx: ObjectiveCParser.IdentifierContext) {
        // Ignore on declarations, which are handled separetely.
        if ctx.isDesendentOf(treeType: ObjectiveCParser.DeclarationSpecifiersContext.self) {
            return
        }
        if ctx.isDesendentOf(treeType: ObjectiveCParser.DeclaratorContext.self) {
            return
        }
        if ctx.isDesendentOf(treeType: ObjectiveCParser.TypeNameContext.self) {
            return
        }
        
        target.outputInline(ctx.getText())
    }
    
    override func enterConstant(_ ctx: ObjectiveCParser.ConstantContext) {
        if let float = ctx.FLOATING_POINT_LITERAL() {
            var floatText = float.getText()
            if floatText.hasSuffix("f") || floatText.hasSuffix("F") || floatText.hasSuffix("D") || floatText.hasSuffix("d") {
                floatText = String(floatText.dropLast())
            }
            
            target.outputInline(floatText)
        } else {
            target.outputInline(ctx.getText())
        }
    }
    
    override func exitStringLiteral(_ ctx: ObjectiveCParser.StringLiteralContext) {
        let value = ctx.STRING_VALUE().map {
            // TODO: Support conversion of hexadecimal and octal digits properly.
            // Octal literals need to be converted before being proper to use.
            $0.getText()
        }.joined()
        
        target.outputInline("\"\(value)\"")
    }
    
    static func typeFromContext(_ context: ParserRuleContext) -> ObjcType? {
        let typeExtractor = VarDeclarationTypeExtractor()
        guard let typeString = context.accept(typeExtractor) else {
            return nil
        }
        
        let parser = ObjcParser(string: typeString)
        guard let type = try? parser.parseObjcType() else {
            return nil
        }
        
        return type
    }
    
    static func typeStringFromTypeContext(_ context: ParserRuleContext, nullability: TypeNullability? = nil) -> String? {
        guard let type = typeFromContext(context) else {
            return nil
        }
        
        let typeContext = TypeContext()
        let typeMapper = TypeMapper(context: typeContext)
        let typeString = typeMapper.swiftType(forObjcType: type, context: TypeMapper.TypeMappingContext(explicitNullability: nullability))
        
        return typeString
    }
    
    static func declarationFromTypeContext(_ context: ParserRuleContext, nullability: TypeNullability? = nil) -> String? {
        guard let type = typeFromContext(context) else {
            return nil
        }
        guard let typeString = typeStringFromTypeContext(context, nullability: nullability) else {
            return nil
        }
        
        let varOrLet = SwiftWriter._varOrLet(fromType: type)
        let arc = SwiftWriter._ownershipPrefix(inType: type)
        
        let base = "\(varOrLet): \(typeString)"
        
        if arc.isEmpty {
            return base
        }
        
        return "\(arc) \(base)"
    }
}

extension StmtRewriterListener {
    /// If a given statement is not a compound statement, ensure it prints proper
    /// braces during printing.
    ///
    /// Swift requires that all statements after if, for, while, do, and switch
    /// to feature braces.
    ///
    /// If `stmt` is a case where braces are not needed, like for an already
    /// compound statement or for an `else-if` scenario, this method does nothing.
    func ensureBraces(around stmt: ObjectiveCParser.StatementContext) {
        if stmt.compoundStatement() != nil {
            return
        }
        
        if let parentSelection = stmt.parent as? ObjectiveCParser.SelectionStatementContext, parentSelection.ELSE() != nil, stmt.selectionStatement()?.IF() != nil {
            return
        }
        
        onEnterRule(stmt) {
            self.target.outputInline("{")
            self.target.outputLineFeed()
            self.target.increaseIdentation()
            self.onExitRule(stmt) {
                self.target.outputLineFeed()
                self.target.decreaseIdentation()
                self.target.outputIdentation()
                self.target.outputInline("}")
            }
        }
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

private class OnRuleListener {
    let rule: ParserRuleContext
    let onRule: () -> Void
    
    var executed: Bool = false
    
    init(rule: ParserRuleContext, onRule: @escaping () -> Void) {
        self.rule = rule
        self.onRule = onRule
    }
    
    func checkRule(_ ctx: ParserRuleContext) {
        if ctx === rule {
            onRule()
            executed = true
        }
    }
}
