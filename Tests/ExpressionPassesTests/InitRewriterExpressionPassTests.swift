import XCTest
import ExpressionPasses
import SwiftRewriterLib
import SwiftAST

class InitRewriterExpressionPassTests: ExpressionPassTestCase {
    override func setUp() {
        super.setUp()
        
        sut = InitRewriterExpressionPass()
    }
    
    func testEmptyIfInInit() {
        // Tests an empty common init pattern rewrite
        //
        //   self = [super init];
        //   if(self) {
        //
        //   }
        //   return self;
        //
        // is rewritten as:
        //
        //   super.init()
        //
        
        intentionContext = .initializer(InitGenerationIntention(parameters: []))
        
        assertTransform(
            statement: .compound([
                .expression(
                    Expression
                        .identifier("self")
                        .assignment(
                            op: .assign,
                            rhs: Expression
                                .identifier("super").dot("init").call())
                ),
                
                .if(.identifier("self"), body: [], else: nil),
                
                .return(.identifier("self"))
            ]),
            into: .compound([
                .expression(Expression.identifier("super").dot("init").call())
            ])
        ); assertNotifiedChange()
    }
    
    func testEarlyExitIfSuperInit() {
        // Tests an empty early-exit init pattern rewrite
        //
        //   if(!(self = [super init])) {
        //       return nil;
        //   }
        //   return self;
        //
        // is rewritten as:
        //
        //   super.init()
        //
        
        intentionContext = .initializer(InitGenerationIntention(parameters: []))
        
        assertTransform(
            statement: .compound([
                .if(Expression
                    .unary(
                        op: .negate,
                        Expression.parens(
                            Expression.identifier("self")
                                .assignment(
                                    op: .assign,
                                    rhs: Expression
                                        .identifier("super").dot("init").call()
                                )
                        )
                    ),
                    body: [
                        .return(.constant(.nil))
                    ],
                    else: nil),
                
                .return(.identifier("self"))
                ]),
            into: .compound([
                .expression(Expression.identifier("super").dot("init").call())
                ])
        ); assertNotifiedChange()
    }
}
