import SwiftAST
import TypeSystem
import ObjcParserAntlr
import GrammarModelBase
import ObjcGrammarModels
import ObjcParser
import KnownType

/// Reader that reads Objective-C AST and outputs equivalent a Swift AST
public class ObjectiveCASTReader {
    let typeMapper: TypeMapper
    let typeParser: ObjcTypeParser
    let typeSystem: TypeSystem?

    weak var delegate: ObjectiveCStatementASTReaderDelegate?
    
    public init(typeMapper: TypeMapper,
                typeParser: ObjcTypeParser,
                typeSystem: TypeSystem? = nil) {
        
        self.typeMapper = typeMapper
        self.typeParser = typeParser
        self.typeSystem = typeSystem
    }
    
    public func parseStatements(compoundStatement: ObjectiveCParser.CompoundStatementContext,
                                comments: [RawCodeComment] = [],
                                typeContext: KnownType? = nil) -> CompoundStatement {
        
        let context =
            ObjectiveCASTReaderContext(
                typeSystem: typeSystem,
                typeContext: typeContext,
                comments: comments
            )
        
        let expressionReader =
            ObjectiveCExprASTReader(
                typeMapper: typeMapper,
                typeParser: typeParser,
                context: context,
                delegate: delegate
            )
        
        let parser =
            ObjectiveCStatementASTReader
                .CompoundStatementVisitor(
                    expressionReader: expressionReader,
                    context: context,
                    delegate: delegate
                )
        
        guard let result = compoundStatement.accept(parser) else {
            return [.unknown(UnknownASTContext(context: compoundStatement))]
        }
        
        return result
    }
    
    public func parseExpression(expression: ObjectiveCParser.ExpressionContext,
                                comments: [RawCodeComment] = []) -> Expression {
        
        let context =
            ObjectiveCASTReaderContext(
                typeSystem: typeSystem,
                typeContext: nil,
                comments: comments
            )
        
        let parser =
            ObjectiveCExprASTReader(
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
}
