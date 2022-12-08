/// Syntax element for type identifiers in declarations.
public struct TypeIdentifierSyntax: Hashable, Codable {
    public var identifier: IdentifierSyntax
}

extension TypeIdentifierSyntax: DeclarationSyntaxElementType {
    public var children: [DeclarationSyntaxElementType] {
        toChildrenList(identifier)
    }
}
extension TypeIdentifierSyntax: CustomStringConvertible {
    public var description: String {
        "\(identifier)"
    }
}
extension TypeIdentifierSyntax: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.init(identifier: .init(identifier: value))
    }
}
