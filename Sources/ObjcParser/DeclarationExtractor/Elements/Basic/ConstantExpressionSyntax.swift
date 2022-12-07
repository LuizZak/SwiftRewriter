import GrammarModels

/// A generic C-compatible `constantExpression` syntax node for declarations.
public struct ConstantExpressionSyntax: Hashable, Codable {
    public var sourceRange: SourceRange = .invalid

    /// A valid C `constantExpression`-compatible syntax string.
    public var constantExpressionString: String
}

extension ConstantExpressionSyntax: DeclarationSyntaxElementType {
    public var children: [DeclarationSyntaxElementType] { toChildrenList() }
}

extension ConstantExpressionSyntax: CustomStringConvertible {
    public var description: String {
        constantExpressionString
    }
}
extension ConstantExpressionSyntax: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.init(constantExpressionString: value)
    }
}
