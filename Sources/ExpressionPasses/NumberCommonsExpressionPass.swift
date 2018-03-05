import SwiftAST
import SwiftRewriterLib

/// Fixes casting of numeric types to use associated intializers instead of performing
/// `as?` casts, and does other conversions such as usage of `floorf`/`ceilf`/etc.
/// functions on general floating-point types.
public class NumberCommonsExpressionPass: SyntaxNodeRewriterPass {
    // Converts `<number> as? Float` -> `Float(<number>)`,
    // `<number> as? CInt` -> `CInt(<number>)`, etc.
    public override func visitCast(_ exp: CastExpression) -> Expression {
        if context.typeSystem.isNumeric(exp.type) {
            let name =
                DefaultTypeMapper(context:
                    TypeConstructionContext(typeSystem: context.typeSystem)
                ).typeNameString(for: exp.type)
            
            let newExp =
                Expression
                    .identifier(name)
                    .call(arguments: [.unlabeled(exp.exp)])
            
            notifyChange()
            
            return super.visitPostfix(newExp)
        }
        
        return super.visitCast(exp)
    }
    
    // Converts `floorf`, `roundf`, `ceilf` to simply `floor`, `round`, `ceil`.
    public override func visitPostfix(_ exp: PostfixExpression) -> Expression {
        if let ident = exp.exp.asIdentifier?.identifier {
            if exp.functionCall?.arguments.count == 1 {
                let matchers: [String: String] = [
                    "floorf": "floor",
                    "ceilf": "ceil",
                    "roundf": "round",
                    "fabs": "abs"
                ]
                
                if let match = matchers[ident] {
                    exp.exp.asIdentifier?.identifier = match
                    notifyChange()
                }
            }
            
            if exp.functionCall?.arguments.count == 2 {
                let matchers: [String: String] = [
                    "MAX": "max",
                    "MIN": "min"
                ]
                
                if let match = matchers[ident] {
                    exp.exp.asIdentifier?.identifier = match
                    notifyChange()
                }
            }
        }
        
        return super.visitPostfix(exp)
    }
}
