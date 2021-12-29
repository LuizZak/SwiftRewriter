import Antlr4
import AntlrCommons
import Foundation
import GrammarModelBase
import JsGrammarModels
import JsParserAntlr
import Utils
import XCTest

@testable import JsParser

class JsParserListenerTests: XCTestCase {
    // Keep-alive to allow `.getText()` queries during tests.
    private var _parser: JavaScriptParser?

    override func tearDown() {
        super.tearDown()

        _parser = nil
    }

    func testCollectClass() throws {
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

    func testCollectFunction() throws {
        let node = parserTest(
            """
            function test() {

            }
            """
        )

        let functionDecl: JsFunctionDeclarationNode = try XCTUnwrap(node.firstChild())

        XCTAssertEqual(functionDecl.identifier?.name, "test")
    }

    func testCollectVariableDeclaration() throws {
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
        XCTAssertEqual(
            getText(variableDecls[1].variableDeclarations[0].expression?.expression),
            "0"
        )
        // const c = a + b;
        XCTAssertEqual(variableDecls[2].varModifier, .const)
        XCTAssertEqual(variableDecls[2].variableDeclarations.count, 1)
        XCTAssertEqual(variableDecls[2].variableDeclarations[0].identifier?.name, "c")
        XCTAssertEqual(
            getText(variableDecls[2].variableDeclarations[0].expression?.expression),
            "a + b"
        )
    }

    func testCollectClassComments() throws {
        let input = """
            // A comment
            // Another comment
            class A {
            }
            """
        let comments = JsParser.parseComments(input: input)
        let node = parserTest(input, comments: comments)

        let classNode: JsClassNode = try XCTUnwrap(node.firstChild())

        XCTAssertEqual(classNode.precedingComments.map(\.string), [
            "// A comment\n",
            "// Another comment\n"
        ])
    }

    func testCollectClassPropertyComments() throws {
        let input = """
            class A {
                // A comment
                // Another comment
                a = 0
            }
            """
        let comments = JsParser.parseComments(input: input)
        let node = parserTest(input, comments: comments)

        let classNode: JsClassNode = try XCTUnwrap(node.firstChild())

        XCTAssertEqual(classNode.properties.first?.precedingComments.map(\.string), [
            "// A comment\n",
            "// Another comment\n"
        ])
    }

    func testCollectClassMethodComments() throws {
        let input = """
            class A {
                // A comment
                // Another comment
                f() {
                }
            }
            """
        let comments = JsParser.parseComments(input: input)
        let node = parserTest(input, comments: comments)

        let classNode: JsClassNode = try XCTUnwrap(node.firstChild())

        XCTAssertEqual(classNode.methods.first?.precedingComments.map(\.string), [
            "// A comment\n",
            "// Another comment\n"
        ])
    }

    func testCollectGlobalVariableComments() throws {
        let input = """
            // A comment
            // Another comment
            var a = 0;
            """
        let comments = JsParser.parseComments(input: input)
        let node = parserTest(input, comments: comments)

        let variableNode: JsVariableDeclarationListNode = try XCTUnwrap(node.firstChild())

        XCTAssertEqual(variableNode.precedingComments.map(\.string), [
            "// A comment\n",
            "// Another comment\n"
        ])
    }

    func testCollectMultilineComments() throws {
        let input = """
            /**
             * Bezier curve constructor.
             *
             * ...docs pending...
             */
            var a = 0;
            """
        let comments = JsParser.parseComments(input: input)
        let node = parserTest(input, comments: comments)

        let variableNode: JsVariableDeclarationListNode = try XCTUnwrap(node.firstChild())
        let mappedComment = try XCTUnwrap(variableNode.precedingComments.map(\.string).first)

        XCTAssertEqual(mappedComment,
            """
            /**
             * Bezier curve constructor.
             *
             * ...docs pending...
             */
            """
        )
    }

    // MARK: - Test internals

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
    private func parserTest(_ source: String, comments: [CodeComment] = [], file: StaticString = #filePath, line: UInt = #line) -> JsGlobalContextNode
    {
        return _parseTestGlobalContextNode(source: source, comments: comments, file: file, line: line)
    }

    private func _parseTestGlobalContextNode(
        source: String,
        comments: [CodeComment],
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> JsGlobalContextNode {
        do {
            let parserState = try JsParserState().makeMainParser(input: source)
            let parser = parserState.parser
            _parser = parser  // Keep object alive long enough for ParserRuleContext.getText() calls

            let codeSource = StringCodeSource(source: source, fileName: "test.js")
            let diagnostics = Diagnostics()

            let errorListener = AntlrDiagnosticsErrorListener(
                source: codeSource,
                diagnostics: diagnostics
            )
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

            let commentQuerier = CommentQuerier(allComments: comments)
            let listener = JsParserListener(sourceString: source, source: codeSource, commentQuerier: commentQuerier)

            let walker = ParseTreeWalker()
            try walker.walk(listener, root)

            return listener.rootNode
        }
        catch {
            XCTFail("Failed to parse test '\(source)': \(error)", file: file, line: line)
            fatalError()
        }
    }
}
