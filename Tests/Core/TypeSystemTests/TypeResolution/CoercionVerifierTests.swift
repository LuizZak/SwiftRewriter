import SwiftAST
import XCTest

@testable import TypeSystem

class CoercionVerifierTests: XCTestCase {
    private var typeSystem: TypeSystem!

    override func setUp() {
        super.setUp()

        typeSystem = TypeSystem()
    }

    override func tearDown() {
        super.tearDown()

        typeSystem = nil
    }

    // Identifier w/ type information

    func testIdentifier_canBeCoercedToMatchingType() {
        let fixture = makeFixture(type: .float)

        fixture
        .assertCanCoerce(
            .identifier("a").typed(.float).settingDefinition(
                LocalCodeDefinition.forLocalIdentifier(
                    "a",
                    type: .float,
                    isConstant: true,
                    location: .parameter(index: 0)
                )
            )
        )
        .assertCannotCoerce(
            .identifier("a").typed(.string).settingDefinition(
                LocalCodeDefinition.forLocalIdentifier(
                    "a",
                    type: .string,
                    isConstant: true,
                    location: .parameter(index: 0)
                )
            )
        )
    }

    // Any

    func testAnyType_canCoerceAllExpressions() {
        let fixture = makeFixture(type: .any)

        fixture
        .assertCanCoerce(
            .constant(.string("")),
            .constant(.int(0, .decimal)),
            .constant(.float(0)),
            .constant(.boolean(false)),
            .constant(.rawConstant("")),
            .constant(.nil),
            .binary(lhs: .constant(0), op: .add, rhs: .constant(0)),
            .arrayLiteral([.constant(true)])
        )
    }

    // String

    func testStringType_canOnlyCoerceStringConstants() {
        let fixture = makeFixture(type: .string)

        fixture
        .assertCanCoerce(
            .constant(.string(""))
        )
        .assertCannotCoerce(
            .constant(.int(0, .decimal)),
            .constant(.float(0)),
            .constant(.boolean(false)),
            .constant(.rawConstant("")),
            .constant(.nil)
        )
    }

    // Bool

    func testBoolType_canOnlyCoerceBoolConstants() {
        let fixture = makeFixture(type: .bool)

        fixture
        .assertCanCoerce(
            .constant(.boolean(false))
        )
        .assertCannotCoerce(
            .constant(.int(0, .decimal)),
            .constant(.float(0)),
            .constant(.string("")),
            .constant(.rawConstant("")),
            .constant(.nil)
        )
    }

    // Nil

    func testNilType_canOnlyCoerceNilConstants() {
        let fixture = makeFixture(type: .optional("A"))

        fixture
        .assertCanCoerce(
            .constant(.nil)
        )
        .assertCannotCoerce(
            .constant(.int(0, .decimal)),
            .constant(.float(0)),
            .constant(.string("")),
            .constant(.rawConstant("")),
            .constant(.boolean(false))
        )
    }

    // Float

    func testFloatType_integerConstant() {
        let fixture = makeFixture(type: .float)

        fixture.assertCanCoerce(
            .constant(.int(0, .decimal)),
            .constant(.int(0, .hexadecimal)),
            .constant(.int(0, .octal)),
            .constant(.int(0, .binary))
        )
    }

    func testFloatType_floatConstant() {
        let fixture = makeFixture(type: .float)

        fixture.assertCanCoerce(
            .constant(.float(0.0))
        )
    }

    func testFloatType_doubleConstant() {
        let fixture = makeFixture(type: .float)

        fixture.assertCanCoerce(
            .constant(.double(0))
        )
    }

    // Double

    func testDoubleType_integerConstant() {
        let fixture = makeFixture(type: .double)

        fixture.assertCanCoerce(
            .constant(.int(0, .decimal)),
            .constant(.int(0, .hexadecimal)),
            .constant(.int(0, .octal)),
            .constant(.int(0, .binary))
        )
    }

    func testDoubleType_floatConstant() {
        let fixture = makeFixture(type: .double)

        fixture.assertCanCoerce(
            .constant(.float(0.0))
        )
    }

    func testDoubleType_doubleConstant() {
        let fixture = makeFixture(type: .double)

        fixture.assertCanCoerce(
            .constant(.double(0))
        )
    }

    // Int

    func testIntType_integerConstant() {
        let fixture = makeFixture(type: .int)

        fixture.assertCanCoerce(
            .constant(.int(0, .decimal)),
            .constant(.int(0, .hexadecimal)),
            .constant(.int(0, .octal)),
            .constant(.int(0, .binary))
        )
    }

    func testIntType_floatConstant() {
        let fixture = makeFixture(type: .int)

        fixture.assertCannotCoerce(
            .constant(.float(0.0))
        )
    }

    // MARK: - Test internals

    private func makeFixture(type: SwiftType) -> TestFixture {
        TestFixture(type: type, typeSystem: typeSystem)
    }
}

private class TestFixture {
    let type: SwiftType
    let typeSystem: TypeSystem

    init(type: SwiftType, typeSystem: TypeSystem) {
        self.type = type
        self.typeSystem = typeSystem
    }

    @discardableResult
    func assert(
        _ exp: Expression,
        isCoercible: Bool,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> TestFixture {
        let result = makeSut().canCoerce(exp, toType: type)

        guard result != isCoercible else {
            return self
        }

        XCTFail(
            "Expected `\(exp)` to \(isCoercible ? "" : "not ")be coercible to `\(type)`, but it result was \(result).",
            file: file,
            line: line
        )

        return self
    }

    @discardableResult
    private func _assert(
        _ exps: [Expression],
        areCoercible: Bool,
        file: StaticString,
        line: UInt
    ) -> TestFixture {
        var result = self
        
        for exp in exps {
            result = result.assert(
                exp,
                isCoercible: areCoercible,
                file: file,
                line: line
            )
        }

        return result
    }

    @discardableResult
    func assert(
        _ exps: Expression...,
        areCoercible: Bool,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> TestFixture {

        _assert(exps, areCoercible: areCoercible, file: file, line: line)
    }

    @discardableResult
    func assertCanCoerce(
        _ exps: Expression...,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> TestFixture {

        _assert(exps, areCoercible: true, file: file, line: line)
    }

    @discardableResult
    func assertCannotCoerce(
        _ exps: Expression...,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> TestFixture {

        _assert(exps, areCoercible: false, file: file, line: line)
    }

    private func makeSut() -> CoercionVerifier {
        CoercionVerifier(typeSystem: typeSystem)
    }
}
