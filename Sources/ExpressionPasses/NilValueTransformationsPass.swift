import SwiftAST
import SwiftRewriterLib

/// Applies transformations to expressions that perform operations on optional
/// values.
///
/// Applies:
///
/// 1. Ensures top-level function call on optional value uses optional access.
///
///     ex:
///     ```
///     anOptionalBlock()
///     aClass.optionalMember()
///     ```
///     Becomes:
///     ```
///     anOptionalBlock?()
///     aClass.optionalMember?()
///     ```
public class NilValueTransformationsPass: SyntaxNodeRewriterPass {
    public override func visitExpressions(_ stmt: ExpressionsStatement) -> Statement {
        for (i, exp) in stmt.expressions.enumerated() {
            guard let postfix = exp.asPostfix else {
                continue
            }
            guard let transformed = runAnalysis(on: postfix) else {
                continue
            }
            
            stmt.expressions[i] = transformed
            
            notifyChange()
        }
        
        return super.visitExpressions(stmt)
    }
    
    func runAnalysis(on exp: PostfixExpression) -> Expression? {
        guard exp.exp.resolvedType?.isOptional == true else {
            return nil
        }
        guard let fc = exp.functionCall else {
            return nil
        }
        
        exp.op = .optionalAccess(fc)
        
        return exp
    }
}
