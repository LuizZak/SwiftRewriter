import SwiftRewriterLib
import SwiftAST

// TODO: Also support failable init detection by inspecting `nullable` in the
// return type of intializers in Objective-C.

// TODO: Add history tracking to affected initializer intentions.

/// An intention pass that searches for failable initializers based on statement
/// AST analysis and flags them appropriately.
public class FailableInitFlaggingIntentionPass: IntentionPass {
    
    let invertedMatchSelfOrSuperInit =
        ValueMatcher<PostfixExpression>()
            .inverted { inverted in
                inverted
                    .hasCount(3)
                    .atIndex(0, rule: .equals(.root(.identifier("super"))) || equals(.root(.identifier("self"))))
                    .atIndex(1, matcher: .keyPath(\.postfix?.asMember?.name, equals: "init"))
                    .atIndex(2, matcher: .isFunctionCall)
            }.anyExpression()
    
    
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
                initializer.isFailable = true
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
        
        guard let ifStatement = stmt.parent?.parent as? IfStatement else {
            return true
        }
        guard ifStatement.body.statements.count == 1 else {
            return true
        }
        guard ifStatement.body.statements[0] == stmt else {
            return true
        }
        
        if ifStatement.exp.matches(.nilCompare(against: .identifier("self"))) {
            return false
        }
        
        // 2.:
        // if(!(self = [super|self init])) {
        //     return nil;
        // }
        let negatedSelfIsSelfOrSuperInit =
            ValueMatcher<UnaryExpression>()
                .keyPath(\.op, equals: .negate)
                .keyPath(\.exp,
                         ValueMatcher<AssignmentExpression>()
                            .keyPath(\.lhs, ident("self").anyExpression())
                            .keyPath(\.op, equals: .assign)
                            .keyPath(\.rhs, invertedMatchSelfOrSuperInit)
                            .anyExpression()
                ).anyExpression()
        
        if negatedSelfIsSelfOrSuperInit.matches(ifStatement.exp) {
            return false
        }
        
        return true
    }
    
    private func superOrSelfInitExpressionFrom(exp: Expression) -> Expression? {
        
        var superInit: Expression?
        
        let selfInit =
            Expression.matcher(
                .findAny(thatMatches:
                    ident("self")
                        .assignment(
                            op: .assign,
                            rhs: invertedMatchSelfOrSuperInit ->> &superInit
                        )
                        .anyExpression()
                )
        )
        
        if selfInit.anyExpression().matches(exp) {
            return superInit
        }
        
        return nil
    }
    
}
