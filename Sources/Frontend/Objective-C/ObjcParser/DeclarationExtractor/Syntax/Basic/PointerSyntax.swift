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

    public var pointerSpecifiers: [PointerSpecifierSyntax] = []
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
        pointerSpecifiers
    }

    public var sourceRange: SourceRange {
        .init(union: children.map(\.sourceRange) + [.location(location)])
    }
}
extension PointerSyntaxEntry: CustomStringConvertible {
    public var description: String {
        var result = "*"

        result += pointerSpecifiers.map(\.description).joined(separator: " ")

        return result
    }
}

/// Syntax element for a pointer declaration specifier in a pointer syntax.
public enum PointerSpecifierSyntax: Hashable, Codable {
    case typeQualifier(TypeQualifierSyntax)
    case nullability(NullabilitySpecifierSyntax)
    case arcBehaviour(ArcBehaviourSpecifierSyntax)
    
    /// Returns the `TypeQualifierSyntax` associated with this enumerator if its
    /// a `.typeQualifier` case, otherwise returns `nil`.
    public var typeQualifier: TypeQualifierSyntax? {
        switch self {
        case .typeQualifier(let value):
            return value
        default:
            return nil
        }
    }

    /// Returns the `NullabilitySpecifierSyntax` associated with this enumerator
    /// if its a `.nullability` case, otherwise returns `nil`.
    public var nullabilitySpecifier: NullabilitySpecifierSyntax? {
        switch self {
        case .nullability(let value):
            return value
        default:
            return nil
        }
    }

    /// Returns the `ArcBehaviourSpecifierSyntax` associated with this enumerator
    /// if its a `.arcBehaviour` case, otherwise returns `nil`.
    public var arcBehaviourSpecifier: ArcBehaviourSpecifierSyntax? {
        switch self {
        case .arcBehaviour(let value):
            return value
        default:
            return nil
        }
    }
}

extension PointerSpecifierSyntax: DeclarationSyntaxElementType {
    public var children: [DeclarationSyntaxElementType] {
        switch self {
        case .typeQualifier(let value):
            return toChildrenList(value)
        case .nullability(let value):
            return toChildrenList(value)
        case .arcBehaviour(let value):
            return toChildrenList(value)
        }
    }
}
extension PointerSpecifierSyntax: CustomStringConvertible {
    public var description: String {
        switch self {
        case .typeQualifier(let value):
            return "\(value)"
        case .nullability(let value):
            return "\(value)"
        case .arcBehaviour(let value):
            return "\(value)"
        }
    }
}
