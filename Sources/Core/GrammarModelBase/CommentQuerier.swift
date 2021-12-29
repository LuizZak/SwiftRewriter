import Antlr4
import Utils

open class CommentQuerier {
    var allComments: [RawCodeComment]
    
    public init(allComments: [RawCodeComment]) {
        self.allComments = allComments
    }
    
    public func popClosestCommentBefore(node: ParserRuleContext) -> RawCodeComment? {
        guard let start = node.getStart() else {
            return nil
        }
        
        let location = start.sourceLocation()
        
        for (i, comment) in allComments.enumerated().reversed() where comment.location < location {
            allComments.remove(at: i)
            return comment
        }
        
        return nil
    }
    
    public func popClosestCommentsBefore(node: ParserRuleContext) -> [RawCodeComment] {
        var comments: [RawCodeComment] = []
        while let comment = popClosestCommentBefore(node: node) {
            comments.append(comment)
        }
        
        return comments.reversed()
    }
    
    public func popCommentsOverlapping(node: ParserRuleContext) -> [RawCodeComment] {
        guard let startToken = node.getStart(), let stopToken = node.getStop() else {
            return []
        }
        
        let start = startToken.sourceLocation()
        let end = stopToken.sourceLocation()
        
        let test: (RawCodeComment) -> Bool = {
            $0.location >= start && $0.location <= end
        }
        
        defer {
            allComments.removeAll(where: test)
        }
        
        return allComments.filter(test)
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
