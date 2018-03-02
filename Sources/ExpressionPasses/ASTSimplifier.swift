import SwiftRewriterLib
import SwiftAST

/// Simplifies AST structures that may be unnecessarily complex.
public class ASTSimplifier: SyntaxNodeRewriterPass {
    public override func visitCompound(_ stmt: CompoundStatement) -> Statement {
        guard stmt.statements.count == 1, let doStmt = stmt.statements[0].asDoStatement else {
            return super.visitCompound(stmt)
        }
        
        stmt.statements = doStmt.body.statements
        
        for def in doStmt.body.allDefinitions() {
            stmt.definitions.recordDefinition(def)
        }
        
        context.notifyChangedTree()
        
        return stmt
    }
}
