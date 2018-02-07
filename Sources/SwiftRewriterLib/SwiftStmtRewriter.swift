import Antlr4
import ObjcParserAntlr
import ObjcParser

/// Main frontend class for performing Swift-conversion of Objective-C statements.
class SwiftStmtRewriter {
    public func rewrite(_ compound: ObjectiveCParser.CompoundStatementContext, into target: RewriterOutputTarget) {
        let listener = StmtRewriterListener(target: target)
        let walker = ParseTreeWalker()
        try? walker.walk(listener, compound)
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
    
    var onExitListeners: [ExitRuleListener] = []
    
    init(target: RewriterOutputTarget) {
        self.target = target
    }
    
    /// Adds a listener for a context rule that performs a given statements block
    /// when the given parser rule is exited.
    func onExitRule(_ rule: ParserRuleContext, do block: @escaping () -> Void) {
        onExitListeners.append(ExitRuleListener(rule: rule, onExit: block))
    }
    
    override func exitEveryRule(_ ctx: ParserRuleContext) {
        // Trigger exit listeners, removing them whenever they are successfully
        // triggered.
        onExitListeners = onExitListeners.filter { listener in
            return !listener.exitEveryRule(ctx)
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
        
        if !onFirstStatement {
            target.outputLineFeed()
        }
        target.outputIdentation()
        
        onFirstStatement = true
    }
    
    override func enterCompoundStatement(_ ctx: ObjectiveCParser.CompoundStatementContext) {
        if compoundDepth > 0 {
            target.outputInline(" {")
            target.outputLineFeed()
        }
        
        compoundDepth += 1
    }
    override func exitCompoundStatement(_ ctx: ObjectiveCParser.CompoundStatementContext) {
        compoundDepth -= 1
        
        if compoundDepth > 0 {
            //target.outputLineFeed()
            target.outputIdentation()
            target.outputInline("}")
        }
    }
    
    override func exitDeclaration(_ ctx: ObjectiveCParser.DeclarationContext) {
        target.outputLineFeed()
    }
    
    override func exitStatement(_ ctx: ObjectiveCParser.StatementContext) {
        if ctx.compoundStatement() == nil {
            target.outputLineFeed()
        }
    }
    
    override func enterVarDeclaration(_ ctx: ObjectiveCParser.VarDeclarationContext) {
        guard let initDeclarators = ctx.initDeclaratorList()?.initDeclarator() else {
            return
        }
        
        let extractor = VarDeclarationTypeExtracter()
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
                onExitRule(ident) {
                    self.target.outputInline("\(ident.getText()): \(swiftTypeString)")
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
        if let lp = ctx.LP(), let argumentExpressionList = ctx.argumentExpressionList(), let rp = ctx.RP(0) {
            target.outputInline(lp.getText())
            
            onExitRule(argumentExpressionList) {
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
    
    // MARK: Statements
    override func enterSelectionStatement(_ ctx: ObjectiveCParser.SelectionStatementContext) {
        if ctx.IF() != nil && ctx.ELSE() == nil {
            target.outputInline("if(")
            if let exp = ctx.expression() {
                onExitRule(exp) {
                    self.target.outputInline(")")
                }
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
    }
    
    // MARK: Primitives
    override func enterIdentifier(_ ctx: ObjectiveCParser.IdentifierContext) {
        // Ignore on declarations, which are handled separetely.
        if ctx.isDesendentOf(treeType: ObjectiveCParser.DeclarationContext.self) {
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
}

private class VarDeclarationTypeExtracter: ObjectiveCParserBaseVisitor<String> {
    var declaratorIndex: Int = 0
    
    override func visitVarDeclaration(_ ctx: ObjectiveCParser.VarDeclarationContext) -> String? {
        guard let initDeclarator = ctx.initDeclaratorList()?.initDeclarator(declaratorIndex) else { return nil }
        
        // Get a type string to convert into a proper type
        guard let declarationSpecifiers = ctx.declarationSpecifiers() else { return nil }
        let pointer = initDeclarator.declarator()?.pointer()
        
        let specifiersString = declarationSpecifiers.children?.map {
            $0.getText()
        }.joined(separator: " ") ?? ""
        
        let typeString = "\(specifiersString) \(pointer?.getText() ?? "")"
        
        return typeString
    }
}

private class ExitRuleListener {
    let rule: ParserRuleContext
    let onExit: () -> Void
    
    init(rule: ParserRuleContext, onExit: @escaping () -> Void) {
        self.rule = rule
        self.onExit = onExit
    }
    
    func exitEveryRule(_ ctx: ParserRuleContext) -> Bool {
        if ctx === rule {
            onExit()
            return true
        }
        
        return false
    }
}

private extension Tree {
    func isDesendentOf<T>(treeType: T.Type) -> Bool {
        guard let parent = getParent() else {
            return false
        }
        
        return parent is T || parent.isDesendentOf(treeType: T.self)
    }
    
    func indexOnParent() -> Int {
        return getParent()?.index(of: self) ?? -1
    }
    
    func index(of child: Tree) -> Int? {
        for i in 0..<getChildCount() {
            if getChild(i) === child {
                return i
            }
        }
        
        return nil
    }
}
