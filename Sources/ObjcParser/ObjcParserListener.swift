import GrammarModels
import Antlr4
import ObjcParserAntlr

internal class ObjcParserListener: ObjectiveCParserBaseListener {
    let context: NodeCreationContext
    let rootNode: GlobalContextNode
    private let mapper: GenericParseTreeContextMapper
    private let sourceString: String
    private let source: Source
    
    init(sourceString: String, source: Source) {
        self.sourceString = sourceString
        self.source = source
        
        context = NodeCreationContext()
        context.autoUpdatesSourceRange = false
        rootNode = GlobalContextNode()
        mapper = GenericParseTreeContextMapper(source: source)
        
        super.init()
        
        configureMappers()
    }
    
    // Helper for mapping Objective-C types from raw strings into a structured types
    fileprivate static func parseObjcType(_ source: String) -> ObjcType? {
        let parser = ObjcParser(source: StringCodeSource(source: source))
        return try? parser.parseObjcType()
    }
    
    // Helper for mapping Objective-C types from type declarations into structured
    // types.
    fileprivate static func parseObjcType(inDeclaration decl: ObjectiveCParser.FieldDeclarationContext) -> ObjcType? {
        guard let specQualifier = decl.specifierQualifierList() else {
            return nil
        }
        guard let baseTypeString = specQualifier.typeSpecifier(0)?.getText() else {
            return nil
        }
        guard let declarator = decl.fieldDeclaratorList()?.fieldDeclarator(0)?.declarator() else {
            return nil
        }
        
        let pointerDecl = declarator.pointer()
        
        var typeName = "\(baseTypeString) \(pointerDecl.map { $0.getText() } ?? "")"
        
        if specQualifier.arcBehaviourSpecifier().count > 0 {
            let arcSpecifiers =
                specQualifier.arcBehaviourSpecifier().map {
                    $0.getText()
                }
            
            typeName = "\(arcSpecifiers.joined(separator: " ")) \(typeName)"
        }
        
        guard let type = ObjcParserListener.parseObjcType(typeName) else {
            return nil
        }
        
        return type
    }
    
    fileprivate static func parseObjcType(inDeclarationSpecifiers declarationSpecifiers: ObjectiveCParser.DeclarationSpecifiersContext,
                                          typeDeclarator: ObjectiveCParser.TypeDeclaratorContext) -> ObjcType? {
        let pointer = typeDeclarator.pointer()
        
        let specifiersString = declarationSpecifiers.children?.map {
            $0.getText()
        }.joined(separator: " ") ?? ""
        
        let typeString = "\(specifiersString) \(pointer?.getText() ?? "")"
        
        guard var type = ObjcParserListener.parseObjcType(typeString) else {
            return nil
        }
        
        // Block type
        if let blockIdentifier = typeDeclarator.directDeclarator()?.identifier(),
            let blockParameters = typeDeclarator.directDeclarator()?.blockParameters() {
            let typeVariableDeclaratorOrNames = blockParameters.typeVariableDeclaratorOrName()
            
            var blockParameterTypes: [ObjcType] = []
            
            for typeVariableDeclaratorOrName in typeVariableDeclaratorOrNames {
                let paramType: ObjcType
                if let typeName = typeVariableDeclaratorOrName.typeName(),
                    let type = ObjcParserListener.parseObjcType(typeName.getText()) {
                    paramType = type
                } else {
                    continue
                }
                
                blockParameterTypes.append(paramType)
            }
            
            type = .blockType(name: blockIdentifier.getText(),
                              returnType: type,
                              parameters: blockParameterTypes)
        }
        
        return type
    }
    
    private static func parseObjcType(fromTypeVariableDeclaratorOrTypeName typeContext: ObjectiveCParser.TypeVariableDeclaratorOrNameContext) -> ObjcType? {
        let visitor = VarDeclarationTypeExtractor()
        guard let typeString = typeContext.accept(visitor) else {
            return nil
        }
        
        guard let type = ObjcParserListener.parseObjcType(typeString) else {
            return nil
        }
        
        return type
    }
    
    private static func parseObjcType(fromTypeSpecifier typeSpecifier: ObjectiveCParser.TypeSpecifierContext) -> ObjcType? {
        let visitor = VarDeclarationTypeExtractor()
        guard let typeString = typeSpecifier.accept(visitor) else {
            return nil
        }
        guard let type = ObjcParserListener.parseObjcType(typeString) else {
            return nil
        }
        
        return type
    }
    
    private static func parseObjcType(fromBlockType blockType: ObjectiveCParser.BlockTypeContext) -> ObjcType? {
        guard let returnTypeSpecifier = blockType.typeSpecifier(0) else {
            return nil
        }
        guard let returnType = parseObjcType(fromTypeSpecifier: returnTypeSpecifier) else {
            return nil
        }
        
        var parameterTypes: [ObjcType] = []
        
        if let blockParameters = blockType.blockParameters() {
            for param in blockParameters.typeVariableDeclaratorOrName() {
                guard let paramType = parseObjcType(fromTypeVariableDeclaratorOrTypeName: param) else {
                    continue
                }
                
                parameterTypes.append(paramType)
            }
        }
        
        return ObjcType.blockType(name: "", returnType: returnType, parameters: parameterTypes)
    }
    
    private static func parseObjcType(fromTypeName typeName: ObjectiveCParser.TypeNameContext) -> ObjcType? {
        // Block type
        if let blockType = typeName.blockType() {
            return parseObjcType(fromBlockType: blockType)
        }
        
        let visitor = VarDeclarationTypeExtractor()
        guard let typeString = visitor.visitTypeName(typeName) else {
            return nil
        }
        guard let type = ObjcParserListener.parseObjcType(typeString) else {
            return nil
        }
        
        return type
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
        mapper.addRuleMap(rule: ObjectiveCParser.CategoryInterfaceContext.self, nodeType: ObjcClassCategory.self)
        mapper.addRuleMap(rule: ObjectiveCParser.MethodDeclarationContext.self, nodeType: MethodDefinition.self)
        mapper.addRuleMap(rule: ObjectiveCParser.MethodDefinitionContext.self, nodeType: MethodDefinition.self)
        mapper.addRuleMap(rule: ObjectiveCParser.KeywordDeclaratorContext.self, nodeType: KeywordDeclarator.self)
        mapper.addRuleMap(rule: ObjectiveCParser.MethodSelectorContext.self, nodeType: MethodSelector.self)
        mapper.addRuleMap(rule: ObjectiveCParser.MethodTypeContext.self, nodeType: MethodType.self)
        mapper.addRuleMap(rule: ObjectiveCParser.InstanceVariablesContext.self, nodeType: IVarsList.self)
        mapper.addRuleMap(rule: ObjectiveCParser.TypedefDeclarationContext.self, nodeType: TypedefNode.self)
        mapper.addRuleMap(rule: ObjectiveCParser.BlockParametersContext.self, nodeType: BlockParametersNode.self)
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
        let globalVariableListener = GlobalVariableListener()
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
        if let identifier = ctx.className?.identifier() {
            let identifierNode = Identifier(name: identifier.getText())
            identifierNode.sourceRuleContext = identifier
            classNode.identifier = .valid(identifierNode)
        }
        
        // Super class name
        if let sup = ctx.superclassName?.getText() {
            let supName = SuperclassName(name: sup)
            supName.sourceRuleContext = ctx.superclassName
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
        guard let classNode = context.currentContextNode(as: ObjcClassCategory.self) else {
            return
        }
        
        // Class name
        if let identifier = ctx.categoryName?.identifier() {
            let identifierNode = Identifier(name: identifier.getText())
            identifierNode.sourceRuleContext = identifier
            classNode.identifier = .valid(identifierNode)
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
        if let identifier = ctx.className?.identifier() {
            let identNode = Identifier(name: identifier.getText())
            identNode.sourceRuleContext = identifier
            classNode.identifier = .valid(identNode)
        }
        
        // Super class name
        if let sup = ctx.superclassName?.getText() {
            let supName = SuperclassName(name: sup)
            supName.sourceRuleContext = ctx.superclassName
            context.addChildNode(supName)
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
            guard let declarator = decl.fieldDeclaratorList()?.fieldDeclarator(0)?.declarator() else {
                continue
            }
            guard let identifier = declarator.directDeclarator()?.identifier() else {
                continue
            }
            guard let type = ObjcParserListener.parseObjcType(inDeclaration: decl) else {
                continue
            }
            
            let identString = identifier.getText()
            
            let typeNode = TypeNameNode(type: type)
            typeNode.sourceRuleContext = decl
            let ident = Identifier(name: identString)
            ident.sourceRuleContext = identifier
            
            let ivar = IVarDeclaration()
            ivar.addChild(typeNode)
            ivar.addChild(ident)
            ivar.sourceRuleContext = declarator
            
            context.addChildNode(ivar)
        }
    }
    
    // MARK: - Property Declaration
    override func enterPropertyDeclaration(_ ctx: ObjectiveCParser.PropertyDeclarationContext) {
        let listener = PropertyListener()
        let walker = ParseTreeWalker()
        try? walker.walk(listener, ctx)
        
        context.pushContext(node: listener.property)
    }
    
    override func exitPropertyDeclaration(_ ctx: ObjectiveCParser.PropertyDeclarationContext) {
        context.popContext()
    }
    
    override func enterTypeName(_ ctx: ObjectiveCParser.TypeNameContext) {
        guard let type = ObjcParserListener.parseObjcType(fromTypeName: ctx) else {
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
    
    // MARK: - Method Declaration
    override func enterMethodDeclaration(_ ctx: ObjectiveCParser.MethodDeclarationContext) {
        guard let node = context.currentContextNode(as: MethodDefinition.self) else {
            return
        }
        
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
    
    override func enterTypedefDeclaration(_ ctx: ObjectiveCParser.TypedefDeclarationContext) {
        guard let typedefNode = context.currentContextNode(as: TypedefNode.self) else {
            return
        }
        
        guard let typeDeclaratorList = ctx.typeDeclaratorList() else {
            return
        }
        
        for typeDeclarator in typeDeclaratorList.typeDeclarator() {
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
        for typeDeclarator in typeDeclaratorList.typeDeclarator() {
            guard let directDeclarator = typeDeclarator.directDeclarator() else {
                continue
            }
            guard let identifier = directDeclarator.identifier() else {
                continue
            }
            
            guard let type = ObjcParserListener.parseObjcType(inDeclarationSpecifiers: declarationSpecifiers,
                                                              typeDeclarator: typeDeclarator) else
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
    
    override func enterBlockParameters(_ ctx: ObjectiveCParser.BlockParametersContext) {
        for typeVariableDeclaratorOrName in ctx.typeVariableDeclaratorOrName() {
            guard let type = ObjcParserListener.parseObjcType(fromTypeVariableDeclaratorOrTypeName: typeVariableDeclaratorOrName) else {
                continue
            }
            
            let typeNameNode = TypeNameNode(type: type)
            typeNameNode.sourceRuleContext = typeVariableDeclaratorOrName
            context.addChildNode(typeNameNode)
        }
    }
}

private class GlobalVariableListener: ObjectiveCParserBaseListener {
    var variables: [VariableDeclaration] = []
    
    // Pick global variable declarations on top level
    override func enterTranslationUnit(_ ctx: ObjectiveCParser.TranslationUnitContext) {
        let topLevelDeclarations = ctx.topLevelDeclaration()
        let visitor = GlobalVariableVisitor()
        
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
        
        let visitor = GlobalVariableVisitor()
        
        if let vars = ctx.accept(visitor) {
            variables.append(contentsOf: vars)
        }
    }
    
    private class GlobalVariableVisitor: ObjectiveCParserBaseVisitor<[VariableDeclaration]> {
        override func visitVarDeclaration(_ ctx: ObjectiveCParser.VarDeclarationContext) -> [VariableDeclaration]? {
            var variables: [VariableDeclaration] = []
            
            guard let initDeclarators = ctx.initDeclaratorList()?.initDeclarator() else { return nil }
            
            let allTypes = VarDeclarationTypeExtractor.extractAll(from: ctx)
            
            for (initDeclarator, typeString) in zip(initDeclarators, allTypes) {
                guard let identifier = initDeclarator.declarator()?.directDeclarator()?.identifier() else { continue }
                
                // Get a type string to convert into a proper type
                guard let type = ObjcParserListener.parseObjcType(typeString) else { continue }
                
                let varDecl = VariableDeclaration()
                varDecl.sourceRuleContext = ctx
                varDecl.addChild(Identifier(name: identifier.getText()))
                varDecl.addChild(TypeNameNode(type: type))
                
                if let initializer = initDeclarator.initializer() {
                    let expression = Expression()
                    expression.sourceRuleContext = initializer.expression()
                    expression.expression = initializer.expression()
                    let constantExpression = ConstantExpression()
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
            if let type = ObjcParserListener.parseObjcType(inDeclaration: fieldDeclaration) {
                let typeNode = TypeNameNode(type: type)
                typeNode.sourceRuleContext = ctx
                property.addChild(typeNode)
            }
        }
    }
    
    override func enterPropertyAttributesList(_ ctx: ObjectiveCParser.PropertyAttributesListContext) {
        let node = PropertyModifierList()
        node.sourceRuleContext = ctx
        property.addChild(node)
    }
    
    override func enterPropertyAttribute(_ ctx: ObjectiveCParser.PropertyAttributeContext) {
        let modifier: PropertyModifier.Modifier
        
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
        
        let node = PropertyModifier(modifier: modifier)
        node.sourceRuleContext = ctx
        
        property.modifierList?.addChild(node)
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
            
            let sourceStartIndex = source.stringIndex(forCharOffset: startIndex)
            let sourceEndIndex = source.stringIndex(forCharOffset: endIndex)
            
            node.location =
                .init(source: source, range: .range(sourceStartIndex..<sourceEndIndex))
            
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
