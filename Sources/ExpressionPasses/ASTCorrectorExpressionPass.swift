import SwiftRewriterLib
import SwiftAST

public class ASTCorrectorExpressionPass: SyntaxNodeRewriterPass {
    public override func visitIf(_ stmt: IfStatement) -> Statement {
        if let corrected = correctToBoolean(stmt.exp) {
            stmt.exp = corrected
            
            notifyChange()
        }
        
        return super.visitIf(stmt)
    }
    
    public override func visitWhile(_ stmt: WhileStatement) -> Statement {
        if let corrected = correctToBoolean(stmt.exp) {
            stmt.exp = corrected
            
            notifyChange()
        }
        
        return super.visitWhile(stmt)
    }
    
    public override func visitBinary(_ exp: BinaryExpression) -> Expression {
        if exp.op.category != .logical {
            return super.visitBinary(exp)
        }
        
        exp.lhs = exp.lhs.accept(self)
        exp.rhs = exp.rhs.accept(self)
        
        if let lhs = correctToBoolean(exp.lhs) {
            exp.lhs = .parens(lhs) // Parenthesize, just to be sure
            
            notifyChange()
        }
        
        if let rhs = correctToBoolean(exp.rhs) {
            exp.rhs = .parens(rhs) // Parenthesize, just to be sure
            
            notifyChange()
        }
        
        return exp
    }
    
    public override func visitUnary(_ exp: UnaryExpression) -> Expression {
        if exp.op.category != .logical {
            return super.visitUnary(exp)
        }
        
        exp.exp = exp.exp.accept(self)
        
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
                let outer = exp.binary(op: negated ? .equals : .unequals, rhs: .constant(0))
                outer.resolvedType = .bool
                
                return outer
            }
            
            switch type {
            // <Bool?> -> <Bool?> == true
            // !<Bool?> -> <Bool?> != true (negated)
            case .optional(.bool):
                let outer = exp.binary(op: negated ? .unequals : .equals, rhs: .constant(true))
                outer.resolvedType = .bool
                
                return outer
                
            // <nullable> -> <nullable> != nil
            // <nullable> -> <nullable> == nil (negated)
            case .optional(.typeName):
                let outer = exp.binary(op: negated ? .equals : .unequals, rhs: .constant(.nil))
                outer.resolvedType = .bool
                
                return outer
                
            default:
                return nil
            }
        }
        
        if let unary = exp.asUnary, unary.op == .negate {
            return innerHandle(unary.exp, negated: true)
        } else {
            return innerHandle(exp, negated: false)
        }
    }
}
