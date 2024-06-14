import SwiftAST
import Utils
import TypeSystem
import JsParserAntlr
import GrammarModelBase
import JsGrammarModels
import SwiftRewriterLib
import JsParser
import KnownType

public protocol JavaScriptASTReaderDelegate: AnyObject {

}

public struct JavaScriptASTReaderOptions {
    public static let `default`: Self = .init(
        objectLiteralKind: .rawDictionary
    )

    /// The behavior of reading dictionary literal expressions.
    public var objectLiteralKind: ObjectLiteralKind

    public init(objectLiteralKind: ObjectLiteralKind) {
        self.objectLiteralKind = objectLiteralKind
    }

    /// Describes the output of JavaScript object literal reading.
    public enum ObjectLiteralKind {
        /// Reads the object as a raw Swift dictionary, with keys mapping to
        /// identifiers.
        case rawDictionary

        /// Reads the object as a `JavaScriptObject` definition, with the proper
        /// object type name specified.
        case javaScriptObject(typeName: String = "JavaScriptObject")
    }
}

/// Reader that reads JavaScript AST and outputs equivalent a Swift AST
public class JavaScriptASTReader {
    let typeSystem: TypeSystem?
    let source: Source
    let options: JavaScriptASTReaderOptions

    weak var delegate: JavaScriptASTReaderDelegate?
    
    public init(source: Source, typeSystem: TypeSystem? = nil, options: JavaScriptASTReaderOptions) {
        self.source = source
        self.typeSystem = typeSystem
        self.options = options
    }
    
    public func parseStatements(
        body: JavaScriptParser.FunctionBodyContext,
        comments: [RawCodeComment] = [],
        typeContext: KnownType? = nil
    ) -> CompoundStatement {
        
        guard let sourceElements = body.sourceElements() else {
            let applier = SwiftASTCommentApplier(comments: comments)
            let result = CompoundStatement()
            applier.applyOverlappingComments(to: result, body)
            return result
        }

        return _parseStatements(
            sourceElements,
            comments: comments,
            typeContext: typeContext
        )
    }
    
    public func parseStatements(
        compoundStatement: JavaScriptParser.StatementContext,
        comments: [RawCodeComment] = [],
        typeContext: KnownType? = nil
    ) -> CompoundStatement {
        
        fatalError("Not implemented")
    }
    
    private func _parseStatements(
        _ ctx: JavaScriptParser.SourceElementsContext,
        comments: [RawCodeComment] = [],
        typeContext: KnownType? = nil
    ) -> CompoundStatement {
        
        let context = JavaScriptASTReaderContext(
            source: source,
            typeSystem: typeSystem,
            typeContext: typeContext,
            comments: comments,
            options: options
        )
        
        let expressionReader = JavaScriptExprASTReader(
            context: context,
            delegate: delegate
        )
        
        let parser = JavaScriptStatementASTReader.CompoundStatementVisitor(
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
        
        let context = JavaScriptASTReaderContext(
            source: source,
            typeSystem: typeSystem,
            typeContext: typeContext,
            comments: comments,
            options: options
        )
        
        let expressionReader = JavaScriptExprASTReader(
            context: context,
            delegate: delegate
        )
        
        let parser = JavaScriptStatementASTReader(
            expressionReader: expressionReader,
            context: context,
            delegate: delegate
        )
        
        guard let result = ctx.accept(parser) else {
            return .unknown(UnknownASTContext(context: ctx))
        }
        
        return result
    }
    
    public func parseExpression(
        expression: JavaScriptParser.SingleExpressionContext,
        comments: [RawCodeComment] = []
    ) -> Expression {
        
        let context = JavaScriptASTReaderContext(
            source: source,
            typeSystem: typeSystem,
            typeContext: nil,
            comments: comments,
            options: options
        )
        
        let parser =  JavaScriptExprASTReader(
            context: context,
            delegate: delegate
        )

        guard let result = expression.accept(parser) else {
            return .unknown(UnknownASTContext(context: expression))
        }
        
        return result
    }
    
    public func parseExpression(
        expression: JavaScriptParser.ExpressionStatementContext,
        comments: [RawCodeComment] = []
    ) -> Expression {
        
        let context = JavaScriptASTReaderContext(
            source: source,
            typeSystem: typeSystem,
            typeContext: nil,
            comments: comments,
            options: options
        )
        
        let parser = JavaScriptExprASTReader(
            context: context,
            delegate: delegate
        )

        guard let result = expression.accept(parser) else {
            return .unknown(UnknownASTContext(context: expression))
        }
        
        return result
    }
}
