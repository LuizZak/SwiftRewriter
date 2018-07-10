import SwiftAST
import GrammarModels
import ObjcParserAntlr
import ObjcParser

/// Reader that reads Objective-C AST and outputs equivalent a Swift AST
public class SwiftASTReader {
    let typeMapper: TypeMapper
    let typeParser: TypeParsing
    let typeSystem: TypeSystem?
    
    public init(typeMapper: TypeMapper, typeParser: TypeParsing, typeSystem: TypeSystem? = nil) {
        self.typeMapper = typeMapper
        self.typeParser = typeParser
        self.typeSystem = typeSystem
    }
    
    public func parseStatements(compoundStatement: ObjectiveCParser.CompoundStatementContext,
                                typeContext: KnownType? = nil) -> CompoundStatement {
        
        let context =
            SwiftASTReaderContext(typeSystem: typeSystem,
                                  typeContext: typeContext)
        
        let expressionReader =
            SwiftExprASTReader(typeMapper: typeMapper,
                               typeParser: typeParser,
                               context: context)
        
        let parser =
            SwiftStatementASTReader
                .CompoundStatementVisitor(expressionReader: expressionReader,
                                          context: context)
        
        guard let result = compoundStatement.accept(parser) else {
            return [.unknown(UnknownASTContext(context: compoundStatement))]
        }
        
        return result
    }
    
    public func parseExpression(expression: ObjectiveCParser.ExpressionContext) -> Expression {
        let context = SwiftASTReaderContext(typeSystem: typeSystem, typeContext: nil)
        
        let parser =
            SwiftExprASTReader(typeMapper: typeMapper,
                               typeParser: typeParser,
                               context: context)
        
        guard let result = expression.accept(parser) else {
            return .unknown(UnknownASTContext(context: expression))
        }
        
        return result
    }
}
