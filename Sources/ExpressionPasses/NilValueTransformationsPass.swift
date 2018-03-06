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
    
    override public func visitPostfix(_ exp: PostfixExpression) -> Expression {
        // Member access
        guard exp.member != nil else {
            return super.visitPostfix(exp)
        }
        
        // Verify whether the member access is the access of yet another member
        // access. If so, we need to take into consideration the type of that
        // inner member, since Postfix expressions are left-associative.
        if let inner = exp.exp.asPostfix {
            if let innerMemberAccess = inner.member,
                let innerMember = innerMemberAccess.memberDefinition as? KnownProperty,
                case .optional = innerMember.storage.type {
                exp.op.hasOptionalAccess = true
                
                notifyChange()
            }
        } else {
            // Handle non-chained-postfix access cases, now.
            if case .optional? = exp.exp.resolvedType {
                exp.op.hasOptionalAccess = true
                
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
