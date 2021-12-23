import JsGrammarModels
import JsParserAntlr
import JsParser
import Antlr4
import SwiftAST

public protocol JavaScriptStatementASTReaderDelegate: AnyObject {
    
}

public final class JavaScriptStatementASTReader: JavaScriptParserBaseVisitor<Statement> {
    public typealias Parser = JavaScriptParser
    
    var expressionReader: JavaScriptExprASTReader
    var context: JavaScriptASTReaderContext
    public weak var delegate: JavaScriptStatementASTReaderDelegate?
    
    public init(expressionReader: JavaScriptExprASTReader,
                context: JavaScriptASTReaderContext,
                delegate: JavaScriptStatementASTReaderDelegate?) {

        self.expressionReader = expressionReader
        self.context = context
        self.delegate = delegate
    }
}

private class ASTAnalyzer {
    let node: SyntaxNode
    
    init(_ node: SyntaxNode) {
        self.node = node
    }
    
    func isLocalMutated(localName: String) -> Bool {
        var sequence: AnySequence<Expression>
        
        switch node {
        case let exp as Expression:
            sequence = expressions(in: exp, inspectBlocks: true)
            
        case let stmt as Statement:
            sequence = expressions(in: stmt, inspectBlocks: true)
            
        default:
            return false
        }
        
        return sequence.contains { exp in
            exp.asAssignment?.lhs.asIdentifier?.identifier == localName
        }
    }
}

private func expressions(in statement: Statement, inspectBlocks: Bool) -> AnySequence<Expression> {
    let sequence =
        SyntaxNodeSequence(node: statement,
                           inspectBlocks: inspectBlocks)
    
    return AnySequence(sequence.lazy.compactMap { $0 as? Expression })
}

private func expressions(in expression: Expression, inspectBlocks: Bool) -> AnySequence<Expression> {
    let sequence =
        SyntaxNodeSequence(node: expression,
                           inspectBlocks: inspectBlocks)
    
    return AnySequence(sequence.lazy.compactMap { $0 as? Expression })
}
