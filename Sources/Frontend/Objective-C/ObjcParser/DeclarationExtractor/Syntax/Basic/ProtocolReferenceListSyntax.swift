/// Syntax element for protocol reference lists in declarations.
public struct ProtocolReferenceListSyntax: Hashable, Codable {
    public var protocols: [ProtocolNameSyntax]
}

/// Syntax element for a protocol name in declarations.
public struct ProtocolNameSyntax: Hashable, Codable {
    public var identifier: IdentifierSyntax
}

// MARK: - DeclarationSyntaxElementType conformance

extension ProtocolReferenceListSyntax: DeclarationSyntaxElementType {
    public var children: [DeclarationSyntaxElementType] {
        protocols
    }
}
extension ProtocolReferenceListSyntax: CustomStringConvertible {
    public var description: String {
        "<" + protocols.map(\.description).joined(separator: ", ") + ">"
    }
}

extension ProtocolNameSyntax: DeclarationSyntaxElementType {
    public var children: [DeclarationSyntaxElementType] {
        toChildrenList(identifier)
    }
}
extension ProtocolNameSyntax: CustomStringConvertible {
    public var description: String {
        identifier.description
    }
}
