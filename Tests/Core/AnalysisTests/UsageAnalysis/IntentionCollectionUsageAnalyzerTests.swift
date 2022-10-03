import Intentions
import KnownType
import SwiftAST
import TestCommons
import TypeSystem
import XCTest

@testable import Analysis

class IntentionCollectionUsageAnalyzerTests: XCTestCase {
    func testFindMethodUsages() {
        let builder = IntentionCollectionBuilder()
        let body: CompoundStatement = [
            // B().b()
            .expression(
                Expression
                    .identifier("B").call()
                    .dot("b").call()
            )
        ]

        builder
            .createFile(named: "A.m") { file in
                file
                    .createClass(withName: "A") { builder in
                        builder.createVoidMethod(named: "f1") { method in
                            method.setBody(body)
                        }
                    }
                    .createClass(withName: "B") { builder in
                        builder
                            .createConstructor()
                            .createVoidMethod(named: "b")
                    }
            }
        let intentions = builder.build(typeChecked: true)
        let sut = IntentionCollectionUsageAnalyzer(
            intentions: intentions,
            typeSystem: TypeSystem(),
            numThreads: 8
        )
        let method = intentions.fileIntentions()[0].typeIntentions[1].methods[0]

        let usages = sut.findUsagesOf(method: method)

        XCTAssertEqual(
            usages[0].expression.expression,
            Expression
                .identifier("B").call()
                .dot("b")
        )

        XCTAssertEqual(usages.count, 1)
    }

    func testFindMethodUsagesWithRecursiveCall() {
        let builder = IntentionCollectionBuilder()

        let body: CompoundStatement = [
            // B().b().b()
            .expression(
                Expression
                    .identifier("B").call()
                    .dot("b").call()
                    .dot("b").call()
            )
        ]

        builder
            .createFile(named: "A.m") { file in
                file
                    .createClass(withName: "A") { builder in
                        builder.createVoidMethod(named: "f1") { method in
                            method.setBody(body)
                        }
                    }
                    .createClass(withName: "B") { builder in
                        builder
                            .createConstructor()
                            .createMethod(
                                named: "b",
                                returnType: .typeName("B"),
                                parameters: []
                            )
                    }
            }
        let intentions = builder.build(typeChecked: true)
        let sut = IntentionCollectionUsageAnalyzer(
            intentions: intentions,
            typeSystem: TypeSystem(),
            numThreads: 8
        )
        let method = intentions.fileIntentions()[0].typeIntentions[1].methods[0]

        let usages = sut.findUsagesOf(method: method)

        XCTAssertEqual(usages.count, 2)
    }

    func testFindPropertyUsages() {
        let builder = IntentionCollectionBuilder()

        let body: CompoundStatement = [
            // B().b()
            .expression(
                Expression
                    .identifier("B").call()
                    .dot("b").call()
            )
        ]

        builder
            .createFile(named: "A.m") { file in
                file
                    .createClass(withName: "A") { builder in
                        builder.createVoidMethod(named: "f1") { method in
                            method.setBody(body)
                        }
                    }
                    .createClass(withName: "B") { builder in
                        builder
                            .createConstructor()
                            .createProperty(named: "b", type: .int)
                    }
            }
        let intentions = builder.build(typeChecked: true)
        let sut = IntentionCollectionUsageAnalyzer(
            intentions: intentions,
            typeSystem: TypeSystem(),
            numThreads: 8
        )
        let property = intentions.fileIntentions()[0].typeIntentions[1].properties[0]

        let usages = sut.findUsagesOf(property: property)

        XCTAssertEqual(usages.count, 1)
    }

    func testFindEnumMemberUsage() {
        let builder = IntentionCollectionBuilder()

        let body: CompoundStatement = [
            // B.B_a
            .expression(
                .identifier("B").dot("B_a")
            )
        ]

        builder
            .createFile(named: "A.m") { file in
                file
                    .createClass(withName: "A") { builder in
                        builder.createVoidMethod(named: "f1") { method in
                            method.setBody(body)
                        }
                    }
                    .createEnum(withName: "B", rawValue: .int) { builder in
                        builder.createCase(name: "B_a")
                    }
            }

        let intentions = builder.build(typeChecked: true)
        let sut = IntentionCollectionUsageAnalyzer(
            intentions: intentions,
            typeSystem: TypeSystem(),
            numThreads: 8
        )
        let property = intentions.fileIntentions()[0].enumIntentions[0].cases[0]

        let usages = sut.findUsagesOf(property: property)

        XCTAssertEqual(usages.count, 1)
    }

    /// Tests that we can properly find usages of class members on subclass
    /// instances
    func testFindUsagesOfSuperclassMemberInSubclassInstances() {
        let builder = IntentionCollectionBuilder()

        let body: CompoundStatement = [
            // self.a
            .expression(
                Expression
                    .identifier("self")
                    .dot("a")
            )
        ]

        builder
            .createFile(named: "A.m") { file in
                file
                    .createClass(withName: "A") { builder in
                        builder.createProperty(named: "a", type: .int)
                    }
                    .createClass(withName: "B") { builder in
                        builder
                            .createConstructor()
                            .inherit(from: "A")
                            .createVoidMethod(named: "test") { method in
                                method.setBody(body)
                            }
                    }
            }

        let intentions = builder.build(typeChecked: true)
        let sut = IntentionCollectionUsageAnalyzer(
            intentions: intentions,
            typeSystem: TypeSystem(),
            numThreads: 8
        )
        let property = intentions.fileIntentions()[0].classIntentions[0].properties[0]

        let usages = sut.findUsagesOf(property: property)

        XCTAssertEqual(usages.count, 1)
    }

    func testFindGlobalFunctionUsages() {
        let builder = IntentionCollectionBuilder()
        let body: CompoundStatement = [
            // globalFunc()
            .expression(
                Expression
                    .identifier("globalFunc").call()
            )
        ]

        builder
            .createFile(named: "A.m") { file in
                file
                    .createGlobalFunction(withName: "globalFunc")
                    .createClass(withName: "A") { builder in
                        builder.createVoidMethod(named: "f1") { method in
                            method.setBody(body)
                        }
                    }
            }
        let intentions = builder.build(typeChecked: true)
        let sut = IntentionCollectionUsageAnalyzer(
            intentions: intentions,
            typeSystem: TypeSystem(),
            numThreads: 8
        )
        let function = intentions.fileIntentions()[0].globalFunctionIntentions[0]

        let usages = sut.findUsagesOf(function: function)

        XCTAssertEqual(
            usages[0].expression.expression,
            Expression
                .identifier("globalFunc")
        )

        XCTAssertEqual(usages.count, 1)
    }

    func testFindGlobalFunctionUsages_detectsOverloads() {
        let builder = IntentionCollectionBuilder()
        let body: CompoundStatement = [
            // globalFunc(0)
            .expression(
                Expression
                    .identifier("globalFunc").call([.constant(0)])
            ),
            // globalFunc("")
            .expression(
                Expression
                    .identifier("globalFunc").call([.constant("")])
            )
        ]

        builder
            .createFile(named: "A.m") { file in
                file
                    .createGlobalFunction(withName: "globalFunc", parameters: [
                        .init(label: nil, name: "i", type: .int),
                    ])
                    .createGlobalFunction(withName: "globalFunc", parameters: [
                        .init(label: nil, name: "s", type: .string),
                    ])
                    .createClass(withName: "A") { builder in
                        builder.createVoidMethod(named: "f1") { method in
                            method.setBody(body)
                        }
                    }
            }
        let intentions = builder.build(typeChecked: true)
        let sut = IntentionCollectionUsageAnalyzer(
            intentions: intentions,
            typeSystem: TypeSystem(),
            numThreads: 8
        )
        let functionInt = intentions.fileIntentions()[0].globalFunctionIntentions[0]
        let functionStr = intentions.fileIntentions()[0].globalFunctionIntentions[1]

        let usagesInt = sut.findUsagesOf(function: functionInt)
        let usagesStr = sut.findUsagesOf(function: functionStr)

        XCTAssertEqual(
            usagesInt.first?.expression.expression,
            Expression
                .identifier("globalFunc")
        )
        XCTAssertEqual(usagesInt.count, 1)
        XCTAssertEqual(
            usagesStr.first?.expression.expression,
            Expression
                .identifier("globalFunc")
        )
        XCTAssertEqual(usagesStr.count, 1)
    }
}
