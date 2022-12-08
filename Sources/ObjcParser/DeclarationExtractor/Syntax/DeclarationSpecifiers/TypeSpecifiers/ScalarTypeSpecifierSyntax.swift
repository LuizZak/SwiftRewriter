import GrammarModels

/// Scalar type specifier syntax for declarations.
public enum ScalarTypeSpecifierSyntax: Hashable, Codable {
    case void(SourceRange = .invalid)
    case char(SourceRange = .invalid)
    case short(SourceRange = .invalid)
    case int(SourceRange = .invalid)
    case long(SourceRange = .invalid)
    case float(SourceRange = .invalid)
    case double(SourceRange = .invalid)
    case signed(SourceRange = .invalid)
    case unsigned(SourceRange = .invalid)
    /// C `_Bool`
    case _bool(SourceRange = .invalid)
    /// Regular C `bool`
    case bool(SourceRange = .invalid)
    case complex(SourceRange = .invalid)
    case m128(SourceRange = .invalid)
    case m128d(SourceRange = .invalid)
    case m128i(SourceRange = .invalid)
}

extension ScalarTypeSpecifierSyntax: DeclarationSyntaxElementType {
    public var children: [DeclarationSyntaxElementType] { toChildrenList() }

    public var sourceRange: SourceRange {
        switch self {
        case ._bool(let range),
            .bool(let range),
            .char(let range),
            .complex(let range),
            .double(let range),
            .float(let range),
            .int(let range),
            .long(let range),
            .m128(let range),
            .m128d(let range),
            .m128i(let range),
            .short(let range),
            .signed(let range),
            .unsigned(let range),
            .void(let range):
            
            return range
        }
    }
}
extension ScalarTypeSpecifierSyntax: CustomStringConvertible {
    public var description: String {
        switch self {
        case .void:
            return "void"
        case .unsigned:
            return "unsigned"
        case .char:
            return "char"
        case .double:
            return "double"
        case .float:
            return "float"
        case .int:
            return "int"
        case .long:
            return "long"
        case .short:
            return "short"
        case .signed:
            return "signed"
        case ._bool:
            return "_bool"
        case .bool:
            return "bool"
        case .complex:
            return "complex"
        case .m128:
            return "m128"
        case .m128d:
            return "m128d"
        case .m128i:
            return "m128i"
        }
    }
}
