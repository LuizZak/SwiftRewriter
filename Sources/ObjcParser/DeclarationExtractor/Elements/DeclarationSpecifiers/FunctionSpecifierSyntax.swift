import GrammarModels

/// Function specifier syntax for declarations.
public enum FunctionSpecifierSyntax: Hashable, Codable {
    case inline(SourceRange = .invalid)
    case noreturn(SourceRange = .invalid)
    case gccInline(SourceRange = .invalid)
    case stdcall(SourceRange = .invalid)
    case declspec(SourceLocation = .invalid, IdentifierSyntax)
}

extension FunctionSpecifierSyntax: DeclarationSyntaxElementType {
    public var children: [DeclarationSyntaxElementType] {
        switch self {
        case .inline, .noreturn, .gccInline, .stdcall:
            return toChildrenList()
        case .declspec(_, let value):
            return toChildrenList(value)
        }
    }

    public var sourceRange: SourceRange {
        switch self {
        case .inline(let range):
            return range
        case .noreturn(let range):
            return range
        case .gccInline(let range):
            return range
        case .stdcall(let range):
            return range
        case .declspec(let start, let ident):
            return ident.sourceRange.union(with: start)
        }
    }
}
extension FunctionSpecifierSyntax: CustomStringConvertible {
    public var description: String {
        switch self {
        case .inline:
            return "inline"
        case .noreturn:
            return "_Noreturn"
        case .gccInline:
            return "__inline__"
        case .stdcall:
            return "__stdcall"
        case .declspec(_, let ident):
            return "__declspec(\(ident))"
        }
    }
}
