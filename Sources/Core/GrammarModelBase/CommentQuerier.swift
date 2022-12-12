import Antlr4
import Utils

/// Class used to manage lookups of comments from source code.
open class CommentQuerier {
    /// List of comments that have not been popped off this comment querier yet.
    public private(set) var allComments: [RawCodeComment]
    
    public init(allComments: [RawCodeComment]) {
        self.allComments = allComments
    }

    /// Pops all comments in this comment querier, resetting the list of comments
    /// to an empty one.
    public func popAllComments() -> [RawCodeComment] {
        defer { allComments.removeAll() }
        
        return allComments
    }
    
    /// Pops the closest comment preceding a given source code location.
    ///
    /// Returns `nil` if no comment was found preceding `location`.
    public func popClosestCommentBefore(_ location: SourceLocation) -> RawCodeComment? {
        guard location.isValid else { return nil }

        for (i, comment) in allComments.enumerated().reversed() where comment.location < location {
            allComments.remove(at: i)
            return comment
        }
        
        return nil
    }
    
    /// Pops all comments that precede a given source code location.
    public func popAllCommentsBefore(_ location: SourceLocation) -> [RawCodeComment] {
        guard location.isValid else { return [] }

        var comments: [RawCodeComment] = []
        while let comment = popClosestCommentBefore(location) {
            comments.append(comment)
        }
        
        return comments.reversed()
    }

    /// Pops all comments lay inline with a given source code location.
    public func popCommentsInlineWith(_ location: SourceLocation) -> [RawCodeComment] {
        guard location.isValid else { return [] }

        var comments: [RawCodeComment] = []
        for (i, comment) in allComments.enumerated().reversed() where comment.location.line == location.line {
            allComments.remove(at: i)
            comments.append(comment)
        }
        
        return comments.reversed()
    }
    
    /// Pops all comments whose start/end locations overlap a given source code
    /// location.
    public func popCommentsOverlapping(start: SourceLocation, end: SourceLocation) -> [RawCodeComment] {
        guard start.isValid && end.isValid else { return [] }
        let range = SourceRange(forStart: start, end: end)

        let test: (RawCodeComment) -> Bool = {
            range.overlaps($0.sourceRange)
        }
        
        defer {
            allComments.removeAll(where: test)
        }
        
        return allComments.filter(test)
    }

    /// Pops all comments whose start/end locations overlap a given source code
    /// range.
    public func popCommentsOverlapping(_ range: SourceRange) -> [RawCodeComment] {
        guard let start = range.start, let end = range.end else {
            return []
        }

        return popCommentsOverlapping(start: start, end: end)
    }
    

    /// Pops the closest comment that trails a given source location's exact line
    /// number.
    public func popClosestCommentAtTrailingLine(_ location: SourceLocation) -> RawCodeComment? {
        for (i, comment) in allComments.enumerated() {
            if comment.location.line == location.line && comment.location.column > location.column {
                allComments.remove(at: i)
                return comment
            }
        }
        
        return nil
    }

    // MARK: - Parser rule inputs

    /// Pops the closest comment preceding a given source code location.
    ///
    /// Returns `nil` if no comment was found preceding `rule`.
    public func popClosestCommentBefore(rule: ParserRuleContext) -> RawCodeComment? {
        guard let start = rule.getStart() else {
            return nil
        }
        
        let location = start.sourceLocation()
        
        return popClosestCommentBefore(location)
    }
    
    /// Pops all comments that precede a given parser rule in the source code.
    public func popAllCommentsBefore(rule: ParserRuleContext) -> [RawCodeComment] {
        var comments: [RawCodeComment] = []
        while let comment = popClosestCommentBefore(rule: rule) {
            comments.append(comment)
        }
        
        return comments.reversed()
    }

    /// Pops all comments lay inline with a given parser rule context.
    public func popCommentsInlineWith(rule: ParserRuleContext) -> [RawCodeComment] {
        guard let start = rule.getStart() else {
            return []
        }
        
        let location = start.sourceLocation()
        
        return popCommentsInlineWith(location)
    }
    
    /// Pops all comments that overlap a given parser rule context.
    public func popCommentsOverlapping(rule: ParserRuleContext) -> [RawCodeComment] {
        guard let startToken = rule.getStart(), let stopToken = rule.getStop() else {
            return []
        }
        
        let start = startToken.sourceLocation()
        let end = stopToken.sourceLocation()
        
        return popCommentsOverlapping(start: start, end: end)
    }
    
    /// Pops the closest comment that trails a given parser rule's exact line
    /// number.
    public func popClosestCommentAtTrailingLine(rule: ParserRuleContext) -> RawCodeComment? {
        guard let location = rule.getStop()?.sourceLocation() else {
            return nil
        }

        return popClosestCommentAtTrailingLine(location)
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
