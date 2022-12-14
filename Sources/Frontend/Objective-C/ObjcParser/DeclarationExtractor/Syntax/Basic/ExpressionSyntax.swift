import Utils

/// A generic C-compatible `expression` syntax node for declarations.
public struct ExpressionSyntax: Hashable, Codable {
    public var sourceRange: SourceRange = .invalid
    
    /// A valid C `expression`-compatible syntax string.
    public var expressionString: String
}

extension ExpressionSyntax: DeclarationSyntaxElementType {
    public var children: [DeclarationSyntaxElementType] { toChildrenList() }
}

extension ExpressionSyntax: CustomStringConvertible {
    public var description: String {
        expressionString
    }
}
extension ExpressionSyntax: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.init(expressionString: value)
    }
}
