import Utils

/// Syntax elements for pointers in declarations.
public struct PointerSyntax: Hashable, Codable {
    /// List of pointers within this pointer syntax.
    /// Must have length >1.
    public var pointerEntries: [PointerSyntaxEntry]
}

/// Specifies a single pointer declaration in a pointer syntax node in a declaration.
public struct PointerSyntaxEntry: Hashable, Codable {
    public var location: SourceLocation = .invalid

    public var typeQualifiers: TypeQualifierListSyntax?
    public var nullabilitySpecifier: NullabilitySpecifierSyntax?
}

// MARK: - DeclarationSyntaxElementType conformance

extension PointerSyntax: DeclarationSyntaxElementType {
    public var children: [DeclarationSyntaxElementType] {
        pointerEntries
    }
}
extension PointerSyntax: CustomStringConvertible {
    public var description: String {
        pointerEntries.map(\.description).joined()
    }
}
extension PointerSyntax: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: PointerSyntaxEntry...) {
        self.init(pointerEntries: elements)
    }
}

extension PointerSyntaxEntry: DeclarationSyntaxElementType {
    public var children: [DeclarationSyntaxElementType] {
        toChildrenList(typeQualifiers, nullabilitySpecifier)
    }

    public var sourceRange: SourceRange {
        .init(union: children.map(\.sourceRange) + [.location(location)])
    }
}
extension PointerSyntaxEntry: CustomStringConvertible {
    public var description: String {
        switch (typeQualifiers, nullabilitySpecifier) {
        case (nil, nil):
            return "*"
        case (nil, let nullability?):
            return "*\(nullability)"
        case (let qualifiers?, nil):
            return "*\(qualifiers)"
        case (let qualifiers?, let nullability?):
            return "*\(qualifiers) \(nullability)"
        }
    }
}
