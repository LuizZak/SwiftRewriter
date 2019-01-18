import SwiftSyntax
import Intentions
import SwiftAST

extension SwiftSyntaxProducer {
    func generateStatement(_ statement: Statement) -> StmtSyntax {
        switch statement {
        case let stmt as ReturnStatement:
            return generateReturn(stmt)
            
        default:
            return SyntaxFactory.makeBlankExpressionStmt()
        }
    }
    
    func generateExpression(_ expression: Expression) -> ExprSyntax {
        return SyntaxFactory.makeBlankAsExpr()
    }
    
    func generateReturn(_ stmt: ReturnStatement) -> ReturnStmtSyntax {
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
