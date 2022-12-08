import GrammarModels

/// Syntax node for a type qualifier for declarations.
public enum TypeQualifierSyntax: Hashable, Codable {
    case const(SourceRange = .invalid)
    case volatile(SourceRange = .invalid)
    case restrict(SourceRange = .invalid)
    case atomic(SourceRange = .invalid)
    case protocolQualifier(ProtocolQualifierSyntax)
}

extension TypeQualifierSyntax: DeclarationSyntaxElementType {
    public var children: [DeclarationSyntaxElementType] {
        switch self {
        case .atomic, .const, .restrict, .volatile:
            return toChildrenList()
        case .protocolQualifier(let value):
            return [value]
        }
    }

    public var sourceRange: SourceRange {
        switch self {
        case .atomic(let range):
            return range
        case .const(let range):
            return range
        case .restrict(let range):
            return range
        case .volatile(let range):
            return range
        case .protocolQualifier(let value):
            return value.sourceRange
        }
    }
}
extension TypeQualifierSyntax: CustomStringConvertible {
    public var description: String {
        switch self {
        case .const:
            return "const"
        case .volatile:
            return "volatile"
        case .restrict:
            return "restrict"
        case .atomic:
            return "atomic"
        case .protocolQualifier(let value):
            return "\(value)"
        }
    }
}
