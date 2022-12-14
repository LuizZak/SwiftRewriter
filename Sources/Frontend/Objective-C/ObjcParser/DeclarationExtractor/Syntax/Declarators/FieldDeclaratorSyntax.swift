/// Syntax element for a field declarator in struct or field declarations.
/// Is either a declarator, or a constant expression preceded by an optional
/// declarator.
public enum FieldDeclaratorSyntax: Hashable, Codable {
    case declarator(DeclaratorSyntax)
    case declaratorConstantExpression(DeclaratorSyntax?, ConstantExpressionSyntax)
}

extension FieldDeclaratorSyntax: DeclarationSyntaxElementType {
    public var children: [DeclarationSyntaxElementType] {
        switch self {
        case .declarator(let value):
            return toChildrenList(value)
        case .declaratorConstantExpression(let declarator, let constantExpression):
            return toChildrenList(declarator, constantExpression)
        }
    }
}
extension FieldDeclaratorSyntax: CustomStringConvertible {
    public var description: String {
        switch self {
        case .declarator(let decl):
            return "\(decl)"
        case .declaratorConstantExpression(let decl?, let exp):
            return "\(decl) : \(exp)"
        case .declaratorConstantExpression(nil, let exp):
            return ": \(exp)"
        }
    }
}
