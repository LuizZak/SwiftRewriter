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
