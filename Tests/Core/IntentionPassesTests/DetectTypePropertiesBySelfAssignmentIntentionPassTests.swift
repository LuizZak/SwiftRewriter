import Intentions
import SwiftAST
import TestCommons
import XCTest

@testable import IntentionPasses

class DetectTypePropertiesBySelfAssignmentIntentionPassTests: XCTestCase {
    func testDetectAssignOnInitializer() throws {
        try runTest(forStaticProperty: false, swiftType: .int) { (field, type) in
            type.createConstructor(withParameters: []) { builder in
                builder.setBody([
                    .expression(.identifier("self").dot(field).assignment(op: .assign, rhs: .constant(0))),
                ])
            }
        }
    }

    func testDetectAssignOnMethod() throws {
        try runTest(forStaticProperty: false, swiftType: .int) { (field, type) in
            type.createMethod(named: "method") { builder in
                builder.setBody([
                    .expression(.identifier("self").dot(field).assignment(op: .assign, rhs: .constant(0))),
                ])
            }
        }
    }

    func testDetectAssignOnStaticMethod() throws {
        try runTest(forStaticProperty: true, swiftType: .int) { (field, type) in
            type.createMethod(named: "method", isStatic: true) { builder in
                builder.setBody([
                    .expression(.identifier("self").dot(field).assignment(op: .assign, rhs: .constant(0))),
                ])
            }
        }
    }

    func testDetectTypeOnAssignment() throws {
        try runTest(forStaticProperty: false, swiftType: .float) { (field, type) in
            type.createConstructor(withParameters: []) { builder in
                builder.setBody([
                    .variableDeclaration(identifier: "v", type: .float, initialization: .constant(0)),
                    .expression(.identifier("self").dot(field).assignment(op: .assign, rhs: .identifier("v"))),
                ])
            }
        }
    }

    func testDetectTypeOnAssignment_decideOnMostSpecificType() throws {
        try runTest(forStaticProperty: false, swiftType: .float) { (field, type) in
            type.createConstructor(withParameters: []) { builder in
                builder.setBody([
                    .expression(.identifier("self").dot(field)),
                    .variableDeclaration(identifier: "v", type: .float, initialization: .constant(0)),
                    .expression(.identifier("self").dot(field).assignment(op: .assign, rhs: .identifier("v"))),
                ])
            }
        }
    }

    func testDetectTypeOnAssignment_ignoreErrorTypes() throws {
        try runTest(forStaticProperty: false, swiftType: .any) { (field, type) in
            type.createConstructor(withParameters: []) { builder in
                builder.setBody([
                    .expression(.identifier("self").dot(field).assignment(op: .assign, rhs: .identifier("unknown"))),
                ])
            }
        }
    }

    func testDontDuplicateProperties() throws {
        try runTest(forStaticProperty: false, swiftType: .int) { (field, type) in
            type.createMethod(named: "method") { builder in
                builder.setBody([
                    .expression(.identifier("self").dot(field).assignment(op: .assign, rhs: .constant(0))),
                    .expression(.identifier("self").dot(field).assignment(op: .assign, rhs: .constant(1))),
                ])
            }
        }
    }

    func testDontDuplicateExistingProperties() throws {
        let intentions =
            IntentionCollectionBuilder()
            .createFileWithClass(named: "A") { type in
                type.createConstructor() { builder in
                    builder.setBody([
                        .expression(.identifier("self").dot("property").assignment(op: .equals, rhs: .constant(0))),
                    ])
                }.createProperty(
                    named: "property",
                    type: .int
                )
            }.build(typeChecked: true)
        let sut = DetectTypePropertiesBySelfAssignmentIntentionPass()

        sut.apply(on: intentions, context: makeContext(intentions: intentions))

        let type = try intentions.fileIntentions()[try: 0].classIntentions[try: 0]

        XCTAssertEqual(type.properties.count, 1)
        try XCTAssertEqual(type.properties[try: 0].name, "property")
        try XCTAssertEqual(type.properties[try: 0].type, .int)
    }

    func testDontDuplicateExistingInstanceVariables() throws {
        let intentions =
            IntentionCollectionBuilder()
            .createFileWithClass(named: "A") { type in
                type.createConstructor() { builder in
                    builder.setBody([
                        .expression(.identifier("self").dot("variable").assignment(op: .equals, rhs: .constant(0))),
                    ])
                }.createInstanceVariable(
                    named: "variable",
                    type: .int
                )
            }.build(typeChecked: true)
        let sut = DetectTypePropertiesBySelfAssignmentIntentionPass()

        sut.apply(on: intentions, context: makeContext(intentions: intentions))

        let type = try intentions.fileIntentions()[try: 0].classIntentions[try: 0]

        XCTAssertEqual(type.properties.count, 0)
        XCTAssertEqual(type.instanceVariables.count, 1)
        try XCTAssertEqual(type.instanceVariables[try: 0].name, "variable")
        try XCTAssertEqual(type.instanceVariables[try: 0].type, .int)
    }

    // MARK: - Test internals

    private func runTest(forStaticProperty isStatic: Bool = false, swiftType: SwiftType, builder: (_ fieldName: String, TypeBuilder<ClassGenerationIntention>) -> Void, line: UInt = #line) throws {
        let intentions =
            IntentionCollectionBuilder()
            .createFileWithClass(named: "A") { type in
                builder("field", type)
            }.build(typeChecked: true)
        let sut = DetectTypePropertiesBySelfAssignmentIntentionPass()

        sut.apply(on: intentions, context: makeContext(intentions: intentions))

        let type = try intentions.fileIntentions()[try: 0].classIntentions[try: 0]

        XCTAssertEqual(type.properties.count, 1, line: line)
        try XCTAssertEqual(type.properties[try: 0].name, "field", line: line)
        try XCTAssertEqual(type.properties[try: 0].type, swiftType, line: line)
        try XCTAssertEqual(type.properties[try: 0].isStatic, isStatic, line: line)
    }
}
