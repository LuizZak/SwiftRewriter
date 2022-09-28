import SwiftSyntax

extension SyntaxProtocol {
    var asSyntax: Syntax {
        return Syntax(self)
    }
    
    func inCodeBlock() -> CodeBlockItemSyntax {
        return asSyntax.inCodeBlock()
    }

    func withExtraLeading(consuming trivia: inout Trivia?) -> Self {
        if let t = trivia {
            trivia = nil
            return withLeadingTrivia(t + (leadingTrivia ?? []))
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
        withLeadingTrivia((leadingTrivia ?? []) + trivia)
    }
    
    func addingTrailingTrivia(_ trivia: Trivia) -> Self {
        withTrailingTrivia((trailingTrivia ?? []) + trivia)
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
