import SwiftAST

/// Describes a top level function body, statement, or expression that an intention
/// carries.
public enum StatementContainer {
    case function(FunctionBodyIntention)
    case statement(Statement)
    case expression(Expression)

    /// Convenience for applying an AST visitor on the contents of this container
    /// value.
    public func accept<Visitor>(_ visitor: Visitor) -> Visitor.ExprResult where Visitor: StatementVisitor & ExpressionVisitor, Visitor.ExprResult == Visitor.StmtResult {
        switch self {
        case .function(let body):
            return visitor.visitStatement(body.body)
        case .statement(let stmt):
            return visitor.visitStatement(stmt)
        case .expression(let exp):
            return visitor.visitExpression(exp)
        }
    }

    /// Gets the function body, if this statement container is a function body
    /// case.
    public var functionBody: FunctionBodyIntention? {
        switch self {
        case .function(let body):
            return body
        default:
            return nil
        }
    }

    /// Gets the statement, if this statement container is a statement case.
    public var statement: Statement? {
        switch self {
        case .statement(let stmt):
            return stmt
        default:
            return nil
        }
    }

    /// Gets the expression, if this statement container is a expression case.
    public var expression: Expression? {
        switch self {
        case .expression(let exp):
            return exp
        default:
            return nil
        }
    }

    /// Gets the syntax node associated with this statement container.
    public var syntaxNode: SyntaxNode {
        switch self {            
        case .function(let value):
            return value.body

        case
            .statement(let value as SyntaxNode),
            .expression(let value as SyntaxNode):
            return value
        }
    }
}
