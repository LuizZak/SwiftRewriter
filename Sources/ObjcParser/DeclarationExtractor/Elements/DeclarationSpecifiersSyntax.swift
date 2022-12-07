/// Syntax element for declaration specifiers in declarations.
public struct DeclarationSpecifiersSyntax: Hashable, Codable {
    /// List of declaration specifiers.
    public var declarationSpecifier: [DeclarationSpecifierSyntax]
}

extension DeclarationSpecifiersSyntax: DeclarationSyntaxElementType {
    public var children: [DeclarationSyntaxElementType] {
        return declarationSpecifier
    }
}
extension DeclarationSpecifiersSyntax: CustomStringConvertible {
    public var description: String {
        return declarationSpecifier.map(\.description).joined(separator: " ")
    }
}
extension DeclarationSpecifiersSyntax: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: DeclarationSpecifierSyntax...) {
        self.init(declarationSpecifier: elements)
    }
}
