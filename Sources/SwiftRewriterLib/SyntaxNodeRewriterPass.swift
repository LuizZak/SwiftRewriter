import SwiftAST

/// Context for an `SyntaxNodeRewriterPass` execution.
public struct ExpressionPassContext {
    public static let empty = ExpressionPassContext(knownTypes: _Source())
    
    public let knownTypes: KnownTypeSource
    
    public init(knownTypes: KnownTypeSource) {
        self.knownTypes = knownTypes
    }
    
    private struct _Source: KnownTypeSource {
        func recoverType(named name: String) -> KnownType? {
            return nil
        }
    }
}

/// A base class for expression rewriting passes.
open class SyntaxNodeRewriterPass: SyntaxNodeRewriter {
    public var context: ExpressionPassContext = .empty
}
