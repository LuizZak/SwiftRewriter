import GrammarModelBase
import ObjcGrammarModels

class ObjcCommentApplier {
    var comments: [RawCodeComment]
    var commentQuerier: CommentQuerier

    init(comments: [RawCodeComment]) {
        self.comments = comments
        self.commentQuerier = CommentQuerier(allComments: comments)
    }

    func applyAll(toTree node: ASTNode) {
        apply(to: node)

        // Apply nested comments to children
        let sortedChildren = node.children.sorted {
            $0.location < $1.location
        }

        for child in sortedChildren {
            applyAll(toTree: child)
        }
    }

    private func apply(to node: ASTNode) {
        if node.sourceRange != .invalid && shouldApplyPrecedingComments(to: node) {
            node.precedingComments = commentQuerier.popAllCommentsBefore(node.location)
        }

        switch node {
        case let body as ObjcMethodBodyNode:
            body.comments = commentQuerier.popCommentsOverlapping(body.sourceRange)
        default:
            break
        }
    }

    private func shouldApplyPrecedingComments(to node: ASTNode) -> Bool {
        node is CommentedASTNodeType
    }
}
