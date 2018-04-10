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
///
/// 2. Ensures conditional accesses on optional value member accesses
///
///    ex:
///    ```
///    anOptional.member = 0
///    ```
///    Becomes:
///    ```
///    anOptional?.member = 0
///    ```
public class NilValueTransformationsPass: ASTRewriterPass {
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
    
    override public func visitPostfix(_ exp: PostfixExpression) -> Expression {
        // Work on rooted postfix expressions only
        if let parent = exp.parent as? PostfixExpression, parent.exp === exp {
            return super.visitPostfix(exp)
        }
        
        let accesses = PostfixChainInverter.invert(expression: exp)
        
        for (i, current) in accesses.enumerated().dropLast() {
            let next = accesses[i + 1]
            
            // If from the current to the next access the result is nullable,
            // mark the current postfix access as optional.
            guard let type = current.resolvedType, let postfix = next.postfix else {
                continue
            }
            
            if type.isOptional && !type.isImplicitlyUnwrapped && postfix.hasOptionalAccess == false {
                postfix.hasOptionalAccess = true
                notifyChange()
            }
        }
        
        return super.visitPostfix(exp)
    }
    
    func runAnalysis(on exp: PostfixExpression) -> Expression? {
        guard exp.exp.resolvedType?.isOptional == true else {
            return nil
        }
        
        // Function call
        if exp.op is FunctionCallPostfix {
            exp.op.hasOptionalAccess = true
            
            return exp
        }
        
        return nil
    }
}
