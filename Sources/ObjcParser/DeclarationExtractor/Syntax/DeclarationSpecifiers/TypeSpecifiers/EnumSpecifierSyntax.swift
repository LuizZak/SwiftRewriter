import GrammarModels

/// Syntax element for enum specifiers in declarations.
public enum EnumSpecifierSyntax: Hashable, Codable {
    /// A regular C `enum` declaration.
    case cEnum(IdentifierSyntax?, TypeNameSyntax?, Declaration)

    /// An `NS_OPTIONS` or `NS_ENUM` declaration.
    case nsOptionsOrNSEnum(NSOptionsOrNSEnum, TypeNameSyntax, IdentifierSyntax, EnumeratorListSyntax)

    /// Specifies whether an enum specifier was declared using `NS_OPTIONS` or
    /// `NS_ENUM` macros provided by Objective-C.
    public enum NSOptionsOrNSEnum: Hashable, Codable {
        case nsOptions(SourceRange = .invalid)
        case nsEnum(SourceRange = .invalid)
    }

    /// The declaration part of the specifier syntax.
    /// Is either an identifier only (opaque), or an enumerator list body with
    /// no identifier.
    public enum Declaration: Hashable, Codable {
        case opaque(IdentifierSyntax)
        case declared(IdentifierSyntax?, EnumeratorListSyntax)
    }
}

/// Syntax element for a list of enumerators in an enumeration declaration.
public struct EnumeratorListSyntax: Hashable, Codable {
    public var enumerators: [EnumeratorSyntax]
}

/// Syntax element for an enumerator in an enumeration declaration.
public struct EnumeratorSyntax: Hashable, Codable {
    public var enumeratorIdentifier: IdentifierSyntax
    public var expression: ExpressionSyntax?
}

// MARK: - DeclarationSyntaxElementType conformance

extension EnumSpecifierSyntax: DeclarationSyntaxElementType {
    public var children: [DeclarationSyntaxElementType] {
        switch self {
        case .cEnum(let identifier, let typeName, let declaration):
            return toChildrenList(identifier, typeName, declaration)

        case .nsOptionsOrNSEnum(_, let typeName, let identifier, let enumerator):
            return toChildrenList(typeName, identifier, enumerator)
        }
    }
}
extension EnumSpecifierSyntax: CustomStringConvertible {
    public var description: String {
        switch self {
        case .cEnum(let identifier?, let typeName?, let declaration):
            return "enum \(identifier) : \(typeName) \(declaration)"
        
        case .cEnum(let identifier?, nil, let declaration):
            return "enum \(identifier) \(declaration)"

        case .cEnum(nil, _, let declaration):
            return "enum \(declaration)"

        case .nsOptionsOrNSEnum(let keyword, let typeName, let identifier, let enumerator):
            return "\(keyword)(\(typeName), \(identifier)) \(enumerator)"
        }
    }
}

extension EnumSpecifierSyntax.NSOptionsOrNSEnum: DeclarationSyntaxElementType {
    public var children: [DeclarationSyntaxElementType] { toChildrenList() }

    public var sourceRange: SourceRange {
        switch self {
        case .nsEnum(let range), .nsOptions(let range):
            return range
        }
    }
}
extension EnumSpecifierSyntax.NSOptionsOrNSEnum: CustomStringConvertible {
    public var description: String {
        switch self {
        case .nsEnum:
            return "NS_ENUM"
        case .nsOptions:
            return "NS_OPTIONS"
        }
    }
}

extension EnumSpecifierSyntax.Declaration: DeclarationSyntaxElementType {
    public var children: [DeclarationSyntaxElementType] {
        switch self {
        case .opaque(let identifier):
            return toChildrenList(identifier)

        case .declared(let identifier, let enumeratorList):
            return toChildrenList(identifier, enumeratorList)
        }
    }
}
extension EnumSpecifierSyntax.Declaration: CustomStringConvertible {
    public var description: String {
        switch self {
        case .opaque(let identifier):
            return identifier.description
        case .declared(let identifier?, let enumerators):
            return "\(identifier) \(enumerators)"
        case .declared(nil, let enumerators):
            return enumerators.description
        }
    }
}

extension EnumeratorListSyntax: DeclarationSyntaxElementType {
    public var children: [DeclarationSyntaxElementType] {
        enumerators
    }
}
extension EnumeratorListSyntax: CustomStringConvertible {
    public var description: String {
        "{ " + enumerators.map(\.description).joined(separator: ", ") + " }"
    }
}
extension EnumeratorListSyntax: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: EnumeratorSyntax...) {
        self.init(enumerators: elements)
    }
}

extension EnumeratorSyntax: DeclarationSyntaxElementType {
    public var children: [DeclarationSyntaxElementType] {
        if let expression {
            return toChildrenList(enumeratorIdentifier, expression)
        }

        return toChildrenList(enumeratorIdentifier)
    }
}
extension EnumeratorSyntax: CustomStringConvertible {
    public var description: String {
        if let expression {
            return "\(enumeratorIdentifier) = \(expression)"
        }

        return enumeratorIdentifier.description
    }
}
