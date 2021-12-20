import Antlr4
import Utils
import ObjcParserAntlr
import ObjcGrammarModels
import GrammarModelBase

class ObjcASTNodeFactory {
    typealias Parser = ObjectiveCParser
    
    let source: Source
    let nonnullContextQuerier: NonnullContextQuerier
    let commentQuerier: CommentQuerier
    
    init(source: Source,
         nonnullContextQuerier: NonnullContextQuerier,
         commentQuerier: CommentQuerier) {
        
        self.source = source
        self.nonnullContextQuerier = nonnullContextQuerier
        self.commentQuerier = commentQuerier
    }
    
    func isInNonnullContext(_ context: ParserRuleContext) -> Bool {
        nonnullContextQuerier.isInNonnullContext(context)
    }
    
    func comments(preceeding context: ParserRuleContext) -> [CodeComment] {
        commentQuerier.popClosestCommentsBefore(node: context)
    }
    
    func comments(overlapping context: ParserRuleContext) -> [CodeComment] {
        commentQuerier.popCommentsOverlapping(node: context)
    }
    
    func makeIdentifier(from context: Parser.IdentifierContext) -> Identifier {
        let nonnull = isInNonnullContext(context)
        let node = Identifier(name: context.getText(), isInNonnullContext: nonnull)
        updateSourceLocation(for: node, with: context)
        return node
    }
    
    func makeSuperclassName(from context: Parser.SuperclassNameContext) -> SuperclassName {
        let nonnull = isInNonnullContext(context)
        let node = SuperclassName(name: context.getText(), isInNonnullContext: nonnull)
        updateSourceLocation(for: node, with: context)
        return node
    }
    
    func makeSuperclassName(from context: Parser.GenericSuperclassNameContext,
                            identifier: Parser.IdentifierContext) -> SuperclassName {
        
        let nonnull = isInNonnullContext(context)
        let node = SuperclassName(name: identifier.getText(), isInNonnullContext: nonnull)
        updateSourceLocation(for: node, with: context)
        return node
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
            updateSourceLocation(for: protocolListNode, with: identifier)
            protocolListNode.addChild(protNameNode)
        }
        
        return protocolListNode
    }
    
    func makePointer(from context: ObjectiveCParser.PointerContext) -> PointerNode {
        let node = PointerNode(isInNonnullContext: isInNonnullContext(context))
        updateSourceLocation(for: node, with: context)
        if let pointer = context.pointer() {
            node.addChild(makePointer(from: pointer))
        }
        return node
    }
    
    func makeTypeDeclarator(from context: ObjectiveCParser.DeclaratorContext) -> TypeDeclaratorNode {
        let node = TypeDeclaratorNode(isInNonnullContext: isInNonnullContext(context))
        updateSourceLocation(for: node, with: context)
        if let identifierNode = context.directDeclarator()?.identifier().map(makeIdentifier) {
            node.addChild(identifierNode)
        }
        if let pointer = context.pointer() {
            node.addChild(makePointer(from: pointer))
        }
        return node
    }
    
    func makeNullabilitySpecifier(from rule: Parser.NullabilitySpecifierContext) -> NullabilitySpecifier {
        let spec = NullabilitySpecifier(name: rule.getText(),
                                        isInNonnullContext: isInNonnullContext(rule))
        updateSourceLocation(for: spec, with: rule)
        
        return spec
    }
    
    func makeMethodBody(from rule: Parser.MethodDefinitionContext) -> MethodBody {
        let methodBody = MethodBody(isInNonnullContext: isInNonnullContext(rule))
        updateSourceLocation(for: methodBody, with: rule)
        methodBody.statements = rule.compoundStatement()
        methodBody.comments = comments(overlapping: rule)
        
        return methodBody
    }
    
    func makeMethodBody(from rule: Parser.CompoundStatementContext) -> MethodBody {
        
        let nonnull = nonnullContextQuerier.isInNonnullContext(rule)
        
        let body = MethodBody(isInNonnullContext: nonnull)
        body.statements = rule
        updateSourceLocation(for: body, with: rule)
        body.comments = comments(overlapping: rule)
        
        return body
    }
    
    func makeEnumCase(from rule: Parser.EnumeratorContext, identifier: Parser.IdentifierContext) -> ObjcEnumCase {
        let nonnull = nonnullContextQuerier.isInNonnullContext(rule)
        
        let enumCase = ObjcEnumCase(isInNonnullContext: nonnull)
        enumCase.precedingComments = comments(preceeding: rule)
        updateSourceLocation(for: enumCase, with: rule)
        
        let identifierNode = makeIdentifier(from: identifier)
        enumCase.addChild(identifierNode)
        
        if let expression = rule.expression() {
            let expressionNode = ExpressionNode(isInNonnullContext: nonnull)
            expressionNode.expression = expression
            updateSourceLocation(for: expressionNode, with: expression)
            enumCase.addChild(expressionNode)
        }
        
        return enumCase
    }
    
    func updateSourceLocation(for node: ObjcASTNode, with rule: ParserRuleContext) {
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
