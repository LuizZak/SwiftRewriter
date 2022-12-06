import Antlr4
import ObjcParserAntlr
import GrammarModels

public class ASTNodeFactory {
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
    
    public func comments(preceeding context: ParserRuleContext) -> [ObjcComment] {
        commentQuerier.popClosestCommentsBefore(node: context)
    }
    
    public func comments(overlapping context: ParserRuleContext) -> [ObjcComment] {
        commentQuerier.popCommentsOverlapping(node: context)
    }
    
    public func makeIdentifier(from context: Parser.IdentifierContext) -> Identifier {
        let nonnull = isInNonnullContext(context)
        let node = Identifier(name: context.getText(), isInNonnullContext: nonnull)
        updateSourceLocation(for: node, with: context)
        return node
    }
    
    public func makeSuperclassName(from context: Parser.SuperclassNameContext) -> SuperclassName {
        let nonnull = isInNonnullContext(context)
        let node = SuperclassName(name: context.getText(), isInNonnullContext: nonnull)
        updateSourceLocation(for: node, with: context)
        return node
    }
    
    public func makeSuperclassName(
        from context: Parser.GenericSuperclassNameContext,
        identifier: Parser.IdentifierContext
    ) -> SuperclassName {
        
        let nonnull = isInNonnullContext(context)
        let node = SuperclassName(name: identifier.getText(), isInNonnullContext: nonnull)
        updateSourceLocation(for: node, with: context)
        return node
    }
    
    public func makeProtocolReferenceList(from context: Parser.ProtocolListContext) -> ProtocolReferenceList {
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
    
    public func makePointer(from context: ObjectiveCParser.PointerContext) -> PointerNode {
        let node = PointerNode(isInNonnullContext: isInNonnullContext(context))
        updateSourceLocation(for: node, with: context)
        
        for pointerEntry in context.pointerEntry().dropFirst() {
            if pointerEntry.MUL() != nil {
                node.addChild(makePointer(from: context))
            }
        }

        return node
    }
    
    public func makeTypeDeclarator(from context: ObjectiveCParser.DeclaratorContext) -> TypeDeclaratorNode {
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
    
    public func makeNullabilitySpecifier(from rule: Parser.NullabilitySpecifierContext) -> NullabilitySpecifier {
        let spec = NullabilitySpecifier(name: rule.getText(),
                                        isInNonnullContext: isInNonnullContext(rule))
        updateSourceLocation(for: spec, with: rule)
        
        return spec
    }
    
    public func makeMethodBody(from rule: Parser.MethodDefinitionContext) -> MethodBody {
        let methodBody = MethodBody(isInNonnullContext: isInNonnullContext(rule))
        updateSourceLocation(for: methodBody, with: rule)
        methodBody.statements = rule.compoundStatement()
        methodBody.comments = comments(overlapping: rule)
        
        return methodBody
    }
    
    public func makeMethodBody(from rule: Parser.CompoundStatementContext) -> MethodBody {
        
        let nonnull = nonnullContextQuerier.isInNonnullContext(rule)
        
        let body = MethodBody(isInNonnullContext: nonnull)
        body.statements = rule
        updateSourceLocation(for: body, with: rule)
        body.comments = comments(overlapping: rule)
        
        return body
    }
    
    public func makeEnumCase(from rule: Parser.EnumeratorContext, identifier: Parser.IdentifierContext) -> ObjcEnumCase {
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

    public func makeInitialExpression(from rule: Parser.ExpressionContext) -> InitialExpression {
        let nonnull = nonnullContextQuerier.isInNonnullContext(rule)
        
        let node = InitialExpression(isInNonnullContext: nonnull)
        node.addChild(makeConstantExpression(from: rule))

        updateSourceLocation(for: node, with: rule)

        return node
    }

    public func makeConstantExpression(from rule: Parser.ExpressionContext) -> ConstantExpressionNode {
        let nonnull = nonnullContextQuerier.isInNonnullContext(rule)

        let node = ConstantExpressionNode(isInNonnullContext: nonnull)
        node.addChild(makeExpression(from: rule))

        updateSourceLocation(for: node, with: rule)

        return node
    }

    public func makeExpression(from rule: Parser.ExpressionContext) -> ExpressionNode {
        let nonnull = nonnullContextQuerier.isInNonnullContext(rule)

        let node = ExpressionNode(isInNonnullContext: nonnull)
        node.expression = rule

        updateSourceLocation(for: node, with: rule)

        return node
    }
    
    public func updateSourceLocation(for node: ASTNode, with rule: ParserRuleContext) {
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

extension Source {
    /// Returns the source range for a specified parser rule context object.
    func sourceRange(for rule: ParserRuleContext) -> SourceRange {
        guard let startIndex = rule.start?.getStartIndex(), let endIndex = rule.stop?.getStopIndex() else {
            return .invalid
        }

        let sourceStartIndex = stringIndex(forCharOffset: startIndex)
        let sourceEndIndex = stringIndex(forCharOffset: endIndex + 1 /* ANTLR character ranges are inclusive */)

        let startLoc = sourceLocation(atStringIndex: sourceStartIndex)
        let endLoc = sourceLocation(atStringIndex: sourceEndIndex)

        return .range(start: startLoc, end: endLoc)
    }

    /// Returns the source range for a specified terminal node rule context object.
    func sourceRange(for node: TerminalNode) -> SourceRange {
        guard let symbol = node.getSymbol() else {
            return .invalid
        }
        
        let startIndex = symbol.getStartIndex()
        let endIndex = symbol.getStopIndex()

        let sourceStartIndex = stringIndex(forCharOffset: startIndex)
        let sourceEndIndex = stringIndex(forCharOffset: endIndex + 1 /* ANTLR character ranges are inclusive */)

        let startLoc = sourceLocation(atStringIndex: sourceStartIndex)
        let endLoc = sourceLocation(atStringIndex: sourceEndIndex)

        return .range(start: startLoc, end: endLoc)
    }
}
