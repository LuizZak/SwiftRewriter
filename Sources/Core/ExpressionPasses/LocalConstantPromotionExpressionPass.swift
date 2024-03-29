import SwiftAST
import Analysis

/// Allows detecting local variables that are never mutated and can be marked as
/// constant `let` declarations.
public class LocalConstantPromotionExpressionPass: ASTRewriterPass {
    public override func visitVariableDeclarations(_ stmt: VariableDeclarationsStatement) -> Statement {
        let container = context.container
        
        let usage = LocalUsageAnalyzer(typeSystem: typeSystem)
        
        for (i, decl) in stmt.decl.enumerated() where !decl.isConstant && decl.ownership != .weak {
            let usages = usage.findUsagesOf(
                localNamed: decl.identifier,
                in: container,
                intention: context.source
            )
            
            // Look for read-only usages
            if usages.contains(where: { $0.usageKind.isWrite }) {
                return super.visitVariableDeclarations(stmt)
            }
            
            stmt.decl[i].isConstant = true
            
            notifyChange()
        }
        
        return stmt
    }
}
