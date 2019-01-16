import Foundation
import SwiftRewriterLib
import SwiftAST
import Utils

/// Promotes local variables in method bodies to non-nil if all assignment sites
/// are detected to be non-nil as well.
public class VariableNullabilityPromotionExpressionPass: ASTRewriterPass {
    let localsAnalyzer: LocalUsageAnalyzer
    let body: FunctionBodyIntention?
    
    public required init(context: ASTRewriterPassContext) {
        self.localsAnalyzer = LocalUsageAnalyzer(typeSystem: context.typeSystem)
        body = context.functionBodyIntention
        
        super.init(context: context)
    }
    
    public override func visitVariableDeclarations(_ stmt: VariableDeclarationsStatement) -> Statement {
        let stmt = super.visitVariableDeclarations(stmt)
        
        guard let body = body else {
            return stmt
        }
        guard let varDeclStmt = stmt.asVariableDeclaration else {
            return stmt
        }
        
        for (i, decl) in varDeclStmt.decl.enumerated() {
            let usages =
                localsAnalyzer
                    .findUsagesOf(localNamed: decl.identifier, in: body)
            
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
            
            let values = collectAssignments(for: decl)
            
            var isNilSet = false
            
            for value in values {
                if value.literalExpressionKind == .nil || value.resolvedType?.isOptional == true {
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
    
    private func collectAssignments(for decl: StatementVariableDeclaration) -> [Expression] {
        guard let body = body else {
            return []
        }
        
        var assignments: [Expression] = []
        
        let usages =
            localsAnalyzer
                .findUsagesOf(localNamed: decl.identifier, in: body)
        
        if let exp = decl.initialization {
            assignments.append(exp)
        } else if !decl.isConstant && decl.type.isOptional {
            // Initializing a non-constant optional declaration results in an
            // implicit `nil` initial value
            assignments.append(Expression.constant(.nil))
        }
        
        for usage in usages where !usage.isReadOnlyUsage {
            guard let assignExp = usage.expression.parentExpression?.asAssignment else {
                continue
            }
            
            assignments.append(assignExp.rhs)
        }
        
        return assignments
    }
}
