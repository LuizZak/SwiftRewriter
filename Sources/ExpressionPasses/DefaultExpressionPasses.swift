public class DefaultExpressionPasses: ASTRewriterPassSource {
    public var syntaxNodePasses: [ASTRewriterPass.Type] = [
        CanonicalNameExpressionPass.self,
        AllocInitExpressionPass.self,
        InitRewriterExpressionPass.self,
        ASTSimplifier.self,
        PropertyAsMethodAccessCorrectingExpressionPass.self,
        CompoundTypeApplierExpressionPass.self,
        CoreGraphicsExpressionPass.self,
        FoundationExpressionPass.self,
        UIKitExpressionPass.self,
        NilValueTransformationsPass.self,
        NumberCommonsExpressionPass.self,
        ASTCorrectorExpressionPass.self,
        NumberCommonsExpressionPass.self,
        EnumRewriterExpressionPass.self,
        LocalConstantPromotionExpressionPass.self,
        VariableNullabilityPromotionExpressionPass.self,
        // Do a last simplification pass after all other passes
        ASTSimplifier.self
    ]
    
    public init() {
        
    }
}
