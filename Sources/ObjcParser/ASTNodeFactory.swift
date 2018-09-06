import Antlr4
import ObjcParserAntlr
import GrammarModels

class ASTNodeFactory {
    typealias Parser = ObjectiveCParser
    
    let source: Source
    let nonnullContextQuerier: NonnullContextQuerier
    
    init(source: Source, nonnullContextQuerier: NonnullContextQuerier) {
        self.source = source
        self.nonnullContextQuerier = nonnullContextQuerier
    }
    
    func isInNonnullContext(_ context: ParserRuleContext) -> Bool {
        return nonnullContextQuerier.isInNonnullContext(context)
    }
    
    func makeIdentifier(from context: Parser.IdentifierContext) -> Identifier {
        let nonnull = isInNonnullContext(context)
        return Identifier(name: context.getText(), isInNonnullContext: nonnull)
    }
    
    func makeSuperclassName(from context: Parser.SuperclassNameContext) -> SuperclassName {
        let nonnull = isInNonnullContext(context)
        return SuperclassName(name: context.getText(), isInNonnullContext: nonnull)
    }
    
    func makeProtocolReferenceList(from context: Parser.ProtocolListContext) -> ProtocolReferenceList {
        let protocolListNode =
            ProtocolReferenceList(isInNonnullContext: isInNonnullContext(context))
        
        for prot in context.protocolName() {
            guard let identifier = prot.identifier() else {
                continue
            }
            
            let protNameNode =
                ProtocolName(name: identifier.getText(),
                             isInNonnullContext: isInNonnullContext(identifier))
            
            protocolListNode.addChild(protNameNode)
        }
        
        return protocolListNode
    }
    
    func makePointer(from context: ObjectiveCParser.PointerContext) -> PointerNode {
        let node = PointerNode(isInNonnullContext: isInNonnullContext(context))
        if let pointer = context.pointer() {
            node.addChild(makePointer(from: pointer))
        }
        return node
    }
    
    func makeTypeDeclarator(from context: ObjectiveCParser.DeclaratorContext) -> TypeDeclaratorNode {
        let node = TypeDeclaratorNode(isInNonnullContext: isInNonnullContext(context))
        if let identifierNode = context.directDeclarator()?.identifier().map(makeIdentifier) {
            node.addChild(identifierNode)
        }
        if let pointer = context.pointer() {
            node.addChild(makePointer(from: pointer))
        }
        return node
    }
    
    private func sourceLocation(for rule: ParserRuleContext) -> SourceLocation {
        guard let startIndex = rule.start?.getStartIndex(), let endIndex = rule.stop?.getStopIndex() else {
            return .invalid
        }
        
        let sourceStartIndex = source.stringIndex(forCharOffset: startIndex)
        let sourceEndIndex = source.stringIndex(forCharOffset: endIndex)
        
        return SourceLocation(source: source, range: .range(sourceStartIndex..<sourceEndIndex))
    }
    
}
