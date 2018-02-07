import XCTest
import SwiftRewriterLib
import ObjcParser
import GrammarModels

class TypeMapperTests: XCTestCase {
    func testMapSimpleTypes() {
        expect(.specified(specifiers: ["const"], .struct("NSInteger")),
               toConvertTo: "Int")
        
        expect(.specified(specifiers: ["const"], .struct("NSInteger")),
               withExplicitNullability: nil,
               toConvertTo: "Int")
        
        expect(.struct("NSInteger"), toConvertTo: "Int")
        
        expect(.struct("BOOL"), toConvertTo: "Bool")
        
        expect(.struct("CGColor"), toConvertTo: "CGColor")
        
        expect(.pointer(.struct("NSString")),
               toConvertTo: "String")
        
        expect(.pointer(.struct("NSObject")),
               toConvertTo: "NSObject")
        
        expect(.id(protocols: []),
               toConvertTo: "AnyObject")
        
        expect(.id(protocols: ["UITableViewDelegate"]),
               withExplicitNullability: .nullable,
               toConvertTo: "AnyObject<UITableViewDelegate>?")
        
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
               toConvertTo: "AnyObject!")
    }
    
    func testConcreteTypesWithProtocol() {
        expect(.pointer(.generic("UIView", parameters: [.struct("UIDelegate")])),
               toConvertTo: "UIView & UIDelegate")
        expect(.pointer(.generic("UIView", parameters: [.struct("UIDelegate")])),
               withExplicitNullability: .nullable,
               toConvertTo: "(UIView & UIDelegate)?")
    }
    
    private func expect(_ type: ObjcType, withExplicitNullability nullability: TypeNullability? = .nonnull, toConvertTo expected: String, file: String = #file, line: Int = #line) {
        let converted = typeMapperConvert(type, nullability: nullability)
        
        if converted != expected {
            recordFailure(withDescription: "Expected type \(type) to convert into '\(expected)', but received '\(converted)' instead.",
                inFile: file, atLine: line, expected: false)
        }
    }
    
    private func typeMapperConvert(_ type: ObjcType, nullability: TypeNullability?) -> String {
        let context = TypeContext()
        let mapper = TypeMapper(context: context)
        
        var ctx: TypeMapper.TypeMappingContext = .empty
        if let nul = nullability {
            ctx = TypeMapper.TypeMappingContext(explicitNullability: nul)
        }
        
        return mapper.swiftType(forObjcType: type, context: ctx)
    }
}
