import SwiftAST
import XCTest

class MemberPostfixTests: XCTestCase {
    func testDescription() {
        let sut = MemberPostfix(name: "member")
        XCTAssertEqual(sut.description, ".member")
    }

    func testSafeOptionalDescription() {
        let sut = MemberPostfix(name: "member")
        sut.optionalAccessKind = .safeUnwrap
        XCTAssertEqual(sut.description, "?.member")
    }

    func testForceUnwrapOptionalDescription() {
        let sut = MemberPostfix(name: "member")
        sut.optionalAccessKind = .forceUnwrap
        XCTAssertEqual(sut.description, "!.member")
    }
}

class SubscriptPostfixTests: XCTestCase {
    func testDescription() {
        let sut = SubscriptPostfix(expression: .constant(0))
        XCTAssertEqual(sut.description, "[0]")
    }

    func testSafeOptionalDescription() {
        let sut = SubscriptPostfix(expression: .constant(0))
        sut.optionalAccessKind = .safeUnwrap
        XCTAssertEqual(sut.description, "?[0]")
    }

    func testForceUnwrapOptionalDescription() {
        let sut = SubscriptPostfix(expression: .constant(0))
        sut.optionalAccessKind = .forceUnwrap
        XCTAssertEqual(sut.description, "![0]")
    }
}

class FunctionCallPostfixTests: XCTestCase {
    func testDescription() {
        let arguments: [FunctionArgument] = [
            .init(label: "foo", expression: .constant(0)),
            .init(label: nil, expression: .constant(1)),
        ]
        let sut = FunctionCallPostfix(arguments: arguments)
        XCTAssertEqual(sut.description, "(foo: 0, 1)")
    }

    func testSafeOptionalDescription() {
        let arguments: [FunctionArgument] = [
            .init(label: "foo", expression: .constant(0)),
            .init(label: nil, expression: .constant(1)),
        ]
        let sut = FunctionCallPostfix(arguments: arguments)
        sut.optionalAccessKind = .safeUnwrap
        XCTAssertEqual(sut.description, "?(foo: 0, 1)")
    }

    func testForceUnwrapOptionalDescription() {
        let arguments: [FunctionArgument] = [
            .init(label: "foo", expression: .constant(0)),
            .init(label: nil, expression: .constant(1)),
        ]
        let sut = FunctionCallPostfix(arguments: arguments)
        sut.optionalAccessKind = .forceUnwrap
        XCTAssertEqual(sut.description, "!(foo: 0, 1)")
    }
}
