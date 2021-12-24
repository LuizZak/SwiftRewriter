import SwiftAST
import TypeSystem
import JsParserAntlr
import GrammarModelBase
import JsGrammarModels
import JsParser
import KnownType

/// Reader that reads JavaScript AST and outputs equivalent a Swift AST
public class JavaScriptASTReader {
    let typeSystem: TypeSystem?

    weak var delegate: JavaScriptStatementASTReaderDelegate?
    
    public init(typeSystem: TypeSystem? = nil) {
        self.typeSystem = typeSystem
    }
    
    public func parseStatements(body: JavaScriptParser.FunctionBodyContext,
                                comments: [CodeComment] = [],
                                typeContext: KnownType? = nil) -> CompoundStatement {
        
        guard let sourceElements = body.sourceElements() else {
            return CompoundStatement()
        }

        return _parseStatements(
            sourceElements,
            comments: comments,
            typeContext: typeContext
        )
    }
    
    public func parseStatements(compoundStatement: JavaScriptParser.StatementContext,
                                comments: [CodeComment] = [],
                                typeContext: KnownType? = nil) -> CompoundStatement {
        
        fatalError("Not implemented")
    }
    
    private func _parseStatements(
        _ ctx: JavaScriptParser.SourceElementsContext,
        comments: [CodeComment] = [],
        typeContext: KnownType? = nil
    ) -> CompoundStatement {
        
        let context =
            JavaScriptASTReaderContext(
                typeSystem: typeSystem,
                typeContext: typeContext,
                comments: comments
            )
        
        let expressionReader =
            JavaScriptExprASTReader(
                context: context,
                delegate: delegate
            )
        
        let parser =
            JavaScriptStatementASTReader
                .CompoundStatementVisitor(
                    expressionReader: expressionReader,
                    context: context,
                    delegate: delegate
                )
        
        guard let result = ctx.accept(parser) else {
            return [.unknown(UnknownASTContext(context: ctx))]
        }
        
        return result
    }

    private func _parseStatement(
        _ ctx: JavaScriptParser.StatementContext,
        comments: [CodeComment] = [],
        typeContext: KnownType? = nil
    ) -> Statement {
        
        let context =
            JavaScriptASTReaderContext(
                typeSystem: typeSystem,
                typeContext: typeContext,
                comments: comments
            )
        
        let expressionReader =
            JavaScriptExprASTReader(
                context: context,
                delegate: delegate
            )
        
        let parser =
            JavaScriptStatementASTReader(
                expressionReader: expressionReader,
                context: context,
                delegate: delegate
            )
        
        guard let result = ctx.accept(parser) else {
            return .unknown(UnknownASTContext(context: ctx))
        }
        
        return result
    }
    
    public func parseExpression(expression: JavaScriptParser.SingleExpressionContext,
                                comments: [CodeComment] = []) -> Expression {
        
        let context =
            JavaScriptASTReaderContext(
                typeSystem: typeSystem,
                typeContext: nil,
                comments: comments
            )
        
        let parser = 
            JavaScriptExprASTReader(
                context: context,
                delegate: delegate
            )

        guard let result = expression.accept(parser) else {
            return .unknown(UnknownASTContext(context: expression))
        }
        
        return result
    }
    
    public func parseExpression(expression: JavaScriptParser.ExpressionStatementContext,
                                comments: [CodeComment] = []) -> Expression {
        
        let context =
            JavaScriptASTReaderContext(
                typeSystem: typeSystem,
                typeContext: nil,
                comments: comments
            )
        
        let parser = 
            JavaScriptExprASTReader(
                context: context,
                delegate: delegate
            )

        guard let result = expression.accept(parser) else {
            return .unknown(UnknownASTContext(context: expression))
        }
        
        return result
    }
}
