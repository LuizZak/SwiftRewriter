import SwiftSyntax

extension SyntaxProtocol {
    var asSyntax: Syntax {
        Syntax(self)
    }
}

extension TypeSyntaxProtocol {
    var asTypeSyntax: TypeSyntax {
        TypeSyntax(self)
    }
}

extension DeclSyntaxProtocol {
    var asDeclSyntax: DeclSyntax {
        DeclSyntax(self)
    }

    func inMemberDeclListItem() -> MemberDeclListItemSyntax {
        MemberDeclListItemSyntax(decl: self.asDeclSyntax)
    }
}

extension ExprSyntaxProtocol {
    var asExprSyntax: ExprSyntax {
        ExprSyntax(self)
    }
}

extension StmtSyntaxProtocol {
    var asStmtSyntax: StmtSyntax {
        StmtSyntax(self)
    }
}

extension PatternSyntaxProtocol {
    var asPatternSyntax: PatternSyntax {
        PatternSyntax(self)
    }
}

extension ExprSyntaxProtocol {
    func inCodeBlock() -> CodeBlockItemSyntax {
        .init(item: .expr(self.asExprSyntax))
    }
}

extension StmtSyntaxProtocol {
    func inCodeBlock() -> CodeBlockItemSyntax {
        .init(item: .stmt(self.asStmtSyntax))
    }
}
