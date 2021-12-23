import Antlr4
import JsParserAntlr
import JsParser
import JsGrammarModels
import SwiftAST
import TypeSystem

/// A visitor that reads simple JavaScript expressions and emits as Expression
/// enum cases.
public final class JavaScriptExprASTReader: JavaScriptParserBaseVisitor<Expression> {
    public var typeMapper: TypeMapper
    public var context: JavaScriptASTReaderContext
    public var delegate: JavaScriptStatementASTReaderDelegate?
    
    public init(
        typeMapper: TypeMapper,
        context: JavaScriptASTReaderContext,
        delegate: JavaScriptStatementASTReaderDelegate?
    ) {
        self.typeMapper = typeMapper
        self.context = context
        self.delegate = delegate
    }
}
