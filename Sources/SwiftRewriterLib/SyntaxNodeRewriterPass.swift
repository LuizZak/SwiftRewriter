import SwiftAST

/// Context for an `SyntaxNodeRewriterPass` execution.
public struct ExpressionPassContext {
    public static let empty =
        ExpressionPassContext(typeSystem: DefaultTypeSystem())
    
    public let typeSystem: TypeSystem
    
    public init(typeSystem: TypeSystem) {
        self.typeSystem = typeSystem
    }
}

/// A base class for expression rewriting passes.
open class SyntaxNodeRewriterPass: SyntaxNodeRewriter {
    public var context: ExpressionPassContext = .empty
}
