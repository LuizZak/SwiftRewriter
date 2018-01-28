import XCTest
@testable import ObjcParser
import GrammarModels

class ObjcParserTests: XCTestCase {
    static var allTests = [
        ("testInit", testInit),
    ]
    
    func testInit() {
        _=ObjcParser(string: "abc")
    }
    
    func testParseComments() {
        let source = """
            // Test comment
            /*
                Test multi-line comment
            */
            """
        _=parserTest(source)
    }
    
    func testParseDeclarationAfterComments() {
        let source = """
            // Test comment
            /*
                Test multi-line comment
            */
            @interface MyClass
            @end
            """
        _=parserTest(source)
    }
    
    private func parserTest(_ source: String) -> GlobalContextNode {
        let sut = ObjcParser(string: source)
        
        return _parseTestGlobalContextNode(source: source, parser: sut)
    }
    
    private func _parseTestGlobalContextNode(source: String, parser: ObjcParser, file: String = #file, line: Int = #line) -> GlobalContextNode {
        do {
            try parser.parse()
            return parser.rootNode
        } catch {
            recordFailure(withDescription: "Failed to parse test '\(source)': \(error)", inFile: #file, atLine: line, expected: false)
            fatalError()
        }
    }
}
