import XCTest
@testable import ObjcParser
import GrammarModels

class ObjcParserTests: XCTestCase {
    func testInit() {
        _=ObjcParser(string: "abc")
    }
    
    func testParseClass() throws {
        let source = """
            @interface MyClass
            @end
            """
        let sut = ObjcParser(string: source)
        
        try sut.parseClassInerfaceNode()
        
        let result: ObjcClassInterface! = sut.context.topmostNode?.childrenMatching().first
        XCTAssertEqual(result.identifier.name, "MyClass")
    }
    
    func testParseClassKeywords() throws {
        let source = """
            @interface MyClass
            @end
            """
        let sut = ObjcParser(string: source)
        
        try sut.parseClassInerfaceNode()
        
        let result: ObjcClassInterface! = sut.context.topmostNode?.childrenMatching().first
        let keywords = result.childrenMatching(type: Keyword.self)
        XCTAssertEqual(result.identifier.name, "MyClass")
        XCTAssertTrue(keywords.contains { $0.name == "@interface" })
        XCTAssertTrue(keywords.contains { $0.name == "@end" })
    }
    
    func testParseClassProperty() throws {
        let source = """
            @interface MyClass
            @property BOOL myProperty1;
            @property NSInteger myProperty2;
            @end
            """
        let sut = ObjcParser(string: source)
        
        try sut.parseClassInerfaceNode()
        
        let result: ObjcClassInterface! = sut.context.topmostNode?.childrenMatching().first
        let keywordsProp1 = result.properties[0].childrenMatching(type: Keyword.self)
        XCTAssertTrue(keywordsProp1.contains { $0.name == "@property" })
        XCTAssertEqual(result.properties[0].type.type, .struct("BOOL"))
        XCTAssertEqual(result.properties[0].identifier.name, "myProperty1")
        XCTAssert(result.properties[0].childrenMatching(type: TokenNode.self).contains { $0.token == ";" })
        XCTAssert(sut.diagnostics.errors.count == 0, sut.diagnostics.errors.description)
    }
    
    func testParseClassPropertyWithGenericType() throws {
        // Arrange
        let source = """
            @interface MyClass
            @property NSArray<NSString*>* myProperty3;
            @end
            """
        let sut = ObjcParser(string: source)
        
        // Act
        try sut.parseClassInerfaceNode()
        
        // Assert
        let result: ObjcClassInterface! = sut.context.topmostNode?.childrenMatching().first
        let keywordsProp1 = result.properties[0].childrenMatching(type: Keyword.self)
        
        XCTAssertTrue(keywordsProp1.contains { $0.name == "@property" })
        XCTAssertEqual(result.properties[0].type.type, .pointer(.generic("NSArray", parameters: [.pointer(.struct("NSString"))])))
        XCTAssertEqual(result.properties[0].identifier.name, "myProperty3")
        XCTAssert(result.properties[0].childrenMatching(type: TokenNode.self).contains { $0.token == ";" })
        XCTAssert(sut.diagnostics.errors.count == 0, sut.diagnostics.errors.description)
    }
    
    func testParseClassPropertyWithModifiers() throws {
        let source = """
            @interface MyClass
            @property ( atomic, nonatomic , copy ) BOOL myProperty1;
            @end
            """
        let sut = ObjcParser(string: source)
        
        try sut.parseClassInerfaceNode()
        
        let result: ObjcClassInterface! = sut.context.topmostNode?.childrenMatching().first
        
        XCTAssertEqual(result.properties[0].type.type, .struct("BOOL"))
        XCTAssertEqual(result.properties[0].identifier.name, "myProperty1")
        XCTAssertNotNil(result.properties[0].modifierList)
        XCTAssertEqual(result.properties[0].modifierList?.modifiers[0].name, "atomic")
        XCTAssertEqual(result.properties[0].modifierList?.modifiers[1].name, "nonatomic")
        XCTAssertEqual(result.properties[0].modifierList?.modifiers[2].name, "copy")
    }
    
    func testParseClassPropertyWithModifiersRecovery() throws {
        let source = """
            @interface MyClass
            @property ( atomic, nonatomic , ) BOOL myProperty1;
            @end
            """
        let sut = ObjcParser(string: source)
        
        try sut.parseClassInerfaceNode()
        
        let result: ObjcClassInterface! = sut.context.topmostNode?.childrenMatching().first
        
        XCTAssertEqual(result.properties[0].type.type, .struct("BOOL"))
        XCTAssertEqual(result.properties[0].identifier.name, "myProperty1")
        XCTAssertNotNil(result.properties[0].modifierList)
        XCTAssertEqual(result.properties[0].modifierList?.modifiers[0].name, "atomic")
        XCTAssertEqual(result.properties[0].modifierList?.modifiers[1].name, "nonatomic")
        
        XCTAssertEqual(sut.diagnostics.errors.count, 1)
    }
    
    func testParseClassPropertyMissingNameRecovery() throws {
        let source = """
            @interface MyClass
            @property BOOL ;
            @end
            """
        let sut = ObjcParser(string: source)
        
        try sut.parseClassInerfaceNode()
        
        let result: ObjcClassInterface! = sut.context.topmostNode?.childrenMatching().first
        
        XCTAssertEqual(result.properties[0].type.type, .struct("BOOL"))
        XCTAssertFalse(result.properties[0].identifier.exists)
        XCTAssertNil(result.properties[0].modifierList)
        XCTAssertEqual(result.properties[0].childrenMatching(type: TokenNode.self)[0].token, ";")
        
        XCTAssertEqual(sut.diagnostics.errors.count, 1)
    }
    
    func testParseClassPropertyMissingTypeAndNameRecovery() throws {
        let source = """
            @interface MyClass
            @property ;
            @end
            """
        let sut = ObjcParser(string: source)
        
        try sut.parseClassInerfaceNode()
        
        let result: ObjcClassInterface! = sut.context.topmostNode?.childrenMatching().first
        
        XCTAssertEqual(result.properties[0].type.exists, false)
        XCTAssertFalse(result.properties[0].identifier.exists)
        XCTAssertNil(result.properties[0].modifierList)
        XCTAssertEqual(result.properties[0].childrenMatching(type: TokenNode.self)[0].token, ";")
        
        XCTAssertEqual(sut.diagnostics.errors.count, 2)
    }
    
    func testParseClassSuperclass() throws {
        let source = """
            @interface MyClass : Superclass
            @end
            """
        let sut = ObjcParser(string: source)
        
        try sut.parseClassInerfaceNode()
        
        let result: ObjcClassInterface! = sut.context.topmostNode?.childrenMatching().first
        
        XCTAssertEqual(result.superclass?.name, "Superclass")
    }
    
    static var allTests = [
        ("testInit", testInit),
    ]
}
