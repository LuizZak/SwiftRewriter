import GrammarModels
import Antlr4
import ObjcParserAntlr

internal class ObjcParserListener: ObjectiveCParserBaseListener {
    let context: NodeCreationContext
    let rootNode: GlobalContextNode
    let typeParser: TypeParsing
    private let mapper: GenericParseTreeContextMapper
    private let sourceString: String
    private let source: Source
    
    /// Whether the listener is currently visiting a @protocol section that was
    /// marked @optional.
    private var inOptionalContext: Bool = false
    
    init(sourceString: String, source: Source, state: ObjcParserState) {
        self.sourceString = sourceString
        self.source = source
        self.typeParser = TypeParsing(state: state)
        
        context = NodeCreationContext()
        context.autoUpdatesSourceRange = false
        rootNode = GlobalContextNode()
        mapper = GenericParseTreeContextMapper(source: source)
        
        super.init()
        
        configureMappers()
    }
    
    private func sourceLocation(for rule: ParserRuleContext) -> SourceLocation {
        guard let startIndex = rule.start?.getStartIndex(), let endIndex = rule.stop?.getStopIndex() else {
            return .invalid
        }
        
        let sourceStartIndex = source.stringIndex(forCharOffset: startIndex)
        let sourceEndIndex = source.stringIndex(forCharOffset: endIndex)
        
        return SourceLocation(source: source, range: .range(sourceStartIndex..<sourceEndIndex))
    }
    
    /// Configures mappers in `self.mapper` so they are automatically pushed and
    /// popped whenever the rules are entered and exited during visit.
    ///
    /// Used as a convenience over manually pushing and popping contexts every time
    /// a node of significance is entered.
    private func configureMappers() {
        mapper.addRuleMap(rule: ObjectiveCParser.TranslationUnitContext.self, node: rootNode)
        mapper.addRuleMap(rule: ObjectiveCParser.ClassInterfaceContext.self, nodeType: ObjcClassInterface.self)
        mapper.addRuleMap(rule: ObjectiveCParser.ClassImplementationContext.self, nodeType: ObjcClassImplementation.self)
        mapper.addRuleMap(rule: ObjectiveCParser.CategoryInterfaceContext.self, nodeType: ObjcClassCategoryInterface.self)
        mapper.addRuleMap(rule: ObjectiveCParser.CategoryImplementationContext.self, nodeType: ObjcClassCategoryImplementation.self)
        mapper.addRuleMap(rule: ObjectiveCParser.MethodDeclarationContext.self, nodeType: MethodDefinition.self)
        mapper.addRuleMap(rule: ObjectiveCParser.MethodDefinitionContext.self, nodeType: MethodDefinition.self)
        mapper.addRuleMap(rule: ObjectiveCParser.KeywordDeclaratorContext.self, nodeType: KeywordDeclarator.self)
        mapper.addRuleMap(rule: ObjectiveCParser.MethodSelectorContext.self, nodeType: MethodSelector.self)
        mapper.addRuleMap(rule: ObjectiveCParser.MethodTypeContext.self, nodeType: MethodType.self)
        mapper.addRuleMap(rule: ObjectiveCParser.InstanceVariablesContext.self, nodeType: IVarsList.self)
        mapper.addRuleMap(rule: ObjectiveCParser.TypedefDeclarationContext.self, nodeType: TypedefNode.self)
        mapper.addRuleMap(rule: ObjectiveCParser.BlockParametersContext.self, nodeType: BlockParametersNode.self)
        mapper.addRuleMap(rule: ObjectiveCParser.ProtocolDeclarationContext.self, nodeType: ProtocolDeclaration.self)
        mapper.addRuleMap(rule: ObjectiveCParser.EnumDeclarationContext.self, nodeType: ObjcEnumDeclaration.self)
        mapper.addRuleMap(rule: ObjectiveCParser.FunctionDeclarationContext.self, nodeType: FunctionDefinition.self)
        mapper.addRuleMap(rule: ObjectiveCParser.FunctionDefinitionContext.self, nodeType: FunctionDefinition.self)
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
        let globalVariableListener = GlobalVariableListener(typeParser: typeParser)
        let walker = ParseTreeWalker()
        try? walker.walk(globalVariableListener, ctx)
        
        for global in globalVariableListener.variables {
            context.addChildNode(global)
        }
    }
    
    // MARK: - Class Interface
    override func enterClassInterface(_ ctx: ObjectiveCParser.ClassInterfaceContext) {
        guard let classNode = context.currentContextNode(as: ObjcClassInterface.self) else {
            return
        }
        
        // Class name
        if let identifier = ctx.className()?.identifier() {
            let identifierNode = Identifier(name: identifier.getText())
            identifierNode.sourceRuleContext = identifier
            classNode.addChild(identifierNode)
        }
        
        // Super class name
        if let sup = ctx.superclassName()?.getText() {
            let supName = SuperclassName(name: sup)
            supName.sourceRuleContext = ctx.superclassName()
            context.addChildNode(supName)
        }
        
        // Protocol list
        if let protocolList = ctx.protocolList() {
            let protocolListNode = ProtocolReferenceList()
            protocolListNode.sourceRuleContext = protocolList
            
            for prot in protocolList.protocolName() {
                guard let identifier = prot.identifier() else {
                    continue
                }
                
                let protNameNode = ProtocolName(name: identifier.getText())
                protNameNode.sourceRuleContext = identifier
                protocolListNode.addChild(protNameNode)
            }
            
            context.addChildNode(protocolListNode)
        }
    }
    
    // MARK: - Class Category
    override func enterCategoryInterface(_ ctx: ObjectiveCParser.CategoryInterfaceContext) {
        guard let classNode = context.currentContextNode(as: ObjcClassCategoryInterface.self) else {
            return
        }
        
        // Note: In the original Antlr's grammar, 'className' and 'categoryName'
        // seem to be switched around. We undo that here while parsing.
        
        if let className = ctx.categoryName?.identifier() {
            let identifierNode = Identifier(name: className.getText())
            identifierNode.sourceRuleContext = ctx.className()
            classNode.addChild(identifierNode)
        }
        
        // Class category name
        if let identifier = ctx.identifier() {
            let identifierNode = Identifier(name: identifier.getText())
            identifierNode.sourceRuleContext = identifier
            classNode.addChild(identifierNode)
        }
        
        // Protocol list
        if let protocolList = ctx.protocolList() {
            let protocolListNode = ProtocolReferenceList()
            protocolListNode.sourceRuleContext = protocolList
            
            for prot in protocolList.protocolName() {
                guard let identifier = prot.identifier() else {
                    continue
                }
                
                let protNameNode = ProtocolName(name: identifier.getText())
                protNameNode.sourceRuleContext = identifier
                protocolListNode.addChild(protNameNode)
            }
            
            context.addChildNode(protocolListNode)
        }
    }
    
    // MARK: - Class Implementation
    override func enterClassImplementation(_ ctx: ObjectiveCParser.ClassImplementationContext) {
        guard let classNode = context.currentContextNode(as: ObjcClassImplementation.self) else {
            return
        }
        
        // Class name
        if let identifier = ctx.className()?.identifier() {
            let identNode = Identifier(name: identifier.getText())
            identNode.sourceRuleContext = identifier
            classNode.addChild(identNode)
        }
        
        // Super class name
        if let sup = ctx.superclassName()?.getText() {
            let supName = SuperclassName(name: sup)
            supName.sourceRuleContext = ctx.superclassName()
            context.addChildNode(supName)
        }
    }
    
    override func enterCategoryImplementation(_ ctx: ObjectiveCParser.CategoryImplementationContext) {
        guard let classNode = context.currentContextNode(as: ObjcClassCategoryImplementation.self) else {
            return
        }
        
        // Class name
        if let identifier = ctx.className()?.identifier() {
            let identNode = Identifier(name: identifier.getText())
            identNode.sourceRuleContext = identifier
            classNode.addChild(identNode)
        }
        
        // Category name
        if let identifier = ctx.identifier() {
            let identNode = Identifier(name: identifier.getText())
            identNode.sourceRuleContext = identifier
            classNode.addChild(identNode)
        }
    }
    
    // MARK: - Instance Variables
    override func enterVisibilitySection(_ ctx: ObjectiveCParser.VisibilitySectionContext) {
        if let accessModifier = ctx.accessModifier() {
            var accessNode: KeywordNode?
            
            if accessModifier.PRIVATE() != nil {
                accessNode = KeywordNode(keyword: .atPrivate)
            } else if accessModifier.PACKAGE() != nil {
                accessNode = KeywordNode(keyword: .atPackage)
            } else if accessModifier.PROTECTED() != nil {
                accessNode = KeywordNode(keyword: .atProtected)
            } else if accessModifier.PUBLIC() != nil {
                accessNode = KeywordNode(keyword: .atPublic)
            }
            
            if let accessNode = accessNode {
                accessNode.sourceRuleContext = accessModifier
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
                guard let type = typeParser.parseObjcType(inSpecifierQualifierList: specifierQualifierList, declarator: declarator) else {
                    continue
                }
                
                let typeNode = TypeNameNode(type: type)
                typeNode.sourceRuleContext = decl
                let ident = Identifier(name: identifier)
                ident.sourceRuleContext = declarator.directDeclarator()?.identifier()
                
                let ivar = IVarDeclaration()
                ivar.addChild(typeNode)
                ivar.addChild(ident)
                ivar.sourceRuleContext = declarator
                
                context.addChildNode(ivar)
            }
        }
    }
    
    // MARK: - Protocol Declaration
    override func enterProtocolDeclaration(_ ctx: ObjectiveCParser.ProtocolDeclarationContext) {
        guard context.currentContextNode(as: ProtocolDeclaration.self) != nil else {
            return
        }
        
        if let identifier = ctx.protocolName()?.identifier() {
            let identifierNode = Identifier(name: identifier.getText())
            identifierNode.sourceRuleContext = identifier
            context.addChildNode(identifierNode)
        }
        
        // Protocol list
        if let protocolList = ctx.protocolList() {
            let protocolListNode = ProtocolReferenceList()
            protocolListNode.sourceRuleContext = protocolList
            
            for prot in protocolList.protocolName() {
                guard let identifier = prot.identifier() else {
                    continue
                }
                
                let protNameNode = ProtocolName(name: identifier.getText())
                protNameNode.sourceRuleContext = identifier
                protocolListNode.addChild(protNameNode)
            }
            
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
        let listener = PropertyListener(typeParser: typeParser)
        let walker = ParseTreeWalker()
        try? walker.walk(listener, ctx)
        
        listener.property.isOptionalProperty = inOptionalContext
        
        context.pushContext(node: listener.property)
    }
    
    override func exitPropertyDeclaration(_ ctx: ObjectiveCParser.PropertyDeclarationContext) {
        context.popContext()
    }
    
    override func enterTypeName(_ ctx: ObjectiveCParser.TypeNameContext) {
        guard let type = typeParser.parseObjcType(fromTypeName: ctx) else {
            return
        }
        
        let node = TypeNameNode(type: type)
        node.sourceRuleContext = ctx
        context.addChildNode(node)
    }
    
    override func enterGenericTypeSpecifier(_ ctx: ObjectiveCParser.GenericTypeSpecifierContext) {
        mapper.pushTemporaryException(forRuleType: ObjectiveCParser.ProtocolListContext.self)
    }
    
    override func exitGenericTypeSpecifier(_ ctx: ObjectiveCParser.GenericTypeSpecifierContext) {
        mapper.popTemporaryException()
    }
    
    override func enterNullabilitySpecifier(_ ctx: ObjectiveCParser.NullabilitySpecifierContext) {
        let spec = NullabilitySpecifier(name: ctx.getText())
        spec.sourceRuleContext = ctx
        context.addChildNode(spec)
    }
    
    // MARK: - Method Declaration
    override func enterMethodDeclaration(_ ctx: ObjectiveCParser.MethodDeclarationContext) {
        guard let node = context.currentContextNode(as: MethodDefinition.self) else {
            return
        }
        
        node.isOptionalMethod = inOptionalContext
        node.isClassMethod = ctx.parent is ObjectiveCParser.ClassMethodDeclarationContext
    }
    
    override func enterMethodDefinition(_ ctx: ObjectiveCParser.MethodDefinitionContext) {
        guard let node = context.currentContextNode(as: MethodDefinition.self) else {
            return
        }
        
        node.isClassMethod = ctx.parent is ObjectiveCParser.ClassMethodDefinitionContext
        
        let methodBody = MethodBody()
        
        methodBody.sourceRuleContext = ctx
        methodBody.statements = ctx.compoundStatement()
        
        node.body = methodBody
    }
    
    override func enterMethodSelector(_ ctx: ObjectiveCParser.MethodSelectorContext) {
        if let selIdentifier = ctx.selector()?.identifier() {
            let node = Identifier(name: selIdentifier.getText())
            node.sourceRuleContext = ctx
            context.addChildNode(node)
        }
    }
    
    override func enterKeywordDeclarator(_ ctx: ObjectiveCParser.KeywordDeclaratorContext) {
        guard let node = context.currentContextNode(as: KeywordDeclarator.self) else {
            return
        }
        
        let selectorIdent =
            (ctx.selector()?.identifier()).map { ctx -> Identifier in
                let node = Identifier(name: ctx.getText())
                node.sourceRuleContext = ctx
                return node
        }
        
        let ident =
            ctx.identifier().map { ctx -> Identifier in
                let node = Identifier(name: ctx.getText())
                node.sourceRuleContext = ctx
                return node
        }
        
        if let ident = selectorIdent {
            node.addChild(ident)
        }
        if let ident = ident {
            node.addChild(ident)
        }
    }
    
    // MARK: - Typedef
    
    override func enterTypedefDeclaration(_ ctx: ObjectiveCParser.TypedefDeclarationContext) {
        guard let typedefNode = context.currentContextNode(as: TypedefNode.self) else {
            return
        }
        
        guard let typeDeclaratorList = ctx.typeDeclaratorList() else {
            return
        }
        
        for typeDeclarator in typeDeclaratorList.declarator() {
            guard let directDeclarator = typeDeclarator.directDeclarator() else {
                continue
            }
            guard let identifier = directDeclarator.identifier() else {
                continue
            }
            
            let identifierNode = Identifier(name: identifier.getText())
            identifierNode.sourceRuleContext = identifier
            typedefNode.addChild(identifierNode)
        }
    }
    
    override func exitTypedefDeclaration(_ ctx: ObjectiveCParser.TypedefDeclarationContext) {
        guard let typedefNode = context.currentContextNode(as: TypedefNode.self) else {
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
            
            guard let type = typeParser.parseObjcType(inDeclarationSpecifiers: declarationSpecifiers,
                                                      declarator: typeDeclarator) else
            {
                continue
            }
            
            let identifierNode = Identifier(name: identifier.getText())
            identifierNode.sourceRuleContext = identifier
            typedefNode.addChild(identifierNode)
            
            let typeNameNode = TypeNameNode(type: type)
            typeNameNode.sourceRuleContext = typeDeclarator
            typedefNode.addChild(typeNameNode)
        }
    }
    
    override func enterEnumDeclaration(_ ctx: ObjectiveCParser.EnumDeclarationContext) {
        guard let enumSpecifier = ctx.enumSpecifier() else {
            return
        }
        
        guard let enumNode = context.currentContextNode(as: ObjcEnumDeclaration.self) else {
            return
        }
        
        let isObjcEnum = enumSpecifier.NS_ENUM() != nil || enumSpecifier.NS_OPTIONS() != nil
        
        enumNode.isOptionSet = enumSpecifier.NS_OPTIONS() != nil
        
        if let identifier = enumSpecifier.identifier(isObjcEnum ? 0 : 1) {
            let identifierNode = Identifier(name: identifier.getText())
            identifierNode.sourceRuleContext = identifier
            enumNode.addChild(identifierNode)
        }
    }
    
    override func enterEnumerator(_ ctx: ObjectiveCParser.EnumeratorContext) {
        guard let identifier = ctx.enumeratorIdentifier()?.getText() else {
            return
        }
        
        let enumCase = ObjcEnumCase()
        enumCase.sourceRuleContext = ctx
        
        let identifierNode = Identifier(name: identifier)
        identifierNode.sourceRuleContext = ctx.enumeratorIdentifier()
        enumCase.addChild(identifierNode)
        
        if let expression = ctx.expression() {
            let expressionNode = ExpressionNode()
            expressionNode.sourceRuleContext = expression
            expressionNode.expression = expression
            enumCase.addChild(expressionNode)
        }
        
        context.addChildNode(enumCase)
    }
    
    override func enterBlockParameters(_ ctx: ObjectiveCParser.BlockParametersContext) {
        for typeVariableDeclaratorOrName in ctx.typeVariableDeclaratorOrName() {
            guard let type = typeParser.parseObjcType(fromTypeVariableDeclaratorOrTypeName: typeVariableDeclaratorOrName) else {
                continue
            }
            
            let typeNameNode = TypeNameNode(type: type)
            typeNameNode.sourceRuleContext = typeVariableDeclaratorOrName
            context.addChildNode(typeNameNode)
        }
    }
    
    // MARK: - Function Declaration/Definition
    override func enterFunctionDefinition(_ ctx: ObjectiveCParser.FunctionDefinitionContext) {
        guard let function = context.currentContextNode(as: FunctionDefinition.self) else {
            return
        }
        guard let compoundStatement = ctx.compoundStatement() else {
            return
        }
        
        let body = MethodBody()
        body.sourceRuleContext = compoundStatement
        body.statements = compoundStatement
        
        function.addChild(body)
    }
    
    override func enterFunctionSignature(_ ctx: ObjectiveCParser.FunctionSignatureContext) {
        guard let function = context.currentContextNode(as: FunctionDefinition.self) else {
            return
        }
        
        var returnType: ObjcType?
        if let declarationSpecifiers = ctx.declarationSpecifiers() {
            returnType = typeParser.parseObjcType(inDeclarationSpecifiers: declarationSpecifiers)
        }
        
        if let returnType = returnType {
            let typeNameNode = TypeNameNode(type: returnType)
            typeNameNode.sourceRuleContext = ctx.declarationSpecifiers()
            function.addChild(typeNameNode)
        }
        
        if let identifier = ctx.identifier() {
            let identifierNode = Identifier(name: identifier.getText())
            identifierNode.sourceRuleContext = identifier
            function.addChild(identifierNode)
        }
        
        // Parameter list
        let parameterListNode = context.pushContext(nodeType: ParameterList.self)
        defer {
            context.popContext()
        }
        
        parameterListNode.sourceRuleContext = ctx.parameterList()
        
        if let params = ctx.parameterList(), let paramDecl = params.parameterDeclarationList() {
            for param in paramDecl.parameterDeclaration() {
                let node = context.pushContext(nodeType: FunctionParameter.self)
                defer {
                    context.popContext()
                }
                
                node.sourceRuleContext = param
                
                guard let declarationSpecifiers = param.declarationSpecifiers() else {
                    continue
                }
                guard let declarator = param.declarator() else {
                    continue
                }
                guard let name = VarDeclarationIdentifierNameExtractor.extract(from: declarator) else {
                    continue
                }
                guard let type = typeParser.parseObjcType(inDeclarationSpecifiers: declarationSpecifiers, declarator: declarator) else {
                    continue
                }
                
                let identifier = Identifier(name: name)
                identifier.sourceRuleContext = declarator.directDeclarator()?.identifier()
                context.addChildNode(identifier)
                
                let typeNode = TypeNameNode(type: type)
                typeNode.sourceRuleContext = param
                context.addChildNode(typeNode)
            }
            
            if params.ELIPSIS() != nil {
                let variadicParameter = VariadicParameter()
                variadicParameter.sourceRuleContext = params
                context.addChildNode(variadicParameter)
            }
        }
    }
}

private class GlobalVariableListener: ObjectiveCParserBaseListener {
    var variables: [VariableDeclaration] = []
    var typeParser: TypeParsing
    
    init(typeParser: TypeParsing) {
        self.typeParser = typeParser
    }
    
    // Pick global variable declarations on top level
    override func enterTranslationUnit(_ ctx: ObjectiveCParser.TranslationUnitContext) {
        let topLevelDeclarations = ctx.topLevelDeclaration()
        let visitor = GlobalVariableVisitor(typeParser: typeParser)
        
        for topLevelDeclaration in topLevelDeclarations {
            guard let declaration = topLevelDeclaration.declaration() else { continue }
            guard let varDeclaration = declaration.varDeclaration() else { continue }
            
            if let vars = varDeclaration.accept(visitor) {
                variables.append(contentsOf: vars)
            }
        }
    }
    
    // Pick global variable declarations that are beneath the top-level, like inside
    // class @interface/@implementations etc.
    override func enterVarDeclaration(_ ctx: ObjectiveCParser.VarDeclarationContext) {
        if ctx.context.scope != .class || !ctx.context.isStatic {
            return
        }
        
        let visitor = GlobalVariableVisitor(typeParser: typeParser)
        
        if let vars = ctx.accept(visitor) {
            variables.append(contentsOf: vars)
        }
    }
    
    private class GlobalVariableVisitor: ObjectiveCParserBaseVisitor<[VariableDeclaration]> {
        var typeParser: TypeParsing
        
        init(typeParser: TypeParsing) {
            self.typeParser = typeParser
        }
        
        override func visitVarDeclaration(_ ctx: ObjectiveCParser.VarDeclarationContext) -> [VariableDeclaration]? {
            var variables: [VariableDeclaration] = []
            
            guard let initDeclarators = ctx.initDeclaratorList()?.initDeclarator() else { return nil }
            
            let allTypes = VarDeclarationTypeExtractor.extractAll(from: ctx)
            
            for (initDeclarator, typeString) in zip(initDeclarators, allTypes) {
                guard let identifier = initDeclarator.declarator()?.directDeclarator()?.identifier() else { continue }
                
                // Get a type string to convert into a proper type
                guard let type = typeParser.parseObjcType(typeString) else { continue }
                
                let varDecl = VariableDeclaration()
                varDecl.sourceRuleContext = ctx
                varDecl.addChild(Identifier(name: identifier.getText()))
                varDecl.addChild(TypeNameNode(type: type))
                
                if let initializer = initDeclarator.initializer() {
                    let expression = ExpressionNode()
                    expression.sourceRuleContext = initializer.expression()
                    expression.expression = initializer.expression()
                    let constantExpression = ConstantExpressionNode()
                    constantExpression.sourceRuleContext = initializer
                    constantExpression.addChild(expression)
                    let initialExpression = InitialExpression()
                    initialExpression.sourceRuleContext = initializer
                    initialExpression.addChild(constantExpression)
                    
                    varDecl.addChild(initialExpression)
                }
                
                variables.append(varDecl)
            }
            
            return variables
        }
    }
}

private class PropertyListener: ObjectiveCParserBaseListener {
    var property = PropertyDefinition()
    var typeParser: TypeParsing
    
    init(typeParser: TypeParsing) {
        self.typeParser = typeParser
    }
    
    override func enterPropertyDeclaration(_ ctx: ObjectiveCParser.PropertyDeclarationContext) {
        property.sourceRuleContext = ctx
        
        if let ident =
            ctx.fieldDeclaration()?
                .fieldDeclaratorList()?
                .fieldDeclarator(0)?
                .declarator()?
                .directDeclarator()?
                .identifier() {
            
            let node = Identifier(name: ident.getText())
            node.sourceRuleContext = ctx
            
            property.addChild(node)
        }
        
        if let fieldDeclaration = ctx.fieldDeclaration() {
            if let type = typeParser.parseObjcType(inDeclaration: fieldDeclaration) {
                let typeNode = TypeNameNode(type: type)
                typeNode.sourceRuleContext = ctx
                property.addChild(typeNode)
            }
        }
    }
    
    override func enterPropertyAttributesList(_ ctx: ObjectiveCParser.PropertyAttributesListContext) {
        let node = PropertyAttributesList()
        node.sourceRuleContext = ctx
        property.addChild(node)
    }
    
    override func enterPropertyAttribute(_ ctx: ObjectiveCParser.PropertyAttributeContext) {
        let modifier: PropertyAttributeNode.Attribute
        
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
        
        let node = PropertyAttributeNode(modifier: modifier)
        node.sourceRuleContext = ctx
        
        property.attributesList?.addChild(node)
    }
}

private class GenericParseTreeContextMapper {
    typealias NodeType = ASTNode & InitializableNode
    
    private var pairs: [Pair] = []
    private var exceptions: [ParserRuleContext.Type] = []
    
    private var source: Source
    
    init(source: Source) {
        self.source = source
    }
    
    func addRuleMap<T: ParserRuleContext, U: NodeType>(rule: T.Type, nodeType: U.Type) {
        assert(match(ruleType: rule) == nil, "Duplicated mapping rule for parser rule context \(rule)")
        
        pairs.append(.type(rule: rule, nodeType: nodeType))
    }
    
    func addRuleMap<T: ParserRuleContext, U: NodeType>(rule: T.Type, node: U) {
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
        case .type(_, let nodeType):
            let node = nodeType.init()
            
            let startIndex = rule.start?.getStartIndex() ?? 0
            let endIndex = rule.stop?.getStopIndex() ?? 0
            
            node.location =
                SourceLocation(source: source, intRange: startIndex..<endIndex)
            
            node.sourceRuleContext = rule
            context.pushContext(node: node)
        case .instance(_, let node):
            node.sourceRuleContext = rule
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
            case .type(_, let nodeType):
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
        case type(rule: ParserRuleContext.Type, nodeType: NodeType.Type)
        case instance(rule: ParserRuleContext.Type, node: NodeType)
        
        var ruleType: ParserRuleContext.Type {
            switch self {
            case .type(let rule, _):
                return rule
            case .instance(let rule, _):
                return rule
            }
        }
    }
}
