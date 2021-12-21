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

    #if JS_PARSER_TESTS_FULL_FIXTURES

    func testParse_allFixtures() throws {
        let fixtures = try XCTUnwrap(Bundle.module.urls(forResourcesWithExtension: "js", subdirectory: nil))

        let exp = expectation(description: "JsParser fixture tests")

        let queue = OperationQueue()

        for fixture in fixtures {
            let fixture = fixture as URL

            queue.addOperation {
                do {
                    let source = try String(contentsOf: fixture, encoding: .utf8)
                    let sut = JsParser(string: source, state: JsParserState())
                    
                    try sut.parse()

                    if !sut.diagnostics.errors.isEmpty {
                        var diag = ""
                        sut.diagnostics.printDiagnostics(to: &diag)
                        
                        XCTFail("Unexpected error diagnostics while parsing \(fixture.lastPathComponent):\n\(diag)")
                    }
                } catch {

                }
            }
        }

        queue.addBarrierBlock {
            exp.fulfill()
        }

        wait(for: [exp], timeout: 60.0)
    }

    #endif
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
