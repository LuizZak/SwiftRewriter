import GrammarModels

/// ARC memory management behaviour specifier syntax for declarations.
public enum ArcBehaviourSpecifierSyntax: Hashable, Codable {
    case weakQualifier(SourceRange = .invalid)
    case strongQualifier(SourceRange = .invalid)
    case autoreleasingQualifier(SourceRange = .invalid)
    case unsafeUnretainedQualifier(SourceRange = .invalid)
}

extension ArcBehaviourSpecifierSyntax: DeclarationSyntaxElementType {
    public var children: [DeclarationSyntaxElementType] { toChildrenList() }

    public var sourceRange: SourceRange {
        switch self {
        case .weakQualifier(let range),
            .strongQualifier(let range),
            .autoreleasingQualifier(let range),
            .unsafeUnretainedQualifier(let range):
            return range
        }
    }
}
extension ArcBehaviourSpecifierSyntax: CustomStringConvertible {
    public var description: String {
        switch self {
        case .weakQualifier:
            return "__weak"
        case .strongQualifier:
            return "__strong"
        case .autoreleasingQualifier:
            return "__autoreleasing"
        case .unsafeUnretainedQualifier:
            return "__unsafe_unretained"
        }
    }
}
