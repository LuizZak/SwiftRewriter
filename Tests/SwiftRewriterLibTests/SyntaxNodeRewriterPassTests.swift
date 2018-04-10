import XCTest
import SwiftRewriterLib
import SwiftAST

class ASTRewriterPassTests: XCTestCase {
    
    func testTraverseThroughPostfixFunctionArgument() {
        let exp: Expression =
            .postfix(.identifier("a"),
                     .functionCall(arguments: [
                        .unlabeled(.postfix(.identifier("function"), .functionCall(arguments: [])))
                        ]))
        
        let sut = TestExpressionPass()
        
        let result = exp.accept(sut)
        
        XCTAssert(sut.foundNeedle)
        XCTAssertEqual(result,
                       .postfix(.identifier("a"),
                                .functionCall(arguments: [
                                    .unlabeled(.postfix(.identifier("function2"), .functionCall(arguments: [])))
                                    ])))
    }
    
    func testTraverseThroughPostfixSubscriptArgument() {
        let exp: Expression =
            .postfix(.identifier("a"),
                     .subscript(.postfix(.identifier("function"), .functionCall(arguments: []))))
        
        let sut = TestExpressionPass()
        let result = exp.accept(sut)
        
        XCTAssert(sut.foundNeedle)
        XCTAssertEqual(result,
                       .postfix(.identifier("a"),
                                .subscript(.postfix(.identifier("function2"), .functionCall(arguments: [])))))
    }
    
    func testTraverseStatement() {
        let stmt: Statement = Statement.compound([.continue, .break])
        
        let sut = TestExpressionPass()
        let result = stmt.accept(sut)
        
        XCTAssert(sut.foundNeedle)
        XCTAssertEqual(result, .compound([.continue, .continue]))
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
        
        let stmt: Statement =
            .compound([
                .expression(
                    .postfix(
                        .identifier("describe"),
                        .functionCall(arguments: [
                            .unlabeled(.constant("A thing")),
                            .unlabeled(
                                .block(parameters: [],
                                       return: .void,
                                       body: [
                                        .expression(
                                            .postfix(
                                                .identifier("context"),
                                                .functionCall(arguments: [
                                                    .unlabeled(.constant("A context")),
                                                    .unlabeled(
                                                        .block(parameters: [],
                                                               return: .void,
                                                               body: [
                                                                .expression(
                                                                    .postfix(
                                                                        .identifier("it"),
                                                                        .functionCall(arguments: [
                                                                            .unlabeled(.constant("must do X")),
                                                                            .unlabeled(
                                                                                .block(parameters: [],
                                                                                       return: .void,
                                                                                       body: [
                                                                                        .expression(.postfix(.identifier("statement"), .functionCall()))
                                                                                    ]))
                                                                            ]))
                                                                ),
                                                                .expression(
                                                                    .postfix(
                                                                        .identifier("it"),
                                                                        .functionCall(arguments: [
                                                                            .unlabeled(.constant("must also do Y")),
                                                                            .unlabeled(
                                                                                .block(parameters: [],
                                                                                       return: .void,
                                                                                       body: [
                                                                                        .expression(.postfix(.identifier("otherStatement"), .functionCall()))
                                                                                    ]
                                                                                )
                                                                            )
                                                                            ]
                                                                        )
                                                                    )
                                                                )
                                                            ]
                                                        )
                                                    )
                                                    ]
                                                )
                                            )
                                        ),
                                        .expression(
                                            .postfix(
                                                .identifier("context"),
                                                .functionCall(arguments: [
                                                    .unlabeled(.constant("Another context")),
                                                    .unlabeled(
                                                        .block(parameters: [],
                                                               return: .void,
                                                               body: [
                                                                .expression(
                                                                    .postfix(
                                                                        .identifier("beforeEach"),
                                                                        .functionCall(arguments: [
                                                                            .unlabeled(
                                                                                .block(parameters: [],
                                                                                       return: .void,
                                                                                       body: [
                                                                                        .expression(.postfix(.identifier("function"), .functionCall()))
                                                                                    ]))
                                                                            ]))
                                                                )
                                                            ]))
                                                    ])
                                            )
                                        )
                                    ]))
                            ])))
                ])
        
        let sut = TestExpressionPass()
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
            
            return .continue
        }
    }
}
