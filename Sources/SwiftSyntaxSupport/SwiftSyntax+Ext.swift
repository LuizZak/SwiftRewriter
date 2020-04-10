import SwiftSyntax

extension SyntaxProtocol {
    var asSyntax: Syntax {
        return Syntax(self)
    }
}

extension TypeSyntaxProtocol {
    var asTypeSyntax: TypeSyntax {
        return TypeSyntax(self)
    }
}

extension DeclSyntaxProtocol {
    var asDeclSyntax: DeclSyntax {
        return DeclSyntax(self)
    }
}

extension ExprSyntaxProtocol {
    var asExprSyntax: ExprSyntax {
        return ExprSyntax(self)
    }
}

extension StmtSyntaxProtocol {
    var asStmtSyntax: StmtSyntax {
        return StmtSyntax(self)
    }
}

extension PatternSyntaxProtocol {
    var asPatternSyntax: PatternSyntax {
        return PatternSyntax(self)
    }
}
