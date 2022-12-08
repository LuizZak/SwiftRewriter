/// Syntax elements for abstract declarators in declarations.
public enum AbstractDeclaratorSyntax: Hashable, Codable {
    /// A pointer-only abstract declarator syntax
    case pointer(PointerSyntax)

    /// A direct abstract declarator syntax, optionally preceded by a pointer
    /// syntax.
    case directAbstractDeclarator(PointerSyntax?, DirectAbstractDeclaratorSyntax)

    /// Gets the `PointerSyntax` associated with this abstract declarator syntax
    /// element, if one is present.
    public var pointer: PointerSyntax? {
        switch self {
        case .pointer(let value):
            return value
        case .directAbstractDeclarator(let value, _):
            return value
        }
    }

    /// Gets the `DirectAbstractDeclaratorSyntax` associated with this abstract
    /// declarator syntax element, if one is present.
    public var directAbstractDeclarator: DirectAbstractDeclaratorSyntax? {
        switch self {
        case .pointer:
            return nil
        case .directAbstractDeclarator(_, let value):
            return value
        }
    }
}

extension AbstractDeclaratorSyntax: DeclarationSyntaxElementType {
    public var children: [DeclarationSyntaxElementType] {
        switch self {
        case .pointer(let pointer):
            return toChildrenList(pointer)
        case .directAbstractDeclarator(let pointer, let directAbstractDeclarator):
            return toChildrenList(pointer, directAbstractDeclarator)
        }
    }
}
extension AbstractDeclaratorSyntax: CustomStringConvertible {
    public var description: String {
        switch self {
        case .pointer(let pointer):
            return "\(pointer)"
        case .directAbstractDeclarator(let pointer?, let directAbstractDeclarator):
            return "\(pointer)\(directAbstractDeclarator)"
        case .directAbstractDeclarator(nil, let directAbstractDeclarator):
            return "\(directAbstractDeclarator)"
        }
    }
}
