import SwiftAST
import SwiftRewriterLib

/// Analyzes non-overriden methods that have implicitly unwrapped optional returns,
/// detecting non-null return signature by looking into all return statements
/// on all exit paths and the values they return.
public class DetectNonnullReturnsIntentionPass: ClassVisitingIntentionPass {
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
        guard method.returnType.isImplicitlyUnwrapped else {
            return
        }
        guard let body = method.functionBody else {
            return
        }
        
        // Collect all return statements
        let returns =
            SyntaxNodeSequence(node: body.body, inspectBlocks: false)
                .compactMap { $0 as? ReturnStatement }
        
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
        
        didWork = true
    }
}
