/// Syntax element for a block direct declarator.
public struct BlockDeclaratorSyntax: Hashable, Codable {
    /// An optional list of block declaration specifiers for this block declarator.
    public var blockDeclarationSpecifiers: [BlockDeclarationSpecifierSyntax] = []

    /// The base direct declarator for this block declarator.
    public var directDeclarator: DirectDeclaratorSyntax

    /// Parameter type list associated with this block declarator.
    public var parameterList: ParameterListSyntax
}

extension BlockDeclaratorSyntax: DeclarationSyntaxElementType {
    public var children: [DeclarationSyntaxElementType] {
        blockDeclarationSpecifiers + toChildrenList(directDeclarator, parameterList)
    }
}
extension BlockDeclaratorSyntax: CustomStringConvertible {
    public var description: String {
        var result: String = ""
        result += "(^"
        
        result += blockDeclarationSpecifiers.map(\.description).joined(separator: " ")
        if !blockDeclarationSpecifiers.isEmpty {
            result += " "
        }

        result += "\(directDeclarator)"
        result += ")"

        result += "("
        result += "\(parameterList)"
        result += ")"

        return result
    }
}
