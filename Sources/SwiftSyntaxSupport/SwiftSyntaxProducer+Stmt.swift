import SwiftSyntax
import Intentions
import SwiftAST

extension SwiftSyntaxProducer {
    func generateStatement(_ statement: Statement) -> StmtSyntax {
        return SyntaxFactory.makeBlankExpressionStmt()
    }
    
    func generateExpression(_ expression: Expression) -> ExprSyntax {
        return SyntaxFactory.makeBlankAsExpr()
    }
}
