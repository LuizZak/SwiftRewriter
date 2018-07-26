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
        let intentions =
            IntentionCollectionBuilder()
                .createFileWithClass(named: "A") { type in
                    type.createConstructor()
                }.build()
        let ctor = intentions.classIntentions()[0].constructors[0]
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        XCTAssertFalse(ctor.isFailableInitializer)
    }
    
    func testInitThatReturnsNil() {
        let intentions =
            IntentionCollectionBuilder()
                .createFileWithClass(named: "A") { type in
                    type.createConstructor { ctor in
                        ctor.setBody([.return(.constant(.nil))])
                    }
                }.build()
        let ctor = intentions.classIntentions()[0].constructors[0]
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        XCTAssert(ctor.isFailableInitializer)
    }
    
    func testInitThatHasBlockThatReturnsNil() {
        let intentions =
            IntentionCollectionBuilder()
                .createFileWithClass(named: "A") { type in
                    type.createConstructor { ctor in
                        ctor.setBody([
                            .expression(
                                .block(body: [
                                    .return(.constant(.nil))
                                ])
                            )
                        ])
                    }
                }.build()
        let ctor = intentions.classIntentions()[0].constructors[0]
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        XCTAssertFalse(ctor.isFailableInitializer)
    }
}
