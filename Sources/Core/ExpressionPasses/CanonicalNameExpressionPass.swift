import SwiftAST
import TypeSystem

/// Given a set of canonical type providers, does lookups in expression trees to
/// replace references of non-canonical names with the proper canonical ones.
///
/// Should be run as one of the first few expression passes.
public class CanonicalNameExpressionPass: ASTRewriterPass {
    
    public override func visitIdentifier(_ exp: IdentifierExpression) -> Expression {
        // Identifiers with definitions (that are not type definitions) cannot
        // be type names
        switch exp.definition {
        case nil, is TypeCodeDefinition:
            break
        default:
            return super.visitIdentifier(exp)
        }
        // Same deal for resolved type of identifiers
        switch exp.resolvedType {
        case nil, SwiftType.metatype?:
            break
        default:
            return super.visitIdentifier(exp)
        }
        
        if let canonical = typeSystem.canonicalName(forTypeName: exp.identifier) {
            notifyChange()
            
            return IdentifierExpression(identifier: canonical)
                .copyTypeAndMetadata(from: exp)
                .typed(.metatype(for: .typeName(canonical)))
        }
        
        return super.visitIdentifier(exp)
    }
    
}
