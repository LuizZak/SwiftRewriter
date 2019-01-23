import SwiftSyntax
import SwiftSyntaxSupport

/// Syntax pass which spaces lines of statements based on their similarity
public class StatementSpacingSyntaxPass: SwiftSyntaxRewriterPass {
    public init() {
        
    }
    
    public func rewrite(_ file: SourceFileSyntax) -> SourceFileSyntax {
        return file
    }
}
