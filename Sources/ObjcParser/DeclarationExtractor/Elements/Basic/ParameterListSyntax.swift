/// Syntax element for parameter lists in declarations.
public struct ParameterListSyntax: Hashable, Codable {
    /// List of parameter declarations.
    /// May be empty.
    public var parameterDeclarations: [ParameterDeclarationSyntax]
}

// MARK: - DeclarationSyntaxElementType conformance

extension ParameterListSyntax: DeclarationSyntaxElementType {
    public var children: [DeclarationSyntaxElementType] {
        parameterDeclarations
    }
}
extension ParameterListSyntax: CustomStringConvertible {
    public var description: String {
        parameterDeclarations.map(\.description).joined(separator: ", ")
    }
}
extension ParameterListSyntax: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: ParameterDeclarationSyntax...) {
        self.init(parameterDeclarations: elements)
    }
}
