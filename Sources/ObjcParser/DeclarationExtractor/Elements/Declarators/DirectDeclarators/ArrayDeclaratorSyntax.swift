/// Syntax element for an array direct declarator.
public struct ArrayDeclaratorSyntax: Hashable, Codable {
    /// The base direct declarator for this array declarator.
    public var directDeclarator: DirectDeclaratorSyntax

    public var typeQualifiers: TypeQualifierListSyntax?
    public var length: ExpressionSyntax?
}

extension ArrayDeclaratorSyntax: DeclarationSyntaxElementType {
    public var children: [DeclarationSyntaxElementType] {
        toChildrenList(directDeclarator, typeQualifiers, length)
    }
}
extension ArrayDeclaratorSyntax: CustomStringConvertible {
    public var description: String {
        switch (typeQualifiers, length) {
        case (nil, nil):
            return "\(directDeclarator)[]"
        case (nil, let length?):
            return "\(directDeclarator)[\(length)]"
        case (let qualifiers?, nil):
            return "\(directDeclarator)[\(qualifiers)]"
        case (let qualifiers?, let length?):
            return "\(directDeclarator)[\(qualifiers) \(length)]"
        }
    }
}
