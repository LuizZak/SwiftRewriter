/// Common protocol for function and callable JavaScript node types.
public protocol JsFunctionNodeType: JsASTNode {
    /// Gets the identifier for this function node.
    var identifier: JsIdentifierNode? { get }

    /// Gets the function signature associated to this function node.
    var signature: JsFunctionSignature? { get }
}
