/// Syntax element for an array abstract declarator.
public struct ArrayAbstractDeclaratorSyntax: Hashable, Codable {
    /// A base direct declarator for this array declarator.
    public var directAbstractDeclarator: DirectAbstractDeclaratorSyntax?

    public var typeQualifiers: TypeQualifierListSyntax?
    public var length: ExpressionSyntax?
}

extension ArrayAbstractDeclaratorSyntax: DeclarationSyntaxElementType {
    public var children: [DeclarationSyntaxElementType] {
        toChildrenList(directAbstractDeclarator, typeQualifiers, length)
    }
}
extension ArrayAbstractDeclaratorSyntax: CustomStringConvertible {
    public var description: String {
        var result: String = ""
        
        if let directAbstractDeclarator {
            result += "\(directAbstractDeclarator)"
        }

        result += "["

        switch (typeQualifiers, length) {
        case (nil, nil):
            break
        case (nil, let length?):
            result += "\(length)"
        case (let qualifiers?, nil):
            result += "\(qualifiers)"
        case (let qualifiers?, let length?):
            result += "\(qualifiers) \(length)"
        }

        result += "]"

        return result
    }
}
