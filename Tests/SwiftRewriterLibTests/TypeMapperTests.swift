import XCTest
import SwiftRewriterLib
import ObjcParser
import GrammarModels

class TypeMapperTests: XCTestCase {
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
    
    func testMapSimpleTypes() {
        expect(.specified(specifiers: ["const"], .struct("NSInteger")),
               toConvertTo: "Int")
        
        expect(.specified(specifiers: ["const"], .struct("NSInteger")),
               withExplicitNullability: nil,
               toConvertTo: "Int")
        
        expect(.struct("NSInteger"), toConvertTo: "Int")
        expect(.struct("int"), toConvertTo: "Int")
        expect(.struct("BOOL"), toConvertTo: "Bool")
        expect(.struct("CGColor"), toConvertTo: "CGColor")
        
        expect(.pointer(.struct("NSString")),
               toConvertTo: "String")
        
        expect(.pointer(.struct("NSObject")),
               toConvertTo: "NSObject")
        
        expect(.id(protocols: []),
               toConvertTo: "AnyObject")
        
        expect(.instancetype,
               toConvertTo: "AnyObject")
        
        expect(.instancetype,
               withExplicitNullability: .nullable,
               toConvertTo: "AnyObject?")
        
        expect(.id(protocols: ["UITableViewDelegate"]),
               withExplicitNullability: .nullable,
               toConvertTo: "UITableViewDelegate?")
        
        expect(.id(protocols: ["UITableViewDelegate", "UITableViewDataSource"]),
               withExplicitNullability: .nullable,
               toConvertTo: "(UITableViewDelegate & UITableViewDataSource)?")
        
        expect(.pointer(.generic("NSArray", parameters: [.struct("NSInteger")])),
               toConvertTo: "[Int]")
        
        expect(.pointer(.generic("NSArray", parameters: [.pointer(.struct("NSString"))])),
               toConvertTo: "[String]")
        
        expect(.pointer(.generic("NSArray", parameters: [])),
               toConvertTo: "NSArray")
        expect(.pointer(.struct("NSArray")),
               toConvertTo: "NSArray")
        
        expect(.struct("instancetype"),
               toConvertTo: "AnyObject")
        
        expect(.specified(specifiers: ["__weak"], .id(protocols: [])),
               withExplicitNullability: nil,
               toConvertTo: "AnyObject?")
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
               toConvertTo: "(String?, String!) -> Int")
        
        expect(.blockType(name: "block",
                          returnType: .struct("NSInteger"),
                          parameters: [.specified(specifiers: ["nonnull"], .pointer(.struct("NSString"))),
                                       .pointer(.struct("NSString"))]),
               withExplicitNullability: nil,
               toConvertTo: "(String, String!) -> Int")
    }
    
    func testNullableBlock() {
        expect(.qualified(.blockType(name: "block", returnType: .void, parameters: []),
                          qualifiers: ["_Nullable"]),
               withExplicitNullability: nil,
               toConvertTo: "(() -> Void)?"
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
    
    private func expect(_ type: ObjcType, withExplicitNullability nullability: TypeNullability? = .nonnull,
                        toConvertTo expected: String, file: String = #file, line: Int = #line) {
        let converted = typeMapperConvert(type, nullability: nullability)
        
        if converted != expected {
            recordFailure(withDescription: """
                Expected Objective-C type \(type) to convert into '\(expected)', \
                but received '\(converted)' instead.
                """,
                inFile: file, atLine: line, expected: false)
        }
    }
    
    private func expectSwift(_ type: SwiftType, toConvertTo expected: String, file: String = #file, line: Int = #line) {
        let converted = typeMapperConvert(type)
        
        if converted != expected {
            recordFailure(withDescription: """
                Expected Swift type \(type) to convert into '\(expected)', but \
                received '\(converted)' instead.
                """,
                inFile: file, atLine: line, expected: false)
        }
    }
    
    private func typeMapperConvert(_ type: SwiftType) -> String {
        let context = TypeContext()
        let mapper = TypeMapper(context: context)
        
        return mapper.typeNameString(for: type)
    }
    
    private func typeMapperConvert(_ type: ObjcType, nullability: TypeNullability?) -> String {
        let context = TypeContext()
        let mapper = TypeMapper(context: context)
        
        var ctx: TypeMapper.TypeMappingContext = .empty
        if let nul = nullability {
            ctx = TypeMapper.TypeMappingContext(explicitNullability: nul)
        }
        
        return mapper.typeNameString(for: type, context: ctx)
    }
}
