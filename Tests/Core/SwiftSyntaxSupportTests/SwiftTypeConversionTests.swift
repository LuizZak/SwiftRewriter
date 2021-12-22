import SwiftAST
import SwiftSyntaxSupport
import XCTest

class SwiftTypeConversionTests: XCTestCase {

    func testTypeNameString() {
        expectSwift(.typeName("MyType"), toConvertTo: "MyType")
        expectSwift(.optional(.typeName("MyType")), toConvertTo: "MyType?")
        expectSwift(.implicitUnwrappedOptional(.typeName("MyType")), toConvertTo: "MyType!")
        expectSwift(.int, toConvertTo: "Int")
        expectSwift(.array(.int), toConvertTo: "[Int]")
        expectSwift(.dictionary(key: .int, value: .string), toConvertTo: "[Int: String]")
        expectSwift(.optional(.array(.int)), toConvertTo: "[Int]?")
        expectSwift(
            .optional(.dictionary(key: .int, value: .string)),
            toConvertTo: "[Int: String]?"
        )
        expectSwift(
            .protocolComposition([.typeName("Type1"), .typeName("Type2")]),
            toConvertTo: "Type1 & Type2"
        )
        expectSwift(
            .optional(.protocolComposition([.typeName("Type1"), .typeName("Type2")])),
            toConvertTo: "(Type1 & Type2)?"
        )
        expectSwift(.swiftBlock(returnType: .int, parameters: [.int]), toConvertTo: "(Int) -> Int")
        expectSwift(
            .optional(.swiftBlock(returnType: .int, parameters: [.int])),
            toConvertTo: "((Int) -> Int)?"
        )
        expectSwift(.metatype(for: .int), toConvertTo: "Int.Type")
        expectSwift(.tuple(.empty), toConvertTo: "Void")
        expectSwift(.tuple(.types([.int, .int])), toConvertTo: "(Int, Int)")
    }
}

extension SwiftTypeConversionTests {
    private func expectSwift(
        _ type: SwiftType,
        toConvertTo expected: String,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {

        let converted = typeMapperConvert(type)

        if converted != expected {
            XCTFail(
                """
                Expected Swift type \(type) to convert into '\(expected)', but \
                received '\(converted)' instead.
                """,
                file: file,
                line: line
            )
        }
    }

    private func typeMapperConvert(_ type: SwiftType) -> String {
        return SwiftTypeConverter.makeTypeSyntax(type, startTokenHandler: NullStartTokenHandler())
            .description
    }
}
