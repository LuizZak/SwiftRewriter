import XCTest
@testable import ObjcParser
import GrammarModels

class ObjcParser_ObjcClassTests: XCTestCase {
    
    
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
    
    func testParseClassWithProperty() throws {
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
    
    func testParseClassWithPropertyWithGenericType() throws {
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
    
    func testParseClassWithPropertyWithModifiers() throws {
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
    
    func testParseClassWithPropertyWithModifiersRecovery() throws {
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
    
    func testParseClassWithPropertyMissingNameRecovery() throws {
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
    
    func testParseClassWithPropertyMissingTypeAndNameRecovery() throws {
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
    
    func testParseClassWithSuperclass() throws {
        let source = """
            @interface MyClass : Superclass
            @end
            """
        let sut = ObjcParser(string: source)
        
        try sut.parseClassInerfaceNode()
        
        let result: ObjcClassInterface! = sut.context.topmostNode?.childrenMatching().first
        
        XCTAssertEqual(result.superclass?.name, "Superclass")
        XCTAssertEqual(sut.diagnostics.errors.count, 0)
    }
    
    func testParseClassWithProtocolReferenceList() throws {
        let source = """
            @interface MyClass <MyProtocol1, MyProtocol2>
            @end
            """
        let sut = ObjcParser(string: source)
        
        try sut.parseClassInerfaceNode()
        
        let result: ObjcClassInterface! = sut.context.topmostNode?.childrenMatching().first
        
        XCTAssertEqual(result.protocolList?.protocols.count, 2)
        XCTAssertEqual(result.protocolList?.protocols[0], "MyProtocol1")
        XCTAssertEqual(result.protocolList?.protocols[1], "MyProtocol2")
        XCTAssertEqual(sut.diagnostics.errors.count, 0)
    }
    
    func testParseClassWithSuperclassProtocolReferenceList() throws {
        let source = """
            @interface MyClass : Superclass <MyProtocol1, MyProtocol2>
            @end
            """
        let sut = ObjcParser(string: source)
        
        try sut.parseClassInerfaceNode()
        
        let result: ObjcClassInterface! = sut.context.topmostNode?.childrenMatching().first
        
        XCTAssertEqual(result.superclass?.name, "Superclass")
        XCTAssertEqual(result.protocolList?.protocols.count, 2)
        XCTAssertEqual(result.protocolList?.protocols[0], "MyProtocol1")
        XCTAssertEqual(result.protocolList?.protocols[1], "MyProtocol2")
        XCTAssertEqual(sut.diagnostics.errors.count, 0)
    }
    
    func testParseClassProtocolReferenceListRecover1() throws {
        let source = """
            @interface MyClass : Superclass <MyProtocol1, >
            @end
            """
        let sut = ObjcParser(string: source)
        
        try sut.parseClassInerfaceNode()
        
        let result: ObjcClassInterface! = sut.context.topmostNode?.childrenMatching().first
        let protocolList = result.protocolList!
        
        XCTAssertEqual(result.superclass?.name, "Superclass")
        XCTAssertEqual(protocolList.protocols.count, 1)
        XCTAssertEqual(protocolList.protocols[0], "MyProtocol1")
        XCTAssert(result.childrenMatching(type: Keyword.self).contains { $0.name == "@interface" })
        XCTAssert(protocolList.childrenMatching(type: TokenNode.self).contains { $0.token == "<" })
        XCTAssert(protocolList.childrenMatching(type: TokenNode.self).contains { $0.token == ">" })
        XCTAssert(result.childrenMatching(type: Keyword.self).contains { $0.name == "@end" })
        XCTAssert(sut.diagnostics.errors.count > 0)
    }
    
    func testParseProtocolReferenceList() throws {
        // Arrange
        let source = "<UITableViewDataSource, UITableViewDelegate, _MyProtocol1_>"
        let sut = ObjcParser(string: source)
        
        // Act
        try sut.parseProtocolReferenceListNode()
        
        // Assert
        let result: ObjcClassInterface.ProtocolReferenceList! = sut.context.topmostNode?.childrenMatching().first
        
        XCTAssertEqual(result.protocols.count, 3)
        XCTAssertEqual(result.protocols[0], "UITableViewDataSource")
        XCTAssertEqual(result.protocols[1], "UITableViewDelegate")
        XCTAssertEqual(result.protocols[2], "_MyProtocol1_")
    }
    
    func testParseProtocolReferenceListRecovery() throws {
        // Arrange
        let source = "<UITableViewDataSource, ,>"
        let sut = ObjcParser(string: source)
        
        // Act
        try sut.parseProtocolReferenceListNode()
        
        // Assert
        let result: ObjcClassInterface.ProtocolReferenceList! = sut.context.topmostNode?.childrenMatching().first
        
        XCTAssertEqual(result.protocols.count, 1)
        XCTAssertEqual(result.protocols[0], "UITableViewDataSource")
        XCTAssert(sut.diagnostics.errors.count > 0)
    }
}
