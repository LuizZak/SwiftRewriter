import KnownType
import SwiftAST
import SwiftRewriterLib
import AntlrCommons
import Intentions
import TypeSystem
import ObjcParserAntlr
import ObjcParser
import ObjectiveCFrontend
import TestCommons
import Utils

final class ObjectiveCExpressionPassTestAdapter: ExpressionPassTestCaseAdapter {
    static var _state: ObjcParserState = ObjcParserState()

    typealias Lexer = ObjectiveCLexer
    typealias Parser = ObjectiveCParser

    init() {

    }

    func makeParser(for source: String) -> AntlrParser<Lexer, Parser> {
        return try! Self._state.makeMainParser(input: source)
    }

    func parseExpression(
        _ parser: Parser,
        source: Source,
        typeSystem: TypeSystem,
        intentionContext: FunctionBodyCarryingIntention?,
        container: StatementContainer?
    ) throws -> Expression? {
        let expression = try parser.expression()

        let typeMapper = DefaultTypeMapper(typeSystem: typeSystem)

        let context = ObjectiveCASTReaderContext(
            typeSystem: typeSystem,
            typeContext: nil,
            comments: []
        )

        let reader = ObjectiveCExprASTReader(
            typeMapper: typeMapper,
            typeParser: ObjcTypeParser(
                state: Self._state,
                source: source
            ),
            context: context,
            delegate: nil
        )

        return expression.accept(reader)
    }

    func parseStatement(
        _ parser: Parser,
        source: Source,
        typeSystem: TypeSystem,
        intentionContext: FunctionBodyCarryingIntention?,
        container: StatementContainer?
    ) throws -> Statement? {
        let stmt = try parser.statement()

        let typeMapper = DefaultTypeMapper(typeSystem: typeSystem)
        let typeParser = ObjcTypeParser(
            state: Self._state,
            source: source
        )

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

        return stmt.accept(reader)
    }
}
