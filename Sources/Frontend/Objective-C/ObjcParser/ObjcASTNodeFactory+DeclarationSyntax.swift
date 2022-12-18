import Utils
import ObjcGrammarModels
import GrammarModelBase

extension ObjcASTNodeFactory {
    public func isInNonnullContext(_ syntax: DeclarationSyntaxElementType) -> Bool {
        guard let start = syntax.sourceRange.start else {
            return false
        }

        return nonnullContextQuerier.isInNonnullContext(start)
    }
    
    public func makeIdentifier(from syntax: IdentifierSyntax) -> ObjcIdentifierNode {
        let nonnull = isInNonnullContext(syntax)
        let node = ObjcIdentifierNode(name: syntax.identifier, isInNonnullContext: nonnull)
        updateSourceLocation(for: node, with: syntax)
        return node
    }
    
    public func makeProtocolReferenceList(from syntax: ProtocolReferenceListSyntax) -> ObjcProtocolReferenceListNode {
        let protocolListNode = ObjcProtocolReferenceListNode(
            isInNonnullContext: isInNonnullContext(syntax)
        )
        
        for prot in syntax.protocols {
            let protNameNode = makeProtocolName(from: prot)
            protocolListNode.addChild(protNameNode)
        }
        
        return protocolListNode
    }

    public func makeProtocolName(from syntax: ProtocolNameSyntax) -> ObjcProtocolNameNode {
        let protNameNode = ObjcProtocolNameNode(
            name: syntax.identifier.identifier,
            isInNonnullContext: isInNonnullContext(syntax)
        )
        updateSourceLocation(for: protNameNode, with: syntax)

        return protNameNode
    }
    
    public func makePointer(from syntax: PointerSyntax) -> ObjcPointerNode {
        let node = ObjcPointerNode(isInNonnullContext: isInNonnullContext(syntax))
        updateSourceLocation(for: node, with: syntax)
        
        var last = node
        for pointerEntry in syntax.pointerEntries.dropFirst() {
            let new: ObjcPointerNode
            defer { last = new }

            new = ObjcPointerNode(isInNonnullContext: isInNonnullContext(pointerEntry))
            last.addChild(new)
            updateSourceLocation(for: new, with: pointerEntry)
        }

        return node
    }
    
    public func makeTypeDeclarator(from syntax: DeclaratorSyntax) -> ObjcTypeDeclaratorNode {
        let node = ObjcTypeDeclaratorNode(isInNonnullContext: isInNonnullContext(syntax))
        updateSourceLocation(for: node, with: syntax)
        node.addChild(
            makeIdentifier(from: syntax.directDeclarator.identifier)
        )
        if let pointer = syntax.pointer {
            node.addChild(makePointer(from: pointer))
        }
        return node
    }
    
    public func makeNullabilitySpecifier(from syntax: NullabilitySpecifierSyntax) -> ObjcNullabilitySpecifierNode {
        let spec = ObjcNullabilitySpecifierNode(
            name: syntax.description,
            isInNonnullContext: isInNonnullContext(syntax)
        )
        updateSourceLocation(for: spec, with: syntax)
        
        return spec
    }
    
    public func makeEnumCase(
        from syntax: EnumeratorSyntax,
        identifier: Parser.IdentifierContext
    ) -> ObjcEnumCaseNode {

        let nonnull = isInNonnullContext(syntax)
        
        let enumCase = ObjcEnumCaseNode(isInNonnullContext: nonnull)

        updateSourceLocation(for: enumCase, with: syntax)
        
        let identifierNode = makeIdentifier(from: identifier)
        enumCase.addChild(identifierNode)
        
        if let expression = syntax.expression {
            enumCase.addChild(makeExpression(from: expression))
        }
        
        return enumCase
    }

    public func makeInitialExpression(from syntax: ExpressionSyntax) -> ObjcInitialExpressionNode {
        let nonnull = isInNonnullContext(syntax)
        
        let node = ObjcInitialExpressionNode(isInNonnullContext: nonnull)
        node.addChild(makeExpression(from: syntax))

        updateSourceLocation(for: node, with: syntax)

        return node
    }

    public func makeConstantExpression(from syntax: ConstantExpressionSyntax) -> ObjcConstantExpressionNode {
        let nonnull = isInNonnullContext(syntax)

        let node = ObjcConstantExpressionNode(isInNonnullContext: nonnull)
        node.expression = .string(syntax.constantExpressionString)

        updateSourceLocation(for: node, with: syntax)

        return node
    }

    public func makeExpression(from syntax: ExpressionSyntax) -> ObjcExpressionNode {
        let nonnull = isInNonnullContext(syntax)

        let node = ObjcExpressionNode(isInNonnullContext: nonnull)
        node.expression = .string(syntax.expressionString)

        updateSourceLocation(for: node, with: syntax)

        return node
    }
    
    public func updateSourceLocation(for node: ObjcASTNode, with syntax: DeclarationSyntaxElementType) {
        (node.location, node.length) = sourceLocationAndLength(for: syntax)
    }

    public func updateSourceLocation(for node: ObjcASTNode, with range: SourceRange) {
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
