import Antlr4
import AntlrCommons
import GrammarModelBase
import Intentions
import ObjcParser
import ObjcParserAntlr
import ObjectiveCFrontend
import SwiftAST
import SwiftRewriterLib
import SwiftSyntaxSupport
import TypeSystem
import Utils
import WriterTargetOutput
import XCTest

@testable import ExpressionPasses

class ExpressionPassTestCase: XCTestCase {
    static var _state: ObjcParserState = ObjcParserState()

    var notified: Bool = false
    var sutType: ASTRewriterPass.Type!
    var typeSystem: TypeSystem!
    var intentionContext: FunctionBodyCarryingIntention?
    var functionBodyContext: FunctionBodyIntention?

    override func setUp() {
        super.setUp()

        typeSystem = TypeSystem()
        notified = false
        intentionContext = nil
        functionBodyContext = nil
    }

    func assertNotifiedChange(file: StaticString = #filePath, line: UInt = #line) {
        if !notified {
            XCTFail(
                """
                Expected syntax rewriter \(sutType!) to notify change via \
                \(\ASTRewriterPassContext.notifyChangedTree), but it did not.
                """,
                file: file,
                line: line
            )
        }
    }

    func assertDidNotNotifyChange(file: StaticString = #filePath, line: UInt = #line) {
        if notified {
            XCTFail(
                """
                Expected syntax rewriter \(sutType!) to not notify any changes \
                via \(\ASTRewriterPassContext.notifyChangedTree), but it did.
                """,
                file: file,
                line: line
            )
        }
    }

    @discardableResult
    func assertTransformParsed(
        expression original: String,
        into expected: String,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> Expression {
        notified = false
        let exp = parse(original, file: file, line: line)

        let sut = makeSut()
        let result = sut.apply(on: exp, context: makeContext())

        if expected != result.description {
            XCTFail(
                """
                Failed to convert: Expected to convert expression

                \(expected)

                but received

                \(result.description)
                """,
                file: file,
                line: line
            )
        }

        return result
    }

    @discardableResult
    func assertTransformParsed(
        expression original: String,
        into expected: Expression,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> Expression {

        let exp = parse(original, file: file, line: line)
        return assertTransform(expression: exp, into: expected, file: file, line: line)
    }

    @discardableResult
    func assertTransformParsed(
        statement original: String,
        into expected: Statement,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> Statement {

        let stmt = parseStmt(original, file: file, line: line)
        return assertTransform(statement: stmt, into: expected, file: file, line: line)
    }

    @discardableResult
    func assertTransform(
        expression: Expression,
        into expected: Expression,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> Expression {

        notified = false
        let sut = makeSut()
        let result = sut.apply(on: expression, context: makeContext())

        if expected != result {
            var expString = ""
            var resString = ""

            dump(expected, to: &expString)
            dump(result, to: &resString)

            XCTFail(
                """
                Failed to convert: Expected to convert expression into
                \(expString)
                but received
                \(resString)
                """,
                file: file,
                line: line
            )
        }

        return result
    }

    @discardableResult
    func assertNoTransform(
        statement: Statement,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> Statement {
        
        defer { 
            assertDidNotNotifyChange(
                file: file,
                line: line
            )
        }

        return assertTransform(
            statement: statement,
            into: statement,
            file: file,
            line: line
        )
    }

    @discardableResult
    func assertTransform(
        statement: Statement,
        into expected: Statement,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> Statement {

        notified = false
        let sut = makeSut()
        let result = sut.apply(on: statement, context: makeContext())

        if expected != result {
            var expString = ""
            var resString = ""

            let producer = SwiftSyntaxProducer()

            expString = producer.generateStatement(expected).description + "\n"
            resString = producer.generateStatement(result).description + "\n"

            dump(expected, to: &expString)
            dump(result, to: &resString)

            XCTFail(
                """
                Failed to convert: Expected to convert statement into

                \(expString)

                but received

                \(resString)
                """,
                file: file,
                line: line
            )
        }

        return result
    }

    func parse(_ exp: String, file: StaticString = #filePath, line: UInt = #line) -> Expression {
        let (stream, parser) = objcParser(for: exp)
        defer {
            _ = stream  // Keep alive!
        }
        let diag = AntlrDiagnosticsErrorListener(
            source: StringCodeSource(source: exp),
            diagnostics: Diagnostics()
        )
        parser.addErrorListener(diag)

        let expression = try! parser.expression()

        if !diag.diagnostics.diagnostics.isEmpty {
            let summary = diag.diagnostics.diagnosticsSummary()
            XCTFail(
                "Unexpected diagnostics while parsing expression:\n\(summary)",
                file: file,
                line: line
            )
        }

        let typeMapper = DefaultTypeMapper(typeSystem: typeSystem)

        let context = ObjectiveCASTReaderContext(
            typeSystem: typeSystem,
            typeContext: nil,
            comments: []
        )

        let reader = ObjectiveCExprASTReader(
            typeMapper: typeMapper,
            typeParser: ObjcTypeParser(state: ExpressionPassTestCase._state),
            context: context,
            delegate: nil
        )

        return expression.accept(reader)!
    }

    func parseStmt(_ stmtString: String, file: StaticString = #filePath, line: UInt = #line)
        -> Statement
    {
        let (stream, parser) = objcParser(for: stmtString)
        defer {
            _ = stream  // Keep alive!
        }
        let diag = AntlrDiagnosticsErrorListener(
            source: StringCodeSource(source: stmtString),
            diagnostics: Diagnostics()
        )
        parser.addErrorListener(diag)

        let stmt = try! parser.statement()

        if !diag.diagnostics.diagnostics.isEmpty {
            let summary = diag.diagnostics.diagnosticsSummary()
            XCTFail(
                "Unexpected diagnostics while parsing statement:\n\(summary)",
                file: file,
                line: line
            )
        }

        let typeMapper = DefaultTypeMapper(typeSystem: typeSystem)
        let typeParser = ObjcTypeParser(state: ExpressionPassTestCase._state)

        let expReader =
            ObjectiveCExprASTReader(
                typeMapper: typeMapper,
                typeParser: typeParser,
                context: ObjectiveCASTReaderContext(
                    typeSystem: typeSystem,
                    typeContext: nil,
                    comments: []
                ),
                delegate: nil
            )

        let reader = ObjectiveCStatementASTReader(
            expressionReader: expReader,
            context: expReader.context,
            delegate: nil
        )

        return stmt.accept(reader)!
    }

    func objcParser(for objc: String) -> (CommonTokenStream, ObjectiveCParser) {
        let parser = try! ExpressionPassTestCase._state.makeMainParser(input: objc)
        return (parser.tokens, parser.parser)
    }

    func makeSut() -> ASTRewriterPass {
        return sutType.init(context: makeContext())
    }

    func makeContext(functionBody: CompoundStatement? = nil) -> ASTRewriterPassContext {
        let block: () -> Void = { [weak self] in
            self?.notified = true
        }

        return ASTRewriterPassContext(
            typeSystem: typeSystem,
            notifyChangedTree: block,
            source: intentionContext,
            functionBodyIntention: functionBodyContext
        )
    }
}
