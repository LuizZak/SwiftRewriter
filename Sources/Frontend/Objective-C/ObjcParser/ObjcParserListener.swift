import Antlr4
import ObjcParserAntlr
import ObjcGrammarModels
import GrammarModelBase

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
    
    init(sourceString: String,
         source: Source,
         state: ObjcParserState,
         antlrSettings: AntlrSettings,
         nonnullContextQuerier: NonnullContextQuerier,
         commentQuerier: CommentQuerier) {
        
        self.sourceString = sourceString
        self.source = source
        self.nonnullContextQuerier = nonnullContextQuerier
        self.commentQuerier = commentQuerier
        self.nodeFactory =
            ObjcASTNodeFactory(source: source,
                           nonnullContextQuerier: nonnullContextQuerier,
                           commentQuerier: commentQuerier)
        
        typeParser = ObjcTypeParser(state: state, antlrSettings: antlrSettings)
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
            nodeType: ObjcMethodSelectorNide.self
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
            rule: O.TypedefDeclarationContext.self,
            nodeType: ObjcTypedefNode.self,
            collectComments: true
        )
        mapper.addRuleMap(
            rule: O.BlockParametersContext.self,
            nodeType: ObjcBlockParametersNode.self
        )
        mapper.addRuleMap(
            rule: O.ProtocolDeclarationContext.self,
            nodeType: ObjcProtocolDeclarationNode.self,
            collectComments: true
        )
        mapper.addRuleMap(
            rule: O.EnumDeclarationContext.self,
            nodeType: ObjcEnumDeclarationNode.self,
            collectComments: true
        )
        mapper.addRuleMap(
            rule: O.FunctionDeclarationContext.self,
            nodeType: ObjcFunctionDefinitionNode.self,
            collectComments: true
        )
        mapper.addRuleMap(
            rule: O.FunctionDefinitionContext.self,
            nodeType: ObjcFunctionDefinitionNode.self,
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
    
    override func enterEveryRule(_ ctx: ParserRuleContext) {
        mapper.matchEnter(rule: ctx, context: context)
    }
    
    override func exitEveryRule(_ ctx: ParserRuleContext) {
        mapper.matchExit(rule: ctx, context: context)
    }
    
    // MARK: - Global Context
    override func enterTranslationUnit(_ ctx: ObjectiveCParser.TranslationUnitContext) {
        // Collect global variables
        let globalVariableListener =
            GlobalVariableListener(typeParser: typeParser,
                                   nonnullContextQuerier: nonnullContextQuerier,
                                   commentQuerier: commentQuerier,
                                   nodeFactory: nodeFactory)
        
        let walker = ParseTreeWalker()
        try? walker.walk(globalVariableListener, ctx)
        
        for global in globalVariableListener.declarations {
            context.addChildNode(global)
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
        if let sup = classInterfaceName.genericSuperclassName(), let ident = sup.identifier() {
            let supName = nodeFactory.makeSuperclassName(from: sup, identifier: ident)
            context.addChildNode(supName)
        }
        
        // Protocol list
        if let protocolList = classInterfaceName.protocolList() {
            let protocolListNode =
                nodeFactory.makeProtocolReferenceList(from: protocolList)
            
            context.addChildNode(protocolListNode)
        }
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
    }
    
    // MARK: - Class Implementation
    override func enterClassImplementation(_ ctx: ObjectiveCParser.ClassImplementationContext) {
        guard let classNode = context.currentContextNode(as: ObjcClassImplementationNode.self) else {
            return
        }
        guard let classImplementationName = ctx.classImplementatioName() else {
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
        
        let declarations = ctx.fieldDeclaration()
        
        for decl in declarations {
            guard let specifierQualifierList = decl.specifierQualifierList() else {
                continue
            }
            guard let fieldDeclarators = decl.fieldDeclaratorList()?.fieldDeclarator() else {
                continue
            }
            
            for fieldDeclarator in fieldDeclarators {
                guard let declarator = fieldDeclarator.declarator() else {
                    continue
                }
                guard let identifier = VarDeclarationIdentifierNameExtractor.extract(from: declarator) else {
                    continue
                }
                guard let type = typeParser.parseObjcType(in: specifierQualifierList,
                                                          declarator: declarator) else {
                    continue
                }
                
                let nonnull = isInNonnullContext(fieldDeclarator)
                
                let typeNode = ObjcTypeNameNode(type: type, isInNonnullContext: nonnull)
                let ident = nodeFactory.makeIdentifier(from: identifier)
                nodeFactory.updateSourceLocation(for: typeNode, with: fieldDeclarator)
                
                let ivar = ObjcIVarDeclarationNode(isInNonnullContext: nonnull)
                ivar.precedingComments = commentQuerier.popClosestCommentsBefore(node: decl)
                ivar.addChild(typeNode)
                ivar.addChild(ident)
                ivar.updateSourceRange()
                
                context.addChildNode(ivar)
            }
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
        let listener = PropertyListener(isInNonnullContext: isInNonnullContext(ctx),
                                        typeParser: typeParser,
                                        nonnullContextQuerier: nonnullContextQuerier,
                                        commentQuerier: commentQuerier,
                                        inOptionalContext: inOptionalContext,
                                        updateSourceLocation: nodeFactory.updateSourceLocation)
        
        let walker = ParseTreeWalker()
        try? walker.walk(listener, ctx)
        
        context.pushContext(node: listener.property)
    }
    
    override func exitPropertyDeclaration(_ ctx: ObjectiveCParser.PropertyDeclarationContext) {
        context.popContext()
    }
    
    override func enterTypeName(_ ctx: ObjectiveCParser.TypeNameContext) {
        guard let type = typeParser.parseObjcType(from: ctx) else {
            return
        }
        
        let node = ObjcTypeNameNode(type: type, isInNonnullContext: isInNonnullContext(ctx))
        nodeFactory.updateSourceLocation(for: node, with: ctx)
        context.addChildNode(node)
    }
    
    override func enterGenericTypeSpecifier(_ ctx: ObjectiveCParser.GenericTypeSpecifierContext) {
        mapper.pushTemporaryException(forRuleType: ObjectiveCParser.ProtocolListContext.self)
    }
    
    override func exitGenericTypeSpecifier(_ ctx: ObjectiveCParser.GenericTypeSpecifierContext) {
        mapper.popTemporaryException() // ObjectiveCParser.ProtocolListContext
    }
    
    override func enterNullabilitySpecifier(_ ctx: ObjectiveCParser.NullabilitySpecifierContext) {
        let spec = nodeFactory.makeNullabilitySpecifier(from: ctx)
        context.addChildNode(spec)
    }
    
    // MARM: - Property implementaiton
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
    
    // MARK: - Typedef
    
    override func enterTypedefDeclaration(_ ctx: ObjectiveCParser.TypedefDeclarationContext) {
        guard let typedefNode = context.currentContextNode(as: ObjcTypedefNode.self) else {
            return
        }
        
        if let functionPointer = ctx.functionPointer() {
            // TODO: FunctionPointerVisitor may be better off being a listener
            // instead of a visitor due to this awkward use case?
            let visitor =
                FunctionPointerVisitor(typedefNode: typedefNode,
                                       typeParser: typeParser,
                                       nonnullContextQuerier: nonnullContextQuerier,
                                       nodeFactory: nodeFactory)
            
            _=functionPointer.accept(visitor)
            
            return
        }
        
        guard let typeDeclaratorList = ctx.typeDeclaratorList() else {
            return
        }
        
        // Collect structs
        let listener = StructListener(typeParser: typeParser,
                                      nonnullContextQuerier: nonnullContextQuerier,
                                      nodeFactory: nodeFactory)
        let walker = ParseTreeWalker()
        try? walker.walk(listener, ctx)
        
        typedefNode.addChildren(listener.structs)
        
        for (i, typeDeclarator) in typeDeclaratorList.declarator().enumerated() {
            let declarator = nodeFactory.makeTypeDeclarator(from: typeDeclarator)
            
            // Tie first declarator to any pointer from the type specifier of the
            // struct declaration, recording it as a typealias to a pointer type.
            if i == 0, let pointer = ctx.declarationSpecifiers()?.typeSpecifier(0)?.pointer() {
                declarator.addChild(nodeFactory.makePointer(from: pointer))
            }
            
            typedefNode.addChild(declarator)
        }
    }
    
    override func exitTypedefDeclaration(_ ctx: ObjectiveCParser.TypedefDeclarationContext) {
        guard let typedefNode = context.currentContextNode(as: ObjcTypedefNode.self) else {
            return
        }
        
        guard let declarationSpecifiers = ctx.declarationSpecifiers() else {
            return
        }
        guard let typeDeclaratorList = ctx.typeDeclaratorList() else {
            return
        }
        
        // Detect block types
        for typeDeclarator in typeDeclaratorList.declarator() {
            guard let directDeclarator = typeDeclarator.directDeclarator() else {
                continue
            }
            guard let identifier = directDeclarator.identifier() else {
                continue
            }
            
            guard let type = typeParser.parseObjcType(in: declarationSpecifiers,
                                                      declarator: typeDeclarator) else {
                continue
            }
            
            typedefNode.addChild(nodeFactory.makeIdentifier(from: identifier))
            
            let typeNameNode = ObjcTypeNameNode(type: type,
                                            isInNonnullContext: isInNonnullContext(ctx))
            nodeFactory.updateSourceLocation(for: typeNameNode, with: typeDeclarator)
            typedefNode.addChild(typeNameNode)
        }
    }
    
    override func enterEnumDeclaration(_ ctx: ObjectiveCParser.EnumDeclarationContext) {
        guard let enumSpecifier = ctx.enumSpecifier() else {
            return
        }
        
        guard let enumNode = context.currentContextNode(as: ObjcEnumDeclarationNode.self) else {
            return
        }
        
        let isObjcEnum = enumSpecifier.NS_ENUM() != nil || enumSpecifier.NS_OPTIONS() != nil
        
        enumNode.isOptionSet = enumSpecifier.NS_OPTIONS() != nil
        
        if let identifier = enumSpecifier.identifier(isObjcEnum ? 0 : 1) {
            enumNode.addChild(nodeFactory.makeIdentifier(from: identifier))
        }
    }
    
    override func enterEnumerator(_ ctx: ObjectiveCParser.EnumeratorContext) {
        guard let identifier = ctx.enumeratorIdentifier()?.identifier() else {
            return
        }
        
        let enumCase = nodeFactory.makeEnumCase(from: ctx, identifier: identifier)
            
        context.addChildNode(enumCase)
    }
    
    override func enterBlockParameters(_ ctx: ObjectiveCParser.BlockParametersContext) {
        for typeVariableDeclaratorOrName in ctx.typeVariableDeclaratorOrName() {
            guard let type
                = typeParser.parseObjcType(from: typeVariableDeclaratorOrName) else {
                continue
            }
            
            let typeNameNode =
                ObjcTypeNameNode(type: type,
                             isInNonnullContext: isInNonnullContext(typeVariableDeclaratorOrName))
            nodeFactory.updateSourceLocation(for: typeNameNode, with: typeVariableDeclaratorOrName)
            context.addChildNode(typeNameNode)
        }
    }
    
    // MARK: - Function Declaration/Definition
    override func enterFunctionDefinition(_ ctx: ObjectiveCParser.FunctionDefinitionContext) {
        guard let function = context.currentContextNode(as: ObjcFunctionDefinitionNode.self) else {
            return
        }
        guard let compoundStatement = ctx.compoundStatement() else {
            return
        }
        
        let body = nodeFactory.makeMethodBody(from: compoundStatement)
        
        function.addChild(body)
    }
    
    override func enterFunctionSignature(_ ctx: ObjectiveCParser.FunctionSignatureContext) {
        guard let function = context.currentContextNode(as: ObjcFunctionDefinitionNode.self) else {
            return
        }
        
        if let declarationSpecifiers = ctx.declarationSpecifiers() {
            let returnType = typeParser.parseObjcType(in: declarationSpecifiers)
            
            if let returnType = returnType {
                let typeNameNode =
                    ObjcTypeNameNode(type: returnType,
                                 isInNonnullContext: isInNonnullContext(declarationSpecifiers))
                nodeFactory.updateSourceLocation(for: typeNameNode, with: declarationSpecifiers)
                function.addChild(typeNameNode)
            }
        }
        
        if let identifier = ctx.identifier() {
            function.addChild(nodeFactory.makeIdentifier(from: identifier))
        }
        
        // Parameter list
        context.pushContext(nodeType: ObjcParameterListNode.self)
        defer {
            context.popContext()
        }
        
        if let params = ctx.parameterList(), let paramDecl = params.parameterDeclarationList() {
            for param in paramDecl.parameterDeclaration() {
                context.pushContext(nodeType: ObjcFunctionParameterNode.self)
                defer {
                    context.popContext()
                }
                
                guard let declarationSpecifiers = param.declarationSpecifiers() else {
                    continue
                }
                guard let declarator = param.declarator() else {
                    continue
                }
                guard let identifier = VarDeclarationIdentifierNameExtractor.extract(from: declarator) else {
                    continue
                }
                guard let type = typeParser.parseObjcType(in: declarationSpecifiers,
                                                          declarator: declarator) else {
                    continue
                }
                
                let identifierNode = nodeFactory.makeIdentifier(from: identifier)
                context.addChildNode(identifierNode)
                
                let typeNode = ObjcTypeNameNode(type: type,
                                            isInNonnullContext: isInNonnullContext(param))
                nodeFactory.updateSourceLocation(for: typeNode, with: param)
                context.addChildNode(typeNode)
            }
            
            if params.ELIPSIS() != nil {
                let variadicParameter =
                    ObjcVariadicParameterNode(isInNonnullContext: isInNonnullContext(ctx))
                nodeFactory.updateSourceLocation(for: variadicParameter, with: params)
                context.addChildNode(variadicParameter)
            }
        }
    }
    
    private func isInNonnullContext(_ rule: ParserRuleContext) -> Bool {
        nonnullContextQuerier.isInNonnullContext(rule)
    }
}

private class GlobalVariableListener: ObjectiveCParserBaseListener {
    var declarations: [ObjcASTNode] = []
    var typeParser: ObjcTypeParser
    var nonnullContextQuerier: NonnullContextQuerier
    var commentQuerier: CommentQuerier
    var nodeFactory: ObjcASTNodeFactory
    
    init(typeParser: ObjcTypeParser,
         nonnullContextQuerier: NonnullContextQuerier,
         commentQuerier: CommentQuerier,
         nodeFactory: ObjcASTNodeFactory) {
        
        self.typeParser = typeParser
        self.nonnullContextQuerier = nonnullContextQuerier
        self.commentQuerier = commentQuerier
        self.nodeFactory = nodeFactory
    }
    
    // Pick global variable declarations on top level
    override func enterTranslationUnit(_ ctx: ObjectiveCParser.TranslationUnitContext) {
        let topLevelDeclarations = ctx.topLevelDeclaration()
        let visitor = GlobalVariableVisitor(typeParser: typeParser,
                                            nonnullContextQuerier: nonnullContextQuerier,
                                            commentQuerier: commentQuerier,
                                            nodeFactory: nodeFactory)
        
        for topLevelDeclaration in topLevelDeclarations {
            guard let declaration = topLevelDeclaration.declaration() else { continue }
            guard let varDeclaration = declaration.varDeclaration() else { continue }
            
            if let vars = varDeclaration.accept(visitor) {
                declarations.append(contentsOf: vars)
            }
        }
    }
    
    // Pick global variable declarations that are beneath the top-level, like inside
    // class @interface/@implementations etc.
    override func enterVarDeclaration(_ ctx: ObjectiveCParser.VarDeclarationContext) {
        if ctx.context.scope != .class || !ctx.context.isStatic {
            return
        }
        
        let visitor =
            GlobalVariableVisitor(typeParser: typeParser,
                                  nonnullContextQuerier: nonnullContextQuerier,
                                  commentQuerier: commentQuerier,
                                  nodeFactory: nodeFactory)
        
        if let vars = ctx.accept(visitor) {
            declarations.append(contentsOf: vars)
        }
    }
    
    private class GlobalVariableVisitor: ObjectiveCParserBaseVisitor<[ObjcASTNode]> {
        var typeParser: ObjcTypeParser
        var nonnullContextQuerier: NonnullContextQuerier
        var commentQuerier: CommentQuerier
        var nodeFactory: ObjcASTNodeFactory
        
        init(typeParser: ObjcTypeParser,
             nonnullContextQuerier: NonnullContextQuerier,
             commentQuerier: CommentQuerier,
             nodeFactory: ObjcASTNodeFactory) {
            
            self.typeParser = typeParser
            self.nonnullContextQuerier = nonnullContextQuerier
            self.commentQuerier = commentQuerier
            self.nodeFactory = nodeFactory
        }
        
        override func visitVarDeclaration(_ ctx: ObjectiveCParser.VarDeclarationContext) -> [ObjcASTNode]? {
            var declarations: [ObjcASTNode] = []
            
            // Free struct/union declarators
            if let typeSpecifiers = ctx.declarationSpecifiers()?.typeSpecifier() {
                for specifier in typeSpecifiers {
                    if let vars = specifier.accept(self) {
                        declarations.append(contentsOf: vars)
                    }
                }
            }
            
            guard let initDeclarators = ctx.initDeclaratorList()?.initDeclarator() else {
                return declarations
            }
            
            let allTypes = VarDeclarationTypeStringExtractor.extractAll(from: ctx)
            
            for (initDeclarator, typeString) in zip(initDeclarators, allTypes) {
                guard let identifier = initDeclarator.declarator()?.directDeclarator()?.identifier() else { continue }
                
                // Get a type string to convert into a proper type
                guard let type = typeParser.parseObjcType(typeString) else { continue }
                
                let inNonnull = nonnullContextQuerier.isInNonnullContext(initDeclarator)
                
                let varDecl = ObjcVariableDeclarationNode(isInNonnullContext: inNonnull)
                varDecl.precedingComments = commentQuerier.popClosestCommentsBefore(node: ctx)
                
                let identifierNode = nodeFactory.makeIdentifier(from: identifier)
                let typeNameNode = ObjcTypeNameNode(type: type, isInNonnullContext: inNonnull)
                nodeFactory.updateSourceLocation(for: typeNameNode, with: ctx)
                
                varDecl.addChild(identifierNode)
                varDecl.addChild(typeNameNode)
                
                if let initializer = initDeclarator.initializer() {
                    let expression = ObjcExpressionNode(isInNonnullContext: inNonnull)
                    expression.expression = initializer.expression()
                    if let exp = initializer.expression() {
                        nodeFactory.updateSourceLocation(for: expression, with: exp)
                    }
                    let constantExpression = ObjcConstantExpressionNode(isInNonnullContext: inNonnull)
                    constantExpression.addChild(expression)
                    constantExpression.updateSourceRange()
                    let initialExpression = ObjcInitialExpressionNode(isInNonnullContext: inNonnull)
                    initialExpression.addChild(constantExpression)
                    initialExpression.updateSourceRange()
                    
                    varDecl.addChild(initialExpression)
                }
                
                varDecl.updateSourceRange()
                
                declarations.append(varDecl)
            }
            
            return declarations
        }
        
        override func visitTypeSpecifier(_ ctx: ObjectiveCParser.TypeSpecifierContext) -> [ObjcASTNode]? {
            
            if ctx.structOrUnionSpecifier() != nil {
                let structListener =
                    StructListener(typeParser: typeParser,
                                   nonnullContextQuerier: nonnullContextQuerier,
                                   nodeFactory: nodeFactory)
                
                let walker = ParseTreeWalker()
                try? walker.walk(structListener, ctx)
                
                return structListener.structs
            }
            
            return nil
        }
    }
}

private class StructListener: ObjectiveCParserBaseListener {
    var structs: [ObjcStructDeclarationNode] = []
    var typeParser: ObjcTypeParser
    var nonnullContextQuerier: NonnullContextQuerier
    var nodeFactory: ObjcASTNodeFactory
    
    init(typeParser: ObjcTypeParser,
         nonnullContextQuerier: NonnullContextQuerier,
         nodeFactory: ObjcASTNodeFactory) {
        
        self.typeParser = typeParser
        self.nonnullContextQuerier = nonnullContextQuerier
        self.nodeFactory = nodeFactory
    }
    
    override func enterStructOrUnionSpecifier(_ ctx: ObjectiveCParser.StructOrUnionSpecifierContext) {
        guard ctx.STRUCT() != nil else {
            return
        }
        
        let inNonnull = nonnullContextQuerier.isInNonnullContext(ctx)
        
        let str = ObjcStructDeclarationNode(isInNonnullContext: inNonnull)
        nodeFactory.updateSourceLocation(for: str, with: ctx)
        
        if let identifier = ctx.identifier() {
            let identifier = nodeFactory.makeIdentifier(from: identifier)
            
            str.addChild(identifier)
        }
        
        // Declaration body
        if ctx.LBRACE() != nil {
            let body = ObjcStructDeclarationBodyNode(isInNonnullContext: inNonnull)
            
            str.addChild(body)
            
            for fieldDeclaration in ctx.fieldDeclaration() {
                let names
                    = VarDeclarationIdentifierNameExtractor
                        .extractAll(from: fieldDeclaration)
                
                let types
                    = typeParser.parseObjcTypes(in: fieldDeclaration)
                
                for (type, identifier) in zip(types, names) {
                    let field = ObjcStructFieldNode(isInNonnullContext: inNonnull)
                    
                    let identifierNode = nodeFactory.makeIdentifier(from: identifier)
                    
                    let typeNode = ObjcTypeNameNode(type: type, isInNonnullContext: inNonnull)
                    nodeFactory.updateSourceLocation(for: typeNode, with: fieldDeclaration)
                    
                    field.addChild(identifierNode)
                    field.addChild(typeNode)
                    nodeFactory.updateSourceLocation(for: field, with: fieldDeclaration)
                    
                    body.addChild(field)
                }
            }
        }
        
        structs.append(str)
    }
}

private class PropertyListener: ObjectiveCParserBaseListener {
    var property: ObjcPropertyDefinitionNode
    var typeParser: ObjcTypeParser
    var nonnullContextQuerier: NonnullContextQuerier
    var commentQuerier: CommentQuerier
    var inOptionalContext: Bool
    var updateSourceLocation: (ObjcASTNode, ParserRuleContext) -> Void
    
    init(isInNonnullContext: Bool,
         typeParser: ObjcTypeParser,
         nonnullContextQuerier: NonnullContextQuerier,
         commentQuerier: CommentQuerier,
         inOptionalContext: Bool,
         updateSourceLocation: @escaping (ObjcASTNode, ParserRuleContext) -> Void) {
        
        self.property = ObjcPropertyDefinitionNode(isInNonnullContext: isInNonnullContext)
        self.typeParser = typeParser
        self.nonnullContextQuerier = nonnullContextQuerier
        self.commentQuerier = commentQuerier
        self.inOptionalContext = inOptionalContext
        self.updateSourceLocation = updateSourceLocation
    }
    
    override func enterPropertyDeclaration(_ ctx: ObjectiveCParser.PropertyDeclarationContext) {
        
        let node =
            ObjcKeywordNode(keyword: .atProperty,
                        isInNonnullContext: nonnullContextQuerier.isInNonnullContext(ctx))
        updateSourceLocation(node, ctx)
        property.addChild(node)
        property.precedingComments = commentQuerier.popClosestCommentsBefore(node: ctx)
        
        if ctx.ibOutletQualifier() != nil {
            property.hasIbOutletSpecifier = true
        }
        if ctx.IB_INSPECTABLE() != nil {
            property.hasIbInspectableSpecifier = true
        }
        
        if let ident =
            ctx.fieldDeclaration()?
                .fieldDeclaratorList()?
                .fieldDeclarator(0)?
                .declarator()?
                .directDeclarator()?
                .identifier() {
            
            let inNonnull = nonnullContextQuerier.isInNonnullContext(ident)
            
            let node = ObjcIdentifierNode(
                name: ident.getText(),
                isInNonnullContext: inNonnull
            )
            updateSourceLocation(node, ident)
            
            property.addChild(node)
        }
        
        guard let fieldDeclaration = ctx.fieldDeclaration() else {
            return
        }
        guard let specQualifier = fieldDeclaration.specifierQualifierList() else {
            return
        }
        guard let declarator = fieldDeclaration.fieldDeclaratorList()?.fieldDeclarator().first?.declarator() else {
            return
        }
        
        let inNonnull = nonnullContextQuerier.isInNonnullContext(fieldDeclaration)
        
        if let type = typeParser.parseObjcType(in: specQualifier, declarator: declarator) {
            let typeNode = ObjcTypeNameNode(type: type, isInNonnullContext: inNonnull)
            updateSourceLocation(typeNode, fieldDeclaration)
            property.addChild(typeNode)
        }
    }
    
    override func enterPropertyAttributesList(_ ctx: ObjectiveCParser.PropertyAttributesListContext) {
        let inNonnull = nonnullContextQuerier.isInNonnullContext(ctx)
        
        let node = ObjcPropertyAttributesListNode(isInNonnullContext: inNonnull)
        updateSourceLocation(node, ctx)
        property.addChild(node)
    }
    
    override func enterPropertyAttribute(_ ctx: ObjectiveCParser.PropertyAttributeContext) {
        let modifier: ObjcPropertyAttributeNode.Attribute
        
        if let ident = ctx.identifier()?.getText() {
            if ctx.GETTER() != nil {
                modifier = .getter(ident)
            } else if ctx.SETTER() != nil {
                modifier = .setter(ident)
            } else {
                modifier = .keyword(ident)
            }
        } else {
            modifier = .keyword(ctx.getText())
        }
        
        let inNonnull = nonnullContextQuerier.isInNonnullContext(ctx)
        
        let node = ObjcPropertyAttributeNode(modifier: modifier,
                                         isInNonnullContext: inNonnull)
        updateSourceLocation(node, ctx)
        property.attributesList?.addChild(node)
    }
}

private class FunctionPointerVisitor: ObjectiveCParserBaseVisitor<ObjcTypedefNode> {
    
    var typedefNode: ObjcTypedefNode
    var typeParser: ObjcTypeParser
    var nonnullContextQuerier: NonnullContextQuerier
    var nodeFactory: ObjcASTNodeFactory
    
    init(typedefNode: ObjcTypedefNode,
         typeParser: ObjcTypeParser,
         nonnullContextQuerier: NonnullContextQuerier,
         nodeFactory: ObjcASTNodeFactory) {
        
        self.typedefNode = typedefNode
        self.typeParser = typeParser
        self.nonnullContextQuerier = nonnullContextQuerier
        self.nodeFactory = nodeFactory
    }
    
    override func visitFunctionPointer(_ ctx: ObjectiveCParser.FunctionPointerContext) -> ObjcTypedefNode? {
        guard let identifier = VarDeclarationIdentifierNameExtractor.extract(from: ctx) else {
            return nil
        }
        guard let type = typeParser.parseObjcType(from: ctx) else {
            return nil
        }
        
        let inNonnull = nonnullContextQuerier.isInNonnullContext(ctx)
        
        let identifierNode = nodeFactory.makeIdentifier(from: identifier)
        let typeNameNode = ObjcTypeNameNode(type: type, isInNonnullContext: inNonnull)
        nodeFactory.updateSourceLocation(for: typeNameNode, with: ctx)
        
        typedefNode.addChild(identifierNode)
        typedefNode.addChild(typeNameNode)
        
        nodeFactory.updateSourceLocation(for: typedefNode, with: ctx)
        
        return nil
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
                node.precedingComments = commentQuerier.popClosestCommentsBefore(node: rule)
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
