import SwiftRewriterLib

public class DefaultExpressionPasses: SyntaxNodeRewriterPassSource {
    public var syntaxNodePasses: [SyntaxNodeRewriterPass.Type] = [
        ASTSimplifier.self,
        AllocInitExpressionPass.self,
        CoreGraphicsExpressionPass.self,
        FoundationExpressionPass.self,
        UIKitExpressionPass.self,
        NilValueTransformationsPass.self,
        NumberCommonsExpressionPass.self,
        ASTCorrectorExpressionPass.self,
        EnumRewriterExpressionPass.self
    ]
    
    public init() {
        
    }
}
