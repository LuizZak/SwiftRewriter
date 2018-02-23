import XCTest
import SwiftRewriterLib
import SwiftAST

class SyntaxNodeRewriterPassTests: XCTestCase {
    
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
    
    class TestExpressionPass: SyntaxNodeRewriterPass {
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
