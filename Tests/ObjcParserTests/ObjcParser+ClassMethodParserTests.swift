import XCTest
@testable import ObjcParser
import GrammarModels

class ObjcParser_ClassMethodParseTests: XCTestCase {
    
    func testParseSimpleMethod() throws {
        let result = genMethodNode("- (void)abc;")
        
        XCTAssert(result.childrenMatching(type: TokenNode.self).contains { $0.token.type == .operator(.subtract) })
        XCTAssertEqual(result.returnType.type.type, .void)
        XCTAssertEqual(result.methodSelector.selector?.identifier?.name, "abc")
        XCTAssert(result.childrenMatching(type: TokenNode.self).contains { $0.token.type == .semicolon })
    }
    
    func testParseMethodWithParameter() throws {
        let result = genMethodNode("- (void)abc:(NSInteger)a;")
        
        XCTAssert(result.childrenMatching(type: TokenNode.self).contains { $0.token.type == .operator(.subtract) })
        XCTAssertEqual(result.returnType.type.type, .void)
        XCTAssertEqual(result.methodSelector.selector?.keywordDeclarations?[0].selector?.name, "abc")
        XCTAssertEqual(result.methodSelector.selector?.keywordDeclarations?[0].type?.type.type, .struct("NSInteger"))
        XCTAssertEqual(result.methodSelector.selector?.keywordDeclarations?[0].identifier?.name, "a")
        XCTAssert(result.childrenMatching(type: TokenNode.self).contains { $0.token.type == .semicolon })
    }
    
    func testParseMethodWithTwoParameters() throws {
        let result = genMethodNode("- (void)abc:(NSInteger)a def:(NSString*)def;")
        
        XCTAssert(result.childrenMatching(type: TokenNode.self).contains { $0.token.type == .operator(.subtract) })
        XCTAssertEqual(result.returnType.type.type, .void)
        
        XCTAssertEqual(result.methodSelector.selector?.keywordDeclarations?[0].selector?.name, "abc")
        XCTAssertEqual(result.methodSelector.selector?.keywordDeclarations?[0].type?.type.type, .struct("NSInteger"))
        XCTAssertEqual(result.methodSelector.selector?.keywordDeclarations?[0].identifier?.name, "a")
        
        XCTAssertEqual(result.methodSelector.selector?.keywordDeclarations?[1].selector?.name, "def")
        XCTAssertEqual(result.methodSelector.selector?.keywordDeclarations?[1].type?.type.type, .pointer(.struct("NSString")))
        XCTAssertEqual(result.methodSelector.selector?.keywordDeclarations?[1].identifier?.name, "def")
        
        XCTAssert(result.childrenMatching(type: TokenNode.self).contains { $0.token.type == .semicolon })
    }
    
    func testParseMethodWithTypelessParameters() throws {
        let result = genMethodNode("- (void)abc:a def:(NSString*)def;")
        
        XCTAssert(result.childrenMatching(type: TokenNode.self).contains { $0.token.type == .operator(.subtract) })
        XCTAssertEqual(result.returnType.type.type, .void)
        
        XCTAssertEqual(result.methodSelector.selector?.keywordDeclarations?[0].selector?.name, "abc")
        XCTAssertNil(result.methodSelector.selector?.keywordDeclarations?[0].type)
        XCTAssertEqual(result.methodSelector.selector?.keywordDeclarations?[0].identifier?.name, "a")
        
        XCTAssertEqual(result.methodSelector.selector?.keywordDeclarations?[1].selector?.name, "def")
        XCTAssertEqual(result.methodSelector.selector?.keywordDeclarations?[1].type?.type.type, .pointer(.struct("NSString")))
        XCTAssertEqual(result.methodSelector.selector?.keywordDeclarations?[1].identifier?.name, "def")
        
        XCTAssert(result.childrenMatching(type: TokenNode.self).contains { $0.token.type == .semicolon })
    }
    
    func testParseMethodWithNamelessTypelessParameters() throws {
        let result = genMethodNode("- (void)abc:a:b:c;")
        
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
    }
    
    func testParseNullabilitySpecifier() throws {
        let source = "- (void)abc:(nullable NSString*)a;"
        let sut = ObjcParser(string: source)
        
        let result = _parseTestMethodNode(source: source, parser: sut)
        
        XCTAssert(result.childrenMatching(type: TokenNode.self).contains { $0.token.type == .operator(.subtract) })
        XCTAssertEqual(result.returnType.type.type, .void)
        
        let keyword = result.methodSelector.selector?.keywordDeclarations?[0]
        
        XCTAssertEqual(keyword?.selector?.name, "abc")
        XCTAssertEqual(keyword?.type?.nullabilitySpecifiers[0].name, "nullable")
        XCTAssertEqual(keyword?.type?.type.type, .pointer(.struct("NSString")))
        XCTAssertEqual(keyword?.identifier?.name, "a")
        XCTAssert(result.childrenMatching(type: TokenNode.self).contains { $0.token.type == .semicolon })
    }
    
    private func genMethodNode(_ source: String) -> MethodDefinition {
        let sut = ObjcParser(string: source)
        defer {
            XCTAssert(sut.diagnostics.errors.count == 0, sut.diagnostics.errors.description)
        }
        
        return _parseTestMethodNode(source: source, parser: sut)
    }
    
    private func _parseTestMethodNode(source: String, parser: ObjcParser, file: String = #file, line: Int = #line) -> MethodDefinition {
        let finalSrc = """
            @interface myClass
            \(source)
            @end
            """
        
        let parser = ObjcParser(string: finalSrc)
        
        do {
            try parser.parse()
            
            let node =
                parser.rootNode
                    .firstChild(ofType: ObjcClassInterface.self)?
                    .firstChild(ofType: MethodDefinition.self)
            return node!
        } catch {
            recordFailure(withDescription: "Failed to parse test '\(source)': \(error)", inFile: #file, atLine: line, expected: false)
            fatalError()
        }
    }
}
