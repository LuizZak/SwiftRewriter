import XCTest
import SwiftRewriterLib
import ObjcParser
import GrammarModels
import SwiftAST

class DefaultTypeMapperTests: XCTestCase {
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
        expectSwift(.block(returnType: .int, parameters: [.int]), toConvertTo: "(Int) -> Int")
        expectSwift(.optional(.block(returnType: .int, parameters: [.int])), toConvertTo: "((Int) -> Int)?")
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
    
    /// Test we properly map NS- types into equivalent Swift types (as of Swift 4.1).
    func testMapNSTypes() {
        expect(.specified(specifiers: ["const"], .struct("NSInteger")),
               toConvertTo: "Int")
        
        expect(.specified(specifiers: ["const"], .struct("NSInteger")),
               withExplicitNullability: nil,
               toConvertTo: "Int")
        
        expect(.pointer(.struct("NSDate")), toConvertTo: "Date")
        expect(.pointer(.struct("NSString")), toConvertTo: "String")
        expect(.pointer(.struct("NSObject")), toConvertTo: "NSObject")
        expect(.pointer(.struct("NSTimeInterval")), toConvertTo: "TimeInterval")
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
        
        expect(.pointer(.generic("NSMutableDictionary", parameters: [.pointer(.struct("NSString"))])),
               toConvertTo: "NSMutableDictionary<String>")
        expect(.pointer(.struct("NSMutableDictionary")),
               toConvertTo: "NSMutableDictionary")
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
               toConvertTo: "(String!, String!) -> Int")
        
        expect(.blockType(name: "block",
                          returnType: .struct("NSInteger"),
                          parameters: [.pointer(.struct("NSString")),
                                       .pointer(.struct("NSString"))]),
               withExplicitNullability: .nonnull,
               toConvertTo: "(String!, String!) -> Int")
        
        expect(.blockType(name: "block",
                          returnType: .struct("NSInteger"),
                          parameters: [.qualified(.pointer(.struct("NSString")), qualifiers: ["_Nullable"]),
                                       .pointer(.struct("NSString"))]),
               withExplicitNullability: nil,
               toConvertTo: "((String?, String!) -> Int)!")
        
        expect(.blockType(name: "block",
                          returnType: .struct("NSInteger"),
                          parameters: [.specified(specifiers: ["nonnull"], .pointer(.struct("NSString"))),
                                       .pointer(.struct("NSString"))]),
               withExplicitNullability: nil,
               toConvertTo: "((String, String!) -> Int)!")
    }
    
    func testNullableBlock() {
        expect(.qualified(.blockType(name: "block", returnType: .void, parameters: []),
                          qualifiers: ["_Nullable"]),
               withExplicitNullability: nil,
               toConvertTo: "(() -> Void)?"
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
}

extension DefaultTypeMapperTests {
    private func expect(_ type: ObjcType, withExplicitNullability nullability: TypeNullability? = .nonnull,
                        context: TypeConstructionContext = TypeConstructionContext(typeSystem: DefaultTypeSystem()),
                        toConvertTo expected: String, file: String = #file, line: Int = #line) {
        let converted = typeMapperConvert(type, nullability: nullability, context: context)
        
        if converted != expected {
            recordFailure(withDescription: """
                Expected Objective-C type \(type) to convert into '\(expected)', \
                but received '\(converted)' instead.
                """,
                inFile: file, atLine: line, expected: true)
        }
    }
    
    private func expectSwift(_ type: SwiftType, toConvertTo expected: String,
                             context: TypeConstructionContext = TypeConstructionContext(typeSystem: DefaultTypeSystem()),
                             file: String = #file, line: Int = #line) {
        let converted = typeMapperConvert(type, context: context)
        
        if converted != expected {
            recordFailure(withDescription: """
                Expected Swift type \(type) to convert into '\(expected)', but \
                received '\(converted)' instead.
                """,
                inFile: file, atLine: line, expected: true)
        }
    }
    
    private func typeMapperConvert(_ type: SwiftType, context: TypeConstructionContext) -> String {
        let mapper = DefaultTypeMapper(context: context)
        
        return mapper.typeNameString(for: type)
    }
    
    private func typeMapperConvert(_ type: ObjcType, nullability: TypeNullability?, context: TypeConstructionContext) -> String {
        let mapper = DefaultTypeMapper(context: context)
        
        var ctx: TypeMappingContext = .empty
        if let nul = nullability {
            ctx = TypeMappingContext(explicitNullability: nul)
        }
        
        return mapper.typeNameString(for: type, context: ctx)
    }
}
