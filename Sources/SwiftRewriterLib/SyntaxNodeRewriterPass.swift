import SwiftAST

/// Context for an `SyntaxNodeRewriterPass` execution.
public struct SyntaxNodeRewriterPassContext {
    public static let empty =
        SyntaxNodeRewriterPassContext(typeSystem: DefaultTypeSystem())
    
    public let typeSystem: TypeSystem
    
    public init(typeSystem: TypeSystem) {
        self.typeSystem = typeSystem
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
