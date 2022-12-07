/// Syntax element for lists of type specifiers and type qualifiers.
public struct SpecifierQualifierListSyntax: Hashable, Codable {
    /// List of type specifiers and qualifiers.
    /// Must have length >1.
    public var specifierQualifiers: [TypeSpecifierQualifierSyntax]
}

/// A type specifier or type qualifier for a specifier qualifier list.
public enum TypeSpecifierQualifierSyntax: Hashable, Codable {
    indirect case typeSpecifier(TypeSpecifierSyntax)
    case typeQualifier(TypeQualifierSyntax)
    case alignment(AlignmentSpecifierSyntax)
}

// MARK: - DeclarationSyntaxElementType conformance

extension SpecifierQualifierListSyntax: DeclarationSyntaxElementType {
    public var children: [DeclarationSyntaxElementType] {
        specifierQualifiers
    }
}
extension SpecifierQualifierListSyntax: CustomStringConvertible {
    public var description: String {
        specifierQualifiers.map(\.description).joined(separator: " ")
    }
}
extension SpecifierQualifierListSyntax: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: TypeSpecifierQualifierSyntax...) {
        self.init(specifierQualifiers: elements)
    }
}

extension TypeSpecifierQualifierSyntax: DeclarationSyntaxElementType {
    public var children: [DeclarationSyntaxElementType] {
        switch self {
        case .alignment(let value):
            return toChildrenList(value)
        case .typeQualifier(let value):
            return toChildrenList(value)
        case .typeSpecifier(let value):
            return toChildrenList(value)
        }
    }
}
extension TypeSpecifierQualifierSyntax: CustomStringConvertible {
    public var description: String {
        switch self {
        case .alignment(let value):
            return "\(value)"
        case .typeQualifier(let value):
            return "\(value)"
        case .typeSpecifier(let value):
            return "\(value)"
        }
    }
}
