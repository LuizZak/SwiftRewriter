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
    
    func correctToBoolean(_ exp: Expression) -> Expression? {
        guard let type = exp.resolvedType else {
            return nil
        }
        
        // <Numeric>
        if context.typeSystem.isNumeric(type.deepUnwrapped) {
            let outer = exp.binary(op: .unequals, rhs: .constant(0))
            outer.resolvedType = .bool
            
            return outer
        }
        
        switch type {
        // <Bool?> -> <Bool?> == true
        case .optional(.bool):
            let outer = exp.binary(op: .equals, rhs: .constant(true))
            outer.resolvedType = .bool
            
            return outer
            
        // <nullable> -> <nullable> != nil
        case .optional(.typeName):
            let outer = exp.binary(op: .unequals, rhs: .constant(.nil))
            outer.resolvedType = .bool
            
            return outer
            
        default:
            return nil
        }
    }
}
