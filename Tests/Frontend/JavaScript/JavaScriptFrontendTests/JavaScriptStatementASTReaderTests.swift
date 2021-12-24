import XCTest
import Antlr4
import JsParser
import TypeSystem
import JsParserAntlr
import SwiftAST

@testable import JavaScriptFrontend

class JavaScriptStatementASTReaderTests: XCTestCase {
    var tokens: CommonTokenStream!
    
    func testBlockStatement() {
        assert(
            jsStmt: """
            { }
            """,
            readsAs: CompoundStatement()
        )
    }

    func testVariableStatement() {
        // var
        assert(
            jsStmt: """
            var a;
            """,
            readsAs: .variableDeclarations([
                .init(identifier: "a", storage: .variable(ofType: .any), initialization: nil),
            ])
        )
        // let
        assert(
            jsStmt: """
            let a;
            """,
            readsAs: .variableDeclarations([
                .init(identifier: "a", storage: .variable(ofType: .any), initialization: nil)
            ])
        )
        // const
        assert(
            jsStmt: """
            const a;
            """,
            readsAs: .variableDeclarations([
                .init(identifier: "a", storage: .constant(ofType: .any), initialization: nil)
            ])
        )
        // Multi-declaration statement
        assert(
            jsStmt: """
            var a = 0, b = 1, c;
            """,
            readsAs: .variableDeclarations([
                .init(identifier: "a", storage: .variable(ofType: .any), initialization: .constant(0)),
                .init(identifier: "b", storage: .variable(ofType: .any), initialization: .constant(1)),
                .init(identifier: "c", storage: .variable(ofType: .any), initialization: nil)
            ])
        )
    }
}

extension JavaScriptStatementASTReaderTests {

    func assert(
        jsStmt: String,
        parseWith: (JavaScriptParser) throws -> ParserRuleContext = { parser in
            try parser.statement()
        },
        readsAs expected: Statement,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {

        let typeSystem = TypeSystem()

        let context = JavaScriptASTReaderContext(
            typeSystem: typeSystem,
            typeContext: nil,
            comments: []
        )

        let expReader = JavaScriptExprASTReader(
            context: context,
            delegate: nil
        )

        let sut =
            JavaScriptStatementASTReader(
                expressionReader: expReader,
                context: context,
                delegate: nil
            )

        do {
            let state = try JavaScriptStatementASTReaderTests._state.makeMainParser(input: jsStmt)
            tokens = state.tokens

            let expr = try parseWith(state.parser)

            let result = expr.accept(sut)

            if result != expected {
                var resStr = "nil"
                var stmtStr = ""

                if let result = result {
                    resStr = ""
                    dump(result, to: &resStr)
                }
                dump(expected, to: &stmtStr)

                XCTFail(
                    """
                    Failed: Expected to read JavaScript statement
                    \(jsStmt)
                    as
                    \(stmtStr)
                    but read as
                    \(resStr)
                    """,
                    file: file,
                    line: line
                )
            }
        }
        catch {
            XCTFail(
                "Unexpected error(s) parsing JavaScript: \(error)",
                file: file,
                line: line
            )
        }
    }

    private static var _state = JsParserState()
}

