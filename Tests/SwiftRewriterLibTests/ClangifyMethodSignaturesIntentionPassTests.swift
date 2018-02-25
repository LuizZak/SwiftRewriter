//
//  ClangifyMethodSignaturesIntentionPassTests.swift
//  SwiftRewriterLibTests
//
//  Created by Luiz Fernando Silva on 24/02/2018.
//

import XCTest
@testable import SwiftRewriterLib

class ClangifyMethodSignaturesIntentionPassTests: XCTestCase {
    func testConvertWith() {
        let sut = ClangifyMethodSignaturesIntentionPass()
        
        testThat(sut: sut)
            .method(withSignature:
                FunctionSignature(name: "doThingWithColor",
                                  parameters: [
                                    ParameterSignature(label: "_", name: "color", type: .any)
                    ]))
            .converts(to:
                FunctionSignature(name: "doThing",
                                  parameters: [
                                    ParameterSignature(label: "with", name: "color", type: .any)
                    ]))
    }
    
    func testConvertWithAtSuffix() {
        let sut = ClangifyMethodSignaturesIntentionPass()
        
        testThat(sut: sut)
            .method(withSignature:
                FunctionSignature(name: "doThingWith",
                                  parameters: [
                                    ParameterSignature(label: "_", name: "color", type: .any)
                    ]))
            .converts(to:
                FunctionSignature(name: "doThingWith",
                                  parameters: [
                                    ParameterSignature(label: "_", name: "color", type: .any)
                    ]))
    }
    
    func testConvertWithin() {
        let sut = ClangifyMethodSignaturesIntentionPass()
        
        testThat(sut: sut)
            .method(withSignature:
                FunctionSignature(name: "doThingWithin",
                                  parameters: []))
            .converts(to:
                FunctionSignature(name: "doThingWithin",
                                  parameters: []))
    }
    
    func testConvertWithinWithParameter() {
        let sut = ClangifyMethodSignaturesIntentionPass()
        
        testThat(sut: sut)
            .method(withSignature:
                FunctionSignature(name: "doThingWithin",
                                  parameters: [
                                    ParameterSignature(label: "_", name: "thing", type: .any)
                    ]))
            .converts(to:
                FunctionSignature(name: "doThingWithin",
                                  parameters: [
                                    ParameterSignature(label: "_", name: "thing", type: .any)
                    ]))
    }
    
    func testConvertInit() {
        let sut = ClangifyMethodSignaturesIntentionPass()
        
        testThat(sut: sut)
            .method(withSignature:
                FunctionSignature(name: "init",
                                  parameters: [],
                                  returnType: .anyObject,
                                  isStatic: false))
            .converts(toInitializer: [])
    }
    
    func testConvertInitwithInt() {
        let sut = ClangifyMethodSignaturesIntentionPass()
        
        testThat(sut: sut)
            .method(withSignature:
                FunctionSignature(name: "initWithInt",
                                  parameters: [
                                    ParameterSignature(label: "_", name: "int", type: .int)],
                                  returnType: .anyObject,
                                  isStatic: false))
            .converts(toInitializer: [
                ParameterSignature(label: "int", name: "int", type: .int)
                ])
    }
}

private extension ClangifyMethodSignaturesIntentionPassTests {
    func testThat(sut: ClangifyMethodSignaturesIntentionPass) -> ClangifyMethodSignaturesIntentionPassTestBuilder {
        return ClangifyMethodSignaturesIntentionPassTestBuilder(testCase: self, sut: sut)
    }
}

private class ClangifyMethodSignaturesIntentionPassTestBuilder {
    let testCase: XCTestCase
    let intentions: IntentionCollection
    let type: TypeGenerationIntention
    let sut: ClangifyMethodSignaturesIntentionPass
    
    init(testCase: XCTestCase, sut: ClangifyMethodSignaturesIntentionPass) {
        self.testCase = testCase
        self.sut = sut
        intentions = IntentionCollection()
        
        type = TypeGenerationIntention(typeName: "T")
        let file = FileGenerationIntention(sourcePath: "", filePath: "")
        file.addType(type)
        intentions.addIntention(file)
    }
    
    func method(withSignature signature: FunctionSignature) -> Asserter {
        type.addMethod(MethodGenerationIntention(signature: signature))
        
        let context =
            IntentionPassContext(intentions: intentions,
                                 typeSystem: DefaultTypeSystem())
        
        sut.apply(on: intentions, context: context)
        
        return Asserter(testCase: testCase, intentions: intentions, type: type)
    }
    
    class Asserter {
        let testCase: XCTestCase
        let intentions: IntentionCollection
        let type: TypeGenerationIntention
        
        init(testCase: XCTestCase, intentions: IntentionCollection, type: TypeGenerationIntention) {
            self.testCase = testCase
            self.intentions = intentions
            self.type = type
        }
        
        func converts(toInitializer parameters: [ParameterSignature], file: String = #file, line: Int = #line) {
            guard let ctor = type.constructors.first else {
                testCase.recordFailure(withDescription: """
                    Failed to generate initializer: No initializers where found \
                    on target type.
                    """
                    , inFile: file, atLine: line, expected: false)
                return
            }
            guard ctor.parameters != parameters else {
                return
            }
            
            testCase.recordFailure(withDescription: """
                Expected to generate constructor with parameters \(parameters),
                but converted to \(ctor.parameters)
                """
                , inFile: file, atLine: line, expected: false)
        }
        
        func converts(to signature: FunctionSignature, file: String = #file, line: Int = #line) {
            guard type.methods.first?.signature != signature else {
                return
            }
            
            testCase.recordFailure(withDescription: """
                Expected signature \(signature), but converted to \(type.methods[0].signature)
                """
                , inFile: file, atLine: line, expected: false)
        }
    }
}
