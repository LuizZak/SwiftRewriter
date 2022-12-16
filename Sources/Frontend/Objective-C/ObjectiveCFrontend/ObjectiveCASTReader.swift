import Antlr4
import SwiftAST
import TypeSystem
import ObjcParserAntlr
import GrammarModelBase
import ObjcGrammarModels
import ObjcParser
import KnownType

/// Reader that reads Objective-C AST and outputs equivalent a Swift AST
public class ObjectiveCASTReader {
    let parserStatePool: ObjcParserStatePool
    let typeMapper: TypeMapper
    let typeParser: ObjcTypeParser
    let typeSystem: TypeSystem?

    weak var delegate: ObjectiveCStatementASTReaderDelegate?
    
    public init(
        parserStatePool: ObjcParserStatePool,
        typeMapper: TypeMapper,
        typeParser: ObjcTypeParser,
        typeSystem: TypeSystem? = nil
    ) {
        
        self.parserStatePool = parserStatePool
        self.typeMapper = typeMapper
        self.typeParser = typeParser
        self.typeSystem = typeSystem
    }
    
    public func parseStatements(
        compoundStatement: ObjectiveCParser.CompoundStatementContext,
        comments: [RawCodeComment] = [],
        typeContext: KnownType? = nil
    ) -> CompoundStatement {
        
        let context = ObjectiveCASTReaderContext(
            typeSystem: typeSystem,
            typeContext: typeContext,
            comments: comments
        )
        
        let expressionReader = ObjectiveCExprASTReader(
            typeMapper: typeMapper,
            typeParser: typeParser,
            context: context,
            delegate: delegate
        )
        
        let parser = ObjectiveCStatementASTReader.CompoundStatementVisitor(
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
        expression: ObjcExpressionNode.ExpressionKind,
        comments: [RawCodeComment] = [],
        origin: String
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
                parser.parser.removeErrorListeners()
                parser.parser.addErrorListener(ErrorListener(extraContext: origin))
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
        expression: ObjcConstantExpressionNode.ExpressionKind,
        comments: [RawCodeComment] = [],
        origin: String
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
                parser.parser.removeErrorListeners()
                parser.parser.addErrorListener(ErrorListener(extraContext: origin))
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
        comments: [RawCodeComment] = []
    ) -> Expression {
        
        let context = ObjectiveCASTReaderContext(
            typeSystem: typeSystem,
            typeContext: nil,
            comments: comments
        )
        
        let parser = ObjectiveCExprASTReader(
            typeMapper: typeMapper,
            typeParser: typeParser,
            context: context,
            delegate: delegate
        )
        
        guard let result = expression.accept(parser) else {
            return .unknown(UnknownASTContext(context: expression))
        }
        
        return result
    }

    public func parseExpression(
        expression: ObjectiveCParser.ConstantExpressionContext,
        comments: [RawCodeComment] = []
    ) -> Expression {

        let context = ObjectiveCASTReaderContext(
            typeSystem: typeSystem,
            typeContext: nil,
            comments: comments
        )
        
        let parser = ObjectiveCExprASTReader(
            typeMapper: typeMapper,
            typeParser: typeParser,
            context: context,
            delegate: delegate
        )

        guard let result = expression.accept(parser) else {
            return .unknown(UnknownASTContext(context: expression))
        }

        return result
    }

    class ErrorListener: BaseErrorListener {
        var extraContext: String

        init(extraContext: String) {
            self.extraContext = extraContext
        }

        override public func syntaxError<T>(
            _ recognizer: Recognizer<T>,
            _ offendingSymbol: AnyObject?,
            _ line: Int,
            _ charPositionInLine: Int,
            _ msg: String,
            _ e: AnyObject?
        ) {
            print("\(extraContext) line \(line):\(charPositionInLine) \(msg)")
        }
    }
}
