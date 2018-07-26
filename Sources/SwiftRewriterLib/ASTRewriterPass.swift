import SwiftAST

/// Context for an `ASTRewriterPass` execution.
public struct ASTRewriterPassContext {
    public static let empty =
        ASTRewriterPassContext(typeSystem: DefaultTypeSystem())
    
    public let typeSystem: TypeSystem
    public let typeResolver: ExpressionTypeResolver
    public let source: FunctionBodyCarryingIntention?
    
    /// Must be called by every `ASTRewriterPass` if it makes any sort of change
    /// to a syntax tree.
    ///
    /// Not calling this closure may result in stale syntax structure metadata,
    /// like expression types, being fed to subsequent expression passes.
    public let notifyChangedTree: () -> Void
    
    public init(typeSystem: TypeSystem,
                notifyChangedTree: @escaping () -> Void = { },
                source: FunctionBodyCarryingIntention? = nil) {
        
        self.typeSystem = typeSystem
        self.typeResolver = ExpressionTypeResolver(typeSystem: typeSystem)
        self.notifyChangedTree = notifyChangedTree
        self.source = source
    }
    
    public init(typeSystem: TypeSystem,
                typeResolver: ExpressionTypeResolver,
                notifyChangedTree: @escaping () -> Void = { },
                source: FunctionBodyCarryingIntention? = nil) {
        
        self.typeSystem = typeSystem
        self.typeResolver = typeResolver
        self.notifyChangedTree = notifyChangedTree
        self.source = source
    }
}

/// A base class for expression rewriting passes.
///
/// Syntax rewriters are run on every method body found to apply transformations
/// to source code before it is output on files.
open class ASTRewriterPass: SyntaxNodeRewriter {
    public var context: ASTRewriterPassContext = .empty
    public var typeSystem: TypeSystem {
        return context.typeSystem
    }
    
    public override required init() {
        
    }
    
    open func apply(on statement: Statement, context: ASTRewriterPassContext) -> Statement {
        self.context = context
        
        return visitStatement(statement)
    }
    
    open func apply(on expression: Expression, context: ASTRewriterPassContext) -> Expression {
        self.context = context
        
        return visitBaseExpression(expression)
    }
    
    open func visitBaseExpression(_ exp: Expression) -> Expression {
        return visitExpression(exp)
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
            exp.op = sub.replacingExpression(visitBaseExpression(sub.expression))
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
            ExpressionDictionaryPair(key: visitBaseExpression(pair.key),
                                     value: visitBaseExpression(pair.value))
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
    
    open override func visitIf(_ stmt: IfStatement) -> Statement {
        stmt.exp = visitBaseExpression(stmt.exp)
        _=visitStatement(stmt.body)
        _=stmt.elseBody.map(visitStatement)
        
        return stmt
    }
    
    open override func visitWhile(_ stmt: WhileStatement) -> Statement {
        stmt.exp = visitBaseExpression(stmt.exp)
        _=visitStatement(stmt.body)
        
        return stmt
    }
    
    open override func visitFor(_ stmt: ForStatement) -> Statement {
        stmt.pattern = visitPattern(stmt.pattern)
        stmt.exp = visitBaseExpression(stmt.exp)
        _=visitStatement(stmt.body)
        
        return stmt
    }
    
    open override func visitSwitch(_ stmt: SwitchStatement) -> Statement {
        stmt.exp = visitBaseExpression(stmt.exp)
        
        stmt.cases = stmt.cases.map {
            return SwitchCase(patterns: $0.patterns.map(visitPattern),
                              statements: $0.statements.map(visitStatement))
        }
        if let def = stmt.defaultCase {
            stmt.defaultCase = def.map(visitStatement)
        }
        
        return stmt
    }
    
    open override func visitPattern(_ ptn: Pattern) -> Pattern {
        switch ptn {
        case .expression(let exp):
            return .expression(visitBaseExpression(exp))
        case .tuple(let patterns):
            return .tuple(patterns.map(visitPattern))
        case .identifier:
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
