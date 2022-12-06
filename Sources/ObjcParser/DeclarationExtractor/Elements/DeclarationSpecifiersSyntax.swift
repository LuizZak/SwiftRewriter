/// Syntax element for declaration specifiers in declarations.
public struct DeclarationSpecifiersSyntax: Hashable, Codable {
    /// A type prefix for this declaration specifier list.
    public var typePrefix: TypePrefixSyntax?

    /// List of declaration specifiers.
    public var declarationSpecifier: [DeclarationSpecifierSyntax]
}

extension DeclarationSpecifiersSyntax: DeclarationSyntaxElementType {
    public var children: [DeclarationSyntaxElementType] {
        if let typePrefix {
            return [typePrefix] + declarationSpecifier
        }

        return declarationSpecifier
    }
}
extension DeclarationSpecifiersSyntax: CustomStringConvertible {
    public var description: String {
        if let typePrefix {
            return "\(typePrefix) \(declarationSpecifier.map(\.description).joined(separator: " "))"
        }

        return declarationSpecifier.map(\.description).joined(separator: " ")
    }
}
