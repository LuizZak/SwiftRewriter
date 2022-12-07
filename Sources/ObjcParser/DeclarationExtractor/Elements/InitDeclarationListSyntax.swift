/// Declarator list with optional initializers for declarations.
public struct InitDeclaratorListSyntax: Hashable, Codable {
    public var initDeclarators: [InitDeclaratorSyntax]
}

extension InitDeclaratorListSyntax: DeclarationSyntaxElementType {
    public var children: [DeclarationSyntaxElementType] {
        initDeclarators
    }
}
extension InitDeclaratorListSyntax: CustomStringConvertible {
    public var description: String {
        initDeclarators.map(\.description).joined(separator: ", ")
    }
}
extension InitDeclaratorListSyntax: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: InitDeclaratorSyntax...) {
        self.init(initDeclarators: elements)
    }
}
