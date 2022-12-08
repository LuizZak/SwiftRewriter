import Utils

/// Leaf syntax elements for identifiers in declarations.
public struct IdentifierSyntax: Hashable, Codable {
    public var sourceRange: SourceRange = .invalid
    
    public var identifier: String
}

extension IdentifierSyntax: DeclarationSyntaxElementType {
    public var children: [DeclarationSyntaxElementType] { toChildrenList() }
}

extension IdentifierSyntax: CustomStringConvertible {
    public var description: String {
        identifier
    }
}
extension IdentifierSyntax: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.init(identifier: value)
    }
}
