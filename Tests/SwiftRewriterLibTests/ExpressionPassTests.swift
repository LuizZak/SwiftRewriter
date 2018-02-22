//
//  ExpressionPassTests.swift
//  SwiftRewriterLibTests
//
//  Created by Luiz Fernando Silva on 16/02/2018.
//

import XCTest
import SwiftRewriterLib

class ExpressionPassTests: XCTestCase {
    func testTraverseThroughBlockDisabled() {
        let exp: Expression =
            .block(parameters: [], return: .void, body: [
                .expression(.postfix(.identifier("function"), .functionCall(arguments: [])))
                ])
        
        let sut = TestExpressionPass()
        sut.inspectBlocks = false
        
        _=sut.applyPass(on: exp)
        
        XCTAssertFalse(sut.foundNeedle)
    }
    
    func testTraverseThroughBlockEnabled() {
        let exp: Expression =
            .block(parameters: [], return: .void, body: [
                .expression(.postfix(.identifier("function"), .functionCall(arguments: [])))
                ])
        
        let sut = TestExpressionPass()
        sut.inspectBlocks = true
        
        let result = sut.applyPass(on: exp)
        
        XCTAssert(sut.foundNeedle)
        XCTAssertEqual(result,
                       .block(parameters: [], return: .void, body: [
                        .expression(.postfix(.identifier("function2"), .functionCall(arguments: [])))
                        ]))
    }
    
    class TestExpressionPass: ExpressionPass {
        var foundNeedle = false
        
        override func visitPostfix(_ exp: PostfixExpression) -> Expression {
            if exp.exp == .identifier("function") && exp.op == .functionCall(arguments: []) {
                foundNeedle = true
                
                exp.exp = .identifier("function2")
            }
            
            return super.visitPostfix(exp)
        }
    }
}
