import SwiftSyntax

extension TokenSyntax {
    func withExtraLeading(consuming trivia: inout Trivia?) -> TokenSyntax {
        if let t = trivia {
            trivia = nil
            return withLeadingTrivia(t + leadingTrivia)
        }
        
        return self
    }
    func withLeadingSpace(count: Int = 1) -> TokenSyntax {
        withLeadingTrivia(.spaces(count))
    }
    
    func withTrailingSpace(count: Int = 1) -> TokenSyntax {
        withTrailingTrivia(.spaces(count))
    }
    
    func addingLeadingSpace(count: Int = 1) -> TokenSyntax {
        addingLeadingTrivia(.spaces(count))
    }
    
    func addingTrailingSpace(count: Int = 1) -> TokenSyntax {
        addingTrailingTrivia(.spaces(count))
    }
    
    func addingLeadingTrivia(_ trivia: Trivia) -> TokenSyntax {
        withLeadingTrivia(leadingTrivia + trivia)
    }
    
    func addingTrailingTrivia(_ trivia: Trivia) -> TokenSyntax {
        withTrailingTrivia(trailingTrivia + trivia)
    }
    
    func addingSurroundingSpaces() -> TokenSyntax {
        addingLeadingSpace().addingTrailingSpace()
    }
    
    func onNewline() -> TokenSyntax {
        withLeadingTrivia(.newlines(1))
    }
}
