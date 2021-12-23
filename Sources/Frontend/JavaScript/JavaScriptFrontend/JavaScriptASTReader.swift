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
    
    public func parseStatements(compoundStatement: JavaScriptParser.StatementContext,
                                comments: [CodeComment] = [],
                                typeContext: KnownType? = nil) -> CompoundStatement {
        
        fatalError("Not implemented")
    }
    
    public func parseExpression(expression: JavaScriptParser.ExpressionStatementContext,
                                comments: [CodeComment] = []) -> Expression {
        

        fatalError("Not implemented")
    }
}
