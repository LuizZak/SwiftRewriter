import SwiftSyntax
import Intentions
import SwiftAST

extension SwiftSyntaxProducer {
    func generateStatement(_ stmt: Statement) -> [CodeBlockItemSyntax] {
        switch stmt {
        case let stmt as ReturnStatement:
            return [generateReturn(stmt).inCodeBlock()]
            
        case let stmt as ExpressionsStatement:
            return generateExpressions(stmt)
            
        default:
            return [SyntaxFactory.makeBlankExpressionStmt().inCodeBlock()]
        }
    }
    
    private func generateExpressions(_ stmt: ExpressionsStatement) -> [CodeBlockItemSyntax] {
        return stmt.expressions
            .map(generateExpression)
            .map { SyntaxFactory.makeCodeBlockItem(item: $0, semicolon: nil) }
    }
    
    private func generateReturn(_ stmt: ReturnStatement) -> ReturnStmtSyntax {
        return ReturnStmtSyntax { builder in
            var returnToken = makeStartToken(SyntaxFactory.makeReturnKeyword)
            
            if let exp = stmt.exp {
                returnToken = returnToken.addingTrailingSpace()
                builder.useExpression(generateExpression(exp))
            }
            
            builder.useReturnKeyword(returnToken)
        }
    }
}

private extension ExprSyntax {
    func inCodeBlock() -> CodeBlockItemSyntax {
        return CodeBlockItemSyntax { $0.useItem(self) }
    }
}

private extension StmtSyntax {
    func inCodeBlock() -> CodeBlockItemSyntax {
        return CodeBlockItemSyntax { $0.useItem(self) }
    }
}
