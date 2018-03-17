import XCTest
import SwiftRewriterLib
import SwiftAST
import IntentionPasses
import TestCommons

class DetectNonnullReturnsIntentionPassTests: XCTestCase {
    func testApplyOnMethod() {
        let intentions =
            IntentionCollectionBuilder()
                .createFileWithClass(named: "A.m") { type in
                    type.createMethod(named: "a", returnType: .implicitUnwrappedOptional(.typeName("A"))) { method in
                        method.setBody([
                            Statement.return(Expression.identifier("self").typed(.typeName("A")))
                        ])
                    }
                }.build()
        let sut = DetectNonnullReturnsIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        let file = intentions.fileIntentions()[0]
        XCTAssertEqual(file.classIntentions[0].methods[0].returnType, .typeName("A"))
    }
    
    func testDonyApplyOnMethodWithExplicitOptionalReturnType() {
        let intentions =
            IntentionCollectionBuilder()
                .createFileWithClass(named: "A.m") { type in
                    type.createMethod(named: "a", returnType: .optional(.typeName("A"))) { method in
                        method.setBody([
                            Statement.return(Expression.identifier("self").typed(.typeName("A")))
                            ])
                    }
                }.build()
        let sut = DetectNonnullReturnsIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        let file = intentions.fileIntentions()[0]
        XCTAssertEqual(file.classIntentions[0].methods[0].returnType, .optional(.typeName("A")))
    }
    
    func testDonyApplyOnMethodWithErrorReturnType() {
        let intentions =
            IntentionCollectionBuilder()
                .createFileWithClass(named: "A.m") { type in
                    type.createMethod(named: "a", returnType: .implicitUnwrappedOptional(.typeName("A"))) { method in
                        method.setBody([
                            Statement.return(Expression.identifier("self").typed(.errorType))
                            ])
                    }
                }.build()
        let sut = DetectNonnullReturnsIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        let file = intentions.fileIntentions()[0]
        XCTAssertEqual(file.classIntentions[0].methods[0].returnType, .implicitUnwrappedOptional(.typeName("A")))
    }
}
