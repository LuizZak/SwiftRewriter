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

    /// Collects definitions from a given declaration context parser rule.
    public func collect(from ctx: ObjectiveCParser.DeclarationContext) -> [ASTNode] {
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

    /// Collects definitions from a given field declaration context parser rule.
    public func collect(from ctx: ObjectiveCParser.FieldDeclarationContext) -> [ASTNode] {
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

    /// Collects a full function definition from a specified context.
    ///
    /// Returns `nil` if the conversion could not succeed due to missing or invalid
    /// syntax configurations.
    public func collectFunction(from ctx: ObjectiveCParser.FunctionDefinitionContext) -> FunctionDefinition? {
        var declarations: [ASTNode] = []

        guard let functionSignature = ctx.functionSignature() else {
            return nil
        }
        guard let declarator = functionSignature.declarator() else {
            return nil
        }

        let extractor = DeclarationExtractor()
        let translator = DeclarationTranslator()

        guard let decl = extractor.extract(
            fromSpecifiers: functionSignature.declarationSpecifiers(),
            declarator: declarator
        ) else {
            return nil
        }

        let nodeDecls = translator.translate(decl, context: .init(nodeFactory: nodeFactory))

        for nodeDecl in nodeDecls {
            if let nodes = processDeclaration(nodeDecl) {
                declarations.append(contentsOf: nodes)
            }
        }

        guard let funcDecl = declarations.first(where: { $0 is FunctionDefinition }) as? FunctionDefinition else {
            return nil
        }

        if let compoundStatement = ctx.compoundStatement() {
            let methodBody = nodeFactory.makeMethodBody(from: compoundStatement)

            funcDecl.addChild(methodBody)
        }
        
        return funcDecl
    }

    /// Collects definitions from any direct descendant of `ctx` that is a rule
    /// of type `ObjectiveCParser.DeclarationContext`.
    ///
    /// - note: Function is non-recursive: only the first descendants of `ctx`
    /// are inspected.
    public func collect(fromChildrenOf ctx: ParserRuleContext) -> [ASTNode] {
        var result: [ASTNode] = []
        guard let children = ctx.children else {
            return result
        }

        for childCtx in children {
            guard let declCtx = childCtx as? ObjectiveCParser.DeclarationContext else {
                continue
            }

            let declarations = collect(from: declCtx)
            result.append(contentsOf: declarations)
        }

        return result
    }

    private func processVariable(
        _ decl: DeclarationTranslator.ASTNodeDeclaration,
        rule: ParserRuleContext,
        identifier: Identifier,
        type: ObjcType?,
        nullability: ObjcNullabilitySpecifier?,
        arcSpecifier: ObjcArcBehaviorSpecifier?,
        initialValue: ObjectiveCParser.InitializerContext?,
        isStatic: Bool,
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
            arcSpecifier: arcSpecifier,
            initialValue: initialValue,
            isStatic: isStatic,
            notifyDelegate: notifyDelegate
        )
    }

    private func processVariable(
        _ decl: DeclarationTranslator.ASTNodeDeclaration,
        rule: ParserRuleContext,
        identifier: Identifier,
        typeNode: TypeNameNode,
        nullability: ObjcNullabilitySpecifier?,
        arcSpecifier: ObjcArcBehaviorSpecifier?,
        initialValue: ObjectiveCParser.InitializerContext?,
        isStatic: Bool,
        notifyDelegate: Bool
    ) -> [ASTNode]? {

        let node = VariableDeclaration(isInNonnullContext: identifier.isInNonnullContext)
        node.isStatic = isStatic

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
        isVariadic: Bool,
        notifyDelegate: Bool
    ) -> [ASTNode]? {

        let parameterList = ParameterList(isInNonnullContext: identifier.isInNonnullContext)
        parameterList.addChildren(parameters)
        if isVariadic {
            let variadicParam = VariadicParameter(isInNonnullContext: identifier.isInNonnullContext)
            parameterList.addChild(variadicParam)
        }

        let node = FunctionDefinition(isInNonnullContext: identifier.isInNonnullContext)
        
        node.addChild(identifier)
        node.addChild(parameterList)

        if let returnType = returnType {
            node.addChild(returnType)
        }

        node.updateSourceRange()
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
        fields: [DeclarationTranslator.ASTStructFieldDeclaration],
        notifyDelegate: Bool
    ) -> [ASTNode]? {

        let nonnull = nonnullContextQuerier.isInNonnullContext(rule)

        let node = ObjcStructDeclaration(isInNonnullContext: nonnull)
        if let identifier = identifier {
            node.addChild(identifier)
        }

        let bodyNode = ObjcStructDeclarationBody(isInNonnullContext: nonnull)
        bodyNode.addChildren(fields.map(\.node))
        node.addChild(bodyNode)

        node.updateSourceRange()
        collectComments(node, rule)

        // Process comments for each field
        for field in fields {
            collectComments(field.node, field.rule)
        }

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
        enumerators: [DeclarationTranslator.ASTEnumeratorDeclaration],
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

        node.addChildren(enumerators.map(\.node))

        node.updateSourceRange()
        collectComments(node, rule)

        // Process comments for each enumerator
        for enumerator in enumerators {
            collectComments(enumerator.node, enumerator.rule)
        }
        
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
        case .variable(let astDecl):
            return processVariable(
                decl,
                rule: astDecl.rule,
                identifier: astDecl.identifier,
                typeNode: astDecl.type,
                nullability: astDecl.nullability,
                arcSpecifier: astDecl.arcSpecifier,
                initialValue: astDecl.initialValue,
                isStatic: astDecl.isStatic,
                notifyDelegate: notifyDelegate
            )
            
        case .block(let astDecl):
            return processVariable(
                decl,
                rule: astDecl.rule,
                identifier: astDecl.identifier,
                type: decl.objcType,
                nullability: astDecl.nullability,
                arcSpecifier: astDecl.arcSpecifier,
                initialValue: astDecl.initialValue,
                isStatic: astDecl.isStatic,
                notifyDelegate: notifyDelegate
            )
            
        case .functionPointer(let astDecl):
            return processVariable(
                decl,
                rule: astDecl.rule,
                identifier: astDecl.identifier,
                type: decl.objcType,
                nullability: astDecl.nullability,
                arcSpecifier: nil,
                initialValue: astDecl.initialValue,
                isStatic: astDecl.isStatic,
                notifyDelegate: notifyDelegate
            )

        case .enumDecl(let astDecl):
            return processEnumDecl(
                decl,
                rule: astDecl.rule,
                identifier: astDecl.identifier,
                typeName: astDecl.typeName,
                enumDecl: astDecl.context,
                enumerators: astDecl.enumerators,
                notifyDelegate: notifyDelegate
            )

        case .structOrUnionDecl(let astDecl):
            return processStructOrUnionDecl(
                decl,
                rule: astDecl.rule,
                identifier: astDecl.identifier,
                structDecl: astDecl.context,
                fields: astDecl.fields,
                notifyDelegate: notifyDelegate
            )

        case .function(let astDecl):
            return processFunction(
                decl,
                rule: astDecl.rule,
                identifier: astDecl.identifier,
                parameters: astDecl.parameters,
                returnType: astDecl.returnType,
                isVariadic: astDecl.isVariadic,
                notifyDelegate: notifyDelegate
            )

        case .typedef(let astDecl):
            return processTypeAlias(
                decl,
                rule: astDecl.rule,
                baseDecl: astDecl.baseType,
                typeNode: astDecl.typeNode,
                alias: astDecl.alias,
                notifyDelegate: notifyDelegate
            )
        }
    }

    private func collectComments(_ node: ASTNode, _ rule: ParserRuleContext) {
        node.precedingComments.append(
            contentsOf: commentQuerier.popClosestCommentsBefore(node: rule)
        )
        node.precedingComments.append(
            contentsOf: commentQuerier.popCommentsInlineWith(node: rule)
        )
    }
}

/// A delegate for `DefinitionCollector` that stores each type of definition in
/// a separate array.
public class ArrayDefinitionCollectorDelegate: DefinitionCollectorDelegate {
    private(set) public var variables: [VariableDeclaration] = []
    private(set) public var functions: [FunctionDefinition] = []
    private(set) public var typedefNodes: [TypedefNode] = []
    private(set) public var structDeclarations: [ObjcStructDeclaration] = []
    private(set) public var enumDeclarations: [ObjcEnumDeclaration] = []

    public func definitionCollector(
        _ collector: DefinitionCollector,
        didDetectVariable variable: VariableDeclaration,
        from declaration: DeclarationTranslator.ASTNodeDeclaration
    ) {
        self.variables.append(variable)
    }
    
    public func definitionCollector(
        _ collector: DefinitionCollector,
        didDetectFunction function: FunctionDefinition,
        from declaration: DeclarationTranslator.ASTNodeDeclaration
    ) {
        self.functions.append(function)
    }
    
    public func definitionCollector(
        _ collector: DefinitionCollector,
        didDetectTypedef typedefNode: TypedefNode,
        from declaration: DeclarationTranslator.ASTNodeDeclaration
    ) {
        self.typedefNodes.append(typedefNode)
    }
    
    public func definitionCollector(
        _ collector: DefinitionCollector,
        didDetectStruct structDecl: ObjcStructDeclaration,
        from declaration: DeclarationTranslator.ASTNodeDeclaration
    ) {
        self.structDeclarations.append(structDecl)
    }
    
    public func definitionCollector(
        _ collector: DefinitionCollector,
        didDetectEnum enumDecl: ObjcEnumDeclaration,
        from declaration: DeclarationTranslator.ASTNodeDeclaration
    ) {
        self.enumDeclarations.append(enumDecl)
    }
}
