import XCTest
import Foundation
import JsGrammarModels

@testable import JsParser

class JsParserTests: XCTestCase {
    func testParseSimpleProgram() {
        _=parserTest("""
            function abc() { }
            """)
    }

    func testParse_bezierFixture() throws {
        let fixtureUrl = try XCTUnwrap(Bundle.module.url(forResource: "bezier", withExtension: "js"))

        let source = try String(contentsOf: fixtureUrl, encoding: .utf8)

        _=parserTest(source)
    }
}

extension JsParserTests {
    private func parserTest(_ source: String, file: StaticString = #filePath, line: UInt = #line) -> JsGlobalContextNode {
        let sut = JsParser(string: source)
        
        return _parseTestGlobalContextNode(source: source, parser: sut, file: file, line: line)
    }
    
    private func _parseTestGlobalContextNode(source: String, parser: JsParser, file: StaticString = #filePath, line: UInt = #line) -> JsGlobalContextNode {
        do {
            try parser.parse()
            
            if !parser.diagnostics.diagnostics.isEmpty {
                var diag = ""
                parser.diagnostics.printDiagnostics(to: &diag)
                
                XCTFail("Unexpected diagnostics while parsing:\n\(diag)", file: file, line: line)
            }
            
            return parser.rootNode
        } catch {
            XCTFail("Failed to parse test '\(source)': \(error)", file: file, line: line)
            fatalError()
        }
    }
}
