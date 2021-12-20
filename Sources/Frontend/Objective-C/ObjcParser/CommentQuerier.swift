import Antlr4
import Utils
import GrammarModelBase
import ObjcGrammarModels

class CommentQuerier {
    var allComments: [CodeComment]
    
    init(allComments: [CodeComment]) {
        self.allComments = allComments
    }
    
    func popClosestCommentBefore(node: ParserRuleContext) -> CodeComment? {
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
    
    public func popClosestCommentsBefore(node: ParserRuleContext) -> [CodeComment] {
        var comments: [CodeComment] = []
        while let comment = popClosestCommentBefore(node: node) {
            comments.append(comment)
        }
        
        return comments.reversed()
    }
    
    func popCommentsOverlapping(node: ParserRuleContext) -> [CodeComment] {
        guard let startToken = node.getStart(), let stopToken = node.getStop() else {
            return []
        }
        
        let start = startToken.sourceLocation()
        let end = stopToken.sourceLocation()
        
        let test: (CodeComment) -> Bool = {
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
