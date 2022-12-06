import GrammarModels

/// Syntax element for generic type specifiers in declarations.
public struct GenericTypeSpecifierSyntax: Hashable, Codable {
    public var identifier: IdentifierSyntax

    /// List of generic type parameters for this generic type specifier syntax.
    /// Must have length >1.
    public var genericTypeParameters: [GenericTypeParameterSyntax]
}

/// Syntax element for generic type parameters in generic type specifiers in
/// declarations.
public struct GenericTypeParameterSyntax: Hashable, Codable {
    /// Optional generic type variance specifier.
    public var variance: Variance?

    public var typeName: TypeNameSyntax
    
    /// Used to specify whether a generic type parameter is covariant or
    /// contravariant.
    public enum Variance: Hashable, Codable {
        case covariant(SourceRange = .invalid)
        case contravariant(SourceRange = .invalid)
    }
}

extension GenericTypeSpecifierSyntax: DeclarationSyntaxElementType {
    public var children: [DeclarationSyntaxElementType] {
        [identifier] + genericTypeParameters
    }
}
extension GenericTypeSpecifierSyntax: CustomStringConvertible {
    public var description: String {
        "\(identifier)<\(genericTypeParameters.map(\.description).joined(separator: ", "))>"
    }
}

extension GenericTypeParameterSyntax: DeclarationSyntaxElementType {
    public var children: [DeclarationSyntaxElementType] {
        toChildrenList(variance, typeName)
    }
}
extension GenericTypeParameterSyntax: CustomStringConvertible {
    public var description: String {
        if let variance {
            return "\(variance) \(typeName)"
        }

        return "\(typeName)"
    }
}

extension GenericTypeParameterSyntax.Variance: DeclarationSyntaxElementType {
    public var children: [DeclarationSyntaxElementType] { toChildrenList() }

    public var sourceRange: SourceRange {
        switch self {
        case .covariant(let range), .contravariant(let range):
            return range
        }
    }
}
extension GenericTypeParameterSyntax.Variance: CustomStringConvertible {
    public var description: String {
        switch self {
        case .contravariant(_):
            return "__contravariant"
        case .covariant(_):
            return "__covariant"
        }
    }
}
