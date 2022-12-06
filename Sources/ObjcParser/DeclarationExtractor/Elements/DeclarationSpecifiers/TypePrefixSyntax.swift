import GrammarModels

/// Syntax node for a type prefix for declarations.
public enum TypePrefixSyntax: Hashable, Codable {
    case bridge(SourceRange = .invalid)
    case bridgeTransfer(SourceRange = .invalid)
    case bridgeRetained(SourceRange = .invalid)
    case block(SourceRange = .invalid)
    case inline(SourceRange = .invalid)
    case nsInline(SourceRange = .invalid)
    case kindof(SourceRange = .invalid)
}

extension TypePrefixSyntax: DeclarationSyntaxElementType {
    public var children: [DeclarationSyntaxElementType] { toChildrenList() }

    public var sourceRange: SourceRange {
        switch self {
        case .block(let range):
            return range 
        case .bridge(let range):
            return range 
        case .bridgeRetained(let range):
            return range 
        case .bridgeTransfer(let range):
            return range 
        case .inline(let range):
            return range 
        case .kindof(let range):
            return range 
        case .nsInline(let range):
            return range 
        }
    }
}
extension TypePrefixSyntax: CustomStringConvertible {
    public var description: String {
        switch self {
        case .bridge:
            return "__bridge"
        case .bridgeTransfer:
            return "__bridge_transfer"
        case .bridgeRetained:
            return "__bridge_retained"
        case .block:
            return "__block"
        case .inline:
            return "inline"
        case .nsInline:
            return "NS_INLINE"
        case .kindof:
            return "__kindof"
        }
    }
}
