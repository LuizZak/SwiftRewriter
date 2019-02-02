import XCTest
import SwiftRewriterLib
import TypeSystem
import ObjcParser
import GrammarModels
import SwiftAST

class DefaultTypeMapperTests: XCTestCase {
    var typeSystem = TypeSystem()
    
    override func setUp() {
        super.setUp()
        
        typeSystem = TypeSystem()
    }
    
    func testSugarizeArraySwiftType() {
        let sut = makeDefaultTypeMapper()
        
        XCTAssertEqual(sut.sugarizeSwiftType(SwiftType.generic("Array", parameters: ["Inner"])),
                       SwiftType.array("Inner"))
        
        XCTAssertEqual(sut.sugarizeSwiftType(SwiftType.generic("Array", parameters: ["Inner", "Inner2"])),
                       SwiftType.generic("Array", parameters: ["Inner", "Inner2"]))
    }
    
    func testSugarizeArrayDictionarySwiftType() {
        let sut = makeDefaultTypeMapper()
        
        XCTAssertEqual(sut.sugarizeSwiftType(SwiftType.generic("Dictionary", parameters: ["Key", "Value"])),
                       SwiftType.dictionary(key: "Key", value: "Value"))
        
        XCTAssertEqual(sut.sugarizeSwiftType(SwiftType.generic("Dictionary", parameters: ["Element"])),
                       SwiftType.generic("Dictionary", parameters: ["Element"]))
    }
    
    func testTypeNameString() {
        expectSwift(.typeName("MyType"), toConvertTo: "MyType")
        expectSwift(.optional(.typeName("MyType")), toConvertTo: "MyType?")
        expectSwift(.implicitUnwrappedOptional(.typeName("MyType")), toConvertTo: "MyType!")
        expectSwift(.int, toConvertTo: "Int")
        expectSwift(.array(.int), toConvertTo: "[Int]")
        expectSwift(.dictionary(key: .int, value: .string), toConvertTo: "[Int: String]")
        expectSwift(.optional(.array(.int)), toConvertTo: "[Int]?")
        expectSwift(.optional(.dictionary(key: .int, value: .string)), toConvertTo: "[Int: String]?")
        expectSwift(.protocolComposition([.typeName("Type1"), .typeName("Type2")]), toConvertTo: "Type1 & Type2")
        expectSwift(.optional(.protocolComposition([.typeName("Type1"), .typeName("Type2")])), toConvertTo: "(Type1 & Type2)?")
        expectSwift(.swiftBlock(returnType: .int, parameters: [.int]), toConvertTo: "(Int) -> Int")
        expectSwift(.optional(.swiftBlock(returnType: .int, parameters: [.int])), toConvertTo: "((Int) -> Int)?")
        expectSwift(.metatype(for: .int), toConvertTo: "Int.self")
        expectSwift(.tuple(.empty), toConvertTo: "Void")
        expectSwift(.tuple(.types([.int, .int])), toConvertTo: "(Int, Int)")
    }
    
    func testConvertNSObjectSubclassPointersAsInstanceTypes() {
        expect(.pointer(.struct("NSNumber")), toConvertTo: "NSNumber")
        expect(.pointer(.struct("NSInteger")), toConvertTo: "UnsafeMutablePointer<Int>")
        expect(.pointer(.struct("NSUInteger")), toConvertTo: "UnsafeMutablePointer<UInt>")
        expect(.pointer(.struct("NSUInteger")), toConvertTo: "UnsafeMutablePointer<UInt>")
        expect(.pointer(.struct("UIButtonType")), toConvertTo: "UnsafeMutablePointer<UIButtonType>")
        
        expect(.pointer(.struct("char")),
               withExplicitNullability: .nullable,
               toConvertTo: "UnsafeMutablePointer<CChar>?")
    }
    
    func testPrimitiveTypes() {
        // Objective-C/Foundation/CoreGraphics types
        expect(.struct("NSInteger"), toConvertTo: "Int")
        expect(.struct("NSUInteger"), toConvertTo: "UInt")
        expect(.struct("BOOL"), toConvertTo: "Bool")
        expect(.struct("CGColor"), toConvertTo: "CGColor")
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
        expect(.struct("char"), toConvertTo: "CChar")
        expect(.struct("signed"), toConvertTo: "CInt")
        expect(.struct("unsigned"), toConvertTo: "CUnsignedInt")
        expect(.struct("unsigned char"), toConvertTo: "CUnsignedChar")
        expect(.struct("unsigned short"), toConvertTo: "CUnsignedShort")
        expect(.struct("unsigned int"), toConvertTo: "CUnsignedInt")
        expect(.struct("unsigned long"), toConvertTo: "CUnsignedLong")
        expect(.struct("unsigned long long"), toConvertTo: "CUnsignedLongLong")
        expect(.struct("signed char"), toConvertTo: "CSignedChar")
        expect(.struct("short"), toConvertTo: "CShort")
        expect(.struct("int"), toConvertTo: "CInt")
        expect(.struct("long"), toConvertTo: "CLong")
        expect(.struct("long long"), toConvertTo: "CLongLong")
        expect(.struct("float"), toConvertTo: "CFloat")
        expect(.struct("double"), toConvertTo: "CDouble")
        expect(.struct("wchar_t"), toConvertTo: "CWideChar")
        expect(.struct("char16_t"), toConvertTo: "CChar16")
        expect(.struct("char32_t"), toConvertTo: "CChar32")
        expect(.struct("Bool"), toConvertTo: "CBool")
        
        // Pointer of C scalar types
        expect(.pointer(.struct("char")), toConvertTo: "UnsafeMutablePointer<CChar>")
        expect(.pointer(.struct("signed")), toConvertTo: "UnsafeMutablePointer<CInt>")
        expect(.pointer(.struct("unsigned")), toConvertTo: "UnsafeMutablePointer<CUnsignedInt>")
        expect(.pointer(.struct("unsigned char")), toConvertTo: "UnsafeMutablePointer<CUnsignedChar>")
        expect(.pointer(.struct("unsigned short")), toConvertTo: "UnsafeMutablePointer<CUnsignedShort>")
        expect(.pointer(.struct("unsigned int")), toConvertTo: "UnsafeMutablePointer<CUnsignedInt>")
        expect(.pointer(.struct("unsigned long")), toConvertTo: "UnsafeMutablePointer<CUnsignedLong>")
        expect(.pointer(.struct("unsigned long long")), toConvertTo: "UnsafeMutablePointer<CUnsignedLongLong>")
        expect(.pointer(.struct("signed char")), toConvertTo: "UnsafeMutablePointer<CSignedChar>")
        expect(.pointer(.struct("short")), toConvertTo: "UnsafeMutablePointer<CShort>")
        expect(.pointer(.struct("int")), toConvertTo: "UnsafeMutablePointer<CInt>")
        expect(.pointer(.struct("long")), toConvertTo: "UnsafeMutablePointer<CLong>")
        expect(.pointer(.struct("long long")), toConvertTo: "UnsafeMutablePointer<CLongLong>")
        expect(.pointer(.struct("float")), toConvertTo: "UnsafeMutablePointer<CFloat>")
        expect(.pointer(.struct("double")), toConvertTo: "UnsafeMutablePointer<CDouble>")
        expect(.pointer(.struct("wchar_t")), toConvertTo: "UnsafeMutablePointer<CWideChar>")
        expect(.pointer(.struct("char16_t")), toConvertTo: "UnsafeMutablePointer<CChar16>")
        expect(.pointer(.struct("char32_t")), toConvertTo: "UnsafeMutablePointer<CChar32>")
        expect(.pointer(.struct("Bool")), toConvertTo: "UnsafeMutablePointer<CBool>")
    }
    
    func testMapSimpleTypes() {
        expect(.id(protocols: []),
               toConvertTo: "AnyObject")
        
        expect(.instancetype,
               toConvertTo: "__instancetype")
        
        expect(.instancetype,
               withExplicitNullability: .nullable,
               toConvertTo: "__instancetype?")
        
        expect(.id(protocols: ["UITableViewDelegate"]),
               withExplicitNullability: .nullable,
               toConvertTo: "UITableViewDelegate?")
        
        expect(.id(protocols: ["UITableViewDelegate", "UITableViewDataSource"]),
               withExplicitNullability: .nullable,
               toConvertTo: "(UITableViewDelegate & UITableViewDataSource)?")
        
        expect(.specified(specifiers: ["__weak"], .id(protocols: [])),
               withExplicitNullability: nil,
               toConvertTo: "AnyObject?")
    }
    
    func testQualifiedAndSpecifiedTypesDontMapIntoPointersAutomatically() {
        expect(.specified(specifiers: ["const"], .struct("NSInteger")),
               toConvertTo: "Int")
        
        expect(.specified(specifiers: ["const"], .struct("NSInteger")),
               withExplicitNullability: nil,
               toConvertTo: "Int")
        
        expect(.qualified(.struct("NSInteger"), qualifiers: ["const"]),
               toConvertTo: "Int")
        
        expect(.qualified(.struct("NSInteger"), qualifiers: ["const"]),
               withExplicitNullability: nil,
               toConvertTo: "Int")
    }
    
    /// Test we properly map NS- types into equivalent Swift types (as of Swift 4.1).
    func testMapNSTypes() {
        expect(.pointer(.struct("NSDate")), toConvertTo: "Date")
        expect(.pointer(.struct("NSString")), toConvertTo: "String")
        expect(.pointer(.struct("NSObject")), toConvertTo: "NSObject")
        expect(.pointer(.struct("NSCalendar")), toConvertTo: "Calendar")
        expect(.pointer(.struct("NSURL")), toConvertTo: "URL")
        expect(.pointer(.struct("NSURLComponents")), toConvertTo: "URLComponents")
        expect(.pointer(.struct("NSError")), toConvertTo: "Error")
        expect(.pointer(.struct("NSIndexPath")), toConvertTo: "IndexPath")
        expect(.pointer(.struct("NSIndexSet")), toConvertTo: "IndexSet")
        expect(.pointer(.struct("NSNotificationCenter")), toConvertTo: "NotificationCenter")
        expect(.pointer(.struct("NSNotification")), toConvertTo: "Notification")
        expect(.pointer(.struct("NSTimeZone")), toConvertTo: "TimeZone")
        expect(.pointer(.struct("NSLocale")), toConvertTo: "Locale")
        expect(.pointer(.struct("NSDateFormatter")), toConvertTo: "DateFormatter")
        expect(.pointer(.struct("NSNumberFormatter")), toConvertTo: "NumberFormatter")
        
        expect(.struct("NSTimeInterval"), toConvertTo: "TimeInterval")
        expect(.struct("NSComparisonResult"), toConvertTo: "ComparisonResult")
        expect(.struct("NSInteger"), toConvertTo: "Int")
        expect(.struct("NSUInteger"), toConvertTo: "UInt")
    }
    
    func testNSArray() {
        expect(.pointer(.generic("NSArray", parameters: [.pointer(.struct("NSObject"))])),
               toConvertTo: "[NSObject]")
        
        expect(.pointer(.generic("NSArray", parameters: [.pointer(.struct("NSString"))])),
               toConvertTo: "[String]")
        
        expect(.pointer(.generic("NSArray", parameters: [])),
               toConvertTo: "NSArray")
        expect(.pointer(.struct("NSArray")),
               toConvertTo: "NSArray")
    }
    
    func testNestedNSArray() {
        expect(
            .pointer(
                .generic(
                    "NSArray",
                    parameters: [
                        .pointer(
                            .generic(
                                "NSArray",
                                parameters: [
                                    .pointer(
                                        .struct("NSObject"))
                                ]
                            )
                        )
                    ]
                )
            ),
               toConvertTo: "[[NSObject]]")
    }
    
    func testNSDictionary() {
        expect(.pointer(.generic("NSDictionary", parameters: [.pointer(.struct("NSString")), .pointer(.struct("NSObject"))])),
               toConvertTo: "[String: NSObject]")
        
        expect(.pointer(.generic("NSDictionary", parameters: [.pointer(.struct("NSString"))])),
               toConvertTo: "NSDictionary<String>")
        expect(.pointer(.struct("NSDictionary")),
               toConvertTo: "NSDictionary")
    }
    
    /// NSMutableArray is kept alone since its pass-by-reference semantics are
    /// not fully compatible with Swift's array...
    func testNSMutableArray() {
        expect(.pointer(.generic("NSMutableArray", parameters: [.pointer(.struct("NSObject"))])),
               toConvertTo: "NSMutableArray")
        
        expect(.pointer(.generic("NSMutableArray", parameters: [.pointer(.struct("NSString"))])),
               toConvertTo: "NSMutableArray")
        
        expect(.pointer(.generic("NSMutableArray", parameters: [])),
               toConvertTo: "NSMutableArray")
        expect(.pointer(.struct("NSMutableArray")),
               toConvertTo: "NSMutableArray")
    }
    
    /// ...ditto for NSMutableDictionary
    func testNSMutableDictionary() {
        expect(.pointer(.generic("NSMutableDictionary", parameters: [.pointer(.struct("NSString")), .pointer(.struct("NSObject"))])),
               toConvertTo: "NSMutableDictionary")
        
        expect(.pointer(.struct("NSMutableDictionary")),
               toConvertTo: "NSMutableDictionary")
    }
    
    func testNSMutableDictionaryWithSingleTypeParameter() {
        expect(.pointer(.generic("NSMutableDictionary", parameters: [.pointer(.struct("NSString"))])),
               toConvertTo: "NSMutableDictionary<String>")
    }
    
    func testNestedTypeInGenericIsAlwaysReadAsObjectType() {
        expect(ObjcType.generic("A", parameters: [.pointer(.struct("B"))]),
               toConvertTo: "A<B>")
        expect(ObjcType.generic("A", parameters: [.pointer(.struct("B")), .pointer(.struct("C"))]),
               toConvertTo: "A<B, C>")
    }
    
    func testConcreteTypesWithProtocol() {
        expect(.pointer(.generic("UIView", parameters: [.struct("UIDelegate")])),
               toConvertTo: "UIView & UIDelegate")
        expect(.pointer(.generic("UIView", parameters: [.struct("UIDelegate")])),
               withExplicitNullability: .nullable,
               toConvertTo: "(UIView & UIDelegate)?")
    }
    
    func testBlockTypes() {
        expect(.blockType(name: "block", returnType: .void, parameters: []),
               toConvertTo: "() -> Void")
        
        expect(.blockType(name: "block", returnType: .struct("NSInteger"),
                          parameters: []),
               toConvertTo: "() -> Int")
        
        expect(.blockType(name: "block",
                          returnType: .struct("NSInteger"),
                          parameters: [.pointer(.struct("NSString")),
                                       .pointer(.struct("NSString"))]),
               withExplicitNullability: nil,
               toConvertTo: "((String?, String?) -> Int)!")
        
        expect(.blockType(name: "block",
                          returnType: .struct("NSInteger"),
                          parameters: [.pointer(.struct("NSString")),
                                       .pointer(.struct("NSString"))]),
               inNonnullContext: true,
               toConvertTo: "(String, String) -> Int")
        
        expect(.blockType(name: "block",
                          returnType: .struct("NSInteger"),
                          parameters: [.qualified(.pointer(.struct("NSString")), qualifiers: ["_Nullable"]),
                                       .pointer(.struct("NSString"))]),
               withExplicitNullability: nil,
               toConvertTo: "((String?, String?) -> Int)!")
        
        expect(.blockType(name: "block",
                          returnType: .struct("NSInteger"),
                          parameters: [.specified(specifiers: ["nonnull"], .pointer(.struct("NSString"))),
                                       .pointer(.struct("NSString"))]),
               withExplicitNullability: nil,
               toConvertTo: "((String, String?) -> Int)!")
        
        expect(.blockType(name: "block",
                          returnType: .struct("NSInteger"),
                          parameters: [.specified(specifiers: ["nonnull"], .pointer(.struct("NSString"))),
                                       .specified(specifiers: ["nullable"], .pointer(.struct("NSString")))]),
               withExplicitNullability: .nonnull,
               toConvertTo: "(String, String?) -> Int")
        
        expect(.blockType(name: "block",
                          returnType: .struct("NSInteger"),
                          parameters: [.pointer(.struct("NSString")),
                                       .pointer(.struct("NSString"))]),
               withExplicitNullability: .nonnull,
               toConvertTo: "(String?, String?) -> Int")
    }
    
    func testNullableBlock() {
        expect(.qualified(.blockType(name: "block", returnType: .void, parameters: []),
                          qualifiers: ["_Nullable"]),
               withExplicitNullability: nil,
               toConvertTo: "(() -> Void)?"
        )
    }
    
    func testNullableBlockViaTypealias() {
        typeSystem.addTypealias(aliasName: "callback",
                                originalType: .swiftBlock(returnType: .void, parameters: []))
        
        expect(.qualified(.struct("callback"),
                          qualifiers: ["_Nullable"]),
               withExplicitNullability: nil,
               toConvertTo: "callback?"
        )
    }
    
    func testBlockWithNoNullabilityAnnotationInfersAsImplicitlyUnwrappedOptional() {
        // Blocks should behave like pointer types and be properly annotated as
        // implicitly unwrapped optional, if lacking type annotations.
        
        expect(.blockType(name: "block", returnType: .void, parameters: []),
               withExplicitNullability: nil,
               toConvertTo: "(() -> Void)!"
        )
    }
    
    func testQualifiedWithinSpecified() {
        expect(.specified(specifiers: ["static"], .qualified(.pointer(.struct("NSString")), qualifiers: ["_Nullable"])),
               withExplicitNullability: nil,
               toConvertTo: "String?")
        expect(.specified(specifiers: ["__weak"], .qualified(.pointer(.struct("NSString")), qualifiers: ["const"])),
               withExplicitNullability: nil,
               toConvertTo: "String?")
    }
    
    func testFixedArray() {
        expect(.fixedArray(.struct("char"), length: 3),
               toConvertTo: "(CChar, CChar, CChar)")
    }
    
    func testPointerToVoid() {
        expect(.pointer(.void),
               toConvertTo: "UnsafeMutableRawPointer")
    }
}

extension DefaultTypeMapperTests {
    private func expect(_ type: ObjcType,
                        inNonnullContext: Bool = false,
                        withExplicitNullability nullability: TypeNullability? = .nonnull,
                        toConvertTo expected: String,
                        file: String = #file, line: Int = #line) {
        
        let converted = typeMapperConvert(type,
                                          inNonnullContext: inNonnullContext,
                                          nullability: nullability,
                                          typeSystem: typeSystem)
        
        if converted != expected {
            recordFailure(withDescription: """
                Expected Objective-C type \(type) to convert into '\(expected)', \
                but received '\(converted)' instead.
                """,
                inFile: file, atLine: line, expected: true)
        }
    }
    
    private func expectSwift(_ type: SwiftType,
                             toConvertTo expected: String,
                             file: String = #file, line: Int = #line) {
        
        let converted = typeMapperConvert(type, typeSystem: typeSystem)
        
        if converted != expected {
            recordFailure(withDescription: """
                Expected Swift type \(type) to convert into '\(expected)', but \
                received '\(converted)' instead.
                """,
                inFile: file, atLine: line, expected: true)
        }
    }
    
    private func typeMapperConvert(_ type: SwiftType, typeSystem: TypeSystem) -> String {
        let mapper = DefaultTypeMapper(typeSystem: typeSystem)
        
        return mapper.typeNameString(for: type)
    }
    
    private func typeMapperConvert(_ type: ObjcType,
                                   inNonnullContext: Bool,
                                   nullability: TypeNullability?,
                                   typeSystem: TypeSystem) -> String {
        
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
