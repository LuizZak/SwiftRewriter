import XCTest
@testable import ObjcParser
import GrammarModels

class ObjcParser_ClassPropertyParseTests: XCTestCase {
    
    func testParseSimpleProperty() throws {
        let source = "@property BOOL myProperty1;"
        let sut = ObjcParser(string: source)
        
        let result = _parseTestPropertyNode(source: source, parser: sut)
        
        let keywordsProp1 = result.childrenMatching(type: KeywordNode.self)
        XCTAssertTrue(keywordsProp1.contains { $0.keyword == .atProperty })
        XCTAssertEqual(result.type.type, .struct("BOOL"))
        XCTAssertEqual(result.identifier.name, "myProperty1")
        XCTAssert(result.childrenMatching(type: TokenNode.self).contains { $0.token.type == .semicolon })
        XCTAssert(sut.diagnostics.errors.count == 0, sut.diagnostics.errors.description)
    }
    
    func testParsePropertyWithGenericType() throws {
        // Arrange
        let source = "@property NSArray<NSString*>* myProperty3;"
        let sut = ObjcParser(string: source)
        
        // Act
        let result = _parseTestPropertyNode(source: source, parser: sut)
        
        // Assert
        let keywordsProp1 = result.childrenMatching(type: KeywordNode.self)
        XCTAssertTrue(keywordsProp1.contains { $0.keyword == .atProperty })
        XCTAssertEqual(result.type.type, .pointer(.generic("NSArray", parameters: [.pointer(.struct("NSString"))])))
        XCTAssertEqual(result.identifier.name, "myProperty3")
        XCTAssert(result.childrenMatching(type: TokenNode.self).contains { $0.token.type == .semicolon })
        XCTAssert(sut.diagnostics.errors.count == 0, sut.diagnostics.errors.description)
    }
    
    func testParsePropertyWithModifiers() throws {
        let source = "@property ( atomic, nonatomic , copy ) BOOL myProperty1;"
        let sut = ObjcParser(string: source)
        
        let result = _parseTestPropertyNode(source: source, parser: sut)
        
        XCTAssertEqual(result.type.type, .struct("BOOL"))
        XCTAssertEqual(result.identifier.name, "myProperty1")
        XCTAssertNotNil(result.modifierList)
        XCTAssertEqual(result.modifierList?.keywordModifiers[0], "atomic")
        XCTAssertEqual(result.modifierList?.keywordModifiers[1], "nonatomic")
        XCTAssertEqual(result.modifierList?.keywordModifiers[2], "copy")
        XCTAssert(sut.diagnostics.errors.count == 0, sut.diagnostics.errors.description)
    }
    
    func testParsePropertyWithGetterModifier() throws {
        let source = "@property (getter=isEnabled) BOOL enabled;"
        let sut = ObjcParser(string: source)
        
        let result = _parseTestPropertyNode(source: source, parser: sut)
        
        XCTAssertEqual(result.type.type, .struct("BOOL"))
        XCTAssertEqual(result.identifier.name, "enabled")
        XCTAssertNotNil(result.modifierList)
        XCTAssertEqual(result.modifierList?.getterModifiers[0], "isEnabled")
        XCTAssert(sut.diagnostics.errors.count == 0, sut.diagnostics.errors.description)
    }
    
    
    func testParsePropertyWithSetterModifier() throws {
        let source = "@property (setter=setIsEnabled:) BOOL enabled;"
        let sut = ObjcParser(string: source)
        
        let result = _parseTestPropertyNode(source: source, parser: sut)
        
        XCTAssertEqual(result.type.type, .struct("BOOL"))
        XCTAssertEqual(result.identifier.name, "enabled")
        XCTAssertNotNil(result.modifierList)
        XCTAssertEqual(result.modifierList?.setterModifiers[0], "setIsEnabled")
        XCTAssert(sut.diagnostics.errors.count == 0, sut.diagnostics.errors.description)
    }
    
    func testParsePropertyWithModifiersRecovery() throws {
        let source = "@property ( atomic, nonatomic , ) BOOL myProperty1;"
        let sut = ObjcParser(string: source)
        
        let result = _parseTestPropertyNode(source: source, parser: sut)
        
        XCTAssertEqual(result.type.type, .struct("BOOL"))
        XCTAssertEqual(result.identifier.name, "myProperty1")
        XCTAssertNotNil(result.modifierList)
        XCTAssertEqual(result.modifierList?.keywordModifiers[0], "atomic")
        XCTAssertEqual(result.modifierList?.keywordModifiers[1], "nonatomic")
        XCTAssertEqual(sut.diagnostics.errors.count, 1)
    }
    
    func testParsePropertyMissingNameRecovery() throws {
        let source = "@property BOOL ;"
        let sut = ObjcParser(string: source)
        
        let result = _parseTestPropertyNode(source: source, parser: sut)
        
        XCTAssertEqual(result.type.type, .struct("BOOL"))
        XCTAssertFalse(result.identifier.exists)
        XCTAssertNil(result.modifierList)
        XCTAssertEqual(result.childrenMatching(type: TokenNode.self)[0].token.type, .semicolon)
        XCTAssertEqual(sut.diagnostics.errors.count, 1)
    }
    
    func testParsePropertyMissingTypeAndNameRecovery() throws {
        let source = "@property ;"
        let sut = ObjcParser(string: source)
        
        let result = _parseTestPropertyNode(source: source, parser: sut)
        
        XCTAssertEqual(result.type.exists, false)
        XCTAssertFalse(result.identifier.exists)
        XCTAssertNil(result.modifierList)
        XCTAssertEqual(result.childrenMatching(type: TokenNode.self)[0].token.type, .semicolon)
        XCTAssertEqual(sut.diagnostics.errors.count, 2)
    }
    
    private func _parseTestPropertyNode(source: String, parser: ObjcParser, file: String = #file, line: Int = #line) -> PropertyDefinition {
        do {
            let root: GlobalContextNode =
                try parser.withTemporaryContext {
                    try parser.parsePropertyNode()
                }
            
            let result: PropertyDefinition! = root.childrenMatching().first
            
            return result
        } catch {
            recordFailure(withDescription: "Failed to parse test '\(source)': \(error)", inFile: #file, atLine: line, expected: false)
            fatalError()
        }
    }
}
