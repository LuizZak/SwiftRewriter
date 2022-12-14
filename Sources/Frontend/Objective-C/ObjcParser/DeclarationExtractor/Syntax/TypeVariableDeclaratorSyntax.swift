/// Syntax element for type variable declarators.
public struct TypeVariableDeclaratorSyntax: Hashable, Codable {
    public var declarationSpecifiers: DeclarationSpecifiersSyntax
    public var declarator: DeclaratorSyntax
}

extension TypeVariableDeclaratorSyntax: DeclarationSyntaxElementType {
    public var children: [DeclarationSyntaxElementType] {
        toChildrenList(declarationSpecifiers, declarator)
    }
}
extension TypeVariableDeclaratorSyntax: CustomStringConvertible {
    public var description: String {
        return "\(declarationSpecifiers) \(declarator)"
    }
}
