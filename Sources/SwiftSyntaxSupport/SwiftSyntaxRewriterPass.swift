import SwiftSyntax

/// Protocol to be implemented by objects that work on rewriting the syntax of
/// a file.
public protocol SwiftSyntaxRewriterPass {
    /// Returns a given source file syntax, transformed by this syntax pass.
    func rewrite(_ file: SourceFileSyntax) -> SourceFileSyntax
}
