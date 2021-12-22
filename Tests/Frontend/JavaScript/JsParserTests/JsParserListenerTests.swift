import XCTest
import Foundation
import Antlr4
import JsParserAntlr
import Utils
import JsGrammarModels
import AntlrCommons

@testable import JsParser

class JsParserListenerTests: XCTestCase {
    // Keep-alive to allow `.getText()` queries during tests.
    private var _parser: JavaScriptParser?

    override func tearDown() {
        super.tearDown()

        _parser = nil
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

    func testParseVariableDeclaration() throws {
        let node = parserTest(
            """
            var a;
            let b = 0;
            const c = a + b;
            """
        )

        let variableDecls: [JsVariableDeclarationListNode] = node.childrenMatching()

        XCTAssertEqual(variableDecls.count, 3)
        // var a;
        XCTAssertEqual(variableDecls[0].varModifier, .var)
        XCTAssertEqual(variableDecls[0].variableDeclarations.count, 1)
        XCTAssertEqual(variableDecls[0].variableDeclarations[0].identifier?.name, "a")
        XCTAssertNil(variableDecls[0].variableDeclarations[0].expression)
        // let b = 0;
        XCTAssertEqual(variableDecls[1].varModifier, .let)
        XCTAssertEqual(variableDecls[1].variableDeclarations.count, 1)
        XCTAssertEqual(variableDecls[1].variableDeclarations[0].identifier?.name, "b")
        XCTAssertEqual(getText(variableDecls[1].variableDeclarations[0].expression?.expression), "0")
        // const c = a + b;
        XCTAssertEqual(variableDecls[2].varModifier, .const)
        XCTAssertEqual(variableDecls[2].variableDeclarations.count, 1)
        XCTAssertEqual(variableDecls[2].variableDeclarations[0].identifier?.name, "c")
        XCTAssertEqual(getText(variableDecls[2].variableDeclarations[0].expression?.expression), "a + b")
    }

    private func getText(_ rule: ParserRuleContext?) -> String? {
        guard let rule = rule else {
            return nil
        }
        guard let parser = _parser else {
            return nil
        }

        guard let start = rule.getStart() else {
            return nil
        }
        guard let stop = rule.getStop() else {
            return nil
        }

        return try? parser.getTokenStream()?.getText(start, stop)
    }
}

extension JsParserListenerTests {
    private func parserTest(_ source: String, file: StaticString = #filePath, line: UInt = #line) -> JsGlobalContextNode {
        let sut = JsParser(string: source)
        
        return _parseTestGlobalContextNode(source: source, parser: sut, file: file, line: line)
    }
    
    private func _parseTestGlobalContextNode(source: String, parser: JsParser, file: StaticString = #filePath, line: UInt = #line) -> JsGlobalContextNode {
        do {
            let parserState = try JsParserState().makeMainParser(input: source)
            let parser = parserState.parser
            _parser = parser // Keep object alive long enough for ParserRuleContext.getText() calls

            let codeSource = StringCodeSource(source: source, fileName: "test.js")
            let diagnostics = Diagnostics()
            
            let errorListener = AntlrDiagnosticsErrorListener(source: codeSource, diagnostics: diagnostics)
            parser.removeErrorListeners()
            
            parser.addErrorListener(
                errorListener
            )
        
            parser.getInterpreter().setPredictionMode(.LL)
                
            let root = try parser.program()
            
            if !diagnostics.diagnostics.isEmpty {
                var diag = ""
                diagnostics.printDiagnostics(to: &diag)
                
                XCTFail("Unexpected diagnostics while parsing:\n\(diag)", file: file, line: line)
            }
            
            let listener = JsParserListener(sourceString: source, source: codeSource)
            
            let walker = ParseTreeWalker()
            try walker.walk(listener, root)

            return listener.rootNode
        } catch {
            XCTFail("Failed to parse test '\(source)': \(error)", file: file, line: line)
            fatalError()
        }
    }
}
