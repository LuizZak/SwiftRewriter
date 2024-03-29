import Antlr4
import Utils
import GrammarModelBase
import SwiftAST

/// Used to apply source code comments to `SwiftAST` syntax trees that originated
/// from source code as these elements are parsed.
public class SwiftASTCommentApplier {
    private var state: _State
    
    /// Collection of comments yet to be distributed to syntax elements.
    var comments: [RawCodeComment] {
        get { state.comments }
        set { state.comments = newValue }
    }

    var rangeContextStack: [SourceRange] {
        get { state.rangeContextStack }
        set { state.rangeContextStack = newValue }
    }

    /// Returns the most recently pushed `SourceRange` context.
    /// Is `nil` if no range context is currently pushed.
    public var rangeContext: SourceRange? {
        rangeContextStack.last
    }

    /// Initializes a new comment applier with a given set of comments.
    public init(comments: [RawCodeComment]) {
        self.state = _State(
            comments: comments.sorted { $0.location < $1.location },
            rangeContextStack: []
        )
    }

    /// Sets the list of comments of a statement to be all comments that apply to
    /// that statement given a specified parser rule to use as source range.
    public func applyComments(to statement: Statement, _ rule: ParserRuleContext) {
        let leading = popAllCommentsBefore(rule: rule)
        let trailing = popClosestCommentAtTrailingLine(rule: rule)

        statement.comments = leading
        statement.trailingComment = trailing
    }

    /// Appends to the list of comments of a statement all comments that overlap
    /// a given parser rule context's source range.
    public func applyOverlappingComments(to statement: Statement, _ rule: ParserRuleContext) {
        let overlapping = popCommentsOverlapping(rule: rule)

        statement.comments.append(contentsOf:
            overlapping
        )
    }

    /// Pushes a source range context that overlaps a given parser rule context
    /// that acts as a limit to queries of comments provided by this comment
    /// applier by ignoring all comments that do not overlap this range.
    public func pushRangeContext(rule: ParserRuleContext) {
        guard let range = rule.sourceRange() else {
            return
        }

        pushRangeContext(range)
    }

    /// Pushes a source range context that acts as a limit to queries of comments
    /// provided by this comment applier by ignoring all comments that do not
    /// overlap this range.
    public func pushRangeContext(_ range: SourceRange) {
        rangeContextStack.append(range)
    }

    /// Pops the top-most range context from this comment applier.
    public func popRangeContext() {
        if !rangeContextStack.isEmpty {
            rangeContextStack.removeLast()
        }
    }

    /// Pops the top-most range context from this comment applier, applying any
    /// comment that overlapped that range that is still present in the comments
    /// list to a given statement object.
    public func popRangeContext(applyingUnusedCommentsTo stmt: Statement) {
        guard !rangeContextStack.isEmpty else {
            return
        }

        defer { rangeContextStack.removeLast() }

        let comments = _withCommentQuerier {
            $0.popAllComments()
        }

        stmt.comments.append(contentsOf:
            _toCommentArray(comments)
        )
    }

    /// Pops all comments currently stored in this comment applier.
    public func popAllComments() -> [SwiftComment] {
        _withCommentQuerier {
            $0.popAllComments().map(_toComment(_:))
        }
    }

    /// Pops the closest comment preceding a given source code location.
    ///
    /// Returns `nil` if no comment was found preceding `rule`.
    public func popClosestCommentBefore(rule: ParserRuleContext) -> SwiftComment? {
        _withCommentQuerier {
            $0.popClosestCommentBefore(rule: rule).map(_toComment(_:))
        }
    }
    
    /// Pops all comments that precede a given parser rule in the source code.
    public func popAllCommentsBefore(rule: ParserRuleContext) -> [SwiftComment] {
        _withCommentQuerier {
            _toCommentArray($0.popAllCommentsBefore(rule: rule))
        }
    }

    /// Pops all comments lay inline with a given parser rule context.
    public func popCommentsInlineWith(rule: ParserRuleContext) -> [SwiftComment] {
        _withCommentQuerier {
            _toCommentArray($0.popCommentsInlineWith(rule: rule))
        }
    }
    
    /// Pops all comments that overlap a given parser rule context.
    public func popCommentsOverlapping(rule: ParserRuleContext) -> [SwiftComment] {
        _withCommentQuerier {
            _toCommentArray($0.popCommentsOverlapping(rule: rule))
        }
    }
    
    /// Pops the closest comment that trails a given parser rule's exact line
    /// number.
    public func popClosestCommentAtTrailingLine(rule: ParserRuleContext) -> SwiftComment? {
        _withCommentQuerier {
            $0.popClosestCommentAtTrailingLine(rule: rule).map(_toComment(_:))
        }
    }

    /// Returns a State value that can be used to restore the state of this
    /// comment applier to a previous point.
    public func saveState() -> State {
        return State(state: state)
    }

    /// Restores the state of this comment applier to a previous point specified
    /// by a given `State` object.
    ///
    /// This affects both the comments available as well as the stack of source
    /// range contexts pushed by `pushRangeContext(_:)` and `pushRangeContext(rule:)`.
    public func restore(state: State) {
        self.state = state.state
    }

    private func _toCommentArray(_ rawComments: [RawCodeComment]) -> [SwiftComment] {
        rawComments.map(_toComment(_:))
    }

    private func _toComment(_ rawComment: RawCodeComment) -> SwiftComment {
        let comment = rawComment.string.trimmingWhitespace()
        let commentTrivia: SwiftComment

        // TODO: Map comments from frontends into an enum
        if comment.hasPrefix("//") {
            commentTrivia = .line(comment)
        } else if comment.hasPrefix("///") {
            commentTrivia = .docLine(comment)
        } else if comment.hasPrefix("/*") {
            commentTrivia = .block(comment)
        } else if comment.hasPrefix("/**") {
            commentTrivia = .docBlock(comment)
        } else {
            commentTrivia = .line(comment)
        }

        return commentTrivia
    }

    /// Invokes a closure with a comment querier that can be used to modify the
    /// list of comments in this comment applier.
    ///
    /// Only comments that overlap the current range context are visible to the
    /// comment querier.
    ///
    /// After the closure is invoked, the comments that where subtracted from
    /// the comment querier are removed from `self.comments` as well.
    private func _withCommentQuerier<T>(_ closure: (CommentQuerier) -> T) -> T {
        let comments: [RawCodeComment]

        if let rangeContext {
            comments = self.comments.filter {
                $0.sourceRange.overlaps(rangeContext)
            }
        } else {
            comments = self.comments
        }

        let querier = CommentQuerier(allComments: comments)
        defer {
            let remaining = querier.allComments
            let removed = Set(comments).subtracting(remaining)

            self.comments.removeAll(where: removed.contains)
        }

        return closure(querier)
    }

    /// Internal state for a comment applier
    fileprivate struct _State {
        var comments: [RawCodeComment]
        var rangeContextStack: [SourceRange]
    }

    /// A token value that can be used to restore the comments from this AST
    /// comment applier to a previously held state.
    public class State {
        fileprivate var state: _State

        fileprivate init(state: _State) {
            self.state = state
        }
    }
}

private extension ParserRuleContext {
    func sourceRange() -> SourceRange?{
        guard let start = getStart(), let stop = getStop() else {
            return nil
        }

        return .init(forStart: start.sourceLocation(), end: stop.sourceLocation())
    }
}

private extension Token {
    func sourceLocation() -> SourceLocation {
        let line = getLine()
        let col = getCharPositionInLine() + 1
        let char = getStartIndex()
        
        return SourceLocation(line: line, column: col, utf8Offset: char)
    }
}
