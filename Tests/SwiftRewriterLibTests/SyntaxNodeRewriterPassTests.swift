import XCTest
import SwiftRewriterLib
import SwiftAST

class ASTRewriterPassTests: XCTestCase {
    
    func testTraverseThroughPostfixFunctionArgument() {
        let exp =
            Expression
                .identifier("a")
                .call([
                    Expression.identifier("function").call()
                ])
        
        let sut = TestExpressionPass(context: .empty)
        
        let result = exp.accept(sut)
        
        XCTAssert(sut.foundNeedle)
        XCTAssertEqual(result,
                       Expression
                        .identifier("a")
                        .call([
                            Expression.identifier("function2").call()
                        ]))
    }
    
    func testTraverseThroughPostfixSubscriptArgument() {
        let exp: Expression =
            Expression
                .identifier("a")
                .sub(Expression.identifier("function").call())
        
        let sut = TestExpressionPass(context: .empty)
        let result = exp.accept(sut)
        
        XCTAssert(sut.foundNeedle)
        XCTAssertEqual(result,
                       Expression
                        .identifier("a")
                        .sub(Expression.identifier("function2").call()))
    }
    
    func testTraverseStatement() {
        let stmt: Statement = Statement.compound([.continue(), .break()])
        
        let sut = TestExpressionPass(context: .empty)
        let result = stmt.accept(sut)
        
        XCTAssert(sut.foundNeedle)
        XCTAssertEqual(result, .compound([.continue(), .continue()]))
    }
    
    func testTraverseDeepNestedBlockStatement() {
        let equivalent = """
        describe("A thing") {
            context("A context") {
                it("must do X") {
                    statement()
                }
                it("must also do Y") {
                    otherStatement()
                }
            }
            context("Another context") {
                beforeEach {
                    function()
                }
            }
        }
        """
        _=equivalent
        
        let exp =
            Expression
                .identifier("describe")
                .call([
                    .constant("A thing"),
                    .block(
                        body: [
                            .expressions([
                                Expression
                                    .identifier("context")
                                    .call([
                                        .constant("A context"),
                                        .block(
                                            body: [
                                                .expressions([
                                                    Expression
                                                        .block(
                                                            body: [
                                                                .expression(
                                                                    Expression
                                                                        .identifier("it")
                                                                        .call([
                                                                            .constant("must do X"),
                                                                            .block(
                                                                                body: [
                                                                                    .expression(
                                                                                        Expression.identifier("statement").call()
                                                                                    )
                                                                                ]
                                                                            )
                                                                        ])
                                                                )
                                                            ]),
                                                    Expression
                                                        .block(
                                                            body: [
                                                                .expression(
                                                                    Expression
                                                                        .identifier("it")
                                                                        .call([
                                                                            .constant("must also do Y"),
                                                                            .block(
                                                                                body: [
                                                                                    .expression(
                                                                                        Expression.identifier("otherStatement").call()
                                                                                    )
                                                                                ]
                                                                            )
                                                                        ])
                                                                )
                                                            ])
                                                    ]
                                                )
                                            ])
                                    ]),
                                Expression
                                    .identifier("context")
                                    .call([
                                        .constant("Another context"),
                                        .block(
                                            body: [
                                                .expression(
                                                    Expression
                                                        .block(
                                                            body: [
                                                                .expression(
                                                                    Expression
                                                                        .identifier("beforeEach")
                                                                        .call([
                                                                            .block(
                                                                                body: [
                                                                                    .expression(
                                                                                        Expression.identifier("function").call()
                                                                                    )
                                                                                ]
                                                                            )
                                                                        ])
                                                                )
                                                            ])
                                                )
                                            ])
                                        ])
                                ]
                            )
                        ])
                    ])
        
        let stmt = Statement.expression(exp)
        
        let sut = TestExpressionPass(context: .empty)
        _=stmt.accept(sut)
        
        XCTAssert(sut.foundNeedle)
    }
    
    class TestExpressionPass: ASTRewriterPass {
        var foundNeedle = false
        
        override func visitPostfix(_ exp: PostfixExpression) -> Expression {
            if exp.exp == .identifier("function") && exp.op == .functionCall(arguments: []) {
                foundNeedle = true
                
                exp.exp = .identifier("function2")
            }
            
            return super.visitPostfix(exp)
        }
        
        override func visitBreak(_ stmt: BreakStatement) -> Statement {
            foundNeedle = true
            
            return .continue()
        }
    }
}
