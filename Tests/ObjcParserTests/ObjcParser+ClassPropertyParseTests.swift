import XCTest
@testable import ObjcParser
import GrammarModels

class ObjcParser_ClassPropertyParseTests: XCTestCase {
    
    func testParseClassWithProperty() throws {
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
    
    func testParseClassWithPropertyWithGenericType() throws {
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
    
    func testParseClassWithPropertyWithModifiers() throws {
        let source = "@property ( atomic, nonatomic , copy ) BOOL myProperty1;"
        let sut = ObjcParser(string: source)
        
        let result = _parseTestPropertyNode(source: source, parser: sut)
        
        XCTAssertEqual(result.type.type, .struct("BOOL"))
        XCTAssertEqual(result.identifier.name, "myProperty1")
        XCTAssertNotNil(result.modifierList)
        XCTAssertEqual(result.modifierList?.modifiers[0].name, "atomic")
        XCTAssertEqual(result.modifierList?.modifiers[1].name, "nonatomic")
        XCTAssertEqual(result.modifierList?.modifiers[2].name, "copy")
        XCTAssert(sut.diagnostics.errors.count == 0, sut.diagnostics.errors.description)
    }
    
    func testParseClassWithPropertyWithModifiersRecovery() throws {
        let source = "@property ( atomic, nonatomic , ) BOOL myProperty1;"
        let sut = ObjcParser(string: source)
        
        let result = _parseTestPropertyNode(source: source, parser: sut)
        
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
    
    private func _parseTestPropertyNode(source: String, parser: ObjcParser, file: String = #file, line: Int = #line) -> ObjcClassInterface.Property {
        do {
            let root: GlobalContextNode =
                try parser.withTemporaryContext {
                    try parser.parsePropertyNode()
                }
            
            let result: ObjcClassInterface.Property! = root.childrenMatching().first
            
            return result
        } catch {
            recordFailure(withDescription: "Failed to parse test '\(source)': \(error)", inFile: #file, atLine: line, expected: false)
            fatalError()
        }
    }
}
