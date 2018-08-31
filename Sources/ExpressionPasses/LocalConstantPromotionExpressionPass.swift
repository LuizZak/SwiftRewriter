import SwiftAST
import SwiftRewriterLib

/// Allows detecting local variables that are never mutated and can be marked as
/// constant `let` declarations.
public class LocalConstantPromotionExpressionPass: ASTRewriterPass {
    
    public override func visitVariableDeclarations(_ stmt: VariableDeclarationsStatement) -> Statement {
        guard let functionBody = context.functionBodyIntention else {
            return super.visitVariableDeclarations(stmt)
        }
        
        let usage = LocalUsageAnalyzer(functionBody: functionBody,
                                       typeSystem: typeSystem)
        
        for (i, decl) in stmt.decl.enumerated() where !decl.isConstant {
            let usages = usage.findUsagesOf(localNamed: decl.identifier)
            
            // Look for read-only usages
            if usages.contains(where: { !$0.isReadOnlyUsage }) {
                return super.visitVariableDeclarations(stmt)
            }
            
            stmt.decl[i].isConstant = true
        }
        
        notifyChange()
        
        return stmt
    }
    
}
