/// A parameter type list syntax for declarations.
public struct ParameterTypeListSyntax: Hashable, Codable {
    public var parameterList: ParameterListSyntax

    /// Whether this parameter type list contains an ellipsis variadic parameter
    /// specifier at the end, i.e. `...`.
    public var isVariadic: Bool
}

extension ParameterTypeListSyntax: DeclarationSyntaxElementType {
    public var children: [DeclarationSyntaxElementType] {
        toChildrenList(parameterList)
    }
}

extension ParameterTypeListSyntax: CustomStringConvertible {
    public var description: String {
        return parameterList.description + (isVariadic ? ", ..." : "")
    }
}
