import Antlr4
import Utils
import GrammarModelBase
import JsParserAntlr
import JsGrammarModels

class JsASTNodeFactory {
    typealias Parser = JavaScriptParser
    
    let source: Source
    
    init(source: Source) {
        self.source = source
    }
    
    func makeIdentifier(from context: Parser.IdentifierContext) -> JsIdentifierNode {
        let node = JsIdentifierNode(name: context.getText())
        updateSourceLocation(for: node, with: context)
        return node
    }
    
    func updateSourceLocation(for node: JsASTNode, with rule: ParserRuleContext) {
        (node.location, node.length) = sourceLocationAndLength(for: rule)
    }
    
    func sourceLocationAndLength(for rule: ParserRuleContext) -> (SourceLocation, SourceLength) {
        guard let startIndex = rule.start?.getStartIndex(), let endIndex = rule.stop?.getStopIndex() else {
            return (.invalid, .zero)
        }
        
        let sourceStartIndex = source.stringIndex(forCharOffset: startIndex)
        let sourceEndIndex = source.stringIndex(forCharOffset: endIndex)
        
        let startLine = source.lineNumber(at: sourceStartIndex)
        let startColumn = source.columnNumber(at: sourceStartIndex)
        let endLine = source.lineNumber(at: sourceEndIndex)
        let endColumn = source.columnNumber(at: sourceEndIndex)
        
        let location =
            SourceLocation(line: startLine,
                            column: startColumn,
                            utf8Offset: startIndex)
        
        let length =
            SourceLength(newlines: endLine - startLine,
                          columnsAtLastLine: endColumn,
                          utf8Length: endIndex - startIndex)
        
        return (location, length)
    }
}
