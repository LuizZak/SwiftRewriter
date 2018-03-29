import XCTest
import SwiftRewriterLib
import SwiftAST
import TestCommons

class FunctionBodyQueueTests: XCTestCase {
    private var sut: FunctionBodyQueue<TestQueueDelegate>!
    private var delegate: TestQueueDelegate!
    
    override func setUp() {
        super.setUp()
        
        delegate = TestQueueDelegate()
    }
    
    func testQueueGlobalFunctionBody() {
        let intentions =
            IntentionCollectionBuilder()
                .createFile(named: "A") { file in
                    file.createGlobalFunction(withName: "a", body: [])
                }.build()
        let global = intentions.fileIntentions()[0].globalFunctionIntentions[0]
        
        sut = FunctionBodyQueue.fromIntentionCollection(intentions, delegate: delegate)
        let items = sut.items
        
        XCTAssertEqual(items.count, 1)
        XCTAssert(items.first?.body === global.functionBody)
    }
    
    func testQueueMethodBody() {
        let intentions =
            IntentionCollectionBuilder()
                .createFile(named: "A") { file in
                    file.createClass(withName: "A") { type in
                        type.createMethod(named: "a") { method in
                            method.setBody([])
                        }
                    }
                }.build()
        let body = intentions.fileIntentions()[0].typeIntentions[0].methods[0].functionBody
        
        sut = FunctionBodyQueue.fromIntentionCollection(intentions, delegate: delegate)
        let items = sut.items
        
        XCTAssertEqual(items.count, 1)
        XCTAssert(items.first?.body === body)
    }
    
    func testQueuePropertyGetter() {
        let intentions =
            IntentionCollectionBuilder()
                .createFile(named: "A") { file in
                    file.createClass(withName: "A") { type in
                        type.createProperty(named: "a", type: .int, mode: .computed(FunctionBodyIntention(body: [])))
                    }
                }.build()
        let body = intentions.fileIntentions()[0].typeIntentions[0].properties[0].getter
        
        sut = FunctionBodyQueue.fromIntentionCollection(intentions, delegate: delegate)
        let items = sut.items
        
        XCTAssertEqual(items.count, 1)
        XCTAssert(items.first?.body === body)
    }
    
    func testQueuePropertyGetterAndSetter() {
        let intentions =
            IntentionCollectionBuilder()
                .createFile(named: "A") { file in
                    file.createClass(withName: "A") { type in
                        type.createProperty(named: "a", type: .int, mode: .property(get: FunctionBodyIntention(body: []),
                                                                                    set: PropertyGenerationIntention.Setter(valueIdentifier: "setter", body: FunctionBodyIntention(body: []))))
                    }
                }.build()
        let bodyGetter = intentions.fileIntentions()[0].typeIntentions[0].properties[0].getter
        let bodySetter = intentions.fileIntentions()[0].typeIntentions[0].properties[0].setter?.body
        
        sut = FunctionBodyQueue.fromIntentionCollection(intentions, delegate: delegate)
        let items = sut.items
        
        XCTAssertEqual(items.count, 2)
        XCTAssert(items.contains(where: { $0.body === bodyGetter }))
        XCTAssert(items.contains(where: { $0.body === bodySetter }))
    }
}

private class TestQueueDelegate: FunctionBodyQueueDelegate {
    func makeContext(forFunction function: GlobalFunctionGenerationIntention) -> Context {
        return Context()
    }
    func makeContext(forMethod method: MethodGenerationIntention) -> Context {
        return Context()
    }
    func makeContext(forInit ctor: InitGenerationIntention) -> Context {
        return Context()
    }
    func makeContext(forPropertyGetter property: PropertyGenerationIntention, getter: FunctionBodyIntention) -> Context {
        return Context()
    }
    func makeContext(forPropertySetter property: PropertyGenerationIntention, setter: PropertyGenerationIntention.Setter) -> Context {
        return Context()
    }
    
    struct Context {
        
    }
}
