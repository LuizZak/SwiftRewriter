import SwiftAST
import Utils
import TypeSystem
import JsParserAntlr
import GrammarModelBase
import JsGrammarModels
import JsParser
import KnownType

public protocol JavaScriptASTReaderDelegate: AnyObject {

}

/// Reader that reads JavaScript AST and outputs equivalent a Swift AST
public class JavaScriptASTReader {
    let typeSystem: TypeSystem?
    let source: Source

    weak var delegate: JavaScriptASTReaderDelegate?
    
    public init(source: Source, typeSystem: TypeSystem? = nil) {
        self.source = source
        self.typeSystem = typeSystem
    }
    
    public func parseStatements(body: JavaScriptParser.FunctionBodyContext,
                                comments: [RawCodeComment] = [],
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
                                comments: [RawCodeComment] = [],
                                typeContext: KnownType? = nil) -> CompoundStatement {
        
        fatalError("Not implemented")
    }
    
    private func _parseStatements(
        _ ctx: JavaScriptParser.SourceElementsContext,
        comments: [RawCodeComment] = [],
        typeContext: KnownType? = nil
    ) -> CompoundStatement {
        
        let context =
            JavaScriptASTReaderContext(
                source: source,
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
        comments: [RawCodeComment] = [],
        typeContext: KnownType? = nil
    ) -> Statement {
        
        let context =
            JavaScriptASTReaderContext(
                source: source,
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
                                comments: [RawCodeComment] = []) -> Expression {
        
        let context =
            JavaScriptASTReaderContext(
                source: source,
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
                                comments: [RawCodeComment] = []) -> Expression {
        
        let context =
            JavaScriptASTReaderContext(
                source: source,
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
