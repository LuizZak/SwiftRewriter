import SwiftRewriterLib
import SwiftAST

// TODO: Also support failable init detection by inspecting `nullable` in the
// return type of intializers in Objective-C.

// TODO: Add history tracking to affected initializer intentions.

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
    
    private func analyzeInit(_ initializer: InitGenerationIntention) {
        guard let body = initializer.functionBody?.body else {
            return
        }
        
        // Search for `return nil` within the constructor which indicates this is
        // a failable initializer
        // (make sure we don't look into closures and match those by accident,
        // as well).
        
        let nodes = SyntaxNodeSequence(node: body, inspectBlocks: false)
        
        for node in nodes.compactMap({ $0 as? ReturnStatement }) {
            if analyzeReturnStatement(node) {
                initializer.isFailableInitializer = true
                return
            }
        }
    }
    
    private func analyzeReturnStatement(_ stmt: ReturnStatement) -> Bool {
        guard stmt.exp?.matches(.nil) == true else {
            return false
        }
        
        // Check if we're not in one of the following patterns, which signify
        // an early exit that is not neccessarily from a failable initializer
        
        // 1.:
        // if(self == nil) {
        //     return nil;
        // }
        let ifSelfIsNil =
            Statement.matcher(
                ValueMatcher<IfStatement>()
                    .keyPath(\.exp, .nilCompare(against: .identifier("self")))
                    .keyPath(\.body.statements, hasCount(1))
                    .keyPath(\.body.statements[0], equals: stmt)
                ).anySyntaxNode()
        
        if ifSelfIsNil.matchNil().matches(stmt.parent?.parent) {
            return false
        }
        
        // 2.:
        // if(!(self = [super init])) {
        //     return nil;
        // }
        let ifSelfSuperInit =
            Statement.matcher(
                ValueMatcher<IfStatement>()
                    .keyPath(\.exp, ValueMatcher<UnaryExpression>()
                        .keyPath(\.op, equals: .negate)
                        .keyPath(\.exp,
                                 ValueMatcher<AssignmentExpression>()
                                    .keyPath(\.lhs, ident("self").anyExpression())
                                    // Being very broad here: any rhs that mentions 'super' or 'self'
                                    // at all is accepted.
                                    .keyPath(\.rhs, .findAny(thatMatches: ident("super" || "self").anyExpression()))
                                    .anyExpression()
                        ).anyExpression()
                    )
            ).anySyntaxNode()
        
        if ifSelfSuperInit.matchNil().matches(stmt.parent?.parent) {
            return false
        }
        
        return true
    }
}
