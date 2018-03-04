import SwiftAST

/// Context for an `SyntaxNodeRewriterPass` execution.
public struct SyntaxNodeRewriterPassContext {
    public static let empty =
        SyntaxNodeRewriterPassContext(typeSystem: DefaultTypeSystem())
    
    public let typeSystem: TypeSystem
    public let typeResolver: ExpressionTypeResolver
    
    /// Must be called by every `SyntaxNodeRewriterPass` if it makes any sort of
    /// change to a syntax tree.
    ///
    /// Not calling this method may result in stale syntax structure metadata,
    /// like expression types, being fed to subsequent expression passes.
    public let notifyChangedTree: () -> Void
    
    public init(typeSystem: TypeSystem, notifyChangedTree: @escaping () -> Void = { }) {
        self.typeSystem = typeSystem
        self.typeResolver = ExpressionTypeResolver(typeSystem: typeSystem)
        self.notifyChangedTree = notifyChangedTree
    }
    
    public init(typeSystem: TypeSystem, typeResolver: ExpressionTypeResolver, notifyChangedTree: @escaping () -> Void = { }) {
        self.typeSystem = typeSystem
        self.typeResolver = typeResolver
        self.notifyChangedTree = notifyChangedTree
    }
}

/// A base class for expression rewriting passes.
///
/// Syntax rewriters are run on every method body found to apply transformations
/// to source code before it is output on files.
open class SyntaxNodeRewriterPass: SyntaxNodeRewriter {
    public var context: SyntaxNodeRewriterPassContext = .empty
    
    public override required init() {
        
    }
    
    open func apply(on statement: Statement, context: SyntaxNodeRewriterPassContext) -> Statement {
        self.context = context
        
        return statement.accept(self)
    }
    
    open func apply(on expression: Expression, context: SyntaxNodeRewriterPassContext) -> Expression {
        self.context = context
        
        return expression.accept(self)
    }
    
    /// Notifies the context of this syntax rewriter that the rewriter has invoked
    /// changes to the syntax tree.
    public func notifyChange() {
        context.notifyChangedTree()
    }
}
