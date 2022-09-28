import SwiftSyntax

extension SyntaxProtocol {
    var asSyntax: Syntax {
        return Syntax(self)
    }
    
    func inCodeBlock() -> CodeBlockItemSyntax {
        return asSyntax.inCodeBlock()
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

    func inMemberDeclListItem() -> MemberDeclListItemSyntax {
        return MemberDeclListItemSyntax { $0.useDecl(asDeclSyntax) }
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

extension Syntax {
    func inCodeBlock() -> CodeBlockItemSyntax {
        return CodeBlockItemSyntax { $0.useItem(self) }
    }
}

extension ExprSyntaxProtocol {
    func inCodeBlock() -> CodeBlockItemSyntax {
        self.asSyntax.inCodeBlock()
    }
}

extension StmtSyntaxProtocol {
    func inCodeBlock() -> CodeBlockItemSyntax {
        self.asSyntax.inCodeBlock()
    }
}
