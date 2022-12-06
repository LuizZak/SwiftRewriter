/// Syntax element for a function direct declarator.
public struct FunctionAbstractDeclaratorSyntax: Hashable, Codable {
    // A base direct declarator for this function declarator.
    public var directAbstractDeclarator: DirectAbstractDeclaratorSyntax?

    /// Parameter type list associated with this function declarator.
    public var parameterTypeList: ParameterTypeListSyntax?
}

extension FunctionAbstractDeclaratorSyntax: DeclarationSyntaxElementType {
    public var children: [DeclarationSyntaxElementType] {
        toChildrenList(directAbstractDeclarator, parameterTypeList)
    }
}
extension FunctionAbstractDeclaratorSyntax: CustomStringConvertible {
    public var description: String {
        var result: String = ""

        if let directAbstractDeclarator {
            result += "\(directAbstractDeclarator)"
        }

        result += "("
        if let parameterTypeList {
            result += "\(parameterTypeList)"
        }
        result += ")"

        return result
    }
}
