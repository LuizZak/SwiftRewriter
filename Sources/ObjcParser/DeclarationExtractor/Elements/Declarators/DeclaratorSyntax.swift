/// Syntax element for declarators in declarations.
public struct DeclaratorSyntax: Hashable, Codable {
    public var pointer: PointerSyntax?
    public var directDeclarator: DirectDeclaratorSyntax
    // TODO: Support GCC declarator extensions
    // public var gccDeclaratorExtensions: [GCCDeclaratorExtensionSyntax]
}

extension DeclaratorSyntax: DeclarationSyntaxElementType {
    public var children: [DeclarationSyntaxElementType] {
        toChildrenList(pointer, directDeclarator)
    }
}
extension DeclaratorSyntax: CustomStringConvertible {
    public var description: String {
        "\(pointer?.description ?? "")\(directDeclarator)"
    }
}
