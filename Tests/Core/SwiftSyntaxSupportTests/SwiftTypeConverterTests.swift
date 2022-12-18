import XCTest
import SwiftAST

@testable import SwiftSyntaxSupport

class SwiftTypeConverterTests: XCTestCase {

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
        expectSwift(.tuple([.int, .int]), toConvertTo: "(Int, Int)")
    }

    func testNullabilityUnspecified_promotesToOptional_genericParameter() {
        expectSwift(
            .generic("TypeName", parameters: [.nullabilityUnspecified(.string)]),
            toConvertTo: "TypeName<String?>"
        )
        expectSwift(
            .generic(
                "UnsafePointer",
                parameters: [
                    .nullabilityUnspecified(
                        .generic(
                            "UnsafePointer",
                            parameters: [
                                .nullabilityUnspecified(
                                    .generic("UnsafePointer", parameters: ["CChar"])
                                )
                            ]
                        )
                    )
                ]
            ),
            toConvertTo: "UnsafePointer<UnsafePointer<UnsafePointer<CChar>?>?>"
        )
    }

    func testNullabilityUnspecified_promotesToOptional_tupleType() {
        expectSwift(
            .tuple([.int, .nullabilityUnspecified(.int)]),
            toConvertTo: "(Int, Int?)"
        )
    }

    func testNullabilityUnspecified_promotesToOptional_blockParameter() {
        expectSwift(
            .swiftBlock(returnType: .void, parameters: [.nullabilityUnspecified(.string)]),
            toConvertTo: "(String?) -> Void"
        )
    }

    func testNullabilityUnspecified_promotesToOptional_blockReturnType() {
        expectSwift(
            .swiftBlock(returnType: .nullabilityUnspecified(.string)),
            toConvertTo: "() -> String?"
        )
    }
}

extension SwiftTypeConverterTests {
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
