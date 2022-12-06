/// Syntax for a declaration.
public struct DeclarationSyntax: Hashable, Codable {
    public var declarationSpecifiers: DeclarationSpecifiersSyntax
    public var initDeclaratorList: InitDeclaratorListSyntax?
}

extension DeclarationSyntax: DeclarationSyntaxElementType {
    public var children: [DeclarationSyntaxElementType] {
        toChildrenList(declarationSpecifiers, initDeclaratorList)
    }
}
extension DeclarationSyntax: CustomStringConvertible {
    public var description: String {
        if let initDeclaratorList {
            return "\(declarationSpecifiers) \(initDeclaratorList)"
        }

        return "\(declarationSpecifiers)"
    }
}
