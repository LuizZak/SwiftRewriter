/// Syntax element for parameter lists in declarations.
public struct ParameterListSyntax: Hashable, Codable {
    /// List of parameter declarations.
    /// May be empty.
    public var parameterDeclarations: [ParameterDeclarationSyntax]
}

/// Syntax element for parameters in a parameter list syntax of a declaration.
public enum ParameterDeclarationSyntax: Hashable, Codable {
    case declarator(DeclarationSpecifiersSyntax, DeclaratorSyntax)
    case abstractDeclarator(DeclarationSpecifiersSyntax, AbstractDeclaratorSyntax)
    case declarationSpecifiers(DeclarationSpecifiersSyntax)

    public var declarationSpecifiers: DeclarationSpecifiersSyntax {
        switch self {
        case .declarator(let value, _),
            .abstractDeclarator(let value, _),
            .declarationSpecifiers(let value):

            return value
        }
    }
}

// MARK: - DeclarationSyntaxElementType conformance

extension ParameterListSyntax: DeclarationSyntaxElementType {
    public var children: [DeclarationSyntaxElementType] {
        parameterDeclarations
    }
}

extension ParameterListSyntax: CustomStringConvertible {
    public var description: String {
        parameterDeclarations.map(\.description).joined(separator: ", ")
    }
}

extension ParameterDeclarationSyntax: DeclarationSyntaxElementType {
    public var children: [DeclarationSyntaxElementType] {
        switch self {
        case .declarator(let declarationSpecifiers, let declarator):
            return toChildrenList(declarationSpecifiers, declarator)
        case .abstractDeclarator(let declarationSpecifiers, let abstractDeclarator):
            return toChildrenList(declarationSpecifiers, abstractDeclarator)
        case .declarationSpecifiers(let declarationSpecifiers):
            return toChildrenList(declarationSpecifiers)
        }
    }
}

extension ParameterDeclarationSyntax: CustomStringConvertible {
    public var description: String {
        switch self {
        case .declarator(let declarationSpecifiers, let declarator):
            return "\(declarationSpecifiers) \(declarator)"
        case .abstractDeclarator(let declarationSpecifiers, let abstractDeclarator):
            return "\(declarationSpecifiers) \(abstractDeclarator)"
        case .declarationSpecifiers(let declarationSpecifiers):
            return "\(declarationSpecifiers)"
        }
    }
}
