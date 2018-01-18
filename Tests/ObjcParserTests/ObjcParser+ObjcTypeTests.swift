import XCTest
@testable import ObjcParser
import GrammarModels

class ObjcParser_ObjcTypeTests: XCTestCase {
    
    func testParseStructType() throws {
        try assertObjcTypeParse("NSInteger", .struct("NSInteger"))
        try assertObjcTypeParse("BOOL", .struct("BOOL"))
        try assertObjcTypeParse("_MyStruct", .struct("_MyStruct"))
    }
    
    func testParseGenericObjcType() throws {
        try assertObjcTypeParse("NSArray<NSString*>*",
                                .pointer(.generic("NSArray", parameters: [.pointer(.struct("NSString"))])))
        
        try assertObjcTypeParse("NSArray<id>*",
                                .pointer(.generic("NSArray", parameters: [.id(protocols: [])])))
        
        try assertObjcTypeParse("NSDictionary < NSString * , NSNumber * > *",
                                .pointer(.generic("NSDictionary", parameters: [.pointer(.struct("NSString")), .pointer(.struct("NSNumber"))])))
    }
    
    func testParseIdWithNoProtocols() throws {
        try assertObjcTypeParse("id", .id(protocols: []))
        try assertObjcTypeParse("id*", .pointer(.id(protocols: [])))
    }
    
    func testParseIdWithProtocolListObjcType() throws {
        try assertObjcTypeParse("id<UITableViewDelegate>",
                                .id(protocols: ["UITableViewDelegate"]))
        
        try assertObjcTypeParse("id<UITableViewDelegate, UITableViewDataSource>",
                                .id(protocols: ["UITableViewDelegate", "UITableViewDataSource"]))
        
        try assertObjcTypeParse("id < UIDelegate , _MyDelegateProtocol >",
                                .id(protocols: ["UIDelegate", "_MyDelegateProtocol"]))
    }
    
    private func assertObjcTypeParse(_ source: String, _ expectedType: TypeNameNode.ObjcType, file: String = #file, line: Int = #line) throws {
        // Arrange
        let sut = ObjcParser(string: source)
        
        // Act
        do {
            var type: TypeNameNode.ObjcType!
            
            _=try sut.withTemporaryContext(nodeType: GlobalContextNode.self, do: {
                type = try sut.parseObjcType()
            })
            
            // Assert
            if type != expectedType {
                recordFailure(withDescription: "Failed: Expected to parse type \(source) as \(expectedType), but received \(type)", inFile: file, atLine: line, expected: false)
            }
            
            if sut.diagnostics.errors.count != 0 {
                recordFailure(withDescription: "Error(s) parsing type: \(sut.diagnostics.errors.description)", inFile: file, atLine: line, expected: false)
            }
        } catch {
            recordFailure(withDescription: "Error(s) parsing type: \(error)", inFile: file, atLine: line, expected: false)
        }
    }
}
