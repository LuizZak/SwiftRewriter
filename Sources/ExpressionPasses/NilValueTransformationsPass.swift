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
            if let postfix = exp.asPostfix {
                stmt.expressions[i] = runAnalysis(on: postfix)
            }
        }
        
        return stmt
    }
    
    func runAnalysis(on exp: PostfixExpression) -> Expression {
        guard exp.exp.resolvedType?.isOptional == true else {
            return exp
        }
        guard let fc = exp.functionCall, fc.arguments.isEmpty else {
            return exp
        }
        
        exp.op = .optionalAccess(fc)
        
        return exp
    }
}
