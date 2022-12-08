/// Syntax element for a function direct declarator.
public struct FunctionDeclaratorSyntax: Hashable, Codable {
    /// The base direct declarator for this function declarator.
    public var directDeclarator: DirectDeclaratorSyntax

    /// Parameter type list associated with this function declarator.
    public var parameterTypeList: ParameterTypeListSyntax?
}

extension FunctionDeclaratorSyntax: DeclarationSyntaxElementType {
    public var children: [DeclarationSyntaxElementType] {
        toChildrenList(directDeclarator, parameterTypeList)
    }
}
extension FunctionDeclaratorSyntax: CustomStringConvertible {
    public var description: String {
        var result: String = ""
        result += "\(directDeclarator)"

        result += "("
        if let parameterTypeList {
            result += "\(parameterTypeList)"
        }
        result += ")"

        return result
    }
}
