/// Protocol for AST nodes that support preceding comments.
public protocol CommentedASTNodeType: ASTNode {
    /// Gets or sets the preceding comments for this node.
    var precedingComments: [RawCodeComment] { get set }
}
