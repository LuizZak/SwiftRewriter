/// Syntax element for direct abstractor declarators in C declarations.
indirect public enum DirectAbstractDeclaratorSyntax: Hashable, Codable {
    case abstractDeclarator(AbstractDeclaratorSyntax)
    case arrayDeclarator(ArrayAbstractDeclaratorSyntax)
    case functionDeclarator(FunctionAbstractDeclaratorSyntax)
    case blockDeclarator(BlockAbstractDeclaratorSyntax)

    /// Gets the nested direct declarator within this declarator, in case this
    /// direct declarator syntax is either `.declarator()`, `.arrayDeclarator()`,
    /// `.functionDeclarator()`, or `.blockDeclarator()`.
    public var directAbstractDeclarator: DirectAbstractDeclaratorSyntax? {
        switch self {
        case .abstractDeclarator(let value):
            return value.directAbstractDeclarator
        case .arrayDeclarator(let value):
            return value.directAbstractDeclarator
        case .functionDeclarator(let value):
            return value.directAbstractDeclarator
        case .blockDeclarator(let value):
            return value.directAbstractDeclarator
        }
    }
}

extension DirectAbstractDeclaratorSyntax: DeclarationSyntaxElementType {
    public var children: [DeclarationSyntaxElementType] {
        switch self {
        case .abstractDeclarator(let value):
            return toChildrenList(value)
        case .arrayDeclarator(let value):
            return toChildrenList(value)
        case .functionDeclarator(let value):
            return toChildrenList(value)
        case .blockDeclarator(let value):
            return toChildrenList(value)
        }
    }
}
extension DirectAbstractDeclaratorSyntax: CustomStringConvertible {
    public var description: String {
        switch self {
        case .abstractDeclarator(let value):
            return "(\(value))"
        case .arrayDeclarator(let value):
            return "\(value)"
        case .functionDeclarator(let value):
            return "\(value)"
        case .blockDeclarator(let value):
            return "\(value)"
        }
    }
}
