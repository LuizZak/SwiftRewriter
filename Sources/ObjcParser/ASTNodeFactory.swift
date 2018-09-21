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
        let node = Identifier(name: context.getText(), isInNonnullContext: nonnull)
        node.location = sourceLocation(for: context)
        return node
    }
    
    func makeSuperclassName(from context: Parser.SuperclassNameContext) -> SuperclassName {
        let nonnull = isInNonnullContext(context)
        let node = SuperclassName(name: context.getText(), isInNonnullContext: nonnull)
        node.location = sourceLocation(for: context)
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
            protocolListNode.location = sourceLocation(for: identifier)
            protocolListNode.addChild(protNameNode)
        }
        
        return protocolListNode
    }
    
    func makePointer(from context: ObjectiveCParser.PointerContext) -> PointerNode {
        let node = PointerNode(isInNonnullContext: isInNonnullContext(context))
        node.location = sourceLocation(for: context)
        if let pointer = context.pointer() {
            node.addChild(makePointer(from: pointer))
        }
        return node
    }
    
    func makeTypeDeclarator(from context: ObjectiveCParser.DeclaratorContext) -> TypeDeclaratorNode {
        let node = TypeDeclaratorNode(isInNonnullContext: isInNonnullContext(context))
        node.location = sourceLocation(for: context)
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
        spec.location = sourceLocation(for: rule)
        
        return spec
    }
    
    func makeMethodBody(from rule: Parser.MethodDefinitionContext) -> MethodBody {
        let methodBody = MethodBody(isInNonnullContext: isInNonnullContext(rule))
        methodBody.location = sourceLocation(for: rule)
        methodBody.statements = rule.compoundStatement()
        
        return methodBody
    }
    
    func makeMethodBody(from rule: Parser.CompoundStatementContext) -> MethodBody {
        
        let nonnull = nonnullContextQuerier.isInNonnullContext(rule)
        
        let body = MethodBody(isInNonnullContext: nonnull)
        body.statements = rule
        body.location = sourceLocation(for: rule)
        
        return body
    }
    
    func makeEnumCase(from rule: Parser.EnumeratorContext, identifier: Parser.IdentifierContext) -> ObjcEnumCase {
        let nonnull = nonnullContextQuerier.isInNonnullContext(rule)
        
        let enumCase = ObjcEnumCase(isInNonnullContext: nonnull)
        enumCase.location = sourceLocation(for: rule)
        
        let identifierNode = makeIdentifier(from: identifier)
        enumCase.addChild(identifierNode)
        
        if let expression = rule.expression() {
            let expressionNode = ExpressionNode(isInNonnullContext: nonnull)
            expressionNode.expression = expression
            expressionNode.location = sourceLocation(for: expression)
            enumCase.addChild(expressionNode)
        }
        
        return enumCase
    }
    
    func sourceLocation(for rule: ParserRuleContext) -> SourceLocation {
        guard let startIndex = rule.start?.getStartIndex(), let endIndex = rule.stop?.getStopIndex() else {
            return .invalid
        }
        
        let sourceStartIndex = source.stringIndex(forCharOffset: startIndex)
        let sourceEndIndex = source.stringIndex(forCharOffset: endIndex)
        
        return SourceLocation(source: source, range: .range(sourceStartIndex..<sourceEndIndex))
    }
    
}
