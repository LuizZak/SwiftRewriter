import ObjcParserAntlr
import GrammarModels
import ObjcParser
import SwiftAST
import KnownType
import TypeSystem

/// Reader that reads Objective-C AST and outputs equivalent a Swift AST
public class SwiftASTReader {
    let parserStatePool: ObjcParserStatePool
    let typeMapper: TypeMapper
    let typeParser: TypeParsing
    let typeSystem: TypeSystem?

    weak var delegate: SwiftStatementASTReaderDelegate?

    public init(
        parserStatePool: ObjcParserStatePool,
        typeMapper: TypeMapper,
        typeParser: TypeParsing,
        typeSystem: TypeSystem? = nil
    ) {

        self.parserStatePool = parserStatePool
        self.typeMapper = typeMapper
        self.typeParser = typeParser
        self.typeSystem = typeSystem
    }

    public func parseStatements(
        compoundStatement: ObjectiveCParser.CompoundStatementContext,
        comments: [ObjcComment] = [],
        typeContext: KnownType? = nil
    ) -> CompoundStatement {

        let context = SwiftASTReaderContext(
            typeSystem: typeSystem,
            typeContext: typeContext,
            comments: comments
        )

        let expressionReader = SwiftExprASTReader(
            typeMapper: typeMapper,
            typeParser: typeParser,
            context: context,
            delegate: delegate
        )

        let parser = SwiftStatementASTReader.CompoundStatementVisitor(
            expressionReader: expressionReader,
            context: context,
            delegate: delegate
        )

        guard let result = compoundStatement.accept(parser) else {
            return [.unknown(UnknownASTContext(context: compoundStatement))]
        }

        return result
    }

    public func parseExpression(
        expression: ExpressionNode.ExpressionKind,
        comments: [ObjcComment] = []
    ) -> Expression {

        let parser = parserStatePool.pull()
        defer { parserStatePool.repool(parser) }

        switch expression {
        case .antlr(let expression):
            return parseExpression(
                expression: expression,
                comments: comments
            )
        
        case .string(let source):
            do {
                let parser = try parser.makeMainParser(input: source)
                let expression = try parser.parser.expression()

                return parseExpression(
                    expression: expression,
                    comments: comments
                )
            } catch {
                return .unknown(UnknownASTContext(context: "/* \(expression) */"))
            }
        }
    }

    public func parseExpression(
        expression: ConstantExpressionNode.ExpressionKind,
        comments: [ObjcComment] = []
    ) -> Expression {

        let parser = parserStatePool.pull()
        defer { parserStatePool.repool(parser) }

        switch expression {
        case .antlr(let expression):
            return parseExpression(
                expression: expression,
                comments: comments
            )
        
        case .string(let source):
            do {
                let parser = try parser.makeMainParser(input: source)
                let expression = try parser.parser.expression()

                return parseExpression(
                    expression: expression,
                    comments: comments
                )
            } catch {
                return .unknown(UnknownASTContext(context: "/* \(expression) */"))
            }
        }
    }

    public func parseExpression(
        expression: ObjectiveCParser.ExpressionContext,
        comments: [ObjcComment] = []
    ) -> Expression {

        let context = SwiftASTReaderContext(
            typeSystem: typeSystem,
            typeContext: nil,
            comments: comments)

        let parser =
            SwiftExprASTReader(
                typeMapper: typeMapper,
                typeParser: typeParser,
                context: context,
                delegate: delegate)

        guard let result = expression.accept(parser) else {
            return .unknown(UnknownASTContext(context: expression))
        }

        return result
    }

    public func parseExpression(
        expression: ObjectiveCParser.ConstantExpressionContext,
        comments: [ObjcComment] = []
    ) -> Expression {

        let context = SwiftASTReaderContext(
            typeSystem: typeSystem,
            typeContext: nil,
            comments: comments)

        let parser =
            SwiftExprASTReader(
                typeMapper: typeMapper,
                typeParser: typeParser,
                context: context,
                delegate: delegate)

        guard let result = expression.accept(parser) else {
            return .unknown(UnknownASTContext(context: expression))
        }

        return result
    }
}
