import Antlr4
import ObjcParserAntlr

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
    
    override func enterStatement(_ ctx: ObjectiveCParser.StatementContext) {
        if !onFirstStatement {
            target.outputLineFeed()
        }
        target.outputIdentation()
        
        onFirstStatement = true
    }
    
    override func exitStatement(_ ctx: ObjectiveCParser.StatementContext) {
        target.outputLineFeed()
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
        if let messageSelector = ctx.parent?.parent as? ObjectiveCParser.MessageSelectorContext {
            if messageSelector.index(of: ctx.parent!) == 0 {
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
    }
    
    // MARK: Primitives
    override func enterIdentifier(_ ctx: ObjectiveCParser.IdentifierContext) {
        target.outputInline(ctx.getText())
    }
    
    override func enterConstant(_ ctx: ObjectiveCParser.ConstantContext) {
        target.outputInline(ctx.getText())
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
