import SwiftAST
import Intentions
import TypeSystem

/// A base class for expression rewriting passes.
///
/// Syntax rewriters are run on every method body found to apply transformations
/// to source code before it is output on files.
open class ASTRewriterPass: SyntaxNodeRewriter {
    public var context: ASTRewriterPassContext
    public var typeSystem: TypeSystem {
        context.typeSystem
    }

    public required init(context: ASTRewriterPassContext) {
        self.context = context
    }

    open func apply(on statement: Statement, context: ASTRewriterPassContext) -> Statement {
        self.context = context

        return visitStatement(statement)
    }

    open func apply(on expression: Expression, context: ASTRewriterPassContext) -> Expression {
        self.context = context

        return visitBaseExpression(expression)
    }

    /// Visits an expression that is the outermost Expression of a SyntaxNode,
    /// before the next parent up is a Statement-, or other non-Expression- node.
    open func visitBaseExpression(_ exp: Expression) -> Expression {
        visitExpression(exp)
    }

    open override func visitSizeOf(_ exp: SizeOfExpression) -> Expression {
        switch exp.value {
        case .expression(let e):
            exp.value = .expression(visitBaseExpression(e))
        case .type:
            break
        }

        return exp
    }

    open override func visitPostfix(_ exp: PostfixExpression) -> Expression {
        if let fc = exp.op.asFunctionCall {
            exp.exp = visitExpression(exp.exp)
            exp.op = fc.replacingArguments(fc.subExpressions.map(visitBaseExpression))
            return exp
        }

        if let sub = exp.subscription {
            exp.exp = visitExpression(exp.exp)
            exp.op = sub.replacingArguments(sub.subExpressions.map(visitBaseExpression))
            return exp
        }

        return super.visitPostfix(exp)
    }

    open override func visitArray(_ exp: ArrayLiteralExpression) -> Expression {
        exp.items = exp.items.map(visitBaseExpression)

        return exp
    }

    open override func visitDictionary(_ exp: DictionaryLiteralExpression) -> Expression {
        exp.pairs = exp.pairs.map { pair in
            ExpressionDictionaryPair(
                key: visitBaseExpression(pair.key),
                value: visitBaseExpression(pair.value)
            )
        }

        return exp
    }

    open override func visitVariableDeclarations(_ stmt: VariableDeclarationsStatement) -> Statement {
        for i in 0..<stmt.decl.count {
            stmt.decl[i].initialization =
                stmt.decl[i].initialization.map(visitBaseExpression)
        }

        return stmt
    }

    open override func visitExpressions(_ stmt: ExpressionsStatement) -> Statement {
        stmt.expressions = stmt.expressions.map(visitBaseExpression)

        return stmt
    }

    open override func visitReturn(_ stmt: ReturnStatement) -> Statement {
        stmt.exp = stmt.exp.map(visitBaseExpression)
        return stmt
    }

    open override func visitConditionalClauseElement(_ clause: ConditionalClauseElement) -> ConditionalClauseElement {
        clause.pattern = clause.pattern.map(visitPattern)
        clause.expression = visitBaseExpression(clause.expression)

        return clause
    }

    open override func visitFor(_ stmt: ForStatement) -> Statement {
        stmt.pattern = visitPattern(stmt.pattern)
        stmt.exp = visitBaseExpression(stmt.exp)
        _=visitStatement(stmt.body)

        return stmt
    }

    open override func visitSwitch(_ stmt: SwitchStatement) -> Statement {
        stmt.exp = visitBaseExpression(stmt.exp)

        stmt.cases = stmt.cases.map(visitSwitchCase)
        stmt.defaultCase = stmt.defaultCase.map(visitSwitchDefaultCase)

        return stmt
    }

    open override func visitPattern(_ ptn: Pattern) -> Pattern {
        switch ptn {
        case .expression(let exp):
            return .expression(visitBaseExpression(exp))

        case .tuple(let patterns):
            return .tuple(patterns.map(visitPattern))

        case .asType(let pattern, let type):
            return .asType(visitPattern(pattern), type)

        case .valueBindingPattern(let constant, let pattern):
            return .valueBindingPattern(constant: constant, visitPattern(pattern))

        case .identifier, .wildcard:
            return ptn
        }
    }

    /// Notifies the context of this syntax rewriter that the rewriter has invoked
    /// changes to the syntax tree.
    public func notifyChange() {
        context.notifyChangedTree()
    }
}

/// A simple expression passes source that feeds from a contents array
public struct ArrayASTRewriterPassSource: ASTRewriterPassSource {
    public var syntaxNodePasses: [ASTRewriterPass.Type]

    public init(syntaxNodePasses: [ASTRewriterPass.Type]) {
        self.syntaxNodePasses = syntaxNodePasses
    }
}

/// Sources syntax rewriter passes to be used during conversion
public protocol ASTRewriterPassSource {
    /// Types of syntax node rewriters to instantiate and use during transformation.
    var syntaxNodePasses: [ASTRewriterPass.Type] { get }
}
