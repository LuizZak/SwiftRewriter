import SwiftAST
import KnownType

/// Converts top-level enumeration accesses into Swift's enum syntax
/// (`<enum-type>.<enum-value>`)
public class EnumRewriterExpressionPass: ASTRewriterPass {
    var enums: [KnownType] = []
    
    public override func apply(on expression: Expression, context: ASTRewriterPassContext) -> Expression {
        enums = context.typeSystem.knownTypes(ofKind: .enum)
        
        return super.apply(on: expression, context: context)
    }
    
    public override func apply(on statement: Statement, context: ASTRewriterPassContext) -> Statement {
        enums = context.typeSystem.knownTypes(ofKind: .enum)
        
        return super.apply(on: statement, context: context)
    }
    
    public override func visitIdentifier(_ exp: IdentifierExpression) -> Expression {
        // Verify if expression is unresolved
        guard exp.definition == nil && exp.isErrorTyped else {
            return super.visitIdentifier(exp)
        }
        
        for _enum in enums {
            guard let _case = _enum.knownProperties.first(where: { $0.isStatic && $0.name == exp.identifier }) else {
                continue
            }
            
            let ident = Expression.identifier(_enum.typeName)
            ident.resolvedType = .metatype(for: .typeName(_enum.typeName))
            ident.definition = .forType(named: _enum.typeName)
            
            let result = ident.dot(_case.name)
            
            result.resolvedType = .typeName(_enum.typeName)
            result.member?.memberDefinition = _case
            
            return super.visitPostfix(result)
        }
        
        return super.visitIdentifier(exp)
    }
}
