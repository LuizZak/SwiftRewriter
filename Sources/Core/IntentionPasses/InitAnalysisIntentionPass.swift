import SwiftAST
import Intentions

// TODO: Also support fallible init detection by inspecting `nullable` in the
// TODO: return type of initializers in Objective-C.

/// An intention pass that searches for fallible and convenience initializers
/// based on statement AST analysis and flags them appropriately.
public class InitAnalysisIntentionPass: IntentionPass {
    private let tag = "\(InitAnalysisIntentionPass.self)"
    
    // Matches 'self.init'/'super.init' expressions, with or without parameters.
    let matchSelfOrSuperInit =
        ValueMatcher<PostfixExpression>()
            .inverted { inverted in
                inverted
                    .hasCount(3)
                    .atIndex(0, rule: .equals(.root(.identifier("super"))) || equals(.root(.identifier("self"))))
                    .atIndex(1, matcher: .keyPath(\.postfix?.asMember?.name,
                                                  .closure { $0?.hasPrefix("init") == true }))
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
        // a fallible initializer
        // (make sure we don't look into closures and match those by accident,
        // as well).
        
        let nodes = SyntaxNodeSequence(node: body, inspectBlocks: false)
        
        for node in nodes.compactMap({ $0 as? ReturnStatement }) {
            if analyzeIsReturnStatementFallible(node) {
                initializer.isFallible = true
                initializer.history.recordChange(tag: tag, description: """
                    Marked as fallible since an explicit nil return was detected \
                    within initializer body
                    """)
                
                break
            }
        }
        for node in nodes.compactMap({ $0 as? AssignmentExpression }) {
            if let target = superOrSelfInitExpressionTargetFrom(exp: node) {
                initializer.isConvenience = target == "self"
                initializer.history.recordChange(tag: tag, description: """
                    Marked as convenience since a delegated `self.init` was detected \
                    within initializer body
                    """)
            }
        }
    }
    
    private func analyzeIsReturnStatementFallible(_ stmt: ReturnStatement) -> Bool {
        guard stmt.exp?.matches(.nil) == true else {
            return false
        }
        
        // Check if we're not in one of the following patterns, which indicate
        // an early exit that is not necessarily from a fallible initializer
        
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
                            .keyPath(\.lhs, ident("self" || "super").anyExpression())
                            .keyPath(\.op, equals: .assign)
                            .keyPath(\.rhs, matchSelfOrSuperInit)
                            .anyExpression()
                ).anyExpression()
        
        if negatedSelfIsSelfOrSuperInit(matches: ifStatement.exp) {
            return false
        }
        
        return true
    }
    
    private func superOrSelfInitExpressionTargetFrom(exp: Expression) -> String? {
        
        // Looks for
        //
        // self = [super|self init<...>]
        //
        // invocations
        var selfOrSuper: Expression?
        let matchSelfOrSuper =
            Expression.matcher(
                .findAny(thatMatches:
                    ValueMatcher<PostfixExpression>()
                        .inverted { inverted in
                            inverted
                                .hasCount(3)
                                .atIndex(0, matcher:
                                    ValueMatcher()
                                        .match(if:
                                            .equals(.root(.identifier("self")))
                                                || .equals(.root(.identifier("super")))
                                        ).bind(keyPath: \.expression, to: &selfOrSuper)
                                )
                                .atIndex(1, matcher: .keyPath(\.postfix?.asMember?.name,
                                                              .closure { $0?.hasPrefix("init") == true })
                                )
                                .atIndex(2, matcher: .isFunctionCall)
                        }.anyExpression()
                    )
                )
        
        if matchSelfOrSuper(matches: exp), let selfOrSuper = selfOrSuper?.asIdentifier?.identifier {
            return selfOrSuper
        }
        
        return nil
    }
    
}
