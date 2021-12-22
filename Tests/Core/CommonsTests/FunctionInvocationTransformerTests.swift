import XCTest
import SwiftAST
import SwiftRewriterLib
import Commons

class FunctionInvocationTransformerTests: XCTestCase {
    func testRequiredArgumentCount() {
        let sut =
            FunctionInvocationTransformer(
                objcFunctionName: "objc", toSwiftFunction: "swift",
                firstArgumentBecomesInstance: false,
                arguments: [.asIs, .asIs]
            )
        
        XCTAssertEqual(sut.requiredArgumentCount, 2)
    }
    
    /// Test that first argument as instance requires an extra argument on call
    /// site
    func testRequiredArgumentCountWithFirstArgumentBecomesInstance() {
        let sut =
            FunctionInvocationTransformer(
                objcFunctionName: "objc", toSwiftFunction: "swift",
                firstArgumentBecomesInstance: true,
                arguments: [.asIs, .asIs]
        )
        
        XCTAssertEqual(sut.requiredArgumentCount, 3)
    }
    
    func testTransformsTargetZeroArgumentCall() {
        let sut =
            FunctionInvocationTransformer(
                objcFunctionName: "objc", toSwiftFunction: "swift",
                firstArgumentBecomesInstance: true,
                arguments: []
            )
        
        XCTAssertEqual(
            // objc(a)
            sut.attemptApply(on: .identifier("objc").call([.identifier("a")])),
            // a.swift()
            .identifier("a").dot("swift").call()
        )
    }
    
    /// Tests that the required argument count value also takes into consideration
    /// .firstArgIndex's that skip arguments and fetch the n'th argument, past
    /// the actual number of target arguments.
    func testRequiredArgumentCountFromArgIndexInference() {
        let sut =
            FunctionInvocationTransformer(
                objcFunctionName: "objc", toSwiftFunction: "swift",
                firstArgumentBecomesInstance: false,
                arguments: [.fromArgIndex(0), .fromArgIndex(1)]
            )
        let sutSkippingSecondArg =
            FunctionInvocationTransformer(
                objcFunctionName: "objc", toSwiftFunction: "swift",
                firstArgumentBecomesInstance: false,
                arguments: [.fromArgIndex(0), .fromArgIndex(3)]
            )
        
        XCTAssertEqual(sut.requiredArgumentCount, 2)
        XCTAssertEqual(sutSkippingSecondArg.requiredArgumentCount, 3)
    }
    
    /// Tests that the required argument count value also takes into consideration
    /// .firstArgIndex's that skip arguments and fetch the n'th argument, past
    /// the actual number of target arguments.
    func testRequiredArgumentCountWithFirstArgumentIsInstanceInference() {
        let sut =
            FunctionInvocationTransformer(
                objcFunctionName: "objc", toSwiftFunction: "swift",
                firstArgumentBecomesInstance: true,
                arguments: [.asIs, .asIs]
            )
        let sutSkippingSecondArg =
            FunctionInvocationTransformer(
                objcFunctionName: "objc", toSwiftFunction: "swift",
                firstArgumentBecomesInstance: true,
                arguments: [.asIs, .fromArgIndex(2)]
            )
        
        XCTAssertEqual(sut.requiredArgumentCount, 3)
        XCTAssertEqual(sutSkippingSecondArg.requiredArgumentCount, 3)
    }
    
    /// Tests that the required argument count value also takes into consideration
    /// .firstArgIndex's that skip arguments and fetch the n'th argument, past
    /// the actual number of target arguments.
    func testRequiredArgumentCountFromArgIndexWithFirstArgumentIsInstanceInference() {
        let sut =
            FunctionInvocationTransformer(
                objcFunctionName: "objc", toSwiftFunction: "swift",
                firstArgumentBecomesInstance: true,
                arguments: [.fromArgIndex(0), .fromArgIndex(1)]
            )
        let sutSkippingSecondArg =
            FunctionInvocationTransformer(
                objcFunctionName: "objc", toSwiftFunction: "swift",
                firstArgumentBecomesInstance: true,
                arguments: [.fromArgIndex(0), .fromArgIndex(3)]
            )
        
        XCTAssertEqual(sut.requiredArgumentCount, 3)
        XCTAssertEqual(sutSkippingSecondArg.requiredArgumentCount, 4)
    }
    
    func testAsIs() {
        let sut =
            FunctionInvocationTransformer(
                objcFunctionName: "objc", toSwiftFunction: "swift",
                firstArgumentBecomesInstance: false,
                arguments: [.asIs, .asIs]
            )
        
        let exp = Expression.identifier("objc").call([.identifier("argA"), .identifier("argB")])
        
        XCTAssertEqual(
            sut.attemptApply(on: exp),
            .identifier("swift").call([.identifier("argA"), .identifier("argB")])
        )
    }
    
    func testFromArgIndex() {
        // Use the .fromArgIndex argument creation strategy to flip the two
        // arguments of a function invocation
        let sut =
            FunctionInvocationTransformer(
                objcFunctionName: "objc", toSwiftFunction: "swift",
                firstArgumentBecomesInstance: false,
                arguments: [.fromArgIndex(1), .fromArgIndex(0)]
            )
        
        let exp = Expression.identifier("objc").call([.identifier("argA"), .identifier("argB")])
        
        XCTAssertEqual(
            sut.attemptApply(on: exp),
            .identifier("swift").call([.identifier("argB"), .identifier("argA")])
        )
    }
    
    func testOmitIf() {
        let sut =
            FunctionInvocationTransformer(
                objcFunctionName: "objc", toSwiftFunction: "swift",
                firstArgumentBecomesInstance: false,
                arguments: [
                    .omitIf(matches: .equals(to: .identifier("A")))
                ]
            )
        
        let exp1 = Expression.identifier("objc").call([
            .identifier("A")
        ])
        
        let exp2 = Expression.identifier("objc").call([
            .identifier("B")
        ])
        
        XCTAssertEqual(sut.attemptApply(on: exp1), .identifier("swift").call())
        XCTAssertEqual(sut.attemptApply(on: exp2), .identifier("swift").call([.identifier("B")]))
    }
    
    /// The function invocation transformer should not apply any changes if the
    /// argument count of a call site does not match its required argument count
    /// exactly.
    func testDontApplyIfNotMatchingArgCount() {
        let sut =
            FunctionInvocationTransformer(
                objcFunctionName: "objc", toSwiftFunction: "swift",
                firstArgumentBecomesInstance: false,
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
        XCTAssertEqual(
            sut.attemptApply(on: justRight),
            .identifier("swift").call([.identifier("argA"), .identifier("argB")])
        )
        XCTAssertFalse(sut.canApply(to: tooMany))
        XCTAssertNil(sut.attemptApply(on: tooMany))
    }
    
    func testTransformCGPointMake() {
        let sut =
            FunctionInvocationTransformer(
                objcFunctionName: "CGPointMake", toSwiftFunction: "CGPoint",
                firstArgumentBecomesInstance: false,
                arguments: [.labeled("x"), .labeled("y")]
            )
        
        let exp =
            Expression
                .identifier("CGPointMake")
                .call([.constant(1), .constant(2)])
        
        let result = sut.attemptApply(on: exp)
        
        XCTAssertEqual(
            result,
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
                objcFunctionName: "CGRectContainsRect", toSwiftFunction: "contains",
                firstArgumentBecomesInstance: true,
                arguments: [.asIs]
            )
        
        let exp =
            Expression
                .identifier("CGRectContainsRect")
                .call([.identifier("a"), .identifier("b")])
        
        let result = sut.attemptApply(on: exp)
        
        XCTAssertEqual(
            result,
            .identifier("a")
            .dot("contains")
            .call([.identifier("b")])
        )
    }
    
    func testTransformToPropertyGetter() {
        let sut =
            FunctionInvocationTransformer(
                objcFunctionName: "objc",
                toSwiftPropertyGetter: "swift"
            )
        
        XCTAssertEqual(
            // objc(a)
            sut.attemptApply(on: .identifier("objc").call([.identifier("a")])),
            // a.swift
            .identifier("a").dot("swift")
        )
    }
    
    func testTransformToPropertySetter() {
        let sut = FunctionInvocationTransformer(objcFunctionName: "objc", toSwiftPropertySetter: "swift")
        
        XCTAssertEqual(
            // objc(a, b)
            sut.attemptApply(on: .identifier("objc").call([.identifier("a"), .identifier("b")])),
            // a.swift = b
            .identifier("a").dot("swift").assignment(op: .assign, rhs: .identifier("b"))
        )
    }
    
    func testTransformToPropertySetterTransformerBailsIfNotTwoArguments() {
        let sut = FunctionInvocationTransformer(objcFunctionName: "objc", toSwiftPropertySetter: "swift")
        
        XCTAssertNil(
            // objc(a, b, c)
            sut.attemptApply(on:
                .identifier("objc")
                .call([.identifier("a"), .identifier("b"), .identifier("c")])
            )
        )
    }
    
    func testIgnoreFunctionWithExpectedLabeling() {
        let sut =
            FunctionInvocationTransformer(
                objcFunctionName: "function", toSwiftFunction: "function",
                firstArgumentBecomesInstance: false,
                arguments: [.asIs, .labeled("label")]
        )
        
        XCTAssertEqual(
            // function(0, 1)
            sut.attemptApply(on:
                .identifier("function")
                .call([.constant(0), .constant(1)])
            ),
            // function(0, label: 1)
            .identifier("function")
            .call([.unlabeled(.constant(0)), .labeled("label", .constant(1))])
        )
        
        XCTAssertNil(
            // function(0, label: 1)
            sut.attemptApply(on:
                .identifier("function")
                .call([.unlabeled(.constant(0)), .labeled("label", .constant(1))])
            )
        )
    }
}
