import GrammarModels
import ObjcParser
import SwiftAST
import TypeSystem
import XCTest

class DefaultTypeMapperTests: XCTestCase {
    var typeSystem = TypeSystem()

    override func setUp() {
        super.setUp()

        typeSystem = TypeSystem()
    }

    func testSugarizeArraySwiftType() {
        let sut = makeDefaultTypeMapper()

        XCTAssertEqual(
            sut.sugarizeSwiftType(SwiftType.generic("Array", parameters: ["Inner"])),
            SwiftType.array("Inner")
        )

        XCTAssertEqual(
            sut.sugarizeSwiftType(SwiftType.generic("Array", parameters: ["Inner", "Inner2"])),
            SwiftType.generic("Array", parameters: ["Inner", "Inner2"])
        )
    }

    func testSugarizeArrayDictionarySwiftType() {
        let sut = makeDefaultTypeMapper()

        XCTAssertEqual(
            sut.sugarizeSwiftType(SwiftType.generic("Dictionary", parameters: ["Key", "Value"])),
            SwiftType.dictionary(key: "Key", value: "Value")
        )

        XCTAssertEqual(
            sut.sugarizeSwiftType(SwiftType.generic("Dictionary", parameters: ["Element"])),
            SwiftType.generic("Dictionary", parameters: ["Element"])
        )
    }

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
        expectSwift(.metatype(for: .int), toConvertTo: "Int.self")
        expectSwift(.tuple(.empty), toConvertTo: "Void")
        expectSwift(.tuple(.types([.int, .int])), toConvertTo: "(Int, Int)")
    }

    func testConvertNSObjectSubclassPointersAsInstanceTypes() {
        expect(.pointer(.typeName("NSNumber")), toConvertTo: "NSNumber")
        expect(.pointer(.typeName("NSInteger")), toConvertTo: "UnsafeMutablePointer<Int>")
        expect(.pointer(.typeName("NSUInteger")), toConvertTo: "UnsafeMutablePointer<UInt>")
        expect(.pointer(.typeName("NSUInteger")), toConvertTo: "UnsafeMutablePointer<UInt>")
        expect(
            .pointer(.typeName("UIButtonType")), toConvertTo: "UnsafeMutablePointer<UIButtonType>")

        expect(
            .pointer(.typeName("char")),
            withExplicitNullability: .nullable,
            toConvertTo: "UnsafeMutablePointer<CChar>?")
    }

    func testPrimitiveTypes() {
        // Objective-C/Foundation/CoreGraphics types
        expect(.typeName("NSInteger"), toConvertTo: "Int")
        expect(.typeName("NSUInteger"), toConvertTo: "UInt")
        expect(.typeName("BOOL"), toConvertTo: "Bool")
        expect(.typeName("CGColor"), toConvertTo: "CGColor")
    }

    func testCScalarTypes() {
        // Reference: https://github.com/apple/swift/blob/cc8ef9d17050d2684111f2fcdd2e94b63d8e43cc/stdlib/public/core/CTypes.swift#L19

        /*
        /// The C 'char' type.
        ///
        /// This will be the same as either `CSignedChar` (in the common
        /// case) or `CUnsignedChar`, depending on the platform.
        public typealias CChar = Int8

        /// The C 'unsigned char' type.
        public typealias CUnsignedChar = UInt8

        /// The C 'unsigned short' type.
        public typealias CUnsignedShort = UInt16

        /// The C 'unsigned int' type.
        public typealias CUnsignedInt = UInt32

        /// The C 'unsigned long' type.
        public typealias CUnsignedLong = UInt

        /// The C 'unsigned long long' type.
        public typealias CUnsignedLongLong = UInt64

        /// The C 'signed char' type.
        public typealias CSignedChar = Int8

        /// The C 'short' type.
        public typealias CShort = Int16

        /// The C 'int' type.
        public typealias CInt = Int32

        /// The C 'long' type.
        public typealias CLong = Int

        /// The C 'long long' type.
        public typealias CLongLong = Int64

        /// The C 'float' type.
        public typealias CFloat = Float

        /// The C 'double' type.
        public typealias CDouble = Double

        /// The C++ 'wchar_t' type.
        public typealias CWideChar = Unicode.Scalar

        /// The C++11 'char16_t' type, which has UTF-16 encoding.
        public typealias CChar16 = UInt16

        /// The C++11 'char32_t' type, which has UTF-32 encoding.
        public typealias CChar32 = Unicode.Scalar

        /// The C '_Bool' and C++ 'bool' type.
        public typealias CBool = Bool
        */

        // C scalar types
        expect(.typeName("char"), toConvertTo: "CChar")

        expect(.typeName("signed char"), toConvertTo: "CSignedChar")

        expect(.typeName("short"), toConvertTo: "CShort")
        expect(.typeName("short int"), toConvertTo: "CShort")
        expect(.typeName("signed short int"), toConvertTo: "CShort")

        expect(.typeName("int"), toConvertTo: "CInt")
        expect(.typeName("signed"), toConvertTo: "CInt")
        expect(.typeName("signed int"), toConvertTo: "CInt")

        expect(.typeName("long"), toConvertTo: "CLong")
        expect(.typeName("long int"), toConvertTo: "CLong")
        expect(.typeName("signed long int"), toConvertTo: "CLong")
        expect(.typeName("long long"), toConvertTo: "CLongLong")
        expect(.typeName("long long int"), toConvertTo: "CLongLong")
        expect(.typeName("signed long long int"), toConvertTo: "CLongLong")

        expect(.typeName("unsigned char"), toConvertTo: "CUnsignedChar")

        expect(.typeName("unsigned short"), toConvertTo: "CUnsignedShort")
        expect(.typeName("unsigned short int"), toConvertTo: "CUnsignedShort")

        expect(.typeName("unsigned"), toConvertTo: "CUnsignedInt")
        expect(.typeName("unsigned int"), toConvertTo: "CUnsignedInt")

        expect(.typeName("unsigned long"), toConvertTo: "CUnsignedLong")
        expect(.typeName("unsigned long int"), toConvertTo: "CUnsignedLong")

        expect(.typeName("unsigned long long"), toConvertTo: "CUnsignedLongLong")
        expect(.typeName("unsigned long long int"), toConvertTo: "CUnsignedLongLong")

        expect(.typeName("float"), toConvertTo: "CFloat")
        expect(.typeName("double"), toConvertTo: "CDouble")
        expect(.typeName("wchar_t"), toConvertTo: "CWideChar")
        expect(.typeName("char16_t"), toConvertTo: "CChar16")
        expect(.typeName("char32_t"), toConvertTo: "CChar32")
        expect(.typeName("Bool"), toConvertTo: "CBool")

        // Pointer of C scalar types
        expect(.pointer(.typeName("char")), toConvertTo: "UnsafeMutablePointer<CChar>")
        expect(.pointer(.typeName("signed")), toConvertTo: "UnsafeMutablePointer<CInt>")
        expect(.pointer(.typeName("unsigned")), toConvertTo: "UnsafeMutablePointer<CUnsignedInt>")
        expect(
            .pointer(.typeName("unsigned char")),
            toConvertTo: "UnsafeMutablePointer<CUnsignedChar>"
        )
        expect(
            .pointer(.typeName("unsigned short")),
            toConvertTo: "UnsafeMutablePointer<CUnsignedShort>")
        expect(
            .pointer(.typeName("unsigned int")),
            toConvertTo: "UnsafeMutablePointer<CUnsignedInt>")
        expect(
            .pointer(.typeName("unsigned long")),
            toConvertTo: "UnsafeMutablePointer<CUnsignedLong>"
        )
        expect(
            .pointer(.typeName("unsigned long long")),
            toConvertTo: "UnsafeMutablePointer<CUnsignedLongLong>"
        )
        expect(.pointer(.typeName("signed char")), toConvertTo: "UnsafeMutablePointer<CSignedChar>")
        expect(.pointer(.typeName("short")), toConvertTo: "UnsafeMutablePointer<CShort>")
        expect(.pointer(.typeName("int")), toConvertTo: "UnsafeMutablePointer<CInt>")
        expect(.pointer(.typeName("long")), toConvertTo: "UnsafeMutablePointer<CLong>")
        expect(.pointer(.typeName("long long")), toConvertTo: "UnsafeMutablePointer<CLongLong>")
        expect(.pointer(.typeName("float")), toConvertTo: "UnsafeMutablePointer<CFloat>")
        expect(.pointer(.typeName("double")), toConvertTo: "UnsafeMutablePointer<CDouble>")
        expect(.pointer(.typeName("wchar_t")), toConvertTo: "UnsafeMutablePointer<CWideChar>")
        expect(.pointer(.typeName("char16_t")), toConvertTo: "UnsafeMutablePointer<CChar16>")
        expect(.pointer(.typeName("char32_t")), toConvertTo: "UnsafeMutablePointer<CChar32>")
        expect(.pointer(.typeName("Bool")), toConvertTo: "UnsafeMutablePointer<CBool>")
    }

    func testMapSimpleTypes() {
        expect(
            .id(),
            toConvertTo: "AnyObject"
        )

        expect(
            .instancetype,
            toConvertTo: "__instancetype"
        )

        expect(
            .instancetype,
            withExplicitNullability: .nullable,
            toConvertTo: "__instancetype?"
        )

        expect(
            .id(protocols: ["UITableViewDelegate"]),
            withExplicitNullability: .nullable,
            toConvertTo: "UITableViewDelegate?"
        )

        expect(
            .id(protocols: ["UITableViewDelegate", "UITableViewDataSource"]),
            withExplicitNullability: .nullable,
            toConvertTo: "(UITableViewDelegate & UITableViewDataSource)?"
        )

        expect(
            .specified(specifiers: [.weak], .id()),
            withExplicitNullability: nil,
            toConvertTo: "AnyObject?"
        )
    }

    func testQualifiedAndSpecifiedTypesDoNotMapIntoPointersAutomatically() {
        expect(
            .qualified(.typeName("NSInteger"), qualifiers: [.const]),
            toConvertTo: "Int"
        )

        expect(
            .qualified(.typeName("NSInteger"), qualifiers: [.const]),
            withExplicitNullability: nil,
            toConvertTo: "Int"
        )

        expect(
            .qualified(.typeName("NSInteger"), qualifiers: [.const]),
            toConvertTo: "Int"
        )

        expect(
            .qualified(.typeName("NSInteger"), qualifiers: [.const]),
            withExplicitNullability: nil,
            toConvertTo: "Int"
        )
    }

    /// Test we properly map NS- types into equivalent Swift types (as of Swift 4.1).
    func testMapNSTypes() {
        expect(.pointer(.typeName("NSDate")), toConvertTo: "Date")
        expect(.pointer(.typeName("NSString")), toConvertTo: "String")
        expect(.pointer(.typeName("NSObject")), toConvertTo: "NSObject")
        expect(.pointer(.typeName("NSCalendar")), toConvertTo: "Calendar")
        expect(.pointer(.typeName("NSURL")), toConvertTo: "URL")
        expect(.pointer(.typeName("NSURLComponents")), toConvertTo: "URLComponents")
        expect(.pointer(.typeName("NSError")), toConvertTo: "Error")
        expect(.pointer(.typeName("NSIndexPath")), toConvertTo: "IndexPath")
        expect(.pointer(.typeName("NSIndexSet")), toConvertTo: "IndexSet")
        expect(.pointer(.typeName("NSNotificationCenter")), toConvertTo: "NotificationCenter")
        expect(.pointer(.typeName("NSNotification")), toConvertTo: "Notification")
        expect(.pointer(.typeName("NSTimeZone")), toConvertTo: "TimeZone")
        expect(.pointer(.typeName("NSLocale")), toConvertTo: "Locale")
        expect(.pointer(.typeName("NSDateFormatter")), toConvertTo: "DateFormatter")
        expect(.pointer(.typeName("NSNumberFormatter")), toConvertTo: "NumberFormatter")

        expect(.typeName("NSTimeInterval"), toConvertTo: "TimeInterval")
        expect(.typeName("NSComparisonResult"), toConvertTo: "ComparisonResult")
        expect(.typeName("NSInteger"), toConvertTo: "Int")
        expect(.typeName("NSUInteger"), toConvertTo: "UInt")
    }

    func testPointer() {
        expect(.pointer("NSObject"), toConvertTo: "NSObject")
    }

    func testPointer_withNullabilitySpecifier() {
        expect(
            .pointer("NSObject", nullabilitySpecifier: .nonnull),
            toConvertTo: "NSObject"
        )
        expect(
            .pointer("NSObject", nullabilitySpecifier: .nullable),
            toConvertTo: "NSObject?"
        )
        expect(
            .pointer("NSObject", nullabilitySpecifier: .nullResettable),
            toConvertTo: "NSObject!"
        )
        expect(
            .pointer("NSObject", nullabilitySpecifier: .nullResettable),
            toConvertTo: "NSObject!"
        )
    }

    func testNSArray() {
        expect(
            .pointer(.genericTypeName("NSArray", typeParameters: [.pointer(.typeName("NSObject"))])),
            toConvertTo: "[NSObject]"
        )
        expect(
            .pointer(.genericTypeName("NSArray", parameters: [.init(variance: .covariant, type: .pointer(.typeName("NSObject")))])),
            toConvertTo: "[NSObject]"
        )

        expect(
            .pointer(.genericTypeName("NSArray", typeParameters: [.pointer(.typeName("NSString"))])),
            toConvertTo: "[String]"
        )

        expect(
            .pointer(.genericTypeName("NSArray", typeParameters: [])),
            toConvertTo: "NSArray"
        )
        expect(
            .pointer(.typeName("NSArray")),
            toConvertTo: "NSArray"
        )
    }

    func testNestedNSArray() {
        expect(
            .genericTypeName(
                "NSArray",
                typeParameters: [
                    .genericTypeName(
                        "NSArray",
                        typeParameters: [
                            .pointer(
                                .typeName("NSObject")
                            )
                        ]
                    ).wrapAsPointer
                ]
            ).wrapAsPointer,
            toConvertTo: "[[NSObject]]"
        )
    }

    func testNSDictionary() {
        expect(
            .pointer(
                .genericTypeName(
                    "NSDictionary",
                    typeParameters: [.pointer(.typeName("NSString")), .pointer(.typeName("NSObject"))]
                )
            ),
            toConvertTo: "[String: NSObject]"
        )

        expect(
            .pointer(
                .genericTypeName("NSDictionary", typeParameters: [.pointer(.typeName("NSString"))])
            ),
            toConvertTo: "NSDictionary<String>"
        )
    }

    /// NSMutableArray is kept alone since its pass-by-reference semantics are
    /// not fully compatible with Swift's array...
    func testNSMutableArray() {
        expect(
            .pointer(
                .genericTypeName("NSMutableArray", typeParameters: [.pointer(.typeName("NSObject"))])),
            toConvertTo: "NSMutableArray"
        )

        expect(
            .pointer(
                .genericTypeName("NSMutableArray", typeParameters: [.pointer(.typeName("NSString"))])),
            toConvertTo: "NSMutableArray"
        )

        expect(
            .pointer(.genericTypeName("NSMutableArray", parameters: [])),
            toConvertTo: "NSMutableArray"
        )
        expect(
            .pointer(.typeName("NSMutableArray")),
            toConvertTo: "NSMutableArray"
        )
    }

    /// ...ditto for NSMutableDictionary
    func testNSMutableDictionary() {
        expect(
            .pointer(
                .genericTypeName(
                    "NSMutableDictionary",
                    typeParameters: [.pointer(.typeName("NSString")), .pointer(.typeName("NSObject"))]
                )
            ),
            toConvertTo: "NSMutableDictionary"
        )
    }

    func testNSMutableDictionaryWithSingleTypeParameter() {
        expect(
            .pointer(
                .genericTypeName(
                    "NSMutableDictionary",
                    typeParameters: [.pointer(.typeName("NSString"))]
                )
            ),
            toConvertTo: "NSMutableDictionary<String>"
        )
    }

    func testNestedTypeInGenericIsAlwaysReadAsObjectType() {
        expect(
            ObjcType.genericTypeName("A", typeParameters: [.pointer(.typeName("B"))]),
            toConvertTo: "A<B>"
        )
        expect(
            ObjcType.genericTypeName(
                "A", typeParameters: [.pointer(.typeName("B")), .pointer(.typeName("C"))]
            ),
            toConvertTo: "A<B, C>"
        )
    }

    func testConcreteTypesWithProtocol() {
        expect(
            .pointer(.genericTypeName("UIView", typeParameters: [.typeName("UIDelegate")])),
            toConvertTo: "UIView & UIDelegate"
        )
        expect(
            .pointer(.genericTypeName("UIView", typeParameters: [.typeName("UIDelegate")])),
            withExplicitNullability: .nullable,
            toConvertTo: "(UIView & UIDelegate)?"
        )
    }

    func testBlockTypes() {
        expect(
            .blockType(name: "block", returnType: .void, parameters: []),
            toConvertTo: "() -> Void"
        )

        expect(
            .blockType(
                name: "block",
                returnType: .typeName("NSInteger"),
                parameters: []
            ),
            toConvertTo: "() -> Int"
        )

        expect(
            .blockType(
                name: "block",
                returnType: .typeName("NSInteger"),
                parameters: [
                    .pointer(.typeName("NSString")),
                    .pointer(.typeName("NSString")),
                ]
            ),
            withExplicitNullability: nil,
            toConvertTo: "((String?, String?) -> Int)!"
        )

        expect(
            .blockType(
                name: "block",
                returnType: .typeName("NSInteger"),
                parameters: [
                    .pointer(.typeName("NSString")),
                    .pointer(.typeName("NSString")),
                ]
            ),
            inNonnullContext: true,
            toConvertTo: "(String, String) -> Int"
        )

        expect(
            .blockType(
                name: "block",
                returnType: .typeName("NSInteger"),
                parameters: [
                    .pointer(.typeName("NSString"), nullabilitySpecifier: .nullable),
                    .pointer(.typeName("NSString")),
                ]),
            withExplicitNullability: nil,
            toConvertTo: "((String?, String?) -> Int)!"
        )

        expect(
            .blockType(
                name: "block",
                returnType: .typeName("NSInteger"),
                parameters: [
                    .pointer(.typeName("NSString"), nullabilitySpecifier: .nonnull),
                    .pointer(.typeName("NSString")),
                ]),
            withExplicitNullability: nil,
            toConvertTo: "((String, String?) -> Int)!"
        )

        expect(
            .blockType(
                name: "block",
                returnType: .typeName("NSInteger"),
                parameters: [
                    .pointer(.typeName("NSString"), nullabilitySpecifier: .nonnull),
                    .pointer(.typeName("NSString"), nullabilitySpecifier: .nullable),
                ]),
            withExplicitNullability: .nonnull,
            toConvertTo: "(String, String?) -> Int"
        )

        expect(
            .blockType(
                name: "block",
                returnType: .typeName("NSInteger"),
                parameters: [
                    .pointer(.typeName("NSString")),
                    .pointer(.typeName("NSString")),
                ]),
            withExplicitNullability: .nonnull,
            toConvertTo: "(String?, String?) -> Int"
        )
    }

    func testNullableBlock() {
        expect(
            .nullabilitySpecified(
                specifier: .nullable,
                .blockType(
                    name: "block", returnType: .void, parameters: []
                )
            ),
            withExplicitNullability: nil,
            toConvertTo: "(() -> Void)?"
        )
    }

    func testNullableBlock_blockTypeNullability() {
        expect(
            .blockType(
                name: "block", returnType: .void, parameters: [], nullabilitySpecifier: .nullable
            ),
            withExplicitNullability: nil,
            toConvertTo: "(() -> Void)?"
        )
        expect(
            .blockType(
                name: "block", returnType: .void, parameters: [], nullabilitySpecifier: .nonnull
            ),
            withExplicitNullability: nil,
            toConvertTo: "() -> Void"
        )
        expect(
            .blockType(
                name: "block", returnType: .void, parameters: [], nullabilitySpecifier: .nullResettable
            ),
            withExplicitNullability: nil,
            toConvertTo: "(() -> Void)!"
        )
        expect(
            .blockType(
                name: "block", returnType: .void, parameters: [], nullabilitySpecifier: .nullUnspecified
            ),
            withExplicitNullability: nil,
            toConvertTo: "(() -> Void)!"
        )
    }

    func testNullableBlockViaTypealias() {
        typeSystem.addTypealias(
            aliasName: "callback",
            originalType: .swiftBlock(returnType: .void, parameters: [])
        )

        expect(
            .nullabilitySpecified(specifier: .nullable, "callback"),
            withExplicitNullability: nil,
            toConvertTo: "callback?"
        )
        expect(
            .nullabilitySpecified(specifier: .nonnull, "callback"),
            withExplicitNullability: nil,
            toConvertTo: "callback"
        )
        expect(
            .nullabilitySpecified(specifier: .nullUnspecified, "callback"),
            withExplicitNullability: nil,
            toConvertTo: "callback!"
        )
        expect(
            .nullabilitySpecified(specifier: .nullResettable, "callback"),
            withExplicitNullability: nil,
            toConvertTo: "callback!"
        )
    }

    func testBlockWithNoNullabilityAnnotationInfersAsImplicitlyUnwrappedOptional() {
        // Blocks should behave like pointer types and be properly annotated as
        // implicitly unwrapped optional, if lacking type annotations.

        expect(
            .blockType(name: "block", returnType: .void, parameters: []),
            withExplicitNullability: nil,
            toConvertTo: "(() -> Void)!"
        )
    }

    func testQualifiedWithinSpecified() {
        expect(
            .specified(
                specifiers: [.weak],
                .qualified(.pointer(.typeName("NSString")), qualifiers: [.atomic])
            ),
            withExplicitNullability: nil,
            toConvertTo: "String?"
        )
        expect(
            .specified(
                specifiers: [.weak],
                .qualified(.pointer(.typeName("NSString")), qualifiers: [.const])
            ),
            withExplicitNullability: nil,
            toConvertTo: "String?"
        )
    }

    func testFixedArray() {
        expect(
            .fixedArray(.typeName("char"), length: 3),
            toConvertTo: "(CChar, CChar, CChar)"
        )
    }

    func testPointerToVoid() {
        expect(
            .pointer(.void),
            toConvertTo: "UnsafeMutableRawPointer"
        )
    }
}

extension DefaultTypeMapperTests {
    private func expect(
        _ type: ObjcType,
        inNonnullContext: Bool = false,
        withExplicitNullability nullability: ObjcNullabilitySpecifier? = .nonnull,
        toConvertTo expected: String,
        file: StaticString = #filePath, line: UInt = #line
    ) {

        let converted = typeMapperConvert(
            type,
            inNonnullContext: inNonnullContext,
            nullability: nullability,
            typeSystem: typeSystem
        )

        if converted != expected {
            XCTFail(
                """
                Expected Objective-C type \(type) to convert into '\(expected)', \
                but received '\(converted)' instead.
                """,
                file: file,
                line: line
            )
        }
    }

    private func expectSwift(
        _ type: SwiftType,
        toConvertTo expected: String,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {

        let converted = typeMapperConvert(type, typeSystem: typeSystem)

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

    private func typeMapperConvert(_ type: SwiftType, typeSystem: TypeSystem) -> String {
        let mapper = DefaultTypeMapper(typeSystem: typeSystem)

        return mapper.typeNameString(for: type)
    }

    private func typeMapperConvert(
        _ type: ObjcType,
        inNonnullContext: Bool,
        nullability: ObjcNullabilitySpecifier?,
        typeSystem: TypeSystem
    ) -> String {

        let mapper = makeDefaultTypeMapper()

        var ctx: TypeMappingContext = .empty
        if let nul = nullability {
            ctx = TypeMappingContext(explicitNullability: nul)
        }
        ctx.inNonnullContext = inNonnullContext

        return mapper.typeNameString(for: type, context: ctx)
    }

    private func makeDefaultTypeMapper() -> DefaultTypeMapper {
        return DefaultTypeMapper(typeSystem: typeSystem)
    }
}
