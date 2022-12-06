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
        }
    }
}
