import GrammarModels

extension ASTNodeFactory {
    public func isInNonnullContext(_ syntax: DeclarationSyntaxElementType) -> Bool {
        guard let start = syntax.sourceRange.start else {
            return false
        }

        return nonnullContextQuerier.isInNonnullContext(start)
    }
    
    public func popComments(preceding syntax: DeclarationSyntaxElementType) -> [ObjcComment] {
        guard let start = syntax.sourceRange.start else {
            return []
        }

        return commentQuerier.popAllCommentsBefore(start)
    }
    
    public func popComments(overlapping syntax: DeclarationSyntaxElementType) -> [ObjcComment] {
        commentQuerier.popCommentsOverlapping(syntax.sourceRange)
    }
    
    public func popComments(inLineWith syntax: DeclarationSyntaxElementType) -> [ObjcComment] {
        commentQuerier.popCommentsInlineWith(syntax.sourceRange.start ?? .invalid)
    }
    
    public func makeIdentifier(from syntax: IdentifierSyntax) -> Identifier {
        let nonnull = isInNonnullContext(syntax)
        let node = Identifier(name: syntax.identifier, isInNonnullContext: nonnull)
        updateSourceLocation(for: node, with: syntax)
        return node
    }
    
    public func makeProtocolReferenceList(from syntax: ProtocolReferenceListSyntax) -> ProtocolReferenceList {
        let protocolListNode =
            ProtocolReferenceList(isInNonnullContext: isInNonnullContext(syntax))
        
        for prot in syntax.protocols {
            let identifier = prot.identifier
            
            let protNameNode = ProtocolName(
                name: identifier.identifier,
                isInNonnullContext: isInNonnullContext(identifier)
            )
            updateSourceLocation(for: protocolListNode, with: identifier)
            protocolListNode.addChild(protNameNode)
        }
        
        return protocolListNode
    }
    
    public func makePointer(from syntax: PointerSyntax) -> PointerNode {
        let node = PointerNode(isInNonnullContext: isInNonnullContext(syntax))
        updateSourceLocation(for: node, with: syntax)
        
        var last = node
        for pointerEntry in syntax.pointerEntries.dropFirst() {
            let new: PointerNode
            defer { last = new }

            new = PointerNode(isInNonnullContext: isInNonnullContext(pointerEntry))
            last.addChild(new)
            updateSourceLocation(for: new, with: pointerEntry)
        }

        return node
    }
    
    public func makeTypeDeclarator(from syntax: DeclaratorSyntax) -> TypeDeclaratorNode {
        let node = TypeDeclaratorNode(isInNonnullContext: isInNonnullContext(syntax))
        updateSourceLocation(for: node, with: syntax)
        node.addChild(
            makeIdentifier(from: syntax.directDeclarator.identifier)
        )
        if let pointer = syntax.pointer {
            node.addChild(makePointer(from: pointer))
        }
        return node
    }
    
    public func makeNullabilitySpecifier(from syntax: NullabilitySpecifierSyntax) -> NullabilitySpecifier {
        let spec = NullabilitySpecifier(
            name: syntax.description,
            isInNonnullContext: isInNonnullContext(syntax)
        )
        updateSourceLocation(for: spec, with: syntax)
        
        return spec
    }
    
    public func makeEnumCase(
        from syntax: EnumeratorSyntax,
        identifier: Parser.IdentifierContext
    ) -> ObjcEnumCase {

        let nonnull = isInNonnullContext(syntax)
        
        let enumCase = ObjcEnumCase(isInNonnullContext: nonnull)
        enumCase.precedingComments = popComments(preceding: syntax)
        updateSourceLocation(for: enumCase, with: syntax)
        
        let identifierNode = makeIdentifier(from: identifier)
        enumCase.addChild(identifierNode)
        
        if let expression = syntax.expression {
            enumCase.addChild(makeExpression(from: expression))
        }
        
        return enumCase
    }

    public func makeInitialExpression(from syntax: ExpressionSyntax) -> InitialExpression {
        let nonnull = isInNonnullContext(syntax)
        
        let node = InitialExpression(isInNonnullContext: nonnull)
        node.addChild(makeExpression(from: syntax))

        updateSourceLocation(for: node, with: syntax)

        return node
    }

    public func makeConstantExpression(from syntax: ConstantExpressionSyntax) -> ConstantExpressionNode {
        let nonnull = isInNonnullContext(syntax)

        let node = ConstantExpressionNode(isInNonnullContext: nonnull)
        node.expression = .string(syntax.constantExpressionString)

        updateSourceLocation(for: node, with: syntax)

        return node
    }

    public func makeExpression(from syntax: ExpressionSyntax) -> ExpressionNode {
        let nonnull = isInNonnullContext(syntax)

        let node = ExpressionNode(isInNonnullContext: nonnull)
        node.expression = .string(syntax.expressionString)

        updateSourceLocation(for: node, with: syntax)

        return node
    }
    
    public func updateSourceLocation(for node: ASTNode, with syntax: DeclarationSyntaxElementType) {
        (node.location, node.length) = sourceLocationAndLength(for: syntax)
    }

    public func updateSourceLocation(for node: ASTNode, with range: SourceRange) {
        switch range {
        case .location(let loc):
            node.location = loc
            node.length = .zero

        case .range(let start, let end):
            node.location = start
            node.length = start.length(to: end)
        
        case .invalid:
            node.location = .invalid
            node.length = .zero
        }
    }
    
    /// Returns the source location and length for a specified parser rule syntax
    /// object.
    func sourceLocationAndLength(for syntax: DeclarationSyntaxElementType) -> (SourceLocation, SourceLength) {
        guard let start = syntax.sourceRange.start, let length = syntax.sourceRange.length else {
            return (.invalid, .zero)
        }

        return (start, length)
    }
}
