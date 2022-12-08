/// Syntax element for field declarations.
public struct FieldDeclarationSyntax: Hashable, Codable {
    public var declarationSpecifiers: DeclarationSpecifiersSyntax
    public var fieldDeclaratorList: [FieldDeclaratorSyntax]
}

extension FieldDeclarationSyntax: DeclarationSyntaxElementType {
    public var children: [DeclarationSyntaxElementType] {
        toChildrenList(declarationSpecifiers) + fieldDeclaratorList
    }
}
extension FieldDeclarationSyntax: CustomStringConvertible {
    public var description: String {
        return "\(declarationSpecifiers) \(fieldDeclaratorList);"
    }
}
