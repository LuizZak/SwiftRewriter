import SwiftRewriterLib
import SwiftAST

/// Simplifies AST structures that may be unnecessarily complex.
public class ASTSimplifier: ASTRewriterPass {
    public override func visitBaseExpression(_ exp: Expression) -> Expression {
        // Drop parens from base expressions
        if let parens = exp.asParens {
            notifyChange()
            
            return visitBaseExpression(parens.exp.copy())
        }
        
        return super.visitBaseExpression(exp)
    }
    
    /// Simplify `do` statements that are the only statement within a compound
    /// statement context.
    public override func visitCompound(_ stmt: CompoundStatement) -> Statement {
        guard stmt.statements.count == 1, let doStmt = stmt.statements[0].asDoStatement else {
            return super.visitCompound(stmt)
        }
        
        let body = doStmt.body.statements
        doStmt.body.statements = []
        stmt.statements = body
        
        for def in doStmt.body.allDefinitions() {
            stmt.definitions.recordDefinition(def)
        }
        
        notifyChange()
        
        return super.visitCompound(stmt)
    }
    
    /// Simplify check before invoking nullable closure
    public override func visitIf(_ stmt: IfStatement) -> Statement {
        var nullCheckM: IdentifierExpression?
        var postfix: PostfixExpression?
        
        let matcher =
            ValueMatcher<IfStatement>()
                .match(if: !hasElse())
                .keyPath(\.nullCheckMember?.asIdentifier,
                            .differentThan(nil) ->> &nullCheckM)
                .keyPath(\.body.statements, hasCount(1))
                .keyPath(\.body.statements[0].asExpressions,
                         ValueMatcher()
                            .keyPath(\.expressions, hasCount(1))
                            .keyPath(\.expressions[0].asPostfix,
                                     ValueMatcher().keyPath(\.exp, lazyEquals(nullCheckM))
                                        ->> &postfix
                            ))
        
        if matcher.matches(stmt), let postfix = postfix?.copy() {
            postfix.op.hasOptionalAccess = true
            
            let statement = Statement.expression(postfix)
            
            notifyChange()
            
            return super.visitStatement(statement)
        }
        
        return super.visitIf(stmt)
    }
}

extension IfStatement {
    var isNullCheck: Bool {
        // `if (nullablePointer) { ... }`-style checking:
        // An if-statement over a nullable value is also considered a null-check
        // in Objective-C.
        if exp.resolvedType?.isOptional == true {
            return true
        }
        
        guard let binary = exp.asBinary else {
            return false
        }
        
        return binary.op == .unequals && binary.rhs == .constant(.nil)
    }
    
    var nullCheckMember: Expression? {
        guard isNullCheck else {
            return nil
        }
        
        // `if (nullablePointer) { ... }`-style checking
        if exp.resolvedType?.isOptional == true {
            return exp
        }
        
        if let binary = exp.asBinary {
            return binary.rhs == .constant(.nil) ? binary.lhs : binary.rhs
        }
        
        return nil
    }
}
