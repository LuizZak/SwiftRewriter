import XCTest
import GrammarModels
import Antlr4
import ObjcParser
import ObjcParserAntlr

@testable import ObjcParser

class DefinitionCollectorTests: XCTestCase {

    func testCollect_singleDecl_variable_withInitializer() {
        let tester = prepareTest(declaration: "short int a = 0;")

        tester.assert { nodeList in
            nodeList.assertCount(1)?
                .asserter(forItemAt: 0) { intNode in
                    intNode.assert(isOfType: VariableDeclaration.self)?
                        .assert(type: "signed short int")?
                        .assert(name: "a")?
                        .assert(expressionString: "0")
                }
        }
    }

    func testCollect_singleDecl_variable_noInitializer() {
        let tester = prepareTest(declaration: "short int a;")

        tester.assert { nodeList in
            nodeList.assertCount(1)?
                .asserter(forItemAt: 0) { intNode in
                    intNode.assert(isOfType: VariableDeclaration.self)?
                        .assert(type: "signed short int")?
                        .assert(name: "a")?
                        .assertNoInitializer()
                }
        }
    }

    func testCollect_multiDecl_variable_noInitializer() {
        let tester = prepareTest(declaration: "short int a, *b = NULL, c[5];")

        tester.assert { nodeList in
            nodeList.asserterForIterator()
                .asserterForNext { intNode in
                    intNode.assert(isOfType: VariableDeclaration.self)?
                        .assert(type: "signed short int")?
                        .assert(name: "a")?
                        .assertNoInitializer()
                }?
                .asserterForNext { intNode in
                    intNode.assert(isOfType: VariableDeclaration.self)?
                        .assert(type: .pointer("signed short int"))?
                        .assert(name: "b")?
                        .assert(expressionString: "NULL")
                }?
                .asserterForNext { intNode in
                    intNode.assert(isOfType: VariableDeclaration.self)?
                        .assert(type: .fixedArray("signed short int", length: 5))?
                        .assert(name: "c")?
                        .assertNoInitializer()
                }?
                .assertIsAtEnd()
        }
    }

    func testCollect_singleDecl_typedef() {
        let tester = prepareTest(declaration: "typedef short int A;")

        tester.assert { nodeList in
            nodeList.assertCount(1)?
                .asserter(forItemAt: 0) { intNode in
                    intNode.assert(isOfType: TypedefNode.self)?
                        .assert(type: "signed short int")?
                        .assert(name: "A")
                }
        }
    }

    func testCollect_singleDecl_struct() {
        let tester = prepareTest(declaration: "struct AStruct { int field0; };")

        tester.assert { nodeList in
            nodeList.assertCount(1)?
                .asserter(forItemAt: 0) { intNode in
                    intNode.assert(isOfType: ObjcStructDeclaration.self)?
                        .assert(name: "AStruct")?
                        .assertFieldCount(1)?
                        .asserter(forFieldName: "field0") { field0 in
                            field0
                                .assert(name: "field0")?
                                .assert(type: "signed int")
                        }
                }
        }
    }
}

private extension DefinitionCollectorTests {
    func prepareTest(declaration: String) -> Tester {
        Tester(source: declaration)
    }

    class Tester {
        var parserObject: ObjectiveCParserAntlr?
        let parserState = ObjcParserState()
        var source: String
        var nodeFactory: ASTNodeFactory

        init(source: String) {
            self.source = source
            nodeFactory = ASTNodeFactory(
                source: StringCodeSource(source: source),
                nonnullContextQuerier: NonnullContextQuerier(nonnullMacroRegionsTokenRange: []),
                commentQuerier: CommentQuerier(allComments: [])
            )
        }

        func assert(
            file: StaticString = #file,
            line: UInt = #line,
            _ closure: (Asserter<[ASTNode]>) throws -> Void
        ) rethrows {

            let sut = DefinitionCollector(
                nonnullContextQuerier: nodeFactory.nonnullContextQuerier,
                commentQuerier: nodeFactory.commentQuerier,
                nodeFactory: nodeFactory
            )

            do {
                let parser = try parserState.makeMainParser(input: source)
                parserObject = parser

                let errorListener = ErrorListener()
                parser.parser.addErrorListener(errorListener)

                let decl = try parser.parser.declaration()

                if errorListener.hasErrors {
                    XCTFail(
                        "Error while parsing declaration: \(errorListener.errorDescription)",
                        file: file,
                        line: line
                    )
                    return
                }

                guard let result = sut.collect(from: decl) else {
                    XCTFail(
                        "Failed to collect definitions!",
                        file: file,
                        line: line
                    )
                    return
                }

                try closure(.init(object: result))
            } catch {
                XCTFail(
                    "Failed to parse from source string: \(source)",
                    file: file,
                    line: line
                )
            }
        }
    }
}
