import Foundation
import SwiftRewriterLib
import SwiftAST
import Utils

/// Promotes local variables in method bodies to non-nil if all assignment sites
/// are detected to be non-nil as well.
public class VariableNullabilityPromotionExpressionPass: ASTRewriterPass {
    let localsAnalyzer: LocalsUsageAnalyzer?
    
    public required init(context: ASTRewriterPassContext) {
        if let body = context.functionBodyIntention {
            localsAnalyzer =
                LocalUsageAnalyzer(functionBody: body,
                                   typeSystem: context.typeSystem)
        } else {
            localsAnalyzer = nil
        }
        
        super.init(context: context)
    }
    
    public override func visitVariableDeclarations(_ stmt: VariableDeclarationsStatement) -> Statement {
        let stmt = super.visitVariableDeclarations(stmt)
        
        guard let localsAnalyzer = localsAnalyzer else {
            return stmt
        }
        guard let varDeclStmt = stmt.asVariableDeclaration else {
            return stmt
        }
        
        for (i, decl) in varDeclStmt.decl.enumerated() {
            let usages = localsAnalyzer.findUsagesOf(localNamed: decl.identifier)
            
            if usages.isEmpty && decl.initialization == nil {
                continue
            }
            if decl.initialization == nil && decl.isConstant {
                continue
            }
            if decl.initialization?.isErrorTyped == true {
                continue
            }
            if let initialization = decl.initialization {
                if initialization.literalExpressionKind == .nil || initialization.resolvedType?.isOptional == true {
                    continue
                }
            }
            
            var isNilSet = false
            
            for usage in usages where !usage.isReadOnlyUsage {
                guard let assignExp = usage.expression.parentExpression?.asAssignment else {
                    continue
                }
                
                if assignExp.rhs.literalExpressionKind == .nil || assignExp.rhs.resolvedType?.isOptional == true {
                    isNilSet = true
                    break
                }
            }
            
            if !isNilSet {
                varDeclStmt.decl[i].type = varDeclStmt.decl[i].type.deepUnwrapped
                notifyChange()
            }
        }
        
        return varDeclStmt
    }
}
