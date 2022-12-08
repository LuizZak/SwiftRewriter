/// Syntax element for a block direct abstract declarator.
public struct BlockAbstractDeclaratorSyntax: Hashable, Codable {
    /// An optional list of block declaration specifiers for this block declarator.
    public var blockDeclarationSpecifiers: [BlockDeclarationSpecifierSyntax] = []

    /// A base direct declarator for this block declarator.
    public var directAbstractDeclarator: DirectAbstractDeclaratorSyntax?

    /// Parameter type list associated with this block declarator.
    public var parameterList: ParameterListSyntax
}

extension BlockAbstractDeclaratorSyntax: DeclarationSyntaxElementType {
    public var children: [DeclarationSyntaxElementType] {
        blockDeclarationSpecifiers + toChildrenList(directAbstractDeclarator, parameterList)
    }
}
extension BlockAbstractDeclaratorSyntax: CustomStringConvertible {
    public var description: String {
        var result: String = ""
        result += "(^"
        result += blockDeclarationSpecifiers.map(\.description).joined(separator: " ")
        if !blockDeclarationSpecifiers.isEmpty && directAbstractDeclarator != nil {
            result += " "
        }

        if let directAbstractDeclarator {
            result += "\(directAbstractDeclarator)"
        }
        result += ")"

        result += "("
        result += "\(parameterList)"
        result += ")"

        return result
    }
}
