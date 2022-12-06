import GrammarModels

/// Syntax element for struct or union specifiers in declarations.
public struct StructOrUnionSpecifierSyntax: Hashable, Codable {
    public var structOrUnion: StructOrUnion

    // TODO: Support attributes
    // public var attributeSpecifier: [AttributeSpecifierSyntax]

    public var declaration: Declaration

    /// Specifies whether a `StructOrUnionSpecifierSyntax` is a struct or union
    /// specifier.
    public enum StructOrUnion: Hashable, Codable {
        case `struct`(SourceRange = .invalid)
        case union(SourceRange = .invalid)
    }

    /// The declaration part of the specifier syntax.
    /// Is either an identifier only (opaque), or a struct declaration list with
    /// an optional identifier associated with it (declared).
    public enum Declaration: Hashable, Codable {
        case opaque(IdentifierSyntax)
        case declared(IdentifierSyntax?, StructDeclarationListSyntax)
    }
}

/// Syntax element for declaration lists for the body of a struct or union in
/// declarations.
public struct StructDeclarationListSyntax: Hashable, Codable {
    /// List of declarations within this declaration list.
    public var structDeclaration: [StructDeclarationSyntax]
}

/// Syntax element for a declaration in the body of a struct or union in
/// declarations.
public struct StructDeclarationSyntax: Hashable, Codable {
    // TODO: Support attributes
    // public var attributeSpecifier: [AttributeSpecifierSyntax]

    public var specifierQualifierList: SpecifierQualifierListSyntax
    public var fieldDeclaratorList: [FieldDeclaratorSyntax]
}

// MARK: - DeclarationSyntaxElementType conformance

extension StructOrUnionSpecifierSyntax: DeclarationSyntaxElementType {
    public var children: [DeclarationSyntaxElementType] {
        toChildrenList(structOrUnion, declaration)
    }
}
extension StructOrUnionSpecifierSyntax: CustomStringConvertible {
    public var description: String {
        "\(structOrUnion) \(declaration)"
    }
}

extension StructOrUnionSpecifierSyntax.StructOrUnion: DeclarationSyntaxElementType {
    public var children: [DeclarationSyntaxElementType] { toChildrenList() }

    public var sourceRange: SourceRange {
        switch self {
        case .struct(let range), .union(let range):
            return range
        }
    }
}
extension StructOrUnionSpecifierSyntax.StructOrUnion: CustomStringConvertible {
    public var description: String {
        switch self {
        case .struct:
            return "struct"
        case .union:
            return "union"
        }
    }
}

extension StructOrUnionSpecifierSyntax.Declaration: DeclarationSyntaxElementType {
    public var children: [DeclarationSyntaxElementType] {
        switch self {
        case .opaque(let identifier):
            return toChildrenList(identifier)
        case .declared(let identifier, let declarationList):
            return toChildrenList(identifier, declarationList)
        }
    }
}
extension StructOrUnionSpecifierSyntax.Declaration: CustomStringConvertible {
    public var description: String {
        switch self {
        case .opaque(let identifier):
            return "\(identifier)"
        case .declared(let identifier?, let declarationList):
            return "\(identifier) \(declarationList)"
        case .declared(nil, let declarationList):
            return "\(declarationList)"
        }
    }
}

extension StructDeclarationListSyntax: DeclarationSyntaxElementType {
    public var children: [DeclarationSyntaxElementType] {
        structDeclaration
    }
}
extension StructDeclarationListSyntax: CustomStringConvertible {
    public var description: String {
        "{ " + structDeclaration.map(\.description).joined(separator: " ") + " }"
    }
}

extension StructDeclarationSyntax: DeclarationSyntaxElementType {
    public var children: [DeclarationSyntaxElementType] {
        toChildrenList(specifierQualifierList) + fieldDeclaratorList
    }
}
extension StructDeclarationSyntax: CustomStringConvertible {
    public var description: String {
        if fieldDeclaratorList.isEmpty {
            return "\(specifierQualifierList);"
        }

        return "\(specifierQualifierList) \(fieldDeclaratorList.map(\.description).joined(separator: ", "))" + ";"
    }
}
