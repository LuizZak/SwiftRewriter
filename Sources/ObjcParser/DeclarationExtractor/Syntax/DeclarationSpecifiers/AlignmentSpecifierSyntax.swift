/// Alignment specifier syntax element for declarations.
public enum AlignmentSpecifierSyntax: Hashable, Codable {
    case typeName(TypeNameSyntax)

    /// _Alignas(<exp>) alignment specifier.
    /// `expressionSyntax` should be a valid C `constantExpression`-compatible
    /// syntax string.
    case expression(constantExpression: ConstantExpressionSyntax)
}

extension AlignmentSpecifierSyntax: DeclarationSyntaxElementType {
    public var children: [DeclarationSyntaxElementType] {
        switch self {
        case .typeName(let value):
            return toChildrenList(value)
        case .expression(let constantExpression):
            return toChildrenList(constantExpression)
        }
    }
}
extension AlignmentSpecifierSyntax: CustomStringConvertible {
    public var description: String {
        switch self {
        case .typeName(let typeName):
            return "_Alignas(\(typeName))"
        case .expression(let constantExpression):
            return "_Alignas(\(constantExpression))"
        }
    }
}
