import SwiftSyntax

/// Protocol for objects that provide swift syntax rewriter pass classes.
public protocol SwiftSyntaxRewriterPassProvider {
    var passes: [SwiftSyntaxRewriterPass] { get }
}

/// Applies multiple swift syntax passes to source files.
public class SwiftSyntaxRewriterPassApplier {
    let provider: SwiftSyntaxRewriterPassProvider
    
    public init(provider: SwiftSyntaxRewriterPassProvider) {
        self.provider = provider
    }
    
    /// Sequentially applies the syntax passes from the provider this class was
    /// instantiated with, and returns the final result.
    public func apply(to file: SourceFileSyntax) -> SourceFileSyntax {
        return provider.passes.reduce(file) { $1.rewrite($0) }
    }
}

public struct ArraySwiftSyntaxRewriterPassProvider: SwiftSyntaxRewriterPassProvider {
    public var passes: [SwiftSyntaxRewriterPass]
    
    public init(passes: [SwiftSyntaxRewriterPass]) {
        self.passes = passes
    }
}
