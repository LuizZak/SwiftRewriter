/// Syntax element for direct declarators.
indirect public enum DirectDeclaratorSyntax: Hashable, Codable {
    case identifier(IdentifierSyntax)
    case declarator(DeclaratorSyntax)
    case arrayDeclarator(ArrayDeclaratorSyntax)
    case functionDeclarator(FunctionDeclaratorSyntax)
    case blockDeclarator(BlockDeclaratorSyntax)

    /// Gets the nested identifier associated with this declarator.
    public var identifier: IdentifierSyntax {
        switch self {
        case .identifier(let value):
            return value
        case .declarator(let value):
            return value.directDeclarator.identifier
        case .arrayDeclarator(let value):
            return value.directDeclarator.identifier
        case .functionDeclarator(let value):
            return value.directDeclarator.identifier
        case .blockDeclarator(let value):
            return value.directDeclarator.identifier
        }
    }

    /// Gets the nested direct declarator within this declarator, in case this
    /// direct declarator syntax is either `.declarator()`, `.arrayDeclarator()`,
    /// `.functionDeclarator()`, or `.blockDeclarator()`.
    public var directDeclarator: DirectDeclaratorSyntax? {
        switch self {
        case .identifier:
            return nil
        case .declarator(let value):
            return value.directDeclarator
        case .arrayDeclarator(let value):
            return value.directDeclarator
        case .functionDeclarator(let value):
            return value.directDeclarator
        case .blockDeclarator(let value):
            return value.directDeclarator
        }
    }
}

extension DirectDeclaratorSyntax: DeclarationSyntaxElementType {
    public var children: [DeclarationSyntaxElementType] {
        switch self {
        case .identifier(let value):
            return toChildrenList(value)
        case .declarator(let value):
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
extension DirectDeclaratorSyntax: CustomStringConvertible {
    public var description: String {
        switch self {
        case .identifier(let value):
            return "\(value)"
        case .declarator(let value):
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
