/// Syntax element for a block declaration specifier in a declaration.
public enum BlockDeclarationSpecifierSyntax: Hashable, Codable {
    case typePrefix(TypePrefixSyntax)
    case typeQualifier(TypeQualifierSyntax)
    case nullability(NullabilitySpecifierSyntax)
    case arcBehaviour(ArcBehaviourSpecifierSyntax)

    /// Returns the `TypePrefixSyntax` associated with this enumerator if its
    /// a `.typePrefix` case, otherwise returns `nil`.
    public var typePrefix: TypePrefixSyntax? {
        switch self {
        case .typePrefix(let value):
            return value
        default:
            return nil
        }
    }
    
    /// Returns the `TypeQualifierSyntax` associated with this enumerator if its
    /// a `.typeQualifier` case, otherwise returns `nil`.
    public var typeQualifier: TypeQualifierSyntax? {
        switch self {
        case .typeQualifier(let value):
            return value
        default:
            return nil
        }
    }

    /// Returns the `NullabilitySpecifierSyntax` associated with this enumerator
    /// if its a `.nullability` case, otherwise returns `nil`.
    public var nullabilitySpecifier: NullabilitySpecifierSyntax? {
        switch self {
        case .nullability(let value):
            return value
        default:
            return nil
        }
    }

    /// Returns the `ArcBehaviourSpecifierSyntax` associated with this enumerator
    /// if its a `.arcBehaviour` case, otherwise returns `nil`.
    public var arcBehaviourSpecifier: ArcBehaviourSpecifierSyntax? {
        switch self {
        case .arcBehaviour(let value):
            return value
        default:
            return nil
        }
    }
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
