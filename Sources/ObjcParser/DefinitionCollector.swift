import Antlr4
import ObjcParserAntlr
import GrammarModels

/// Protocol for delegates of elements collected by a `DefinitionCollector` as
/// it collects definitions, prior to adding them to the final declarations list.
public protocol DefinitionCollectorDelegate: AnyObject {
    /// Invoked to notify that a variable declaration was detected after
    /// transforming it from an underlying `DeclarationTranslator.ASTNodeDeclaration`
    /// value.
    func definitionCollector(
        _ collector: DefinitionCollector,
        didDetectVariable variable: VariableDeclaration,
        from declaration: DeclarationTranslator.ASTNodeDeclaration
    )
    
    /// Invoked to notify that a function definition was detected after
    /// transforming it from an underlying `DeclarationTranslator.ASTNodeDeclaration`
    /// value.
    func definitionCollector(
        _ collector: DefinitionCollector,
        didDetectFunction function: FunctionDefinition,
        from declaration: DeclarationTranslator.ASTNodeDeclaration
    )
    
    /// Invoked to notify that a typedef was detected after transforming it from
    /// an underlying `DeclarationTranslator.ASTNodeDeclaration` value.
    func definitionCollector(
        _ collector: DefinitionCollector,
        didDetectTypedef typedefNode: TypedefNode,
        from declaration: DeclarationTranslator.ASTNodeDeclaration
    )
    
    /// Invoked to notify that a struct was detected after transforming it from
    /// an underlying `DeclarationTranslator.ASTNodeDeclaration` value.
    func definitionCollector(
        _ collector: DefinitionCollector,
        didDetectStruct structDecl: ObjcStructDeclaration,
        from declaration: DeclarationTranslator.ASTNodeDeclaration
    )
    
    /// Invoked to notify that an enum was detected after transforming it from
    /// an underlying `DeclarationTranslator.ASTNodeDeclaration` value.
    func definitionCollector(
        _ collector: DefinitionCollector,
        didDetectEnum enumDecl: ObjcEnumDeclaration,
        from declaration: DeclarationTranslator.ASTNodeDeclaration
    )
}

public extension DefinitionCollectorDelegate {
    func definitionCollector(
        _ collector: DefinitionCollector,
        didDetectVariable variable: VariableDeclaration,
        from declaration: DeclarationTranslator.ASTNodeDeclaration
    ) { }
    
    func definitionCollector(
        _ collector: DefinitionCollector,
        didDetectFunction function: FunctionDefinition,
        from declaration: DeclarationTranslator.ASTNodeDeclaration
    ) { }
    
    func definitionCollector(
        _ collector: DefinitionCollector,
        didDetectTypedef typedefNode: TypedefNode,
        from declaration: DeclarationTranslator.ASTNodeDeclaration
    ) { }
    
    func definitionCollector(
        _ collector: DefinitionCollector,
        didDetectStruct structDecl: ObjcStructDeclaration,
        from declaration: DeclarationTranslator.ASTNodeDeclaration
    ) { }
    
    func definitionCollector(
        _ collector: DefinitionCollector,
        didDetectEnum enumDecl: ObjcEnumDeclaration,
        from declaration: DeclarationTranslator.ASTNodeDeclaration
    ) { }
}

/// Collects definitions from a `DeclarationContext` parser rule and converts them
/// into `ASTNode` declarations.
public class DefinitionCollector {
    var declarations: [ASTNode] = []
    var nonnullContextQuerier: NonnullContextQuerier
    var commentQuerier: CommentQuerier
    var nodeFactory: ASTNodeFactory

    public weak var delegate: DefinitionCollectorDelegate?
    
    public init(
        nonnullContextQuerier: NonnullContextQuerier,
        commentQuerier: CommentQuerier,
        nodeFactory: ASTNodeFactory
    ) {
        self.nonnullContextQuerier = nonnullContextQuerier
        self.commentQuerier = commentQuerier
        self.nodeFactory = nodeFactory
    }

    public func collect(from ctx: ObjectiveCParser.DeclarationContext) -> [ASTNode]? {
        var declarations: [ASTNode] = []

        let extractor = DeclarationExtractor()
        let translator = DeclarationTranslator()

        let decls = extractor.extract(from: ctx)
        let nodeDecls = translator.translate(decls, context: .init(nodeFactory: nodeFactory))

        for nodeDecl in nodeDecls {
            if let nodes = processDeclaration(nodeDecl) {
                declarations.append(contentsOf: nodes)
            }
        }
        
        return declarations
    }

    private func processVariable(
        _ decl: DeclarationTranslator.ASTNodeDeclaration,
        rule: ParserRuleContext,
        identifier: Identifier,
        type: ObjcType?,
        nullability: DeclarationTranslator.Nullability?,
        initialValue: ObjectiveCParser.InitializerContext?,
        notifyDelegate: Bool
    ) -> [ASTNode]? {

        guard let type = type else {
            return nil
        }

        let typeNode = TypeNameNode(type: type, isInNonnullContext: identifier.isInNonnullContext)

        return processVariable(
            decl,
            rule: rule,
            identifier: identifier,
            typeNode: typeNode,
            nullability: nullability,
            initialValue: initialValue,
            notifyDelegate: notifyDelegate
        )
    }

    private func processVariable(
        _ decl: DeclarationTranslator.ASTNodeDeclaration,
        rule: ParserRuleContext,
        identifier: Identifier,
        typeNode: TypeNameNode,
        nullability: DeclarationTranslator.Nullability?,
        initialValue: ObjectiveCParser.InitializerContext?,
        notifyDelegate: Bool
    ) -> [ASTNode]? {

        let node = VariableDeclaration(isInNonnullContext: identifier.isInNonnullContext)

        node.addChild(identifier)
        node.addChild(typeNode)

        if let expression = initialValue?.expression() {
            node.addChild(
                nodeFactory.makeInitialExpression(from: expression)
            )
        }

        node.updateSourceRange()

        collectComments(node, rule)

        if notifyDelegate {
            delegate?.definitionCollector(
                self,
                didDetectVariable: node,
                from: decl
            )
        }

        return [node]
    }

    private func processFunction(
        _ decl: DeclarationTranslator.ASTNodeDeclaration,
        rule: ParserRuleContext,
        identifier: Identifier,
        parameters: [FunctionParameter],
        returnType: TypeNameNode?,
        notifyDelegate: Bool
    ) -> [ASTNode]? {

        let node = FunctionDefinition(isInNonnullContext: identifier.isInNonnullContext)

        collectComments(node, rule)

        if notifyDelegate {
            delegate?.definitionCollector(
                self,
                didDetectFunction: node,
                from: decl
            )
        }

        return [node]
    }

    private func processStructOrUnionDecl(
        _ decl: DeclarationTranslator.ASTNodeDeclaration,
        rule: ParserRuleContext,
        identifier: Identifier?,
        structDecl: DeclarationExtractor.StructOrUnionSpecifier,
        fields: [ObjcStructField],
        notifyDelegate: Bool
    ) -> [ASTNode]? {

        let nonnull = nonnullContextQuerier.isInNonnullContext(rule)

        let node = ObjcStructDeclaration(isInNonnullContext: nonnull)
        if let identifier = identifier {
            node.addChild(identifier)
        }

        let bodyNode = ObjcStructDeclarationBody(isInNonnullContext: nonnull)
        bodyNode.addChildren(fields)
        node.addChild(bodyNode)

        node.updateSourceRange()
        collectComments(node, rule)


        if notifyDelegate {
            delegate?.definitionCollector(
                self,
                didDetectStruct: node,
                from: decl
            )
        }

        return [node]
    }

    private func processEnumDecl(
        _ decl: DeclarationTranslator.ASTNodeDeclaration,
        rule: ParserRuleContext,
        identifier: Identifier?,
        typeName: TypeNameNode?,
        enumDecl: DeclarationExtractor.EnumSpecifier,
        enumerators: [ObjcEnumCase],
        notifyDelegate: Bool
    ) -> [ASTNode]? {

        let nonnull = nonnullContextQuerier.isInNonnullContext(rule)

        let node = ObjcEnumDeclaration(isInNonnullContext: nonnull)
        if let identifier = identifier {
            node.addChild(identifier)
        }
        if let typeName = typeName {
            node.addChild(typeName)
        }

        node.addChildren(enumerators)

        node.updateSourceRange()
        collectComments(node, rule)

        
        if notifyDelegate {
            delegate?.definitionCollector(
                self,
                didDetectEnum: node,
                from: decl
            )
        }

        return [node]
    }

    private func processTypeAlias(
        _ decl: DeclarationTranslator.ASTNodeDeclaration,
        rule: ParserRuleContext,
        baseDecl: DeclarationTranslator.ASTNodeDeclaration,
        typeNode: TypeNameNode,
        alias: Identifier,
        notifyDelegate: Bool
    ) -> [ASTNode]? {

        let nonnull = nonnullContextQuerier.isInNonnullContext(rule)

        let node = TypedefNode(isInNonnullContext: nonnull)
        node.addChild(alias)
        node.addChild(typeNode)

        if let baseNodes = processDeclaration(baseDecl, notifyDelegate: false) {
            node.addChildren(baseNodes)
        }

        node.updateSourceRange()
        collectComments(node, rule)

        if notifyDelegate {
            delegate?.definitionCollector(
                self,
                didDetectTypedef: node,
                from: decl
            )
        }

        return [node]
    }

    private func processDeclaration(
        _ decl: DeclarationTranslator.ASTNodeDeclaration?,
        notifyDelegate: Bool = true
    ) -> [ASTNode]? {

        guard let decl = decl else {
            return nil
        }

        switch decl {
        case .variable(let rule, let nullability, let identifier, let type, let initialValue):
            return processVariable(
                decl,
                rule: rule,
                identifier: identifier,
                typeNode: type,
                nullability: nullability,
                initialValue: initialValue,
                notifyDelegate: notifyDelegate
            )
            
        case .block(let rule, let nullability, let identifier, _, _, let initialValue):
            return processVariable(
                decl,
                rule: rule,
                identifier: identifier,
                type: decl.objcType,
                nullability: nullability,
                initialValue: initialValue,
                notifyDelegate: notifyDelegate
            )
            
        case .functionPointer(let rule, let nullability, let identifier, _, _, let initialValue):
            return processVariable(
                decl,
                rule: rule,
                identifier: identifier,
                type: decl.objcType,
                nullability: nullability,
                initialValue: initialValue,
                notifyDelegate: notifyDelegate
            )

        case .enumDecl(let rule, let identifier, let typeName, let enumDecl, let enumerators):
            return processEnumDecl(
                decl,
                rule: rule,
                identifier: identifier,
                typeName: typeName,
                enumDecl: enumDecl,
                enumerators: enumerators,
                notifyDelegate: notifyDelegate
            )

        case .structOrUnionDecl(let rule, let identifier, let structDecl, let fields):
            return processStructOrUnionDecl(
                decl,
                rule: rule,
                identifier: identifier,
                structDecl: structDecl,
                fields: fields,
                notifyDelegate: notifyDelegate
            )

        case .function(let rule, let identifier, let parameters, let returnType):
            return processFunction(
                decl,
                rule: rule,
                identifier: identifier,
                parameters: parameters,
                returnType: returnType,
                notifyDelegate: notifyDelegate
            )

        case .typedef(let rule, let baseType, let typeNode, let alias):
            return processTypeAlias(
                decl,
                rule: rule,
                baseDecl: baseType,
                typeNode: typeNode,
                alias: alias,
                notifyDelegate: notifyDelegate
            )
        }
    }

    private func collectComments(_ node: ASTNode, _ rule: ParserRuleContext) {
        node.precedingComments.append(
            contentsOf: commentQuerier.popClosestCommentsBefore(node: rule)
        )
        node.precedingComments.append(
            contentsOf: commentQuerier.popCommentsOverlapping(node: rule)
        )
    }
}
