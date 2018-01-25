import XCTest
@testable import ObjcParser
import GrammarModels

class ObjcParser_ClassMethodParseTests: XCTestCase {
    
    func testParseSimpleMethod() throws {
        let source = "- (void)abc;"
        let sut = ObjcParser(string: source)
        
        let result = _parseTestMethodNode(source: source, parser: sut)
        
        XCTAssert(result.childrenMatching(type: TokenNode.self).contains { $0.token.type == .operator(.subtract) })
        XCTAssertEqual(result.returnType.type.type, .void)
        XCTAssertEqual(result.methodSelector.selector?.identifier?.name, "abc")
        XCTAssert(result.childrenMatching(type: TokenNode.self).contains { $0.token.type == .semicolon })
        XCTAssert(sut.diagnostics.errors.count == 0, sut.diagnostics.errors.description)
    }
    
    func testParseMethodWithParameter() throws {
        let source = "- (void)abc:(NSInteger)a;"
        let sut = ObjcParser(string: source)
        
        let result = _parseTestMethodNode(source: source, parser: sut)
        
        XCTAssert(result.childrenMatching(type: TokenNode.self).contains { $0.token.type == .operator(.subtract) })
        XCTAssertEqual(result.returnType.type.type, .void)
        XCTAssertEqual(result.methodSelector.selector?.keywordDeclarations?[0].selector?.name, "abc")
        XCTAssertEqual(result.methodSelector.selector?.keywordDeclarations?[0].type?.type.type, .struct("NSInteger"))
        XCTAssertEqual(result.methodSelector.selector?.keywordDeclarations?[0].identifier?.name, "a")
        XCTAssert(result.childrenMatching(type: TokenNode.self).contains { $0.token.type == .semicolon })
        XCTAssert(sut.diagnostics.errors.count == 0, sut.diagnostics.errors.description)
    }
    
    func testParseMethodWithTwoParameters() throws {
        let source = "- (void)abc:(NSInteger)a def:(NSString*)def;"
        let sut = ObjcParser(string: source)
        
        let result = _parseTestMethodNode(source: source, parser: sut)
        
        XCTAssert(result.childrenMatching(type: TokenNode.self).contains { $0.token.type == .operator(.subtract) })
        XCTAssertEqual(result.returnType.type.type, .void)
        
        XCTAssertEqual(result.methodSelector.selector?.keywordDeclarations?[0].selector?.name, "abc")
        XCTAssertEqual(result.methodSelector.selector?.keywordDeclarations?[0].type?.type.type, .struct("NSInteger"))
        XCTAssertEqual(result.methodSelector.selector?.keywordDeclarations?[0].identifier?.name, "a")
        
        XCTAssertEqual(result.methodSelector.selector?.keywordDeclarations?[1].selector?.name, "def")
        XCTAssertEqual(result.methodSelector.selector?.keywordDeclarations?[1].type?.type.type, .pointer(.struct("NSString")))
        XCTAssertEqual(result.methodSelector.selector?.keywordDeclarations?[1].identifier?.name, "def")
        
        XCTAssert(result.childrenMatching(type: TokenNode.self).contains { $0.token.type == .semicolon })
        XCTAssert(sut.diagnostics.errors.count == 0, sut.diagnostics.errors.description)
    }
    
    func testParseMethodWithTypelessParameters() throws {
        let source = "- (void)abc:a def:(NSString*)def;"
        let sut = ObjcParser(string: source)
        
        let result = _parseTestMethodNode(source: source, parser: sut)
        
        XCTAssert(result.childrenMatching(type: TokenNode.self).contains { $0.token.type == .operator(.subtract) })
        XCTAssertEqual(result.returnType.type.type, .void)
        
        XCTAssertEqual(result.methodSelector.selector?.keywordDeclarations?[0].selector?.name, "abc")
        XCTAssertNil(result.methodSelector.selector?.keywordDeclarations?[0].type)
        XCTAssertEqual(result.methodSelector.selector?.keywordDeclarations?[0].identifier?.name, "a")
        
        XCTAssertEqual(result.methodSelector.selector?.keywordDeclarations?[1].selector?.name, "def")
        XCTAssertEqual(result.methodSelector.selector?.keywordDeclarations?[1].type?.type.type, .pointer(.struct("NSString")))
        XCTAssertEqual(result.methodSelector.selector?.keywordDeclarations?[1].identifier?.name, "def")
        
        XCTAssert(result.childrenMatching(type: TokenNode.self).contains { $0.token.type == .semicolon })
        XCTAssert(sut.diagnostics.errors.count == 0, sut.diagnostics.errors.description)
    }
    
    func testParseMethodWithNamelessTypelessParameters() throws {
        let source = "- (void)abc:a:b:c;"
        let sut = ObjcParser(string: source)
        
        let result = _parseTestMethodNode(source: source, parser: sut)
        
        XCTAssert(result.childrenMatching(type: TokenNode.self).contains { $0.token.type == .operator(.subtract) })
        XCTAssertEqual(result.returnType.type.type, .void)
        
        XCTAssertEqual(result.methodSelector.selector?.keywordDeclarations?[0].selector?.name, "abc")
        XCTAssertNil(result.methodSelector.selector?.keywordDeclarations?[0].type)
        XCTAssertEqual(result.methodSelector.selector?.keywordDeclarations?[0].identifier?.name, "a")
        
        XCTAssertNil(result.methodSelector.selector?.keywordDeclarations?[1].selector)
        XCTAssertNil(result.methodSelector.selector?.keywordDeclarations?[1].type)
        XCTAssertEqual(result.methodSelector.selector?.keywordDeclarations?[1].identifier?.name, "b")
        
        XCTAssertNil(result.methodSelector.selector?.keywordDeclarations?[2].selector)
        XCTAssertNil(result.methodSelector.selector?.keywordDeclarations?[2].type)
        XCTAssertEqual(result.methodSelector.selector?.keywordDeclarations?[2].identifier?.name, "c")
        
        XCTAssert(result.childrenMatching(type: TokenNode.self).contains { $0.token.type == .semicolon })
        XCTAssert(sut.diagnostics.errors.count == 0, sut.diagnostics.errors.description)
    }
    
    /*
    func testParseClassWithPropertyWithGenericType() throws {
        // Arrange
        let source = "@property NSArray<NSString*>* myProperty3;"
        let sut = ObjcParser(string: source)
        
        // Act
        let result = _parseTestMethodNode(source: source, parser: sut)
        
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
        
        let result = _parseTestMethodNode(source: source, parser: sut)
        
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
        
        let result = _parseTestMethodNode(source: source, parser: sut)
        
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
        
        let result = _parseTestMethodNode(source: source, parser: sut)
        
        XCTAssertEqual(result.type.type, .struct("BOOL"))
        XCTAssertFalse(result.identifier.exists)
        XCTAssertNil(result.modifierList)
        XCTAssertEqual(result.childrenMatching(type: TokenNode.self)[0].token.type, .semicolon)
        XCTAssertEqual(sut.diagnostics.errors.count, 1)
    }
    
    func testParsePropertyMissingTypeAndNameRecovery() throws {
        let source = "@property ;"
        let sut = ObjcParser(string: source)
        
        let result = _parseTestMethodNode(source: source, parser: sut)
        
        XCTAssertEqual(result.type.exists, false)
        XCTAssertFalse(result.identifier.exists)
        XCTAssertNil(result.modifierList)
        XCTAssertEqual(result.childrenMatching(type: TokenNode.self)[0].token.type, .semicolon)
        XCTAssertEqual(sut.diagnostics.errors.count, 2)
    }
    */
    private func _parseTestMethodNode(source: String, parser: ObjcParser, file: String = #file, line: Int = #line) -> MethodDefinition {
        do {
            let root: GlobalContextNode =
                try parser.withTemporaryContext {
                    try parser.parseMethodDeclaration()
            }
            
            let result: MethodDefinition! = root.childrenMatching().first
            
            return result
        } catch {
            recordFailure(withDescription: "Failed to parse test '\(source)': \(error)", inFile: #file, atLine: line, expected: false)
            fatalError()
        }
    }
}

