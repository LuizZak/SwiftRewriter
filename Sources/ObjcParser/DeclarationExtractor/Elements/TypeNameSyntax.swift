/// Syntax element for type names in declarations.
public struct TypeNameSyntax: Hashable, Codable {
    public var declarationSpecifiers: DeclarationSpecifiersSyntax
    public var abstractDeclarator: AbstractDeclaratorSyntax?
}

extension TypeNameSyntax: DeclarationSyntaxElementType {
    public var children: [DeclarationSyntaxElementType] {
        toChildrenList(declarationSpecifiers, abstractDeclarator)
    }
}
extension TypeNameSyntax: CustomStringConvertible {
    public var description: String {
        if let abstractDeclarator {
            return "\(declarationSpecifiers) \(abstractDeclarator)"
        }

        return "\(declarationSpecifiers)"
    }
}
