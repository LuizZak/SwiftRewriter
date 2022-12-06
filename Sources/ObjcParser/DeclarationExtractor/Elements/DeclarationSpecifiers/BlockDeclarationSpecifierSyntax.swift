/// Syntax element for a block declaration specifier in a declaration.
public enum BlockDeclarationSpecifierSyntax: Hashable, Codable {
    case typePrefix(TypePrefixSyntax)
    case typeQualifier(TypeQualifierSyntax)
    case nullability(NullabilitySpecifierSyntax)
    case arcBehaviour(ArcBehaviourSpecifierSyntax)
}

extension BlockDeclarationSpecifierSyntax: DeclarationSyntaxElementType {
    public var children: [DeclarationSyntaxElementType] {
        switch self {
        case .typePrefix(let value):
            return toChildrenList(value)
        case .typeQualifier(let value):
            return toChildrenList(value)
        case .nullability(let value):
            return toChildrenList(value)
        case .arcBehaviour(let value):
            return toChildrenList(value)
        }
    }
}
extension BlockDeclarationSpecifierSyntax: CustomStringConvertible {
    public var description: String {
        switch self {
        case .typePrefix(let value):
            return "\(value)"
        case .typeQualifier(let value):
            return "\(value)"
        case .nullability(let value):
            return "\(value)"
        case .arcBehaviour(let value):
            return "\(value)"
        }
    }
}
