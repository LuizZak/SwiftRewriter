import Utils

/// Syntax node for storage class specifiers for declarations.
public enum StorageClassSpecifierSyntax: Hashable, Codable {
    case auto(SourceRange = .invalid)
    case constexpr(SourceRange = .invalid)
    case extern(SourceRange = .invalid)
    case register(SourceRange = .invalid)
    case `static`(SourceRange = .invalid)
    case threadLocal(SourceRange = .invalid)
    case typedef(SourceRange = .invalid)
}

extension StorageClassSpecifierSyntax: DeclarationSyntaxElementType {
    public var children: [DeclarationSyntaxElementType] { toChildrenList() }

    public var sourceRange: SourceRange {
        switch self {
        case .auto(let range):
            return range
        case .constexpr(let range):
            return range
        case .extern(let range):
            return range
        case .register(let range):
            return range
        case .static(let range):
            return range
        case .threadLocal(let range):
            return range
        case .typedef(let range):
            return range
        }
    }
}
extension StorageClassSpecifierSyntax: CustomStringConvertible {
    public var description: String {
        switch self {
        case .auto:
            return "auto"
        case .constexpr:
            return "constexpr"
        case .extern:
            return "extern"
        case .register:
            return "register"
        case .static:
            return "static"
        case .threadLocal:
            return "thread_local"
        case .typedef:
            return "typedef"
        }
    }
}
