import Antlr4
import AntlrCommons
import GrammarModelBase
import Intentions
import SwiftAST
import SwiftRewriterLib
import SwiftSyntaxSupport
import TypeSystem
import Utils
import WriterTargetOutput
import XCTest

import ExpressionPasses

public protocol ExpressionPassTestCaseAdapter {
    associatedtype Lexer: Antlr4.Lexer
    associatedtype Parser: Antlr4.Parser

    init()

    func makeParser(for source: String) throws -> AntlrParser<Lexer, Parser>

    func parseExpression(
        _ parser: Parser,
        source: Source,
        typeSystem: TypeSystem,
        intentionContext: FunctionBodyCarryingIntention?,
        container: StatementContainer?
    ) throws -> SwiftAST.Expression?

    func parseStatement(
        _ parser: Parser,
        source: Source,
        typeSystem: TypeSystem,
        intentionContext: FunctionBodyCarryingIntention?,
        container: StatementContainer?
    ) throws -> Statement?
}

open class ExpressionPassTestCase<Adapter: ExpressionPassTestCaseAdapter>: XCTestCase {
    var adapter: Adapter!

    public var notified: Bool = false
    public var sutType: ASTRewriterPass.Type!
    public var typeSystem: TypeSystem!
    public var intentionContext: FunctionBodyCarryingIntention?
    public var container: StatementContainer?

    open override func setUp() {
        super.setUp()

        adapter = Adapter()
        typeSystem = TypeSystem()
        notified = false
        intentionContext = nil
        container = nil
    }

    @discardableResult
    public func assertNoTransformParsed(
        expression original: String,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> SwiftAST.Expression {

        let exp = parse(original, file: file, line: line)

        return assertNoTransform(
            expression: exp,
            file: file,
            line: line
        )
    }

    @discardableResult
    public func assertTransformParsed(
        expression original: String,
        into expected: SwiftAST.Expression,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> SwiftAST.Expression {

        let exp = parse(original, file: file, line: line)
        return assertTransform(expression: exp, into: expected, file: file, line: line)
    }

    @discardableResult
    public func assertTransformParsed(
        statement original: String,
        into expected: Statement,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> Statement {

        let stmt = parseStmt(original, file: file, line: line)
        return assertTransform(statement: stmt, into: expected, file: file, line: line)
    }

    @discardableResult
    public func assertNoTransformParsed(
        statement original: String,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> Statement {

        let stmt = parseStmt(original, file: file, line: line)
        return assertNoTransform(statement: stmt, file: file, line: line)
    }

    @discardableResult
    public func assertNoTransform(
        expression: SwiftAST.Expression,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> SwiftAST.Expression {

        defer {
            assertDidNotNotifyChange(
                file: file,
                line: line
            )
        }

        return _assertTransform(
            expression: expression,
            into: expression,
            file: file,
            line: line
        )
    }

    @discardableResult
    public func assertTransform(
        expression: SwiftAST.Expression,
        into expected: SwiftAST.Expression,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> SwiftAST.Expression {

        defer {
            assertNotifiedChange(
                file: file,
                line: line
            )
        }

        return _assertTransform(
            expression: expression,
            into: expected,
            file: file,
            line: line
        )
    }

    @discardableResult
    public func assertNoTransform(
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

        return _assertTransform(
            statement: statement,
            into: statement,
            file: file,
            line: line
        )
    }

    @discardableResult
    public func assertTransform(
        statement: Statement,
        into expected: Statement,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> Statement {

        defer {
            assertNotifiedChange(
                file: file,
                line: line
            )
        }

        return _assertTransform(
            statement: statement,
            into: expected,
            file: file,
            line: line
        )
    }

    @discardableResult
    private func _assertTransform(
        statement: Statement,
        into expected: Statement,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> Statement {

        let sut = makeSut(container: .statement(statement))
        let result = sut.apply(on: statement, context: makeContext(container: .statement(statement)))

        assertStatementsEqual(
            actual: result,
            expected: expected,
            messageHeader: "Failed to convert: Expected to convert statement into",
            file: file,
            line: line
        )

        return result
    }

    @discardableResult
    private func _assertTransform(
        expression: SwiftAST.Expression,
        into expected: SwiftAST.Expression,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> SwiftAST.Expression {

        let sut = makeSut(container: .expression(expression))
        let result = sut.apply(on: expression, context: makeContext(container: .expression(expression)))

        assertExpressionsEqual(
            actual: result,
            expected: expected,
            messageHeader: "Failed to convert: Expected to convert expression into",
            file: file,
            line: line
        )

        return result
    }

    public func parse(_ exp: String, file: StaticString = #filePath, line: UInt = #line) -> SwiftAST.Expression {
        let (stream, parser) = try! makeParser(for: exp)
        defer {
            _ = stream  // Keep alive!
        }
        let source = StringCodeSource(source: exp)
        let diag = AntlrDiagnosticsErrorListener(
            source: source,
            diagnostics: Diagnostics()
        )
        parser.addErrorListener(diag)

        let expression = try! adapter.parseExpression(
            parser,
            source: source,
            typeSystem: typeSystem,
            intentionContext: intentionContext,
            container: container
        )

        if !diag.diagnostics.diagnostics.isEmpty {
            let summary = diag.diagnostics.diagnosticsSummary()
            XCTFail(
                "Unexpected diagnostics while parsing expression:\n\(summary)",
                file: file,
                line: line
            )
        }

        return expression!
    }

    public func parseStmt(
        _ stmtString: String,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> Statement {
        let (stream, parser) = try! makeParser(for: stmtString)
        defer {
            _ = stream  // Keep alive!
        }
        let source = StringCodeSource(source: stmtString)
        let diag = AntlrDiagnosticsErrorListener(
            source: source,
            diagnostics: Diagnostics()
        )
        parser.addErrorListener(diag)

        let statement = try! adapter.parseStatement(
            parser,
            source: source,
            typeSystem: typeSystem,
            intentionContext: intentionContext,
            container: container
        )

        if !diag.diagnostics.diagnostics.isEmpty {
            let summary = diag.diagnostics.diagnosticsSummary()
            XCTFail(
                "Unexpected diagnostics while parsing statement:\n\(summary)",
                file: file,
                line: line
            )
        }

        return statement!
    }

    public func makeParser(for source: String) throws -> (CommonTokenStream, Adapter.Parser) {
        let parser = try adapter.makeParser(for: source)
        return (parser.tokens, parser.parser)
    }

    public func makeSut(container: StatementContainer) -> ASTRewriterPass {
        return sutType.init(context: makeContext(container: container))
    }

    public func makeContext(container: StatementContainer) -> ASTRewriterPassContext {
        let block: () -> Void = { [weak self] in
            self?.notified = true
        }

        return ASTRewriterPassContext(
            typeSystem: typeSystem,
            notifyChangedTree: block,
            source: intentionContext,
            container: container
        )
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

        notified = false
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

        notified = false
    }
}
