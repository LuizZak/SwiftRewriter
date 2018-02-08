import Antlr4
import GrammarModels
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

private class VarDeclarationIdentifierNameExtractor: ObjectiveCParserBaseVisitor<String> {
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

private class VarDeclarationTypeExtractor: ObjectiveCParserBaseVisitor<String> {
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
    
    override func visitForLoopInitializer(_ ctx: ObjectiveCParser.ForLoopInitializerContext) -> String? {
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
    
    override func visitTypeVariableDeclarator(_ ctx: ObjectiveCParser.TypeVariableDeclaratorContext) -> String? {
        guard let declarator = ctx.declarator() else { return nil }
        
        // Get a type string to convert into a proper type
        guard let declarationSpecifiers = ctx.declarationSpecifiers() else { return nil }
        let pointer = declarator.pointer()
        
        let specifiersString = declarationSpecifiers.children?.map {
            $0.getText()
        }.joined(separator: " ") ?? ""
        
        let typeString = "\(specifiersString) \(pointer?.getText() ?? "")"
        
        return typeString
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
