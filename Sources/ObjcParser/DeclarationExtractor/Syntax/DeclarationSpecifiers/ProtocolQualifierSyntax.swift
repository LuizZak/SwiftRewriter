import GrammarModels

/// Protocol type qualifier syntax for declarations.
public enum ProtocolQualifierSyntax: Hashable, Codable {
    case `in`(SourceRange = .invalid)
    case out(SourceRange = .invalid)
    case `inout`(SourceRange = .invalid)
    case bycopy(SourceRange = .invalid)
    case byref(SourceRange = .invalid)
    case oneway(SourceRange = .invalid)
}

extension ProtocolQualifierSyntax: DeclarationSyntaxElementType {
    public var children: [DeclarationSyntaxElementType] { toChildrenList() }

    public var sourceRange: SourceRange {
        switch self {
        case .bycopy(let range):
            return range
        case .byref(let range):
            return range
        case .in(let range):
            return range
        case .inout(let range):
            return range
        case .oneway(let range):
            return range
        case .out(let range):
            return range
        }
    }
}
extension ProtocolQualifierSyntax: CustomStringConvertible {
    public var description: String {
        switch self {
        case .bycopy:
            return "bycopy"
        case .byref:
            return "byref"
        case .in:
            return "in"
        case .inout:
            return "inout"
        case .oneway:
            return "oneway"
        case .out:
            return "out"
        }
    }
}
