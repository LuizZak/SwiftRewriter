import Antlr4
import Utils
import ObjcParserAntlr
import ObjcGrammarModels
import GrammarModelBase

public class ObjcASTNodeFactory {
    public typealias Parser = ObjectiveCParser
    
    let source: Source
    let nonnullContextQuerier: NonnullContextQuerier
    let commentQuerier: CommentQuerier
    
    public init(
        source: Source,
        nonnullContextQuerier: NonnullContextQuerier,
        commentQuerier: CommentQuerier
    ) {
        
        self.source = source
        self.nonnullContextQuerier = nonnullContextQuerier
        self.commentQuerier = commentQuerier
    }

    public func isInNonnullContext(_ context: ParserRuleContext) -> Bool {
        nonnullContextQuerier.isInNonnullContext(context)
    }

    public func isInNonnullContext(_ location: SourceLocation) -> Bool {
        nonnullContextQuerier.isInNonnullContext(location)
    }

    public func isInNonnullContext(_ range: SourceRange) -> Bool {
        nonnullContextQuerier.isInNonnullContext(range)
    }
    
    public func popComments(preceding context: ParserRuleContext) -> [RawCodeComment] {
        commentQuerier.popAllCommentsBefore(rule: context)
    }
    
    public func popComments(overlapping context: ParserRuleContext) -> [RawCodeComment] {
        commentQuerier.popCommentsOverlapping(rule: context)
    }
    
    public func popComments(inLineWith context: ParserRuleContext) -> [RawCodeComment] {
        commentQuerier.popCommentsInlineWith(rule: context)
    }
    
    public func makeIdentifier(from context: Parser.IdentifierContext) -> ObjcIdentifierNode {
        let nonnull = isInNonnullContext(context)
        let node = ObjcIdentifierNode(name: context.getText(), isInNonnullContext: nonnull)
        updateSourceLocation(for: node, with: context)
        return node
    }
    
    public func makeSuperclassName(from context: Parser.SuperclassNameContext) -> ObjcSuperclassNameNode {
        let nonnull = isInNonnullContext(context)
        let node = ObjcSuperclassNameNode(name: context.getText(), isInNonnullContext: nonnull)
        updateSourceLocation(for: node, with: context)
        return node
    }
    
    public func makeSuperclassName(
        from context: Parser.GenericSuperclassNameContext,
        identifier: Parser.IdentifierContext
    ) -> ObjcSuperclassNameNode {
        
        let nonnull = isInNonnullContext(context)
        let node = ObjcSuperclassNameNode(name: identifier.getText(), isInNonnullContext: nonnull)
        updateSourceLocation(for: node, with: context)
        return node
    }
    
    public func makeProtocolReferenceList(from context: Parser.ProtocolListContext) -> ObjcProtocolReferenceListNode {
        let protocolListNode =
            ObjcProtocolReferenceListNode(isInNonnullContext: isInNonnullContext(context))
        
        for prot in context.protocolName() {
            guard let identifier = prot.identifier() else {
                continue
            }
            
            let protNameNode =
                ObjcProtocolNameNode(name: identifier.getText(),
                             isInNonnullContext: isInNonnullContext(identifier))
            updateSourceLocation(for: protocolListNode, with: identifier)
            protocolListNode.addChild(protNameNode)
        }
        
        return protocolListNode
    }
    
    public func makePointer(from context: ObjectiveCParser.PointerContext) -> ObjcPointerNode {
        let node = ObjcPointerNode(isInNonnullContext: isInNonnullContext(context))
        updateSourceLocation(for: node, with: context)
        
        for pointerEntry in context.pointerEntry().dropFirst() {
            if pointerEntry.MUL() != nil {
                node.addChild(makePointer(from: context))
            }
        }

        return node
    }
    
    public func makeTypeDeclarator(from context: ObjectiveCParser.DeclaratorContext) -> ObjcTypeDeclaratorNode {
        let node = ObjcTypeDeclaratorNode(isInNonnullContext: isInNonnullContext(context))
        updateSourceLocation(for: node, with: context)
        if let identifierNode = context.directDeclarator()?.identifier().map(makeIdentifier) {
            node.addChild(identifierNode)
        }
        if let pointer = context.pointer() {
            node.addChild(makePointer(from: pointer))
        }
        return node
    }
    
    public func makeNullabilitySpecifier(from rule: Parser.NullabilitySpecifierContext) -> ObjcNullabilitySpecifierNode {
        let spec = ObjcNullabilitySpecifierNode(
            name: rule.getText(),
            isInNonnullContext: isInNonnullContext(rule)
        )
        updateSourceLocation(for: spec, with: rule)
        
        return spec
    }
    
    public func makeMethodBody(from rule: Parser.MethodDefinitionContext) -> ObjcMethodBodyNode {
        let methodBody = ObjcMethodBodyNode(isInNonnullContext: isInNonnullContext(rule))
        updateSourceLocation(for: methodBody, with: rule)
        methodBody.statements = rule.compoundStatement()
        methodBody.comments = popComments(overlapping: rule)
        
        return methodBody
    }
    
    public func makeMethodBody(from rule: Parser.CompoundStatementContext) -> ObjcMethodBodyNode {
        
        let nonnull = nonnullContextQuerier.isInNonnullContext(rule)
        
        let body = ObjcMethodBodyNode(isInNonnullContext: nonnull)
        body.statements = rule
        updateSourceLocation(for: body, with: rule)
        body.comments = popComments(overlapping: rule)
        
        return body
    }
    
    public func makeEnumCase(from rule: Parser.EnumeratorContext, identifier: Parser.IdentifierContext) -> ObjcEnumCaseNode {
        let nonnull = nonnullContextQuerier.isInNonnullContext(rule)
        
        let enumCase = ObjcEnumCaseNode(isInNonnullContext: nonnull)
        enumCase.precedingComments = popComments(preceding: rule)
        updateSourceLocation(for: enumCase, with: rule)
        
        let identifierNode = makeIdentifier(from: identifier)
        enumCase.addChild(identifierNode)
        
        if let expression = rule.expression() {
            enumCase.addChild(makeExpression(from: expression))
        }
        
        return enumCase
    }

    public func makeInitialExpression(from rule: Parser.ExpressionContext) -> ObjcInitialExpressionNode {
        let nonnull = nonnullContextQuerier.isInNonnullContext(rule)
        
        let node = ObjcInitialExpressionNode(isInNonnullContext: nonnull)
        node.addChild(makeExpression(from: rule))

        updateSourceLocation(for: node, with: rule)

        return node
    }

    public func makeConstantExpression(from rule: Parser.ConstantExpressionContext) -> ObjcConstantExpressionNode {
        let nonnull = nonnullContextQuerier.isInNonnullContext(rule)

        let node = ObjcConstantExpressionNode(isInNonnullContext: nonnull)
        node.expression = .antlr(rule)

        updateSourceLocation(for: node, with: rule)

        return node
    }

    public func makeExpression(from rule: Parser.ExpressionContext) -> ObjcExpressionNode {
        let nonnull = nonnullContextQuerier.isInNonnullContext(rule)

        let node = ObjcExpressionNode(isInNonnullContext: nonnull)
        node.expression = .antlr(rule)

        updateSourceLocation(for: node, with: rule)

        return node
    }
    
    public func updateSourceLocation(for node: ObjcASTNode, with rule: ParserRuleContext) {
        (node.location, node.length) = sourceLocationAndLength(for: rule)
    }
    
    /// Returns the source location and length for a specified parser rule context
    /// object.
    func sourceLocationAndLength(for rule: ParserRuleContext) -> (SourceLocation, SourceLength) {
        guard let startIndex = rule.start?.getStartIndex(), let endIndex = rule.stop?.getStopIndex() else {
            return (.invalid, .zero)
        }
        
        let sourceStartIndex = source.stringIndex(forCharOffset: startIndex)
        let sourceEndIndex = source.stringIndex(forCharOffset: endIndex + 1 /* ANTLR character ranges are inclusive */)
        
        let startLine = source.lineNumber(at: sourceStartIndex)
        let startColumn = source.columnNumber(at: sourceStartIndex)
        let endLine = source.lineNumber(at: sourceEndIndex)
        let endColumn = source.columnNumber(at: sourceEndIndex)
        
        let location = SourceLocation(
            line: startLine,
            column: startColumn,
            utf8Offset: startIndex
        )
        
        let length = SourceLength(
            newlines: endLine - startLine,
            columnsAtLastLine: endColumn,
            utf8Length: endIndex - startIndex
        )
        
        return (location, length)
    }
    
    /// Returns the source range for a specified parser rule context object.
    func sourceRange(for rule: ParserRuleContext) -> SourceRange {
        source.sourceRange(for: rule)
    }
}
