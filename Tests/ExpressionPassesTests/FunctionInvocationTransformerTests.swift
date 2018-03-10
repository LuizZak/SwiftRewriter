//
//  FunctionInvocationTransformerTests.swift
//  ExpressionPassesTests
//
//  Created by Luiz Fernando Silva on 06/03/2018.
//

import XCTest
import SwiftAST
import SwiftRewriterLib
import ExpressionPasses

class FunctionInvocationTransformerTests: XCTestCase {
    func testRequiredArgumentCount() {
        let sutNonInstance = FunctionInvocationTransformer(
            name: "objc", swiftName: "swift", firstArgumentBecomesInstance: false,
            arguments: [.asIs, .asIs]
        )
        let sutInstance = FunctionInvocationTransformer(
            name: "objc", swiftName: "swift", firstArgumentBecomesInstance: true,
            arguments: [.asIs, .asIs]
        )
        
        XCTAssertEqual(sutNonInstance.requiredArgumentCount, 2)
        XCTAssertEqual(sutInstance.requiredArgumentCount, 3) // first-arg as instance requires an extra argument on call site
    }
    
    /// Tests that the required argument count value also takes into consideration
    /// .firstArgIndex's that skip arguments and fetch the n'th argument, past the
    /// actual number of target arguments.
    func testRequiredArgumentCountFromArgIndexInference() {
        let sut = FunctionInvocationTransformer(
            name: "objc", swiftName: "swift", firstArgumentBecomesInstance: false,
            arguments: [.fromArgIndex(0), .fromArgIndex(1)]
        )
        let sutSkippingSecondArg = FunctionInvocationTransformer(
            name: "objc", swiftName: "swift", firstArgumentBecomesInstance: false,
            arguments: [.fromArgIndex(0), .fromArgIndex(3)]
        )
        
        XCTAssertEqual(sut.requiredArgumentCount, 2)
        XCTAssertEqual(sutSkippingSecondArg.requiredArgumentCount, 3)
    }
    
    /// Tests that the required argument count value also takes into consideration
    /// .firstArgIndex's that skip arguments and fetch the n'th argument, past the
    /// actual number of target arguments.
    func testRequiredArgumentCounWithFirstArgumentIsInstanceInference() {
        let sut = FunctionInvocationTransformer(
            name: "objc", swiftName: "swift",
            firstArgumentBecomesInstance: true,
            arguments: [.asIs, .asIs]
        )
        let sutSkippingSecondArg = FunctionInvocationTransformer(
            name: "objc", swiftName: "swift",
            firstArgumentBecomesInstance: true,
            arguments: [.asIs, .asIs]
        )
        
        XCTAssertEqual(sut.requiredArgumentCount, 3)
        XCTAssertEqual(sutSkippingSecondArg.requiredArgumentCount, 3)
    }
    
    /// Tests that the required argument count value also takes into consideration
    /// .firstArgIndex's that skip arguments and fetch the n'th argument, past the
    /// actual number of target arguments.
    func testRequiredArgumentCountFromArgIndexWithFirstArgumentIsInstanceInference() {
        let sut = FunctionInvocationTransformer(
            name: "objc", swiftName: "swift",
            firstArgumentBecomesInstance: true,
            arguments: [.fromArgIndex(0), .fromArgIndex(1)]
        )
        let sutSkippingSecondArg = FunctionInvocationTransformer(
            name: "objc", swiftName: "swift",
            firstArgumentBecomesInstance: true,
            arguments: [.fromArgIndex(0), .fromArgIndex(3)]
        )
        
        XCTAssertEqual(sut.requiredArgumentCount, 3)
        XCTAssertEqual(sutSkippingSecondArg.requiredArgumentCount, 4)
    }
    
    func testAsIs() {
        let sut = FunctionInvocationTransformer(
            name: "objc", swiftName: "swift", firstArgumentBecomesInstance: false,
            arguments: [.asIs, .asIs]
        )
        
        let exp = Expression.identifier("objc").call([.identifier("argA"), .identifier("argB")])
        
        XCTAssertEqual(sut.attemptApply(on: exp),
                       Expression.identifier("swift").call([.identifier("argA"), .identifier("argB")]))
    }
    
    func testFromArgIndex() {
        // Use the .fromArgIndex argument creation strategy to flip the two arguments
        // of a function invocation
        let sut = FunctionInvocationTransformer(
            name: "objc", swiftName: "swift", firstArgumentBecomesInstance: false,
            arguments: [.fromArgIndex(1), .fromArgIndex(0)]
        )
        
        let exp = Expression.identifier("objc").call([.identifier("argA"), .identifier("argB")])
        
        XCTAssertEqual(sut.attemptApply(on: exp),
                       Expression.identifier("swift").call([.identifier("argB"), .identifier("argA")]))
    }
    
    func testOmitIf() {
        let sut = FunctionInvocationTransformer(
            name: "objc", swiftName: "swift", firstArgumentBecomesInstance: false,
            arguments: [
                .omitIf(matches: .identifier("A"), .asIs)
            ]
        )
        
        let exp1 = Expression.identifier("objc").call([
            .identifier("A")
            ])
        
        let exp2 = Expression.identifier("objc").call([
            .identifier("B")
            ])
        
        XCTAssertEqual(sut.attemptApply(on: exp1), Expression.identifier("swift").call())
        XCTAssertEqual(sut.attemptApply(on: exp2), Expression.identifier("swift").call([.identifier("B")]))
    }
    
    /// The function invocation transformer should not apply any changes if the
    /// argument count of a call site does not match its required argument count
    /// exactly.
    func testDontApplyIfNotMatchingArgCount() {
        let sut = FunctionInvocationTransformer(
            name: "objc", swiftName: "swift", firstArgumentBecomesInstance: false,
            arguments: [.asIs, .asIs]
        )
        
        let tooFew =
            Expression
                .identifier("objc")
                .call([.identifier("argA")])
        
        let justRight =
            Expression
                .identifier("objc")
                .call([.identifier("argA"), .identifier("argB")])
        
        let tooMany =
            Expression
                .identifier("objc")
                .call([.identifier("argA"), .identifier("argB"), .identifier("argC")])
        
        XCTAssertFalse(sut.canApply(to: tooFew))
        XCTAssertNil(sut.attemptApply(on: tooFew))
        XCTAssert(sut.canApply(to: justRight))
        XCTAssertEqual(sut.attemptApply(on: justRight),
                       Expression.identifier("swift").call([.identifier("argA"), .identifier("argB")]))
        XCTAssertFalse(sut.canApply(to: tooMany))
        XCTAssertNil(sut.attemptApply(on: tooMany))
    }
    
    func testTransformCGPointMake() {
        let sut =
            FunctionInvocationTransformer(
                name: "CGPointMake",
                swiftName: "CGPoint",
                firstArgumentBecomesInstance: false,
                arguments: [.labeled("x", .asIs), .labeled("y", .asIs)]
        )
        
        let exp =
            Expression
                .identifier("CGPointMake")
                .call([Expression.constant(1), Expression.constant(2)])
        
        let result = sut.attemptApply(on: exp)
        
        XCTAssertEqual(result,
            Expression
                .identifier("CGPoint")
                .call([
                    .labeled("x", .constant(1)),
                    .labeled("y", .constant(2))
                ])
        )
    }
    
    func testTransformFirstArgumentIsInstance() {
        let sut =
            FunctionInvocationTransformer(
                name: "CGRectContainsRect",
                swiftName: "contains",
                firstArgumentBecomesInstance: true,
                arguments: [.asIs]
        )
        
        let exp =
            Expression
                .identifier("CGRectContainsRect")
                .call([Expression.identifier("a"), Expression.identifier("b")])
        
        let result = sut.attemptApply(on: exp)
        
        XCTAssertEqual(result,
                       Expression
                        .identifier("a")
                        .dot("contains")
                        .call([.identifier("b")])
        )
    }
}
