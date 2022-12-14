import XCTest
import SwiftAST
import TypeSystem

@testable import TypeSystem

class CodeDefinitionTests: XCTestCase {
    func testVariadicFunctionParameterDefinition() {
        let signature = FunctionSignature(
            name: "a",
            parameters: [
                .init(name: "b", type: .int, isVariadic: true),
            ]
        )

        let result = CodeDefinition.forParameters(inSignature: signature)

        XCTAssertEqual(result, [
            .forLocalIdentifier(
                "b",
                type: .array(.int),
                isConstant: true,
                location: .parameter(index: 0)
            )
        ])
    }
}
