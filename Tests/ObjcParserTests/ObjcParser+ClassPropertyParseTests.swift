import XCTest
@testable import ObjcParser
import GrammarModels

class ObjcParser_ClassPropertyParseTests: XCTestCase {
    
    func testParseClassWithProperty() throws {
        let source = "@property BOOL myProperty1;"
        let sut = ObjcParser(string: source)
        
        try sut.parsePropertyNode()
        
        let result: ObjcClassInterface.Property! = sut.context.topmostNode?.childrenMatching().first
        let keywordsProp1 = result.childrenMatching(type: Keyword.self)
        XCTAssertTrue(keywordsProp1.contains { $0.name == "@property" })
        XCTAssertEqual(result.type.type, .struct("BOOL"))
        XCTAssertEqual(result.identifier.name, "myProperty1")
        XCTAssert(result.childrenMatching(type: TokenNode.self).contains { $0.token == ";" })
        XCTAssert(sut.diagnostics.errors.count == 0, sut.diagnostics.errors.description)
    }
    
    func testParseClassWithPropertyWithGenericType() throws {
        // Arrange
        let source = "@property NSArray<NSString*>* myProperty3;"
        let sut = ObjcParser(string: source)
        
        // Act
        try sut.parsePropertyNode()
        
        // Assert
        let result: ObjcClassInterface.Property! = sut.context.topmostNode?.childrenMatching().first
        let keywordsProp1 = result.childrenMatching(type: Keyword.self)
        
        XCTAssertTrue(keywordsProp1.contains { $0.name == "@property" })
        XCTAssertEqual(result.type.type, .pointer(.generic("NSArray", parameters: [.pointer(.struct("NSString"))])))
        XCTAssertEqual(result.identifier.name, "myProperty3")
        XCTAssert(result.childrenMatching(type: TokenNode.self).contains { $0.token == ";" })
        XCTAssert(sut.diagnostics.errors.count == 0, sut.diagnostics.errors.description)
    }
    
    func testParseClassWithPropertyWithModifiers() throws {
        let source = "@property ( atomic, nonatomic , copy ) BOOL myProperty1;"
        let sut = ObjcParser(string: source)
        
        try sut.parsePropertyNode()
        
        let result: ObjcClassInterface.Property! = sut.context.topmostNode?.childrenMatching().first
        
        XCTAssertEqual(result.type.type, .struct("BOOL"))
        XCTAssertEqual(result.identifier.name, "myProperty1")
        XCTAssertNotNil(result.modifierList)
        XCTAssertEqual(result.modifierList?.modifiers[0].name, "atomic")
        XCTAssertEqual(result.modifierList?.modifiers[1].name, "nonatomic")
        XCTAssertEqual(result.modifierList?.modifiers[2].name, "copy")
    }
    
    func testParseClassWithPropertyWithModifiersRecovery() throws {
        let source = "@property ( atomic, nonatomic , ) BOOL myProperty1;"
        let sut = ObjcParser(string: source)
        
        try sut.parsePropertyNode()
        
        let result: ObjcClassInterface.Property! = sut.context.topmostNode?.childrenMatching().first
        
        XCTAssertEqual(result.type.type, .struct("BOOL"))
        XCTAssertEqual(result.identifier.name, "myProperty1")
        XCTAssertNotNil(result.modifierList)
        XCTAssertEqual(result.modifierList?.modifiers[0].name, "atomic")
        XCTAssertEqual(result.modifierList?.modifiers[1].name, "nonatomic")
        
        XCTAssertEqual(sut.diagnostics.errors.count, 1)
    }
    
    func testParseClassWithPropertyMissingNameRecovery() throws {
        let source = "@property BOOL ;"
        let sut = ObjcParser(string: source)
        
        try sut.parsePropertyNode()
        
        let result: ObjcClassInterface.Property! = sut.context.topmostNode?.childrenMatching().first
        
        XCTAssertEqual(result.type.type, .struct("BOOL"))
        XCTAssertFalse(result.identifier.exists)
        XCTAssertNil(result.modifierList)
        XCTAssertEqual(result.childrenMatching(type: TokenNode.self)[0].token, ";")
        
        XCTAssertEqual(sut.diagnostics.errors.count, 1)
    }
    
    func testParsePropertyMissingTypeAndNameRecovery() throws {
        let source = "@property ;"
        let sut = ObjcParser(string: source)
        
        try sut.parsePropertyNode()
        
        let result: ObjcClassInterface.Property! = sut.context.topmostNode?.childrenMatching().first
        
        XCTAssertEqual(result.type.exists, false)
        XCTAssertFalse(result.identifier.exists)
        XCTAssertNil(result.modifierList)
        XCTAssertEqual(result.childrenMatching(type: TokenNode.self)[0].token, ";")
        
        XCTAssertEqual(sut.diagnostics.errors.count, 2)
    }
}
