import Antlr4
import GrammarModels

class CommentQuerier {
    var allComments: [ObjcComment]
    
    init(allComments: [ObjcComment]) {
        self.allComments = allComments
    }
    
    func comments(overlapping node: ParserRuleContext) -> [ObjcComment] {
        guard let startToken = node.getStart(), let stopToken = node.getStop() else {
            return []
        }
        
        let startLine = startToken.getLine()
        let startCol = startToken.getCharPositionInLine() + 1
        let startIndex = startToken.getStartIndex()
        
        let endLine = stopToken.getLine()
        let endCol = stopToken.getCharPositionInLine() + 1
        let endIndex = stopToken.getStartIndex()
        
        let start = SourceLocation(line: startLine,
                                   column: startCol,
                                   utf8Offset: startIndex)
        
        let end = SourceLocation(line: endLine,
                                 column: endCol,
                                 utf8Offset: endIndex)
        
        return allComments.filter {
            $0.location >= start && $0.location <= end
        }
    }
}
