/// Declarator with optional initializers for declarations.
public struct InitDeclaratorSyntax: Hashable, Codable {
    public var declarator: DeclaratorSyntax
    public var initializer: InitializerSyntax?
}

extension InitDeclaratorSyntax: DeclarationSyntaxElementType {
    public var children: [DeclarationSyntaxElementType] {
        toChildrenList(declarator, initializer)
    }
}
extension InitDeclaratorSyntax: CustomStringConvertible {
    public var description: String {
        if let initializer {
            return "\(declarator) = \(initializer)"
        }

        return "\(declarator)"
    }
}
