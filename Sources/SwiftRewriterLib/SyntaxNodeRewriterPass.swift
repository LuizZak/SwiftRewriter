import SwiftAST

/// Context for an `SyntaxNodeRewriterPass` execution.
public struct SyntaxNodeRewriterPassContext {
    public static let empty =
        SyntaxNodeRewriterPassContext(typeSystem: DefaultTypeSystem())
    
    public let typeSystem: TypeSystem
    public let typeResolver: ExpressionTypeResolver
    
    public init(typeSystem: TypeSystem) {
        self.typeSystem = typeSystem
        self.typeResolver = ExpressionTypeResolver(typeSystem: typeSystem)
    }
    
    public init(typeSystem: TypeSystem, typeResolver: ExpressionTypeResolver) {
        self.typeSystem = typeSystem
        self.typeResolver = typeResolver
    }
}

/// A base class for expression rewriting passes.
open class SyntaxNodeRewriterPass: SyntaxNodeRewriter {
    public var context: SyntaxNodeRewriterPassContext = .empty
    
    open func apply(on statement: Statement, context: SyntaxNodeRewriterPassContext) {
        self.context = context
        
        _=statement.accept(self)
    }
    
    open func apply(on expression: Expression, context: SyntaxNodeRewriterPassContext) {
        self.context = context
        
        _=expression.accept(self)
    }
}
