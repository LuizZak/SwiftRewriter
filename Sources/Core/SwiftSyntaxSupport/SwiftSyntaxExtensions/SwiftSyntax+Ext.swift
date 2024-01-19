import SwiftSyntax

extension SyntaxProtocol {
    var asSyntax: Syntax {
        return Syntax(self)
    }

    func withLeadingTrivia(_ trivia: Trivia) -> Self {
        self.with(\.leadingTrivia, trivia)
    }

    func withTrailingTrivia(_ trivia: Trivia) -> Self {
        self.with(\.trailingTrivia, trivia)
    }
    
    func withExtraLeading(consuming trivia: inout Trivia?) -> Self {
        if let t = trivia {
            trivia = nil
            return withLeadingTrivia(t + leadingTrivia)
        }
        
        return self
    }
    
    func withLeadingSpace(count: Int = 1) -> Self {
        withLeadingTrivia(.spaces(count))
    }
    
    func withTrailingSpace(count: Int = 1) -> Self {
        withTrailingTrivia(.spaces(count))
    }
    
    func addingLeadingSpace(count: Int = 1) -> Self {
        addingLeadingTrivia(.spaces(count))
    }
    
    func addingTrailingSpace(count: Int = 1) -> Self {
        addingTrailingTrivia(.spaces(count))
    }
    
    func addingLeadingTrivia(_ trivia: Trivia) -> Self {
        withLeadingTrivia(leadingTrivia + trivia)
    }
    
    func addingTrailingTrivia(_ trivia: Trivia) -> Self {
        withTrailingTrivia(trailingTrivia + trivia)
    }
    
    func addingSurroundingSpaces() -> Self {
        addingLeadingSpace().addingTrailingSpace()
    }
    
    func onNewline() -> Self {
        withLeadingTrivia(.newlines(1))
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

extension ExprSyntaxProtocol {
    func inCodeBlock() -> CodeBlockItemSyntax {
        .init(item: inCodeBlockItem())
    }

    func inCodeBlockItem() -> CodeBlockItemSyntax.Item {
        .expr(self.asExprSyntax)
    }
}

extension StmtSyntaxProtocol {
    func inCodeBlock() -> CodeBlockItemSyntax {
        .init(item: inCodeBlockItem())
    }

    func inCodeBlockItem() -> CodeBlockItemSyntax.Item {
        .stmt(self.asStmtSyntax)
    }
}

extension DeclSyntaxProtocol {
    func inCodeBlock() -> CodeBlockItemSyntax {
        .init(item: inCodeBlockItem())
    }

    func inCodeBlockItem() -> CodeBlockItemSyntax.Item {
        .decl(self.asDeclSyntax)
    }
}

extension TokenSyntax {
    static func spacedBinaryOperator(_ text: String) -> TokenSyntax {
        .binaryOperator(text)
    }
}
