import SwiftAST
import SwiftRewriterLib

/// Analyzes non-overriden methods that have implicitly unwrapped optional returns,
/// detecting non-null return signature by looking into all return statements
/// on all exit paths and the values they return.
public class DetectNonnullReturnsIntentionPass: ClassVisitingIntentionPass {
    private let tag = "\(DetectNonnullReturnsIntentionPass.self)"
    
    var didWork = false
    
    public override init() {
        
    }
    
    public override func apply(on intentionCollection: IntentionCollection, context: IntentionPassContext) {
        repeat {
            didWork = false
            
            super.apply(on: intentionCollection, context: context)
            
            context.typeResolverInvoker.resolveAllExpressionTypes(in: intentionCollection, force: true)
        } while didWork
    }
    
    override func applyOnMethod(_ method: MethodGenerationIntention) {
        guard !method.isOverride else {
            return
        }
        guard method.returnType.isNullabilityUnspecified else {
            return
        }
        guard let body = method.functionBody else {
            return
        }
        
        // Collect all return statements
        var returns: [ReturnStatement] = []
        
        let visitor = AnonymousSyntaxNodeVisitor { node in
            if let ret = node as? ReturnStatement {
                returns.append(ret)
            }
        }
        
        visitor.visitStatement(body.body)
        
        // TODO: Be aware of polymorphism/inheritance here.
        
        // Analyze individual returns, checking if they all return the same non-null
        // type value
        for ret in returns {
            guard let retType = ret.exp?.resolvedType, !retType.isOptional else {
                return
            }
            guard retType == method.returnType.deepUnwrapped else {
                return
            }
        }
        
        // After all checks are successful, replace method's return type
        method.signature.returnType = method.returnType.deepUnwrapped
        method.history.recordChange(tag: tag, description: """
            Marking return as nonnull due to all exit paths returning non-nil values
            """)
        
        didWork = true
    }
}
