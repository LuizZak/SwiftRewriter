import Antlr4
import ObjcParserAntlr
import ObjcGrammarModels
import Utils

/// Protocol for delegates of elements collected by a `DefinitionCollector` as
/// it collects definitions, prior to adding them to the final declarations list.
public protocol DefinitionCollectorDelegate: AnyObject {
    /// Invoked to notify that a variable declaration was detected after
    /// transforming it from an underlying `DeclarationTranslator.ASTNodeDeclaration`
    /// value.
    func definitionCollector(
        _ collector: DefinitionCollector,
        didDetectVariable variable: ObjcVariableDeclarationNode,
        from declaration: DeclarationTranslator.ASTNodeDeclaration
    )
    
    /// Invoked to notify that a function definition was detected after
    /// transforming it from an underlying `DeclarationTranslator.ASTNodeDeclaration`
    /// value.
    func definitionCollector(
        _ collector: DefinitionCollector,
        didDetectFunction function: ObjcFunctionDefinitionNode,
        from declaration: DeclarationTranslator.ASTNodeDeclaration
    )
    
    /// Invoked to notify that a typedef was detected after transforming it from
    /// an underlying `DeclarationTranslator.ASTNodeDeclaration` value.
    func definitionCollector(
        _ collector: DefinitionCollector,
        didDetectTypedef typedefNode: ObjcTypedefNode,
        from declaration: DeclarationTranslator.ASTNodeDeclaration
    )
    
    /// Invoked to notify that a struct was detected after transforming it from
    /// an underlying `DeclarationTranslator.ASTNodeDeclaration` value.
    func definitionCollector(
        _ collector: DefinitionCollector,
        didDetectStruct structDecl: ObjcStructDeclarationNode,
        from declaration: DeclarationTranslator.ASTNodeDeclaration
    )
    
    /// Invoked to notify that an enum was detected after transforming it from
    /// an underlying `DeclarationTranslator.ASTNodeDeclaration` value.
    func definitionCollector(
        _ collector: DefinitionCollector,
        didDetectEnum enumDecl: ObjcEnumDeclarationNode,
        from declaration: DeclarationTranslator.ASTNodeDeclaration
    )
}

public extension DefinitionCollectorDelegate {
    func definitionCollector(
        _ collector: DefinitionCollector,
        didDetectVariable variable: ObjcVariableDeclarationNode,
        from declaration: DeclarationTranslator.ASTNodeDeclaration
    ) { }
    
    func definitionCollector(
        _ collector: DefinitionCollector,
        didDetectFunction function: ObjcFunctionDefinitionNode,
        from declaration: DeclarationTranslator.ASTNodeDeclaration
    ) { }
    
    func definitionCollector(
        _ collector: DefinitionCollector,
        didDetectTypedef typedefNode: ObjcTypedefNode,
        from declaration: DeclarationTranslator.ASTNodeDeclaration
    ) { }
    
    func definitionCollector(
        _ collector: DefinitionCollector,
        didDetectStruct structDecl: ObjcStructDeclarationNode,
        from declaration: DeclarationTranslator.ASTNodeDeclaration
    ) { }
    
    func definitionCollector(
        _ collector: DefinitionCollector,
        didDetectEnum enumDecl: ObjcEnumDeclarationNode,
        from declaration: DeclarationTranslator.ASTNodeDeclaration
    ) { }
}

/// Collects definitions from a `DeclarationContext` parser rule and converts them
/// into `ObjcASTNode` declarations.
public class DefinitionCollector {
    var declarations: [ObjcASTNode] = []
    var nonnullContextQuerier: NonnullContextQuerier
    var nodeFactory: ObjcASTNodeFactory

    var source: Source {
        nodeFactory.source
    }

    public weak var delegate: DefinitionCollectorDelegate?
    
    public init(
        nonnullContextQuerier: NonnullContextQuerier,
        nodeFactory: ObjcASTNodeFactory
    ) {
        self.nonnullContextQuerier = nonnullContextQuerier
        self.nodeFactory = nodeFactory
    }

    /// Collects definitions from a given declaration context parser rule.
    public func collect(from ctx: ObjectiveCParser.DeclarationContext) -> [ObjcASTNode] {
        let parser = AntlrDeclarationParser(source: source)
        guard let syntax = parser.declaration(ctx) else {
            return []
        }

        var declarations: [ObjcASTNode] = []

        let extractor = DeclarationExtractor()
        let translator = DeclarationTranslator()

        let decls = extractor.extract(from: syntax)
        let nodeDecls = translator.translate(decls)

        for nodeDecl in nodeDecls {
            if let nodes = processDeclaration(nodeDecl) {
                declarations.append(contentsOf: nodes)
            }
        }
        
        return declarations
    }

    /// Collects definitions from a given field declaration context parser rule.
    public func collect(from ctx: ObjectiveCParser.FieldDeclarationContext) -> [ObjcASTNode] {
        let parser = AntlrDeclarationParser(source: source)
        guard let syntax = parser.fieldDeclaration(ctx) else {
            return []
        }

        var declarations: [ObjcASTNode] = []

        let extractor = DeclarationExtractor()
        let translator = DeclarationTranslator()

        let decls = extractor.extract(from: syntax)
        let nodeDecls = translator.translate(decls)

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
    public func collectFunction(from ctx: ObjectiveCParser.FunctionDefinitionContext) -> ObjcFunctionDefinitionNode? {
        let parser = AntlrDeclarationParser(source: source)

        guard let functionSignature = ctx.functionSignature() else {
            return nil
        }
        guard let declarator = parser.declarator(functionSignature.declarator()) else {
            return nil
        }
        guard
            let declarationSpecifiers = parser.declarationSpecifiers(functionSignature.declarationSpecifiers())
        else {
            return nil
        }

        let extractor = DeclarationExtractor()
        let translator = DeclarationTranslator()

        guard let decl = extractor.extract(
            fromSpecifiers: declarationSpecifiers,
            declarator: declarator
        ) else {
            return nil
        }

        let nodeDecls = translator.translate(decl)

        var declarations: [ObjcASTNode] = []
        for nodeDecl in nodeDecls {
            if let nodes = processDeclaration(nodeDecl) {
                declarations.append(contentsOf: nodes)
            }
        }

        guard let funcDecl = declarations.first(where: { $0 is ObjcFunctionDefinitionNode }) as? ObjcFunctionDefinitionNode else {
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
    public func collect(fromChildrenOf ctx: ParserRuleContext) -> [ObjcASTNode] {
        var result: [ObjcASTNode] = []
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
        rule: DeclarationSyntaxElementType,
        identifier: DeclarationTranslator.IdentifierInfo,
        type: ObjcType?,
        nullability: ObjcNullabilitySpecifier?,
        arcSpecifier: ObjcArcBehaviorSpecifier?,
        initialValue: DeclarationTranslator.InitializerInfo?,
        isStatic: Bool,
        notifyDelegate: Bool
    ) -> [ObjcASTNode]? {

        guard let type = type else {
            return nil
        }

        let typeNameInfo = DeclarationTranslator.TypeNameInfo(
            sourceRange: rule.sourceRange,
            type: type
        )

        return processVariable(
            decl,
            rule: rule,
            identifier: identifier,
            typeNode: typeNameInfo,
            nullability: nullability,
            arcSpecifier: arcSpecifier,
            initialValue: initialValue,
            isStatic: isStatic,
            notifyDelegate: notifyDelegate
        )
    }

    private func processVariable(
        _ decl: DeclarationTranslator.ASTNodeDeclaration,
        rule: DeclarationSyntaxElementType,
        identifier: DeclarationTranslator.IdentifierInfo,
        typeNode: DeclarationTranslator.TypeNameInfo,
        nullability: ObjcNullabilitySpecifier?,
        arcSpecifier: ObjcArcBehaviorSpecifier?,
        initialValue: DeclarationTranslator.InitializerInfo?,
        isStatic: Bool,
        notifyDelegate: Bool
    ) -> [ObjcASTNode]? {

        let isNonnull = nodeFactory.isInNonnullContext(identifier.sourceRange)

        let node = ObjcVariableDeclarationNode(isInNonnullContext: isNonnull)
        node.isStatic = isStatic

        node.addChild(
            makeIdentifier(identifier)
        )
        node.addChild(
            makeTypeNameNode(typeNode)
        )

        if let initialValue {
            node.addChild(
                makeInitialExpression(initialValue)
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
        rule: DeclarationSyntaxElementType,
        identifier: DeclarationTranslator.IdentifierInfo,
        parameters: [DeclarationTranslator.FunctionParameterInfo],
        returnType: DeclarationTranslator.TypeNameInfo?,
        isVariadic: Bool,
        notifyDelegate: Bool
    ) -> [ObjcASTNode]? {

        let isNonnull = nodeFactory.isInNonnullContext(identifier.sourceRange)

        let parameterList = ObjcParameterListNode(isInNonnullContext: isNonnull)
        parameterList.addChildren(
            makeParameterList(parameters)
        )
        if isVariadic {
            let variadicParam = ObjcVariadicParameterNode(isInNonnullContext: isNonnull)
            parameterList.addChild(variadicParam)
        }

        let node = ObjcFunctionDefinitionNode(isInNonnullContext: isNonnull)
        
        node.addChild(
            makeIdentifier(identifier)
        )
        node.addChild(parameterList)

        if let returnType {
            node.addChild(
                makeTypeNameNode(returnType)
            )
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
        rule: DeclarationSyntaxElementType,
        identifier: DeclarationTranslator.IdentifierInfo?,
        structDecl: DeclarationExtractor.StructOrUnionSpecifier,
        fields: [DeclarationTranslator.ASTStructFieldDeclaration],
        notifyDelegate: Bool
    ) -> [ObjcASTNode]? {

        let nonnull = nodeFactory.isInNonnullContext(rule)

        let node = ObjcStructDeclarationNode(isInNonnullContext: nonnull)
        nodeFactory.updateSourceLocation(for: node, with: rule)

        if let identifier {
            node.addChild(
                makeIdentifier(identifier)
            )
        }

        let fieldNodes = fields.map(self.makeStructField(_:))

        let bodyNode = ObjcStructDeclarationBodyNode(isInNonnullContext: nonnull)
        nodeFactory.updateSourceLocation(for: bodyNode, with: rule)
        
        bodyNode.addChildren(fieldNodes)
        node.addChild(bodyNode)

        node.updateSourceRange()
        collectComments(node, rule)

        // Process comments for each field
        for (node, field) in zip(fieldNodes, fields) {
            collectComments(node, field.rule)
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
        rule: DeclarationSyntaxElementType,
        identifier: DeclarationTranslator.IdentifierInfo?,
        typeName: DeclarationTranslator.TypeNameInfo?,
        enumDecl: DeclarationExtractor.EnumSpecifier,
        enumerators: [DeclarationTranslator.ASTEnumeratorDeclaration],
        notifyDelegate: Bool
    ) -> [ObjcASTNode]? {

        let nonnull = nodeFactory.isInNonnullContext(rule)

        let enumeratorNodes = enumerators.map(makeEnumerator(_:))

        let node = ObjcEnumDeclarationNode(isInNonnullContext: nonnull)
        nodeFactory.updateSourceLocation(for: node, with: rule)
        
        if let identifier = identifier {
            node.addChild(
                makeIdentifier(identifier)
            )
        }
        if let typeName = typeName {
            node.addChild(
                makeTypeNameNode(typeName)
            )
        }

        node.addChildren(enumeratorNodes)

        node.updateSourceRange()
        collectComments(node, rule)

        // Process comments for each enumerator
        for (enumeratorNode, enumerator) in zip(enumeratorNodes, enumerators) {
            collectComments(enumeratorNode, enumerator.rule)
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
        rule: DeclarationSyntaxElementType,
        baseDecl: DeclarationTranslator.ASTNodeDeclaration,
        typeNode: DeclarationTranslator.TypeNameInfo,
        alias: DeclarationTranslator.IdentifierInfo,
        notifyDelegate: Bool
    ) -> [ObjcASTNode]? {

        let nonnull = nodeFactory.isInNonnullContext(rule)

        let node = ObjcTypedefNode(isInNonnullContext: nonnull)
        nodeFactory.updateSourceLocation(for: node, with: rule)

        node.addChild(
            makeIdentifier(alias)
        )
        node.addChild(
            makeTypeNameNode(typeNode)
        )
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
    ) -> [ObjcASTNode]? {

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

    private func makeIdentifier(_ info: DeclarationTranslator.IdentifierInfo) -> ObjcIdentifierNode {
        return nodeFactory.makeIdentifier(
            from: .init(sourceRange: info.sourceRange, identifier: info.name)
        )
    }

    private func makeTypeNameNode(_ info: DeclarationTranslator.TypeNameInfo) -> ObjcTypeNameNode {
        let isNonnull = nodeFactory.isInNonnullContext(info.sourceRange)

        return ObjcTypeNameNode(
            type: info.type,
            isInNonnullContext: isNonnull,
            location: info.sourceRange.start ?? .invalid,
            length: info.sourceRange.length ?? .zero
        )
    }

    private func makeExpression(_ info: DeclarationTranslator.ExpressionInfo) -> ObjcExpressionNode {
        switch info {
        case .string(let range, let str):
            return nodeFactory.makeExpression(
                from: .init(sourceRange: range, expressionString: str)
            )
        case .antlr(_, let ctx):
            return nodeFactory.makeExpression(from: ctx)
        }
    }

    private func makeConstantExpression(_ info: DeclarationTranslator.ConstantExpressionInfo) -> ObjcConstantExpressionNode {
        switch info {
        case .string(let range, let str):
            return nodeFactory.makeConstantExpression(
                from: .init(sourceRange: range, constantExpressionString: str)
            )
        case .antlr(_, let ctx):
            return nodeFactory.makeConstantExpression(from: ctx)
        }
    }

    private func makeInitialExpression(_ info: DeclarationTranslator.InitializerInfo) -> ObjcInitialExpressionNode {
        switch info {
        case .string(let range, let str):
            return nodeFactory.makeInitialExpression(
                from: .init(sourceRange: range, expressionString: str)
            )
        case .antlr(_, let ctx):
            return nodeFactory.makeInitialExpression(from: ctx)
        }
    }

    private func makeStructField(_ info: DeclarationTranslator.ASTStructFieldDeclaration) -> ObjcStructFieldNode {
        let nonnull = nodeFactory.isInNonnullContext(info.rule)

        let node = ObjcStructFieldNode(isInNonnullContext: nonnull)
        node.addChild(
            makeTypeNameNode(info.type)
        )

        if let identifier = info.identifier {
            node.addChild(
                makeIdentifier(identifier)
            )
        }
        if let constantExpression = info.constantExpression {
            node.addChild(
                makeConstantExpression(constantExpression)
            )
        }

        nodeFactory.updateSourceLocation(for: node, with: info.rule)

        return node
    }

    private func makeEnumerator(_ info: DeclarationTranslator.ASTEnumeratorDeclaration) -> ObjcEnumCaseNode {
        let nonnull = nodeFactory.isInNonnullContext(info.rule)

        let node = ObjcEnumCaseNode(isInNonnullContext: nonnull)

        if let identifier = info.identifier {
            node.addChild(
                makeIdentifier(identifier)
            )
        }
        if let expression = info.expression {
            node.addChild(
                makeExpression(expression)
            )
        }

        nodeFactory.updateSourceLocation(for: node, with: info.rule)

        return node
    }

    private func makeParameterList(_ parameterList: [DeclarationTranslator.FunctionParameterInfo]) -> [ObjcFunctionParameterNode] {
        parameterList.map(makeParameter)
    }

    private func makeParameter(_ parameter: DeclarationTranslator.FunctionParameterInfo) -> ObjcFunctionParameterNode {
        let nonnull = nodeFactory.isInNonnullContext(parameter.type.sourceRange)

        let node = ObjcFunctionParameterNode(isInNonnullContext: nonnull)
        node.addChild(
            makeTypeNameNode(parameter.type)
        )

        if let identifier = parameter.identifier {
            node.addChild(
                makeIdentifier(identifier)
            )
        }

        nodeFactory.updateSourceLocation(for: node, with: parameter.type.sourceRange)

        return node
    }

    private func collectComments(_ node: ObjcASTNode, _ rule: ParserRuleContext) {
        node.precedingComments.append(
            contentsOf: nodeFactory.popComments(preceding: rule)
        )
        node.precedingComments.append(
            contentsOf: nodeFactory.popComments(inLineWith: rule)
        )
    }

    private func collectComments(_ node: ObjcASTNode, _ rule: DeclarationSyntaxElementType) {
        node.precedingComments.append(
            contentsOf: nodeFactory.popComments(preceding: rule)
        )
        node.precedingComments.append(
            contentsOf: nodeFactory.popComments(inLineWith: rule)
        )
    }
}

/// A delegate for `DefinitionCollector` that stores each type of definition in
/// a separate array.
public class ArrayDefinitionCollectorDelegate: DefinitionCollectorDelegate {
    private(set) public var variables: [ObjcVariableDeclarationNode] = []
    private(set) public var functions: [ObjcFunctionDefinitionNode] = []
    private(set) public var typedefNodes: [ObjcTypedefNode] = []
    private(set) public var structDeclarations: [ObjcStructDeclarationNode] = []
    private(set) public var enumDeclarations: [ObjcEnumDeclarationNode] = []

    public func definitionCollector(
        _ collector: DefinitionCollector,
        didDetectVariable variable: ObjcVariableDeclarationNode,
        from declaration: DeclarationTranslator.ASTNodeDeclaration
    ) {
        self.variables.append(variable)
    }
    
    public func definitionCollector(
        _ collector: DefinitionCollector,
        didDetectFunction function: ObjcFunctionDefinitionNode,
        from declaration: DeclarationTranslator.ASTNodeDeclaration
    ) {
        self.functions.append(function)
    }
    
    public func definitionCollector(
        _ collector: DefinitionCollector,
        didDetectTypedef typedefNode: ObjcTypedefNode,
        from declaration: DeclarationTranslator.ASTNodeDeclaration
    ) {
        self.typedefNodes.append(typedefNode)
    }
    
    public func definitionCollector(
        _ collector: DefinitionCollector,
        didDetectStruct structDecl: ObjcStructDeclarationNode,
        from declaration: DeclarationTranslator.ASTNodeDeclaration
    ) {
        self.structDeclarations.append(structDecl)
    }
    
    public func definitionCollector(
        _ collector: DefinitionCollector,
        didDetectEnum enumDecl: ObjcEnumDeclarationNode,
        from declaration: DeclarationTranslator.ASTNodeDeclaration
    ) {
        self.enumDeclarations.append(enumDecl)
    }
}
