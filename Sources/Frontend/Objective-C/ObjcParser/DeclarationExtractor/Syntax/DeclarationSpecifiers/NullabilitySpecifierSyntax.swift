import Utils

/// Nullability specifier syntax for declarations.
public enum NullabilitySpecifierSyntax: Hashable, Codable {
    case nullUnspecified(SourceRange = .invalid)
    case nullable(SourceRange = .invalid)
    case nonnull(SourceRange = .invalid)
    case nullResettable(SourceRange = .invalid)
}

extension NullabilitySpecifierSyntax: DeclarationSyntaxElementType {
    public var children: [DeclarationSyntaxElementType] { toChildrenList() }

    public var sourceRange: SourceRange {
        switch self {
        case .nonnull(let range):
            return range
        case .nullResettable(let range):
            return range
        case .nullUnspecified(let range):
            return range
        case .nullable(let range):
            return range
        }
    }
}
extension NullabilitySpecifierSyntax: CustomStringConvertible {
    public var description: String {
        switch self {
        case .nonnull:
            return "nonnull"
        case .nullResettable:
            return "null_resettable"
        case .nullUnspecified:
            return "null_unspecified"
        case .nullable:
            return "nullable"
        }
    }
}
