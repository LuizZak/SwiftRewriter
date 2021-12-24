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

    // MARK: - Compound statement visitor
    class CompoundStatementVisitor: JavaScriptParserBaseVisitor<CompoundStatement> {
        var expressionReader: JavaScriptExprASTReader
        var context: JavaScriptASTReaderContext
        weak var delegate: JavaScriptStatementASTReaderDelegate?
        
        init(expressionReader: JavaScriptExprASTReader,
             context: JavaScriptASTReaderContext,
             delegate: JavaScriptStatementASTReaderDelegate?) {

            self.expressionReader = expressionReader
            self.context = context
            self.delegate = delegate
        }
        
        override func visitStatement(_ ctx: Parser.StatementContext) -> CompoundStatement? {
            if let block = ctx.block() {
                return block.accept(self)
            }
            
            let reader = statementReader()
            
            if let stmt = reader.visitStatement(ctx) {
                return CompoundStatement(statements: [stmt])
            }
            
            return nil
        }

        override func visitSourceElements(_ ctx: JavaScriptParser.SourceElementsContext) -> CompoundStatement? {
            context.pushDefinitionContext()
            defer { context.popDefinitionContext() }
            
            let reader = statementReader()

            let statements: [Statement] = ctx.sourceElement().map { element in
                let unknown = UnknownStatement.unknown(UnknownASTContext(context: element.getText()))

                return element.statement().flatMap(reader.visitStatement) ?? unknown
            }
            
            return CompoundStatement(statements: statements.flatMap { stmt -> [Statement] in
                // Free compound blocks cannot be declared in Swift
                if let inner = stmt.asCompound {
                    // Label the first statement with the compound's label, as
                    // well
                    inner.statements.first?.label = stmt.label
                    
                    return inner.statements
                }
                
                return [stmt]
            })
        }
        
        override func visitBlock(_ ctx: Parser.BlockContext) -> CompoundStatement? {
            context.pushDefinitionContext()
            defer { context.popDefinitionContext() }
            
            let reader = statementReader()

            let statements: [Statement] = ctx.statementList()?.statement().map { stmt in
                let unknown = UnknownStatement.unknown(UnknownASTContext(context: stmt.getText()))

                return reader.visitStatement(stmt) ?? unknown
            } ?? []
            
            return CompoundStatement(statements: statements.flatMap { stmt -> [Statement] in
                // Free compound blocks cannot be declared in Swift
                if let inner = stmt.asCompound {
                    // Label the first statement with the compound's label, as
                    // well
                    inner.statements.first?.label = stmt.label
                    
                    return inner.statements
                }
                
                return [stmt]
            })
        }

        private func statementReader() -> JavaScriptStatementASTReader {
            JavaScriptStatementASTReader(
                expressionReader: expressionReader,
                context: context,
                delegate: delegate
            )
        }
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
