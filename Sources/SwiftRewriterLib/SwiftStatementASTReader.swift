import GrammarModels
import ObjcParserAntlr
import ObjcParser
import Antlr4

public class SwiftStatementASTReader: ObjectiveCParserBaseVisitor<Statement> {
    public override func visitStatement(_ ctx: ObjectiveCParser.StatementContext) -> Statement? {
        if let sel = ctx.selectionStatement()?.accept(self) {
            return sel
        }
        if let cpd = ctx.compoundStatement() {
            return cpd.accept(self)
        }
        
        return nil
    }
    
    public override func visitCompoundStatement(_ ctx: ObjectiveCParser.CompoundStatementContext) -> Statement? {
        let stmts = ctx.statement().compactMap { $0.accept(self) }
        
        return .compound(stmts)
    }
    
    public override func visitSelectionStatement(_ ctx: ObjectiveCParser.SelectionStatementContext) -> Statement? {
        if let expression = ctx.expression() {
            guard let expr = expression.accept(SwiftExprASTReader()) else {
                return nil
            }
            guard let body = ctx.ifBody?.accept(self) else {
                return nil
            }
            
            let elseStmt = ctx.elseBody?.accept(self)
            
            return .if(expr, body: body, else: elseStmt)
        }
        
        return nil
    }
}
