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
                DefaultTypeMapper(typeSystem: context.typeSystem)
                    .typeNameString(for: exp.type)
            
            let newExp =
                Expression
                    .identifier(name)
                    .call([.unlabeled(exp.exp)])
            
            notifyChange()
            
            return super.visitPostfix(newExp)
        }
        
        return super.visitCast(exp)
    }
    
    // Converts `floorf`, `roundf`, `ceilf` to simply `floor`, `round`, `ceil`.
    public override func visitPostfix(_ exp: PostfixExpression) -> Expression {
        if let ident = exp.exp.asIdentifier?.identifier, let call = exp.functionCall {
            if call.arguments.count == 1 {
                let matchers: [String: String] = [
                    "floorf": "floor",
                    "ceilf": "ceil",
                    "roundf": "round",
                    "fabs": "abs"
                ]
                
                if let match = matchers[ident] {
                    exp.exp.asIdentifier?.identifier = match
                    call.arguments[0].expression.expectedType = .float
                    
                    notifyChange()
                }
            }
            
            if call.arguments.count == 2 {
                let matchers: [String: String] = [
                    "MAX": "max",
                    "MIN": "min"
                ]
                
                if let match = matchers[ident] {
                    exp.exp.asIdentifier?.identifier = match
                    
                    setExpectedTypesForParameters(call.subExpressions)
                    
                    notifyChange()
                }
            }
        }
        
        return super.visitPostfix(exp)
    }
    
    /// Given a set of parameters, assigns the proper expected types of the parameters
    /// based on the common resolved types of non-error-typed parameter expressions.
    private func setExpectedTypesForParameters(_ params: [Expression]) {
        var type: SwiftType?
        
        for p in params where !p.isErrorTyped {
            guard let t = type else {
                type = p.resolvedType
                continue
            }
            
            if let resolvedType = p.resolvedType, t.unwrapped != resolvedType.unwrapped {
                return
            }
        }
        
        if let type = type {
            for p in params {
                p.expectedType = type
            }
        }
    }
}
