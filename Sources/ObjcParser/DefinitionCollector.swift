import Antlr4
import ObjcParserAntlr
import GrammarModels

/// Protocol for delegates of elements collected by a `DefinitionCollector` as
/// it collects definitions, prior to adding them to the final declarations list.
protocol DefinitionCollectorDelegate: AnyObject {
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
}

/// Collects definitions from a `DeclarationContext` parser rule and converts them
/// into `ASTNode` declarations.
class DefinitionCollector {
    var declarations: [ASTNode] = []
    var nonnullContextQuerier: NonnullContextQuerier
    var commentQuerier: CommentQuerier
    var nodeFactory: ASTNodeFactory

    weak var delegate: DefinitionCollectorDelegate?
    
    init(
        nonnullContextQuerier: NonnullContextQuerier,
        commentQuerier: CommentQuerier,
        nodeFactory: ASTNodeFactory
    ) {
        self.nonnullContextQuerier = nonnullContextQuerier
        self.commentQuerier = commentQuerier
        self.nodeFactory = nodeFactory
    }

    func collect(from ctx: ObjectiveCParser.DeclarationContext) -> [ASTNode]? {
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
        rule: ParserRuleContext,
        identifier: Identifier,
        type: ObjcType?,
        nullability: DeclarationTranslator.Nullability?,
        initialValue: ObjectiveCParser.InitializerContext?
    ) -> [ASTNode]? {

        guard let type = type else {
            return nil
        }

        let typeNode = TypeNameNode(type: type, isInNonnullContext: identifier.isInNonnullContext)

        return processVariable(
            rule: rule,
            identifier: identifier,
            typeNode: typeNode,
            nullability: nullability,
            initialValue: initialValue
        )
    }

    private func processVariable(
        rule: ParserRuleContext,
        identifier: Identifier,
        typeNode: TypeNameNode,
        nullability: DeclarationTranslator.Nullability?,
        initialValue: ObjectiveCParser.InitializerContext?
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

        return [node]
    }

    private func processFunction(
        rule: ParserRuleContext,
        identifier: Identifier,
        parameters: [FunctionParameter],
        returnType: TypeNameNode?
    ) -> [ASTNode]? {

        let node = FunctionDefinition(isInNonnullContext: identifier.isInNonnullContext)

        collectComments(node, rule)

        return [node]
    }

    private func processStructOrUnionDecl(
        rule: ParserRuleContext,
        identifier: Identifier?,
        structDecl: DeclarationExtractor.StructOrUnionSpecifier,
        fields: [ObjcStructField]
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

        return [node]
    }

    private func processEnumDecl(
        rule: ParserRuleContext,
        identifier: Identifier?,
        typeName: TypeNameNode?,
        enumDecl: DeclarationExtractor.EnumSpecifier,
        enumerators: [ObjcEnumCase]
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

        return [node]
    }

    private func processTypeAlias(
        rule: ParserRuleContext,
        baseDecl: DeclarationTranslator.ASTNodeDeclaration,
        typeNode: TypeNameNode,
        alias: Identifier
    ) -> [ASTNode]? {

        let nonnull = nonnullContextQuerier.isInNonnullContext(rule)

        let node = TypedefNode(isInNonnullContext: nonnull)
        node.addChild(alias)
        node.addChild(typeNode)

        if let baseNodes = processDeclaration(baseDecl) {
            node.addChildren(baseNodes)
        }

        node.updateSourceRange()
        collectComments(node, rule)

        return [node]
    }

    private func processDeclaration(_ decl: DeclarationTranslator.ASTNodeDeclaration?) -> [ASTNode]? {
        guard let decl = decl else {
            return nil
        }

        switch decl {
        case .variable(let rule, let nullability, let identifier, let type, let initialValue):
            return processVariable(
                rule: rule,
                identifier: identifier,
                typeNode: type,
                nullability: nullability,
                initialValue: initialValue
            )
            
        case .block(let rule, let nullability, let identifier, _, _, let initialValue):
            return processVariable(
                rule: rule,
                identifier: identifier,
                type: decl.objcType,
                nullability: nullability,
                initialValue: initialValue
            )
            
        case .functionPointer(let rule, let nullability, let identifier, _, _, let initialValue):
            return processVariable(
                rule: rule,
                identifier: identifier,
                type: decl.objcType,
                nullability: nullability,
                initialValue: initialValue
            )

        case .enumDecl(let rule, let identifier, let typeName, let decl, let enumerators):
            return processEnumDecl(
                rule: rule,
                identifier: identifier,
                typeName: typeName,
                enumDecl: decl,
                enumerators: enumerators
            )

        case .structOrUnionDecl(let rule, let identifier, let decl, let fields):
            return processStructOrUnionDecl(
                rule: rule,
                identifier: identifier,
                structDecl: decl,
                fields: fields
            )

        case .function(let rule, let identifier, let parameters, let returnType):
            return processFunction(
                rule: rule,
                identifier: identifier,
                parameters: parameters,
                returnType: returnType
            )

        case .typedef(let rule, let baseType, let typeNode, let alias):
            return processTypeAlias(
                rule: rule,
                baseDecl: baseType,
                typeNode: typeNode,
                alias: alias
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
