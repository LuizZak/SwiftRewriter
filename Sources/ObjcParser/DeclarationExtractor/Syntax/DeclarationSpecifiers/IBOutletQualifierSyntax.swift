import GrammarModels

/// Syntax element for InterfaceBuilder qualifiers in declarations.
public enum IBOutletQualifierSyntax: Hashable, Codable {
    case ibOutletCollection(SourceLocation = .invalid, IdentifierSyntax)
    case ibOutlet(SourceRange = .invalid)
}

extension IBOutletQualifierSyntax: DeclarationSyntaxElementType {
    public var children: [DeclarationSyntaxElementType] {
        switch self {
        case .ibOutletCollection(_, let value):
            return toChildrenList(value)
        case .ibOutlet:
            return toChildrenList()
        }
    }

    public var sourceRange: SourceRange {
        switch self {
        case .ibOutletCollection(let start, let ident):
            return ident.sourceRange.union(with: start)
        case .ibOutlet(let range):
            return range
        }
    }
}
extension IBOutletQualifierSyntax: CustomStringConvertible {
    public var description: String {
        switch self {
        case .ibOutletCollection(_, let value):
            return "IBOutletCollection(\(value))"
        case .ibOutlet:
            return "IBOutlet"
        }
    }
}
