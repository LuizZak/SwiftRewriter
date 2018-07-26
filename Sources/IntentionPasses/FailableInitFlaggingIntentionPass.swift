import SwiftRewriterLib
import SwiftAST

// TODO: Also support failable init detection by inspecting `nullable` in the
// return type of intializers in Objective-C.

/// An intention pass that searches for failable initializers based on statement
/// AST analysis and flags them appropriately.
public class FailableInitFlaggingIntentionPass: IntentionPass {
    var context: IntentionPassContext?
    
    public init() {
        
    }
    
    public func apply(on intentionCollection: IntentionCollection, context: IntentionPassContext) {
        self.context = context
        
        let visitor = AnonymousIntentionVisitor()
        visitor.onVisitInitializer = { ctor in
            self.analyzeInit(ctor)
        }
        
        visitor.visit(intentions: intentionCollection)
    }
    
    func analyzeInit(_ initializer: InitGenerationIntention) {
        guard let body = initializer.functionBody?.body else {
            return
        }
        
        // Search for `return nil` within the constructor which indicates this is
        // a failable initializer
        // (make sure we don't look into closures and match those by accident,
        // as well).
        
        let nodes = SyntaxNodeSequence(node: body, inspectBlocks: false)
        
        for node in nodes.compactMap({ $0 as? ReturnStatement }) {
            if node.exp?.matches(.nil) == true {
                initializer.isFailableInitializer = true
                return
            }
        }
    }
}
