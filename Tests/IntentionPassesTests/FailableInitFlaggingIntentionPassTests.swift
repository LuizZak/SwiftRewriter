import XCTest
import SwiftAST
import IntentionPasses
import TestCommons
import SwiftRewriterLib

class FailableInitFlaggingIntentionPassTests: XCTestCase {
    var sut: FailableInitFlaggingIntentionPass!
    
    override func setUp() {
        super.setUp()
        
        sut = FailableInitFlaggingIntentionPass()
    }
    
    func testEmptyInit() {
        testDoesNotFlagsBody(CompoundStatement(statements: []))
    }
    
    func testInitThatReturnsNil() {
        testFlagsBody([
            .return(.constant(.nil))
        ])
    }
    
    func testInitThatHasBlockThatReturnsNil() {
        testDoesNotFlagsBody([
            .expression(
                .block(body: [
                    .return(.constant(.nil))
                ])
            )
        ])
    }
    
    func testIgnoreWithinIfWithNilCheckSelf() {
        // Tests that the following case does not trigger the failable init detector:
        //
        // if(self == nil) {
        //     return nil;
        // }
        
        testDoesNotFlagsBody([
            .if(Expression.identifier("self").binary(op: .equals, rhs: .constant(.nil)),
                body: [
                    .return(.constant(.nil))
                ], else: nil)
        ])
    }
    
    func testIgnoreWithinIfWithNilCheckSelfEqualsSuperInit() {
        // Tests that the following case does not trigger the failable init detector:
        //
        // if(!(self = [super init])) {
        //     return nil;
        // }
        
        testDoesNotFlagsBody([
            .if(.unary(op: .negate,
                       Expression
                        .identifier("self")
                        .assignment(
                            op: .assign,
                            rhs: Expression.identifier("super").dot("init").call()
                        )
                ),
                body: [
                    .return(.constant(.nil))
                ], else: nil)
            ])
    }
}

private extension FailableInitFlaggingIntentionPassTests {
    
    func testFlagsBody(_ body: CompoundStatement, line: Int = #line) {
        
        let intentions =
            IntentionCollectionBuilder()
                .createFileWithClass(named: "A") { type in
                    type.createConstructor { ctor in
                        ctor.setBody(body)
                    }
                }.build()
        let ctor = intentions.classIntentions()[0].constructors[0]
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        if !ctor.isFailableInitializer {
            recordFailure(withDescription: """
                Expected to flag initializer as failable
                """, inFile: #file, atLine: line, expected: true)
        }
    }
    
    func testDoesNotFlagsBody(_ body: CompoundStatement, line: Int = #line) {
        
        let intentions =
            IntentionCollectionBuilder()
                .createFileWithClass(named: "A") { type in
                    type.createConstructor { ctor in
                        ctor.setBody(body)
                    }
                }.build()
        let ctor = intentions.classIntentions()[0].constructors[0]
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        if ctor.isFailableInitializer {
            recordFailure(withDescription: """
                Expected to not flag initializer as failable
                """, inFile: #file, atLine: line, expected: true)
        }
    }
}
