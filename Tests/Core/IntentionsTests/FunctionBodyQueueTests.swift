import Intentions
import SwiftAST
import TestCommons
import XCTest

class FunctionBodyQueueTests: XCTestCase {
    private var sut: FunctionBodyQueue<EmptyFunctionBodyQueueDelegate>!
    private var delegate: EmptyFunctionBodyQueueDelegate!

    override func setUp() {
        super.setUp()

        delegate = EmptyFunctionBodyQueueDelegate()
    }

    func testQueueGlobalFunctionBody() {
        let intentions =
            IntentionCollectionBuilder()
            .createFile(named: "A") { file in
                file.createGlobalFunction(withName: "a", body: [])
            }.build()
        let global = intentions.fileIntentions()[0].globalFunctionIntentions[0]

        sut = FunctionBodyQueue.fromIntentionCollection(
            intentions,
            delegate: delegate,
            numThreads: 8
        )
        let items = sut.items

        XCTAssertEqual(items.count, 1)
        XCTAssert(items.first?.container.functionBody === global.functionBody)
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

        sut = FunctionBodyQueue.fromIntentionCollection(
            intentions,
            delegate: delegate,
            numThreads: 8
        )
        let items = sut.items

        XCTAssertEqual(items.count, 1)
        XCTAssert(items.first?.container.functionBody === body)
    }

    func testQueueStructMethodBody() {
        let intentions =
            IntentionCollectionBuilder()
            .createFile(named: "A") { file in
                file.createStruct(withName: "A") { type in
                    type.createMethod(named: "a") { method in
                        method.setBody([])
                    }
                }
            }.build()
        let body = intentions.fileIntentions()[0].typeIntentions[0].methods[0].functionBody

        sut = FunctionBodyQueue.fromIntentionCollection(
            intentions,
            delegate: delegate,
            numThreads: 8
        )
        let items = sut.items

        XCTAssertEqual(items.count, 1)
        XCTAssert(items.first?.container.functionBody === body)
    }

    func testQueuePropertyGetter() {
        let intentions =
            IntentionCollectionBuilder()
            .createFile(named: "A") { file in
                file.createClass(withName: "A") { type in
                    type.createProperty(
                        named: "a",
                        type: .int,
                        mode: .computed(FunctionBodyIntention(body: []))
                    )
                }
            }.build()
        let body = intentions.fileIntentions()[0].typeIntentions[0].properties[0].getter

        sut = FunctionBodyQueue.fromIntentionCollection(
            intentions,
            delegate: delegate,
            numThreads: 8
        )
        let items = sut.items

        XCTAssertEqual(items.count, 1)
        XCTAssert(items.first?.container.functionBody === body)
    }

    func testQueuePropertyGetterAndSetter() {
        let intentions =
            IntentionCollectionBuilder()
            .createFile(named: "A") { file in
                file.createClass(withName: "A") { type in
                    type.createProperty(
                        named: "a",
                        type: .int,
                        mode: .property(
                            get: FunctionBodyIntention(body: []),
                            set: PropertyGenerationIntention.Setter(
                                valueIdentifier: "setter",
                                body: FunctionBodyIntention(body: [])
                            )
                        )
                    )
                }
            }.build()
        let bodyGetter = intentions.fileIntentions()[0].typeIntentions[0].properties[0].getter
        let bodySetter = intentions.fileIntentions()[0].typeIntentions[0].properties[0].setter?.body

        sut = FunctionBodyQueue.fromIntentionCollection(
            intentions,
            delegate: delegate,
            numThreads: 8
        )
        let items = sut.items

        XCTAssertEqual(items.count, 2)
        XCTAssert(items.contains(where: { $0.container.functionBody === bodyGetter }))
        XCTAssert(items.contains(where: { $0.container.functionBody === bodySetter }))
    }

    func testQueueDeinit() {
        let intentions =
            IntentionCollectionBuilder()
            .createFileWithClass(named: "A") { file in
                file.createDeinit()
            }.build()
        let body = intentions.fileIntentions()[0].classIntentions[0].deinitIntention?.functionBody

        sut = FunctionBodyQueue.fromIntentionCollection(
            intentions,
            delegate: delegate,
            numThreads: 8
        )
        let items = sut.items

        XCTAssertEqual(items.count, 1)
        XCTAssert(items.first?.container.functionBody === body)
    }

    func testFromDeinit() {
        let intentions =
            IntentionCollectionBuilder()
            .createFileWithClass(named: "A") { file in
                file.createDeinit()
            }.build()
        let deinitIntent = intentions.fileIntentions()[0].classIntentions[0].deinitIntention

        sut = FunctionBodyQueue.fromDeinit(
            intentions,
            deinitIntent: deinitIntent!,
            delegate: delegate
        )
        let items = sut.items

        XCTAssertEqual(items.count, 1)
        XCTAssert(items.first?.container.functionBody === deinitIntent?.functionBody)
    }

    func testQueueSubscript() {
        let intentions =
            IntentionCollectionBuilder()
            .createFileWithClass(named: "A") { file in
                file.createSubscript("(index: Int)", returnType: .int) { builder in
                    builder.setAsGetterSetter(
                        getter: [],
                        setter: .init(valueIdentifier: "newValue", body: [])
                    )
                }
            }.build()
        let bodyGetter = intentions.fileIntentions()[0].classIntentions[0].subscripts[0].mode.getter
        let bodySetter = intentions.fileIntentions()[0].classIntentions[0].subscripts[0].mode
            .setter?.body

        sut = FunctionBodyQueue.fromIntentionCollection(
            intentions,
            delegate: delegate,
            numThreads: 8
        )
        let items = sut.items

        XCTAssertEqual(items.count, 2)
        XCTAssert(items.contains(where: { $0.container.functionBody === bodyGetter }))
        XCTAssert(items.contains(where: { $0.container.functionBody === bodySetter }))
    }

    func testQueueAllBodiesFound() {
        let intentions =
            IntentionCollectionBuilder()
            .createFile(named: "A") { file in
                file.createGlobalFunction(withName: "a", body: [])
                    .createClass(withName: "B") { type in
                        type.createProperty(
                            named: "b",
                            type: .int,
                            mode: .computed(FunctionBodyIntention(body: []))
                        )
                        .createDeinit()
                    }
            }.createFile(named: "C") { file in
                file.createClass(withName: "C") { type in
                    type.createProperty(
                        named: "c",
                        type: .int,
                        mode: .property(
                            get: FunctionBodyIntention(body: []),
                            set: PropertyGenerationIntention.Setter(
                                valueIdentifier: "setter",
                                body: FunctionBodyIntention(body: [])
                            )
                        )
                    )
                }
            }.build()
        let global = intentions.fileIntentions()[0].globalFunctionIntentions[0].functionBody
        let deinitBody = intentions.fileIntentions()[0].classIntentions[0].deinitIntention?
            .functionBody
        let bodyGetter1 = intentions.fileIntentions()[0].typeIntentions[0].properties[0].getter
        let bodyGetter2 = intentions.fileIntentions()[1].typeIntentions[0].properties[0].getter
        let bodySetter = intentions.fileIntentions()[1].typeIntentions[0].properties[0].setter?.body

        sut = FunctionBodyQueue.fromIntentionCollection(
            intentions,
            delegate: delegate,
            numThreads: 8
        )
        let items = sut.items

        XCTAssertEqual(items.count, 5)
        XCTAssert(items.contains(where: { $0.container.functionBody === global }))
        XCTAssert(items.contains(where: { $0.container.functionBody === deinitBody }))
        XCTAssert(items.contains(where: { $0.container.functionBody === bodyGetter1 }))
        XCTAssert(items.contains(where: { $0.container.functionBody === bodyGetter2 }))
        XCTAssert(items.contains(where: { $0.container.functionBody === bodySetter }))
    }

    func testQueuePropertyInitialValue() throws {
        let intentions =
            IntentionCollectionBuilder()
            .createFile(named: "A") { file in
                file.createClass(withName: "A") { type in
                    type.createProperty(named: "a", type: .int) { prop in
                        prop.setInitialExpression(.identifier("a"))
                    }
                }
            }.build()
        let prop = intentions.fileIntentions()[0].typeIntentions[0].properties[0]
        let initialValue = try XCTUnwrap(prop.initialValueIntention)

        sut = FunctionBodyQueue.fromIntentionCollection(
            intentions,
            delegate: delegate,
            numThreads: 8
        )
        let items = sut.items

        XCTAssertEqual(items.count, 1)
        XCTAssert(items.contains(where: { 
            ($0.container.expression == initialValue.expression) && ($0.intention == .propertyInitializer(prop, initialValue))
        }))
    }

    func testQueueGlobalVariableInitialValue() throws {
        let intentions =
            IntentionCollectionBuilder()
            .createFile(named: "A") { file in
                file.createGlobalVariable(
                    withName: "a",
                    type: .int,
                    initialExpression: .identifier("a")
                )
            }.build()
        let variable = intentions.fileIntentions()[0].globalVariableIntentions[0]
        let initialValue = try XCTUnwrap(variable.initialValueIntention)

        sut = FunctionBodyQueue.fromIntentionCollection(
            intentions,
            delegate: delegate,
            numThreads: 8
        )
        let items = sut.items

        XCTAssertEqual(items.count, 1)
        XCTAssert(items.contains(where: { 
            ($0.container.expression == initialValue.expression) && ($0.intention == .globalVariable(variable, initialValue))
        }))
    }
}
