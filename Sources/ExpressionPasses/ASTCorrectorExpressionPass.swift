import SwiftRewriterLib
import SwiftAST

public class ASTCorrectorExpressionPass: SyntaxNodeRewriterPass {
    public override func visitExpression(_ exp: Expression) -> Expression {
        if exp.expectedType == .bool {
            // Parenthesize depending on parent expression type to avoid issues
            // with operator precedence
            let shouldParenthesize = exp.parent is UnaryExpression || exp.parent is BinaryExpression
            
            if var corrected = correctToBoolean(exp) {
                notifyChange()
                
                corrected.expectedType = nil
                corrected.resolvedType = .bool
                
                if shouldParenthesize {
                    corrected = .parens(corrected)
                    corrected.resolvedType = .bool
                }
                
                return super.visitExpression(corrected)
            }
        }
        
        return super.visitExpression(exp)
    }
    
    public override func visitIf(_ stmt: IfStatement) -> Statement {
        return super.visitIf(stmt)
    }
    
    public override func visitWhile(_ stmt: WhileStatement) -> Statement {
        return super.visitWhile(stmt)
    }
    
    public override func visitUnary(_ exp: UnaryExpression) -> Expression {
        if exp.op.category != .logical {
            return super.visitUnary(exp)
        }

        exp.exp = super.visitExpression(exp.exp)

        if let exp = correctToBoolean(exp) {
            return .parens(exp) // Parenthesize, just to be sure
        }

        return exp
    }
    
    func correctToBoolean(_ exp: Expression) -> Expression? {
        func innerHandle(_ exp: Expression, negated: Bool) -> Expression? {
            guard let type = exp.resolvedType else {
                return nil
            }
            
            // <Numeric>
            if context.typeSystem.isNumeric(type.deepUnwrapped) {
                exp.expectedType = nil
                
                let outer = exp.binary(op: negated ? .equals : .unequals, rhs: .constant(0))
                outer.resolvedType = .bool
                
                return outer
            }
            
            switch type {
            // <Bool?> -> <Bool?> == true
            // !<Bool?> -> <Bool?> != true (negated)
            case .optional(.bool):
                exp.expectedType = nil
                
                let outer = exp.binary(op: negated ? .unequals : .equals, rhs: .constant(true))
                outer.resolvedType = .bool
                
                return outer
                
            // <nullable> -> <nullable> != nil
            // <nullable> -> <nullable> == nil (negated)
            case .optional(.typeName):
                exp.expectedType = nil
                
                let outer = exp.binary(op: negated ? .equals : .unequals, rhs: .constant(.nil))
                outer.resolvedType = .bool
                
                return outer
                
            default:
                return nil
            }
        }
        
        if exp.resolvedType == .bool {
            return nil
        }
        
        if let unary = exp.asUnary, unary.op == .negate {
            return innerHandle(unary.exp, negated: true)
        } else {
            return innerHandle(exp, negated: false)
        }
    }
}
