import Antlr4
import Utils
import AntlrCommons
import GrammarModelBase
import ObjcParserAntlr
import ObjcGrammarModels

// TODO: Create a base implementation to cover this file and with JsParser.JsParserListener.

internal class ObjcParserListener: ObjectiveCParserBaseListener {
    let context: NodeCreationContext
    let rootNode: ObjcGlobalContextNode
    let typeParser: ObjcTypeParser
    private var nonnullContextQuerier: NonnullContextQuerier
    private var commentQuerier: CommentQuerier
    private let mapper: GenericParseTreeContextMapper
    private let sourceString: String
    private let source: Source
    private let nodeFactory: ObjcASTNodeFactory
    
    /// Whether the listener is currently visiting a @protocol section that was
    /// marked @optional.
    private var inOptionalContext: Bool = false
    
    init(
        sourceString: String,
        source: Source,
        state: ObjcParserState,
        antlrSettings: AntlrSettings,
        nonnullContextQuerier: NonnullContextQuerier,
        commentQuerier: CommentQuerier
    ) {
        
        self.sourceString = sourceString
        self.source = source
        self.nonnullContextQuerier = nonnullContextQuerier
        self.commentQuerier = commentQuerier
        self.nodeFactory =
            ObjcASTNodeFactory(
                source: source,
                nonnullContextQuerier: nonnullContextQuerier,
                commentQuerier: commentQuerier
            )
        
        typeParser = ObjcTypeParser(
            state: state,
            source: source,
            antlrSettings: antlrSettings
        )
        context = NodeCreationContext()
        rootNode = ObjcGlobalContextNode(isInNonnullContext: false)
        mapper = GenericParseTreeContextMapper(
            source: source,
            nonnullContextQuerier: nonnullContextQuerier,
            commentQuerier: commentQuerier,
            nodeFactory: nodeFactory)
        
        super.init()
        
        configureMappers()
    }
    
    /// Configures mappers in `self.mapper` so they are automatically pushed and
    /// popped whenever the rules are entered and exited during visit.
    ///
    /// Used as a convenience over manually pushing and popping contexts every
    /// time a node of significance is entered.
    private func configureMappers() {
        typealias O = ObjectiveCParser
        
        mapper.addRuleMap(
            rule: O.TranslationUnitContext.self,
            node: rootNode
        )
        mapper.addRuleMap(
            rule: O.ClassInterfaceContext.self,
            nodeType: ObjcClassInterfaceNode.self,
            collectComments: true
        )
        mapper.addRuleMap(
            rule: O.ClassImplementationContext.self,
            nodeType: ObjcClassImplementationNode.self,
            collectComments: true
        )
        mapper.addRuleMap(
            rule: O.CategoryInterfaceContext.self,
            nodeType: ObjcClassCategoryInterfaceNode.self,
            collectComments: true
        )
        mapper.addRuleMap(
            rule: O.CategoryImplementationContext.self,
            nodeType: ObjcClassCategoryImplementationNode.self,
            collectComments: true
        )
        mapper.addRuleMap(
            rule: O.MethodDeclarationContext.self,
            nodeType: ObjcMethodDefinitionNode.self,
            collectComments: true
        )
        mapper.addRuleMap(
            rule: O.MethodDefinitionContext.self,
            nodeType: ObjcMethodDefinitionNode.self,
            collectComments: true
        )
        mapper.addRuleMap(
            rule: O.KeywordDeclaratorContext.self,
            nodeType: ObjcKeywordDeclaratorNode.self
        )
        mapper.addRuleMap(
            rule: O.MethodSelectorContext.self,
            nodeType: ObjcMethodSelectorNode.self
        )
        mapper.addRuleMap(
            rule: O.MethodTypeContext.self,
            nodeType: ObjcMethodTypeNode.self
        )
        mapper.addRuleMap(
            rule: O.InstanceVariablesContext.self,
            nodeType: ObjcIVarsListNode.self
        )
        mapper.addRuleMap(
            rule: O.ProtocolDeclarationContext.self,
            nodeType: ObjcProtocolDeclarationNode.self,
            collectComments: true
        )
        mapper.addRuleMap(
            rule: O.PropertyImplementationContext.self,
            nodeType: ObjcPropertyImplementationNode.self
        )
        mapper.addRuleMap(
            rule: O.PropertySynthesizeListContext.self,
            nodeType: ObjcPropertySynthesizeListNode.self
        )
        mapper.addRuleMap(
            rule: O.PropertySynthesizeItemContext.self,
            nodeType: ObjcPropertySynthesizeItemNode.self
        )
    }

    private func makeDefinitionCollector(
        delegate: DefinitionCollectorDelegate? = nil
    ) -> DefinitionCollector {

        let collector = DefinitionCollector(
            nonnullContextQuerier: nonnullContextQuerier,
            nodeFactory: nodeFactory
        )
        collector.delegate = delegate

        return collector
    }

    private func makeStaticDeclarationsVisitor() -> StaticDeclarationsVisitor {
        StaticDeclarationsVisitor(nodeFactory: nodeFactory)
    }
    
    override func enterEveryRule(_ ctx: ParserRuleContext) {
        mapper.matchEnter(rule: ctx, context: context)
    }
    
    override func exitEveryRule(_ ctx: ParserRuleContext) {
        mapper.matchExit(rule: ctx, context: context)
    }
    
    // MARK: - Global Context
    
    override func enterTopLevelDeclaration(_ ctx: ObjectiveCParser.TopLevelDeclarationContext) {
        guard let declaration = ctx.declaration() else {
            return
        }

        let collector = makeDefinitionCollector()
        let nodes = collector.collect(from: declaration)
        
        for node in nodes {
            context.addChildNode(node)
        }
    }
    
    // MARK: - Class Interface
    override func enterClassInterface(_ ctx: ObjectiveCParser.ClassInterfaceContext) {
        guard let classNode = context.currentContextNode(as: ObjcClassInterfaceNode.self) else {
            return
        }
        guard let classInterfaceName = ctx.classInterfaceName() else {
            return
        }
        
        // Class name
        if let identifier = classInterfaceName.className()?.identifier() {
            let identifierNode = nodeFactory.makeIdentifier(from: identifier)
            classNode.addChild(identifierNode)
        }
        
        // Super class name
        if let sup = classInterfaceName.superclassName() {
            let supName = nodeFactory.makeSuperclassName(from: sup)
            context.addChildNode(supName)
        }
        
        // Protocol list
        if let protocolList = classInterfaceName.protocolList() {
            let protocolListNode =
                nodeFactory.makeProtocolReferenceList(from: protocolList)
            
            context.addChildNode(protocolListNode)
        }

        // Detect static declarations
        pushToGlobalContext(
            makeStaticDeclarationsVisitor().visitClassInterface(ctx)
        )
    }
    
    // MARK: - Class Category
    override func enterCategoryInterface(_ ctx: ObjectiveCParser.CategoryInterfaceContext) {
        guard let classNode = context.currentContextNode(as: ObjcClassCategoryInterfaceNode.self) else {
            return
        }
        
        // Note: In the original Antlr's grammar, 'className' and 'categoryName'
        // seem to be switched around. We undo that here while parsing.
        
        if let className = ctx.categoryName?.identifier() {
            let identifierNode = nodeFactory.makeIdentifier(from: className)
            classNode.addChild(identifierNode)
        }
        
        // Class category name
        if let identifier = ctx.identifier() {
            let identifierNode = nodeFactory.makeIdentifier(from: identifier)
            classNode.addChild(identifierNode)
        }
        
        // Protocol list
        if let protocolList = ctx.protocolList() {
            let protocolListNode =
                nodeFactory.makeProtocolReferenceList(from: protocolList)
            
            context.addChildNode(protocolListNode)
        }

        // Detect static declarations
        pushToGlobalContext(
            makeStaticDeclarationsVisitor().visitCategoryInterface(ctx)
        )
    }
    
    // MARK: - Class Implementation
    override func enterClassImplementation(_ ctx: ObjectiveCParser.ClassImplementationContext) {
        guard let classNode = context.currentContextNode(as: ObjcClassImplementationNode.self) else {
            return
        }
        guard let classImplementationName = ctx.classImplementationName() else {
            return
        }
        
        // Class name
        if let identifier = classImplementationName.className()?.identifier() {
            let identNode = nodeFactory.makeIdentifier(from: identifier)
            classNode.addChild(identNode)
        }
        
        // Super class name
        if let sup = classImplementationName.superclassName() {
            let supName = nodeFactory.makeSuperclassName(from: sup)
            context.addChildNode(supName)
        }

        // Detect static declarations
        pushToGlobalContext(
            makeStaticDeclarationsVisitor().visitClassImplementation(ctx)
        )
    }
    
    override func enterCategoryImplementation(_ ctx: ObjectiveCParser.CategoryImplementationContext) {
        guard let classNode = context.currentContextNode(as: ObjcClassCategoryImplementationNode.self) else {
            return
        }
        
        // Class name
        if let identifier = ctx.className()?.identifier() {
            let identNode = nodeFactory.makeIdentifier(from: identifier)
            classNode.addChild(identNode)
        }
        
        // Category name
        if let identifier = ctx.identifier() {
            let identNode = nodeFactory.makeIdentifier(from: identifier)
            classNode.addChild(identNode)
        }

        // Detect static declarations
        pushToGlobalContext(
            makeStaticDeclarationsVisitor().visitCategoryImplementation(ctx)
        )
    }
    
    // MARK: - Instance Variables
    override func enterVisibilitySection(_ ctx: ObjectiveCParser.VisibilitySectionContext) {
        if let accessModifier = ctx.accessModifier() {
            var accessNode: ObjcKeywordNode?
            let nonnull = isInNonnullContext(accessModifier)
            
            if accessModifier.PRIVATE() != nil {
                accessNode = ObjcKeywordNode(keyword: .atPrivate, isInNonnullContext: nonnull)
            } else if accessModifier.PACKAGE() != nil {
                accessNode = ObjcKeywordNode(keyword: .atPackage, isInNonnullContext: nonnull)
            } else if accessModifier.PROTECTED() != nil {
                accessNode = ObjcKeywordNode(keyword: .atProtected, isInNonnullContext: nonnull)
            } else if accessModifier.PUBLIC() != nil {
                accessNode = ObjcKeywordNode(keyword: .atPublic, isInNonnullContext: nonnull)
            }
            
            if let accessNode = accessNode {
                context.addChildNode(accessNode)
            }
        }

        let delegate = ArrayDefinitionCollectorDelegate()
        let collector = makeDefinitionCollector(delegate: delegate)
        
        var nodes: [ObjcASTNode] = []

        for fieldDeclaration in ctx.fieldDeclaration() {
            nodes.append(contentsOf: collector.collect(from: fieldDeclaration))
        }

        for varDef in delegate.variables {
            let iVar = iVarFromVariableDeclaration(varDef)

            context.addChildNode(iVar)
        }
    }
    
    // MARK: - Protocol Declaration
    override func enterProtocolDeclaration(_ ctx: ObjectiveCParser.ProtocolDeclarationContext) {
        guard context.currentContextNode(as: ObjcProtocolDeclarationNode.self) != nil else {
            return
        }
        
        if let identifier = ctx.protocolName()?.identifier() {
            let identifierNode = nodeFactory.makeIdentifier(from: identifier)
            context.addChildNode(identifierNode)
        }
        
        // Protocol list
        if let protocolList = ctx.protocolList() {
            let protocolListNode =
                nodeFactory.makeProtocolReferenceList(from: protocolList)
            
            context.addChildNode(protocolListNode)
        }

        // Detect static declarations
        pushToGlobalContext(
            makeStaticDeclarationsVisitor().visitProtocolDeclaration(ctx)
        )
    }
    
    override func enterProtocolDeclarationSection(_ ctx: ObjectiveCParser.ProtocolDeclarationSectionContext) {
        inOptionalContext = ctx.OPTIONAL() != nil
    }
    
    override func exitProtocolDeclarationSection(_ ctx: ObjectiveCParser.ProtocolDeclarationSectionContext) {
        inOptionalContext = false
    }
    
    override func exitProtocolDeclaration(_ ctx: ObjectiveCParser.ProtocolDeclarationContext) {
        inOptionalContext = false
    }
    
    // MARK: - Property Declaration
    override func enterPropertyDeclaration(_ ctx: ObjectiveCParser.PropertyDeclarationContext) {
        let listener = PropertyListener(
            isInNonnullContext: isInNonnullContext(ctx),
            typeParser: typeParser,
            nonnullContextQuerier: nonnullContextQuerier,
            commentQuerier: commentQuerier,
            nodeFactory: nodeFactory,
            inOptionalContext: inOptionalContext
        )
        
        let walker = ParseTreeWalker()
        try? walker.walk(listener, ctx)
        
        context.pushContext(node: listener.property)
    }
    
    override func exitPropertyDeclaration(_ ctx: ObjectiveCParser.PropertyDeclarationContext) {
        context.popContext() // ObjcPropertyDefinitionNode
    }
    
    override func enterGenericTypeSpecifier(_ ctx: ObjectiveCParser.GenericTypeSpecifierContext) {
        mapper.pushTemporaryException(forRuleType: ObjectiveCParser.ProtocolListContext.self)
    }
    
    override func exitGenericTypeSpecifier(_ ctx: ObjectiveCParser.GenericTypeSpecifierContext) {
        mapper.popTemporaryException() // ObjectiveCParser.ProtocolListContext
    }
    
    // MARK: - Property implementation
    override func exitPropertyImplementation(_ ctx: ObjectiveCParser.PropertyImplementationContext) {
        guard let node = context.currentContextNode(as: ObjcPropertyImplementationNode.self) else {
            return
        }
        guard let list = node.list else {
            return
        }
        
        for synth in list.synthesizations {
            synth.isDynamic = ctx.DYNAMIC() != nil
        }
    }
    
    override func enterPropertySynthesizeItem(_ ctx: ObjectiveCParser.PropertySynthesizeItemContext) {
        guard let node = context.currentContextNode(as: ObjcPropertySynthesizeItemNode.self) else {
            return
        }
        
        if let propIdentifier = ctx.identifier(0) {
            node.addChild(nodeFactory.makeIdentifier(from: propIdentifier))
        }
        if let ivarIdentifier = ctx.identifier(1) {
            node.addChild(nodeFactory.makeIdentifier(from: ivarIdentifier))
        }
    }
    
    // MARK: - Method Declaration
    override func enterMethodDeclaration(_ ctx: ObjectiveCParser.MethodDeclarationContext) {
        guard let node = context.currentContextNode(as: ObjcMethodDefinitionNode.self) else {
            return
        }
        
        node.isOptionalMethod = inOptionalContext
        node.isClassMethod = ctx.parent is ObjectiveCParser.ClassMethodDeclarationContext
    }
    
    override func enterMethodDefinition(_ ctx: ObjectiveCParser.MethodDefinitionContext) {
        guard let node = context.currentContextNode(as: ObjcMethodDefinitionNode.self) else {
            return
        }

        node.isClassMethod = ctx.parent is ObjectiveCParser.ClassMethodDefinitionContext
        
        let methodBody = nodeFactory.makeMethodBody(from: ctx)
        
        node.body = methodBody
    }
    
    override func enterMethodSelector(_ ctx: ObjectiveCParser.MethodSelectorContext) {
        if let selIdentifier = ctx.selector()?.identifier() {
            let node = nodeFactory.makeIdentifier(from: selIdentifier)
            context.addChildNode(node)
        }
    }

    override func enterMethodType(_ ctx: ObjectiveCParser.MethodTypeContext) {
        guard let typeName = ctx.typeName() else {
            return
        }
        guard let returnType = typeParser.parseObjcType(from: typeName) else {
            return
        }
        
        let node = ObjcTypeNameNode(type: returnType, isInNonnullContext: isInNonnullContext(ctx))
        nodeFactory.updateSourceLocation(for: node, with: ctx)
        context.addChildNode(node)
    }
    
    override func enterKeywordDeclarator(_ ctx: ObjectiveCParser.KeywordDeclaratorContext) {
        guard let node = context.currentContextNode(as: ObjcKeywordDeclaratorNode.self) else {
            return
        }
        
        let selectorIdent =
            (ctx.selector()?.identifier()).map(nodeFactory.makeIdentifier(from:))
        
        let ident =
            ctx.identifier().map(nodeFactory.makeIdentifier(from:))
        
        if let ident = selectorIdent {
            node.addChild(ident)
        }
        if let ident = ident {
            node.addChild(ident)
        }
    }
    
    override func enterEnumerator(_ ctx: ObjectiveCParser.EnumeratorContext) {
        guard let identifier = ctx.enumeratorIdentifier()?.identifier() else {
            return
        }
        
        let enumCase = nodeFactory.makeEnumCase(from: ctx, identifier: identifier)
            
        context.addChildNode(enumCase)
    }
    
    // MARK: - Function Declaration/Definition
    override func enterFunctionDefinition(_ ctx: ObjectiveCParser.FunctionDefinitionContext) {
        let collector = makeDefinitionCollector()

        if let function = collector.collectFunction(from: ctx) {
            context.pushContext(node: function)
        } else {
            context.pushContext(nodeType: ObjcFunctionDefinitionNode.self)
        }
    }

    override func exitFunctionDefinition(_ ctx: ObjectiveCParser.FunctionDefinitionContext) {
        context.popContext() // ObjcFunctionDefinitionNode
    }
    
    private func isInNonnullContext(_ rule: ParserRuleContext) -> Bool {
        nonnullContextQuerier.isInNonnullContext(rule)
    }

    /// Pushes a list of nodes to the global context, ignoring any current
    /// top-most context node in `self.context`.
    private func pushToGlobalContext(_ nodes: [ObjcASTNode]) {
        rootNode.addChildren(nodes)
    }

    /// Converts a `ObjcVariableDeclarationNode` node into an equivalent
    /// `ObjcIVarDeclarationNode` node.
    ///
    /// Nodes will be moved from the original declaration into the new instance
    /// variable declaration.
    ///
    /// The initializer expression is ignored, if it is present.
    private func iVarFromVariableDeclaration(_ varDef: ObjcVariableDeclarationNode) -> ObjcIVarDeclarationNode {
        let iVar = ObjcIVarDeclarationNode(isInNonnullContext: varDef.isInNonnullContext)
        iVar.existsInSource = varDef.existsInSource
        iVar.precedingComments = varDef.precedingComments

        for node in varDef.children {
            varDef.removeChild(node)
            iVar.addChild(node)
        }

        iVar.updateSourceRange()

        return iVar
    }
}

/// Collects `declaration` parser rules that may define global-scoped declarations
/// that can be extracted from an inner context, such as class interface or
/// implementation, out into the global scope.
private class StaticDeclarationsVisitor: ObjectiveCParserVisitor<[ObjcASTNode]> {
    var nodeFactory: ObjcASTNodeFactory
    
    init(nodeFactory: ObjcASTNodeFactory) {
        self.nodeFactory = nodeFactory
    }
    
    private func makeDefinitionCollector(
        delegate: DefinitionCollectorDelegate? = nil
    ) -> DefinitionCollector {

        let collector = DefinitionCollector(
            nonnullContextQuerier: nodeFactory.nonnullContextQuerier,
            nodeFactory: nodeFactory
        )
        collector.delegate = delegate

        return collector
    }

    override func visitClassInterface(_ ctx: ObjectiveCParser.ClassInterfaceContext) -> [ObjcASTNode] {
        guard let interfaceDeclarationList = ctx.interfaceDeclarationList() else {
            return []
        }

        return visitInterfaceDeclarationList(interfaceDeclarationList)
    }

    override func visitCategoryInterface(_ ctx: ObjectiveCParser.CategoryInterfaceContext) -> [ObjcASTNode] {
        guard let interfaceDeclarationList = ctx.interfaceDeclarationList() else {
            return []
        }

        return visitInterfaceDeclarationList(interfaceDeclarationList)
    }

    override func visitClassImplementation(_ ctx: ObjectiveCParser.ClassImplementationContext) -> [ObjcASTNode] {
        guard let implementationDefinitionList = ctx.implementationDefinitionList() else {
            return []
        }

        return visitImplementationDefinitionList(implementationDefinitionList)
    }

    override func visitCategoryImplementation(_ ctx: ObjectiveCParser.CategoryImplementationContext) -> [ObjcASTNode] {
        guard let implementationDefinitionList = ctx.implementationDefinitionList() else {
            return []
        }

        return visitImplementationDefinitionList(implementationDefinitionList)
    }

    override func visitProtocolDeclaration(_ ctx: ObjectiveCParser.ProtocolDeclarationContext) -> [ObjcASTNode] {
        ctx.protocolDeclarationSection().flatMap(visitProtocolDeclarationSection(_:))
    }

    override func visitProtocolDeclarationSection(_ ctx: ObjectiveCParser.ProtocolDeclarationSectionContext) -> [ObjcASTNode] {
        ctx.interfaceDeclarationList().flatMap(visitInterfaceDeclarationList(_:))
    }

    override func visitImplementationDefinitionList(_ ctx: ObjectiveCParser.ImplementationDefinitionListContext) -> [ObjcASTNode] {
        ctx.declaration().flatMap(visitDeclaration(_:))
    }

    override func visitInterfaceDeclarationList(_ ctx: ObjectiveCParser.InterfaceDeclarationListContext) -> [ObjcASTNode] {
        ctx.declaration().flatMap(visitDeclaration(_:))
    }

    override func visitDeclaration(_ ctx: ObjectiveCParser.DeclarationContext) -> [ObjcASTNode] {
        var result: [ObjcASTNode] = []

        let collector = makeDefinitionCollector()
        for decl in collector.collect(from: ctx) {
            switch decl {
            case let decl as ObjcVariableDeclarationNode where decl.isStatic:
                result.append(decl)

            default:
                break
            }
        }

        return result
    }
}

private class PropertyListener: ObjectiveCParserBaseListener {
    var property: ObjcPropertyDefinitionNode
    var typeParser: ObjcTypeParser
    var nonnullContextQuerier: NonnullContextQuerier
    var commentQuerier: CommentQuerier
    var nodeFactory: ObjcASTNodeFactory
    var inOptionalContext: Bool
    
    init(
        isInNonnullContext: Bool,
        typeParser: ObjcTypeParser,
        nonnullContextQuerier: NonnullContextQuerier,
        commentQuerier: CommentQuerier,
        nodeFactory: ObjcASTNodeFactory,
        inOptionalContext: Bool
    ) {
        
        self.property = ObjcPropertyDefinitionNode(isInNonnullContext: isInNonnullContext)
        self.typeParser = typeParser
        self.nonnullContextQuerier = nonnullContextQuerier
        self.commentQuerier = commentQuerier
        self.nodeFactory = nodeFactory
        self.inOptionalContext = inOptionalContext
    }
    
    private func makeDefinitionCollector() -> DefinitionCollector {

        let collector = DefinitionCollector(
            nonnullContextQuerier: nonnullContextQuerier,
            nodeFactory: nodeFactory
        )

        return collector
    }
    
    override func enterPropertyDeclaration(_ ctx: ObjectiveCParser.PropertyDeclarationContext) {
        let node = ObjcKeywordNode(
            keyword: .atProperty,
            isInNonnullContext: nonnullContextQuerier.isInNonnullContext(ctx)
        )
        nodeFactory.updateSourceLocation(for: node, with: ctx)
        property.addChild(node)
        property.precedingComments = commentQuerier.popAllCommentsBefore(rule: ctx)
        
        if ctx.ibOutletQualifier() != nil {
            property.hasIbOutletSpecifier = true
        }
        if ctx.IB_INSPECTABLE() != nil {
            property.hasIbInspectableSpecifier = true
        }

        if let fieldDeclaration = ctx.fieldDeclaration() {
            let collector = makeDefinitionCollector()
            let decls = collector.collect(from: fieldDeclaration)

            // TODO: Support multiple property declarations from a single fieldDeclaration parser rule
            for decl in decls {
                guard let varDecl = decl as? ObjcVariableDeclarationNode else {
                    continue
                }

                transfer(from: varDecl, to: property)
                break
            }
        }
    }
    
    override func enterPropertyAttributesList(_ ctx: ObjectiveCParser.PropertyAttributesListContext) {
        let inNonnull = nonnullContextQuerier.isInNonnullContext(ctx)
        
        let node = ObjcPropertyAttributesListNode(isInNonnullContext: inNonnull)
        nodeFactory.updateSourceLocation(for: node, with: ctx)
        property.addChild(node)
    }
    
    override func enterPropertyAttribute(_ ctx: ObjectiveCParser.PropertyAttributeContext) {
        let modifier: ObjcPropertyAttributeNode.Attribute
        
        if let ident = ctx.identifier()?.getText() {
            modifier = .keyword(ident)
        } else if let selectorName = ctx.selectorName() {
            if ctx.GETTER() != nil {
                modifier = .getter(selectorName.getText())
            } else if ctx.SETTER() != nil {
                modifier = .setter(selectorName.getText())
            } else {
                modifier = .keyword(ctx.getText())
            }
        } else {
            modifier = .keyword(ctx.getText())
        }
        
        let inNonnull = nonnullContextQuerier.isInNonnullContext(ctx)
        
        let node = ObjcPropertyAttributeNode(
            modifier: modifier,
            isInNonnullContext: inNonnull
        )
        nodeFactory.updateSourceLocation(for: node, with: ctx)
        property.attributesList?.addChild(node)
    }

    /// Transfers the configurations of a `ObjcVariableDeclarationNode` node into 
    /// a `PropertyDeclaration` node.
    ///
    /// Nodes will be moved from the original declaration into the provided property
    /// definition node.
    ///
    /// The initializer expression is ignored, if it is present.
    private func transfer(from varDef: ObjcVariableDeclarationNode, to property: ObjcPropertyDefinitionNode) {
        property.isInNonnullContext = varDef.isInNonnullContext
        property.existsInSource = varDef.existsInSource
        property.precedingComments.append(contentsOf: varDef.precedingComments)

        for node in varDef.children {
            varDef.removeChild(node)
            property.addChild(node)
        }

        property.updateSourceRange()
    }
}

private class GenericParseTreeContextMapper {
    private var pairs: [Pair] = []
    private var exceptions: [ParserRuleContext.Type] = []
    
    private var source: Source
    
    private var nonnullContextQuerier: NonnullContextQuerier
    private var commentQuerier: CommentQuerier
    private var nodeFactory: ObjcASTNodeFactory
    
    init(source: Source,
         nonnullContextQuerier: NonnullContextQuerier,
         commentQuerier: CommentQuerier,
         nodeFactory: ObjcASTNodeFactory) {
        
        self.source = source
        self.nonnullContextQuerier = nonnullContextQuerier
        self.commentQuerier = commentQuerier
        self.nodeFactory = nodeFactory
    }
    
    func addRuleMap<T: ParserRuleContext, U: ObjcInitializableNode>(
        rule: T.Type,
        nodeType: U.Type,
        collectComments: Bool = false) {
        
        assert(match(ruleType: rule) == nil, "Duplicated mapping rule for parser rule context \(rule)")
        
        pairs.append(.type(rule: rule, nodeType: nodeType, collectComments: collectComments))
    }
    
    func addRuleMap<T: ParserRuleContext, U: ObjcInitializableNode>(rule: T.Type, node: U) {
        assert(match(ruleType: rule) == nil, "Duplicated mapping rule for parser rule context \(rule)")
        
        pairs.append(.instance(rule: rule, node: node))
    }
    
    func pushTemporaryException(forRuleType ruleType: ParserRuleContext.Type) {
        exceptions.append(ruleType)
    }
    
    func popTemporaryException() {
        exceptions.removeLast()
    }
    
    func matchEnter(rule: ParserRuleContext, context: NodeCreationContext) {
        let ruleType = type(of: rule)
        guard let nodeType = match(ruleType: ruleType) else {
            return
        }
        
        switch nodeType {
        case let .type(_, nodeType, collectComments):
            let node =
                nodeType.init(isInNonnullContext:
                    nonnullContextQuerier.isInNonnullContext(rule))
            
            nodeFactory.updateSourceLocation(for: node, with: rule)
            
            if collectComments {
                node.precedingComments = commentQuerier.popAllCommentsBefore(rule: rule)
            }
            
            context.pushContext(node: node)
            
        case .instance(_, let node):
            context.pushContext(node: node)
        }
    }
    
    func matchExit(rule: ParserRuleContext, context: NodeCreationContext) {
        let ruleType = type(of: rule)
        guard let pair = match(ruleType: ruleType) else {
            return
        }
        
        if let popped = context.popContext() {
            switch pair {
            case .type(_, let nodeType, _):
                assert(type(of: popped) == nodeType)
            case .instance(_, let node):
                assert(popped === node)
            }
        }
    }
    
    private func match(ruleType: ParserRuleContext.Type) -> Pair? {
        if exceptions.contains(where: { $0 == ruleType }) {
            return nil
        }
        
        return pairs.first { $0.ruleType == ruleType }
    }
    
    private enum Pair {
        case type(rule: ParserRuleContext.Type, nodeType: ObjcInitializableNode.Type, collectComments: Bool)
        case instance(rule: ParserRuleContext.Type, node: ObjcInitializableNode)
        
        var ruleType: ParserRuleContext.Type {
            switch self {
            case .type(let rule, _, _):
                return rule
            case .instance(let rule, _):
                return rule
            }
        }
    }
}
