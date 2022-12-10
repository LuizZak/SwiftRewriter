import XCTest
import SwiftRewriterLib
import SwiftAST
import IntentionPasses
import TestCommons

class DetectNonnullReturnsIntentionPassTests: XCTestCase {
    func testApplyOnMethod() {
        let intentions =
            IntentionCollectionBuilder()
                .createFileWithClass(named: "A") { type in
                    type.createMethod(named: "a", returnType: .nullabilityUnspecified(.typeName("A"))) { method in
                        method.setBody([
                            Statement.return(Expression.identifier("self").typed(.typeName("A")))
                        ])
                    }
                }.build()
        let sut = DetectNonnullReturnsIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        Asserter(object: intentions).asserterForFiles { files in
            files.assertCount(1)
            files[0]?.asserter(forClassNamed: "A") { type in
                type[\.methods][0]?
                    .assert(returnType: "A")
            }
        }
    }
    
    func testApplyOnMethodPolymorphicDetection() {
        let intentions =
            IntentionCollectionBuilder()
                .createFileWithClass(named: "B") { type in
                    type.inherit(from: "A")
                }
                .createFileWithClass(named: "A") { type in
                    type.createProperty(named: "b", type: "B")
                        .createMethod(named: "a", returnType: .nullabilityUnspecified(.typeName("A"))) { method in
                        method.setBody([
                            Statement.return(Expression.identifier("self").dot("b").typed(.typeName("B")))
                        ])
                    }
                }.build()
        let sut = DetectNonnullReturnsIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        Asserter(object: intentions).asserter(forClassNamed: "A") { type in
            type[\.methods][0]?
                .assert(returnType: "A")
        }
    }
    
    func testDontApplyOnMethodWithExplicitOptionalReturnType() {
        let intentions =
            IntentionCollectionBuilder()
                .createFileWithClass(named: "A") { type in
                    type.createMethod(named: "a", returnType: .optional(.typeName("A"))) { method in
                        method.setBody([
                            Statement.return(Expression.identifier("self").typed(.typeName("A")))
                        ])
                    }
                }.build()
        let sut = DetectNonnullReturnsIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        Asserter(object: intentions).asserterForFiles { files in
            files.assertCount(1)
            files[0]?.asserter(forClassNamed: "A") { type in
                type[\.methods][0]?
                    .assert(returnType: .optional("A"))
            }
        }
    }
    
    func testDontApplyOnMethodWithErrorReturnType() {
        let intentions =
            IntentionCollectionBuilder()
                .createFileWithClass(named: "A") { type in
                    type.createMethod(named: "a", returnType: .nullabilityUnspecified(.typeName("A"))) { method in
                        method.setBody([
                            Statement.return(Expression.identifier("self").typed(.errorType))
                        ])
                    }
                }.build()
        let sut = DetectNonnullReturnsIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        Asserter(object: intentions).asserterForFiles { files in
            files.assertCount(1)
            files[0]?.asserter(forClassNamed: "A") { type in
                type[\.methods][0]?
                    .assert(returnType: .nullabilityUnspecified("A"))
            }
        }
    }
    
    func testDontApplyOnOverrides() {
        let intentions =
            IntentionCollectionBuilder()
                .createFileWithClass(named: "A") { type in
                    type.createMethod(named: "a", returnType: .nullabilityUnspecified(.typeName("A"))) { method in
                        method.setIsOverride(true)
                        method.setBody([
                            Statement.return(Expression.identifier("self").typed(.typeName("A")))
                        ])
                    }
                }.build()
        let sut = DetectNonnullReturnsIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        Asserter(object: intentions).asserterForFiles { files in
            files.assertCount(1)
            
            files[0]?.asserter(forClassNamed: "A") { type in
                type[\.methods][0]?
                    .assert(returnType: .nullabilityUnspecified("A"))
            }
        }
    }
}
