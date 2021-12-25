import Foundation
import JsGrammarModels
import Utils
import XCTest

@testable import JsParser

class JsParserTests: XCTestCase {
    func testParseSimpleProgram() {
        _ = parserTest(
            """
            function abc() { }
            """
        )
    }

    func testParseClass() throws {
        let node = parserTest(
            """
            class AClass {
                constructor(args) {

                }
                static method() {
                }
                getProperty() {
                    return 0;
                }
            }
            """
        )

        let classDecl: JsClassNode = try XCTUnwrap(node.firstChild())

        XCTAssertEqual(classDecl.identifier?.name, "AClass")
        XCTAssertEqual(classDecl.methods.count, 3)
        XCTAssertEqual(classDecl.methods[0].identifier?.name, "constructor")
        XCTAssertEqual(classDecl.methods[1].identifier?.name, "method")
        XCTAssertEqual(classDecl.methods[2].identifier?.name, "getProperty")
    }

    func testParseFunction() throws {
        let node = parserTest(
            """
            function test() {

            }
            """
        )

        let functionDecl: JsFunctionDeclarationNode = try XCTUnwrap(node.firstChild())

        XCTAssertEqual(functionDecl.identifier?.name, "test")
    }

    #if JS_PARSER_TESTS_FULL_FIXTURES

        func testParse_bezierFixture() throws {
            let fixtureUrl = try XCTUnwrap(
                Bundle.module.url(forResource: "bezier", withExtension: "js")
            )

            let source = try String(contentsOf: fixtureUrl, encoding: .utf8)

            _ = parserTest(source)
        }

        func testParse_allFixtures() throws {
            let fixtures = try XCTUnwrap(
                Bundle.module.urls(forResourcesWithExtension: "js", subdirectory: nil)
            )

            let exp = expectation(description: "JsParser fixture tests")

            let queue = ConcurrentOperationQueue()

            for fixture in fixtures where fixture.path?.contains("Scoping") == true {
                let fixture = fixture as URL

                queue.addOperation {
                    print("Starting test \(fixture.lastPathComponent)...")
                    
                    try withExtendedLifetime(JsParserState()) { state in
                        let source = try String(contentsOf: fixture, encoding: .utf8)
                        let sut = JsParser(string: source, state: state)

                        try sut.parse()

                        if !sut.diagnostics.errors.isEmpty {
                            var diag = ""
                            sut.diagnostics.printDiagnostics(to: &diag)

                            XCTFail(
                                "Unexpected error diagnostics while parsing \(fixture.lastPathComponent):\n\(diag)"
                            )
                        }
                    }
                }
            }

            queue.addBarrierOperation {
                exp.fulfill()
            }

            queue.runConcurrent()

            wait(for: [exp], timeout: 60.0)

            try queue.throwErrorIfAvailable()
        }

    #endif
}

extension JsParserTests {
    private func parserTest(_ source: String, file: StaticString = #filePath, line: UInt = #line)
        -> JsGlobalContextNode
    {
        let sut = JsParser(string: source)

        return _parseTestGlobalContextNode(source: source, parser: sut, file: file, line: line)
    }

    private func _parseTestGlobalContextNode(
        source: String,
        parser: JsParser,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> JsGlobalContextNode {
        do {
            try parser.parse()

            if !parser.diagnostics.diagnostics.isEmpty {
                var diag = ""
                parser.diagnostics.printDiagnostics(to: &diag)

                XCTFail("Unexpected diagnostics while parsing:\n\(diag)", file: file, line: line)
            }

            return parser.rootNode
        }
        catch {
            XCTFail("Failed to parse test '\(source)': \(error)", file: file, line: line)
            fatalError()
        }
    }
}
