/// Initializer syntax for declarations.
public enum InitializerSyntax: Hashable, Codable {
    case expression(ExpressionSyntax)
    // TODO: Support array initializer
    // case arrayInitializer(ArrayInitializerSyntax)
    // TODO: Support struct initializer
    // case structInitializer(StructInitializerSyntax)
}

extension InitializerSyntax: DeclarationSyntaxElementType {
    public var children: [DeclarationSyntaxElementType] {
        switch self {
        case .expression(let value):
            return toChildrenList(value)
        }
    }
}
extension InitializerSyntax: CustomStringConvertible {
    public var description: String {
        switch self {
        case .expression(let value):
            return value.description
        }
    }
}
extension InitializerSyntax: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self = .expression(.init(expressionString: value))
    }
}
