import SwiftAST
import Intentions
import TypeSystem

/// Context for an `ASTRewriterPass` execution.
public struct ASTRewriterPassContext {
    public static let empty =
        ASTRewriterPassContext(
            typeSystem: TypeSystem.defaultTypeSystem,
            container: .statement(
                .unknown(UnknownASTContext(context: "<invalid>"))
            )
        )
    
    public let typeSystem: TypeSystem
    public let typeResolver: ExpressionTypeResolver
    public let source: FunctionBodyCarryingIntention?
    public let container: StatementContainer
    
    /// Must be called by every `ASTRewriterPass` if it makes any sort of change
    /// to a syntax tree.
    ///
    /// Not calling this closure may result in stale syntax structure metadata,
    /// like expression types, being fed to subsequent expression passes.
    public let notifyChangedTree: () -> Void
    
    public init(
        typeSystem: TypeSystem,
        notifyChangedTree: @escaping () -> Void = { },
        source: FunctionBodyCarryingIntention? = nil,
        container: StatementContainer
    ) {
        
        self.typeSystem = typeSystem
        self.typeResolver = ExpressionTypeResolver(typeSystem: typeSystem)
        self.notifyChangedTree = notifyChangedTree
        self.source = source
        self.container = container
    }
    
    public init(
        typeSystem: TypeSystem,
        typeResolver: ExpressionTypeResolver,
        notifyChangedTree: @escaping () -> Void = { },
        source: FunctionBodyCarryingIntention? = nil,
        container: StatementContainer
    ) {
        
        self.typeSystem = typeSystem
        self.typeResolver = typeResolver
        self.notifyChangedTree = notifyChangedTree
        self.source = source
        self.container = container
    }
}
