import XCTest
@testable import ObjcParser
import GrammarModels

class ObjcParser_ObjcTypeTests: XCTestCase {
    
    func testParseVoidType() throws {
        try assertObjcTypeParse("void", .void)
        try assertObjcTypeParse("void*", .pointer(.void))
    }
    
    func testParseStructType() throws {
        try assertObjcTypeParse("NSInteger", .struct("NSInteger"))
        try assertObjcTypeParse("BOOL", .struct("BOOL"))
        try assertObjcTypeParse("_MyStruct", .struct("_MyStruct"))
    }
    
    func testParseSignedAndUnsignedNumbers() throws {
        try assertObjcTypeParse("unsigned long", .struct("unsigned long"))
        try assertObjcTypeParse("signed long", .struct("signed long"))
        try assertObjcTypeParse("unsigned long long long", .struct("unsigned long long"))
    }
    
    func testParsePointerQualifiers() throws {
        try assertObjcTypeParse("NSArray<NSString*>* _Nonnull",
                                .qualified(.pointer(.generic("NSArray", parameters: [.pointer(.struct("NSString"))])), qualifiers: ["_Nonnull"]))
    }
    
    func testParseTypeSpecifiers() throws {
        try assertObjcTypeParse("const __weak NSArray<NSString*>* _Nonnull",
                                .specified(specifiers: ["const", "__weak"],
                                .qualified(
                                    .pointer(
                                        .generic("NSArray",
                                                 parameters: [.pointer(.struct("NSString"))])),
                                    qualifiers: ["_Nonnull"])
                                    )
                                )
        
        try assertObjcTypeParse("static __weak NSArray<const NSString*>* _Nonnull",
                                .specified(specifiers: ["static", "__weak"],
                                .qualified(
                                    .pointer(
                                        .generic("NSArray",
                                                 parameters: [
                                                    .specified(specifiers: ["const"],
                                                               .pointer(.struct("NSString")))
                                                    ]
                                                )
                                            ),
                                    qualifiers: ["_Nonnull"])
                                    )
                                )
        
        try assertObjcTypeParse("__kindof __weak NSArray*",
                                .specified(specifiers: ["__kindof", "__weak"],
                                           .pointer(.struct("NSArray")
                                        )
                                    )
                                )
        
        try assertObjcTypeParse("__weak id",
                                .specified(specifiers: ["__weak"], .id()))
        
        try assertObjcTypeParse("__block id",
                                .specified(specifiers: ["__block"], .id()))
    }
    
    func testParseGenericObjcType() throws {
        try assertObjcTypeParse("NSArray<NSString*>*",
                                .pointer(.generic("NSArray", parameters: [.pointer(.struct("NSString"))])))
        
        try assertObjcTypeParse("NSArray<id>*",
                                .pointer(.generic("NSArray", parameters: [.id()])))
        
        try assertObjcTypeParse("NSDictionary < NSString * , NSNumber * > *",
                                .pointer(.generic("NSDictionary", parameters: [.pointer(.struct("NSString")), .pointer(.struct("NSNumber"))])))
    }
    
    func testParseIdWithNoProtocols() throws {
        try assertObjcTypeParse("id", .id())
        try assertObjcTypeParse("id*", .pointer(.id()))
    }
    
    func testParseIdWithProtocolListObjcType() throws {
        try assertObjcTypeParse("id<UITableViewDelegate>",
                                .id(protocols: ["UITableViewDelegate"]))
        
        try assertObjcTypeParse("id<UITableViewDelegate, UITableViewDataSource>",
                                .id(protocols: ["UITableViewDelegate", "UITableViewDataSource"]))
        
        try assertObjcTypeParse("id < UIDelegate , _MyDelegateProtocol >",
                                .id(protocols: ["UIDelegate", "_MyDelegateProtocol"]))
    }
    
    private func assertObjcTypeParse(_ source: String, _ expectedType: ObjcType, file: StaticString = #filePath, line: UInt = #line) throws {
        // Arrange
        let sut = ObjcParser(string: source)
        
        // Act
        do {
            var type: ObjcType!
            
            _=try sut.withTemporaryContext(nodeType: GlobalContextNode.self, do: {
                type = try sut.parseObjcType()
            })
            
            // Assert
            if type != expectedType {
                XCTFail("Failed: Expected to parse type '\(source)' as '\(expectedType)', but received '\(type as Any)'",
                        file: file, line: line)
            }
            
            if sut.diagnostics.errors.count != 0 {
                XCTFail("Error(s) parsing type: \(sut.diagnostics.errors.description)",
                        file: file, line: line)
            }
        } catch {
            XCTFail("Error(s) parsing type: \(error)",
                    file: file, line: line)
        }
    }
}
