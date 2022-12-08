/// Syntax element for a single declaration specifier in declarations.
public enum DeclarationSpecifierSyntax: Hashable, Codable {
    case storage(StorageClassSpecifierSyntax)
    case typeSpecifier(TypeSpecifierSyntax)
    case typeQualifier(TypeQualifierSyntax)
    case functionSpecifier(FunctionSpecifierSyntax)
    case alignment(AlignmentSpecifierSyntax)
    case arcBehaviour(ArcBehaviourSpecifierSyntax)
    case nullability(NullabilitySpecifierSyntax)
    case ibOutlet(IBOutletQualifierSyntax)
    case typePrefix(TypePrefixSyntax)

    /// Returns `true` if this `DeclarationSpecifierSyntax` is a `.storage` case.
    public var isStorage: Bool {
        switch self {
        case .storage:
            return true
        default:
            return false
        }
    }

    /// Returns `true` if this `DeclarationSpecifierSyntax` is a `.typeSpecifier`
    /// case.
    public var isTypeSpecifier: Bool {
        switch self {
        case .typeSpecifier:
            return true
        default:
            return false
        }
    }

    /// Returns `true` if this `DeclarationSpecifierSyntax` is a `.typeQualifier`
    /// case.
    public var isTypeQualifier: Bool {
        switch self {
        case .typeQualifier:
            return true
        default:
            return false
        }
    }

    /// Returns `true` if this `DeclarationSpecifierSyntax` is a `.functionSpecifier`
    /// case.
    public var isFunctionSpecifier: Bool {
        switch self {
        case .functionSpecifier:
            return true
        default:
            return false
        }
    }

    /// Returns `true` if this `DeclarationSpecifierSyntax` is a `.alignment` case.
    public var isAlignment: Bool {
        switch self {
        case .alignment:
            return true
        default:
            return false
        }
    }

    /// Returns `true` if this `DeclarationSpecifierSyntax` is a `.arcBehaviour`
    /// case.
    public var isArcBehaviour: Bool {
        switch self {
        case .arcBehaviour:
            return true
        default:
            return false
        }
    }

    /// Returns `true` if this `DeclarationSpecifierSyntax` is a `.nullability`
    /// case.
    public var isNullability: Bool {
        switch self {
        case .nullability:
            return true
        default:
            return false
        }
    }

    /// Returns `true` if this `DeclarationSpecifierSyntax` is a `.ibOutlet` case.
    public var isIbOutlet: Bool {
        switch self {
        case .ibOutlet:
            return true
        default:
            return false
        }
    }
    
    /// Returns `true` if this `DeclarationSpecifierSyntax` is a `.typePrefix`
    /// case.
    public var isTypePrefix: Bool {
        switch self {
        case .typePrefix:
            return true
        default:
            return false
        }
    }
}

extension DeclarationSpecifierSyntax: DeclarationSyntaxElementType {
    public var children: [DeclarationSyntaxElementType] {
        switch self {
        case .storage(let value):
            return toChildrenList(value)
        case .typeSpecifier(let value):
            return toChildrenList(value)
        case .typeQualifier(let value):
            return toChildrenList(value)
        case .functionSpecifier(let value):
            return toChildrenList(value)
        case .alignment(let value):
            return toChildrenList(value)
        case .arcBehaviour(let value):
            return toChildrenList(value)
        case .nullability(let value):
            return toChildrenList(value)
        case .ibOutlet(let value):
            return toChildrenList(value)
        case .typePrefix(let value):
            return toChildrenList(value)
        }
    }
}
extension DeclarationSpecifierSyntax: CustomStringConvertible {
    public var description: String {
        switch self {
        case .storage(let value):
            return "\(value)"
        case .typeSpecifier(let value):
            return "\(value)"
        case .typeQualifier(let value):
            return "\(value)"
        case .functionSpecifier(let value):
            return "\(value)"
        case .alignment(let value):
            return "\(value)"
        case .arcBehaviour(let value):
            return "\(value)"
        case .nullability(let value):
            return "\(value)"
        case .ibOutlet(let value):
            return "\(value)"
        case .typePrefix(let value):
            return "\(value)"
        }
    }
}
