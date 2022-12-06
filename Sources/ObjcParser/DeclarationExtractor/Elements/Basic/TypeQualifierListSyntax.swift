import GrammarModels

/// Syntax node for a list of type qualifiers for declarations.
public struct TypeQualifierListSyntax: Hashable, Codable {
    public var typeQualifiers: [TypeQualifierSyntax]
}

extension TypeQualifierListSyntax: DeclarationSyntaxElementType {
    public var children: [DeclarationSyntaxElementType] {
        typeQualifiers
    }

    public var sourceRange: SourceRange {
        SourceRange(union: typeQualifiers.map(\.sourceRange))
    }
}
extension TypeQualifierListSyntax: CustomStringConvertible {
    public var description: String {
        typeQualifiers.map(\.description).joined(separator: " ")
    }
}
