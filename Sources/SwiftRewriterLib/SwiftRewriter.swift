import Foundation
import GrammarModels
import ObjcParser
import SwiftAST

/// Allows re-writing Objective-C constructs into Swift equivalents.
public class SwiftRewriter {
    
    private var outputTarget: WriterOutput
    private let context: TypeConstructionContext
    private let typeMapper: TypeMapper
    private let intentionCollection: IntentionCollection
    private let sourcesProvider: InputSourcesProvider
    private var typeSystem: IntentionCollectionTypeSystem
    
    /// During parsing, the index of each NS_ASSUME_NONNULL_BEGIN/END pair is
    /// collected so during source analysis by SwiftRewriter we can verify whether
    /// or not a declaration is under the effects of NS_ASSUME_NONNULL by checking
    /// whether it is contained within one of these ranges.
    private var nonnullTokenRanges: [(start: Int, end: Int)] = []
    
    /// To keep token sources alive long enough.
    private var parsers: [ObjcParser] = []
    
    /// A diagnostics instance that collects all diagnostic errors during input
    /// source processing.
    public let diagnostics: Diagnostics
    
    /// An expression pass is executed for every method expression to allow custom
    /// transformations to be applied to resulting code.
    public var syntaxNodeRewriters: [SyntaxNodeRewriterPass] = []
    
    /// Custom source pre-processors that are applied to each input source code
    /// before parsing.
    public var preprocessors: [SourcePreprocessor] = []
    
    /// Provider for intention passes to apply before passing the constructs to
    /// the output
    public var intentionPassesSource: IntentionPassSource
    
    public var writerOptions: ASTWriterOptions = .default
    
    public convenience init(input: InputSourcesProvider, output: WriterOutput) {
        self.init(input: input, output: output,
                  intentionPassesSource: DefaultIntentionPassSource(intentionPasses: []))
    }
    
    public init(input: InputSourcesProvider, output: WriterOutput,
                intentionPassesSource: IntentionPassSource) {
        self.diagnostics = Diagnostics()
        self.sourcesProvider = input
        self.outputTarget = output
        self.context = TypeConstructionContext()
        self.typeMapper = TypeMapper(context: context)
        self.intentionCollection = IntentionCollection()
        self.intentionPassesSource = intentionPassesSource
        
        typeSystem = IntentionCollectionTypeSystem(intentions: intentionCollection)
    }
    
    public func rewrite() throws {
        try autoreleasepool {
            parsers.removeAll()
            
            try loadInputSources()
            performIntentionPasses()
            outputDefinitions()
        }
    }
    
    private func loadInputSources() throws {
        // Load input sources
        let sources = sourcesProvider.sources()
        
        for src in sources {
            try loadObjcSource(from: src)
        }
    }
    
    private func performIntentionPasses() {
        let typeResolver =
            ExpressionTypeResolver(typeSystem: typeSystem,
                                   intrinsicVariables: EmptyCodeScope())
        
        let syntaxPasses = [MandatorySyntaxNodePass()] + syntaxNodeRewriters
        
        let applier =
            SyntaxNodeRewriterPassApplier(passes: syntaxPasses,
                                          typeResolver: typeResolver)
        
        let typeResolverInvoker = DefaultTypeResolverInvoker(typeResolver: typeResolver)
        let context =
            IntentionPassContext(intentions: intentionCollection,
                                 typeSystem: typeSystem,
                                 typeResolverInvoker: typeResolverInvoker)
        
        // Make a pre-type resolve before applying passes
        typeResolverInvoker.resolveAllExpressionTypes(in: intentionCollection)
        
        for pass in intentionPassesSource.intentionPasses {
            pass.apply(on: intentionCollection, context: context)
        }
        
        applier.apply(on: intentionCollection)
    }
    
    private func outputDefinitions() {
        let writer = SwiftWriter(intentions: intentionCollection,
                                 options: writerOptions,
                                 diagnostics: diagnostics,
                                 output: outputTarget)
        
        writer.execute()
    }
    
    private func applyPreprocessors(source: CodeSource) -> String {
        let src = source.fetchSource()
        
        let context = _PreprocessingContext(filePath: source.fileName)
        
        return preprocessors.reduce(src) {
            $1.preprocess(source: $0, context: context)
        }
    }
    
    private func loadObjcSource(from source: InputSource) throws {
        // Generate intention for this source
        var path = source.sourceName()
        path = (path as NSString).deletingPathExtension + ".swift"
        
        let fileIntent = FileGenerationIntention(sourcePath: source.sourceName(), filePath: path)
        intentionCollection.addIntention(fileIntent)
        context.pushContext(fileIntent)
        context.pushContext(AssumeNonnullContext(isNonnullOn: false))
        defer {
            context.popContext()
        }
        
        let src = try source.loadSource()
        
        let processedSrc = applyPreprocessors(source: src)
        
        let parser = ObjcParser(string: processedSrc)
        parsers.append(parser)
        parser.diagnostics = diagnostics
        
        try parser.parse()
        
        nonnullTokenRanges = parser.nonnullMacroRegionsTokenRange
        fileIntent.preprocessorDirectives = parser.preprocessorDirectives
        
        let node = parser.rootNode
        let visitor = AnyASTVisitor()
        let traverser = ASTTraverser(node: node, visitor: visitor)
        
        visitor.onEnterClosure = { node in
            if let ctx = self.context.findContext(ofType: AssumeNonnullContext.self) {
                ctx.isNonnullOn = self.isNodeInNonnullContext(node)
            }
            
            switch node {
            case let n as ObjcClassInterface:
                self.enterObjcClassInterfaceNode(n)
            case let n as ObjcClassCategoryInterface:
                self.enterObjcClassCategoryNode(n)
            case let n as ObjcClassImplementation:
                self.enterObjcClassImplementationNode(n)
            case let n as ObjcClassCategoryImplementation:
                self.enterObjcClassCategoryImplementationNode(n)
            case let n as ProtocolDeclaration:
                self.enterProtocolDeclarationNode(n)
            case let n as IVarsList:
                self.enterObjcClassIVarsListNode(n)
            case let n as ObjcEnumDeclaration:
                self.enterObjcEnumDeclarationNode(n)
            default:
                return
            }
        }
        
        visitor.visitClosure = { node in
            switch node {
            case let n as TypedefNode:
                self.visitTypedefNode(n)
                
            case let n as KeywordNode:
                self.visitKeywordNode(n)
            
            case let n as MethodDefinition:
                self.visitObjcClassMethodNode(n)
            
            case let n as PropertyDefinition:
                self.visitPropertyDefinitionNode(n)
                
            case let n as ProtocolReferenceList:
                self.visitObjcClassProtocolReferenceListNode(n)
                
            case let n as SuperclassName:
                self.visitObjcClassSuperclassName(n)
                
            case let n as IVarDeclaration:
                self.visitObjcClassIVarDeclarationNode(n)
                
            case let n as VariableDeclaration:
                self.visitVariableDeclarationNode(n)
                
            case let n as ObjcEnumCase:
                self.visitObjcEnumCaseNode(n)
                
            case let n as Identifier
                where n.name == "NS_ASSUME_NONNULL_BEGIN":
                self.context.findContext(ofType: AssumeNonnullContext.self)?.isNonnullOn = true
                
            case let n as Identifier
                where n.name == "NS_ASSUME_NONNULL_END":
                self.context.findContext(ofType: AssumeNonnullContext.self)?.isNonnullOn = false
            default:
                return
            }
        }
        
        visitor.onExitClosure = { node in
            switch node {
            case let n as ObjcClassInterface:
                self.exitObjcClassInterfaceNode(n)
            case let n as ObjcClassCategoryInterface:
                self.exitObjcClassCategoryNode(n)
            case let n as ObjcClassImplementation:
                self.exitObjcClassImplementationNode(n)
            case let n as ObjcClassCategoryImplementation:
                self.exitObjcClassCategoryImplementationNode(n)
            case let n as ProtocolDeclaration:
                self.exitProtocolDeclarationNode(n)
            case let n as IVarsList:
                self.exitObjcClassIVarsListNode(n)
            case let n as ObjcEnumDeclaration:
                self.exitObjcEnumDeclarationNode(n)
            default:
                return
            }
        }
        
        traverser.traverse()
    }
    
    private func isNodeInNonnullContext(_ node: ASTNode) -> Bool {
        // Requires original ANTLR's rule context
        guard let ruleContext = node.sourceRuleContext else {
            return false
        }
        // Fetch the token indices of the node's start and end
        guard let startToken = ruleContext.getStart(), let stopToken = ruleContext.getStop() else {
            return false
        }
        
        // Check if it the token start/end indices are completely contained
        // within NS_ASSUME_NONNULL_BEGIN/END intervals
        for n in nonnullTokenRanges {
            if n.start <= startToken.getTokenIndex() && n.end >= stopToken.getTokenIndex() {
                return true
            }
        }
        
        return false
    }
    
    private func visitTypedefNode(_ node: TypedefNode) {
        guard let ctx = context.findContext(ofType: FileGenerationIntention.self) else {
            return
        }
        guard let type = node.type else {
            return
        }
        guard let name = node.identifier?.name else {
            return
        }
        
        let intent = TypealiasIntention(fromType: type.type, named: name)
        intent.inNonnullContext = isNodeInNonnullContext(node)
        
        ctx.addTypealias(intent)
    }
    
    private func visitKeywordNode(_ node: KeywordNode) {
        // ivar list accessibility specification
        if let ctx = context.findContext(ofType: IVarListContext.self) {
            switch node.keyword {
            case .atPrivate:
                ctx.accessLevel = .private
            case .atPublic:
                ctx.accessLevel = .public
            case .atPackage:
                ctx.accessLevel = .internal
            case .atProtected:
                ctx.accessLevel = .internal
            default:
                break
            }
        }
    }
    
    private func visitVariableDeclarationNode(_ node: VariableDeclaration) {
        guard let ctx = context.findContext(ofType: FileGenerationIntention.self) else {
            return
        }
        
        guard let name = node.identifier, let type = node.type else {
            return
        }
        
        let typeContext =
            TypeMapper.TypeMappingContext(inNonnull: isNodeInNonnullContext(node))
        
        let swiftType = typeMapper.swiftType(forObjcType: type.type, context: typeContext)
        let ownership = evaluateOwnershipPrefix(inType: type.type)
        let isConstant = SwiftWriter._isConstant(fromType: type.type)
        
        let storage =
            ValueStorage(type: swiftType, ownership: ownership, isConstant: isConstant)
        
        let intent =
            GlobalVariableGenerationIntention(name: name.name, storage: storage,
                                              source: node)
        
        intent.inNonnullContext = isNodeInNonnullContext(node)
        
        if let initialExpression = node.initialExpression,
            let expression = initialExpression.expression?.expression?.expression {
            let reader = SwiftASTReader()
            let expression = reader.parseExpression(expression: expression)
            
            intent.initialValueExpr =
                GlobalVariableInitialValueIntention(expression: expression,
                                                    source: initialExpression)
        }
        
        ctx.addGlobalVariable(intent)
    }
    
    // MARK: - ObjcClassInterface
    private func enterObjcClassInterfaceNode(_ node: ObjcClassInterface) {
        guard let name = node.identifier?.name else {
            return
        }
        
        let intent =
            ClassGenerationIntention(typeName: name, source: node)
        
        context
            .findContext(ofType: FileGenerationIntention.self)?
            .addType(intent)
        
        context.pushContext(intent)
    }
    
    private func exitObjcClassInterfaceNode(_ node: ObjcClassInterface) {
        if node.identifier?.name != nil {
            context.popContext() // ClassGenerationIntention
        }
    }
    
    // MARK: - ObjcClassCategory
    private func enterObjcClassCategoryNode(_ node: ObjcClassCategoryInterface) {
        guard let name = node.identifier?.name else {
            return
        }
        
        let intent =
            ClassExtensionGenerationIntention(typeName: name, source: node)
        intent.categoryName = node.categoryName?.name
        
        context
            .findContext(ofType: FileGenerationIntention.self)?
            .addType(intent)
        
        context.pushContext(intent)
    }
    
    private func exitObjcClassCategoryNode(_ node: ObjcClassCategoryInterface) {
        if node.identifier?.name != nil {
            context.popContext() // ClassExtensionGenerationIntention
        }
    }
    
    // MARK: - ObjcClassImplementation
    private func enterObjcClassImplementationNode(_ node: ObjcClassImplementation) {
        guard let name = node.identifier?.name else {
            return
        }
        
        let intent =
            ClassGenerationIntention(typeName: name, source: node)
        
        context
            .findContext(ofType: FileGenerationIntention.self)?
            .addType(intent)
        
        context.pushContext(intent)
    }
    
    private func exitObjcClassImplementationNode(_ node: ObjcClassImplementation) {
        context.popContext() // ClassGenerationIntention
    }
    
    // MARK: - ObjcClassCategoryImplementation
    private func enterObjcClassCategoryImplementationNode(_ node: ObjcClassCategoryImplementation) {
        guard let name = node.identifier?.name else {
            return
        }
        
        let intent =
            ClassExtensionGenerationIntention(typeName: name, source: node)
        intent.categoryName = node.categoryName?.name
        
        context
            .findContext(ofType: FileGenerationIntention.self)?
            .addType(intent)
        
        context.pushContext(intent)
    }
    
    private func exitObjcClassCategoryImplementationNode(_ node: ObjcClassCategoryImplementation) {
        context.popContext() // ClassExtensionGenerationIntention
    }
    
    // MARK: - ProtocolDeclaration
    private func enterProtocolDeclarationNode(_ node: ProtocolDeclaration) {
        guard let name = node.identifier?.name else {
            return
        }
        
        let intent =
            ProtocolGenerationIntention(typeName: name, source: node)
        
        context
            .findContext(ofType: FileGenerationIntention.self)?
            .addProtocol(intent)
        
        context.pushContext(intent)
    }
    
    private func exitProtocolDeclarationNode(_ node: ProtocolDeclaration) {
        if node.identifier?.name != nil {
            context.popContext() // ProtocolGenerationIntention
        }
    }
    // MARK: -
    
    private func visitPropertyDefinitionNode(_ node: PropertyDefinition) {
        guard let ctx = context.findContext(ofType: TypeGenerationIntention.self) else {
            return
        }
        
        var swiftType: SwiftType = .anyObject
        var ownership: Ownership = .strong
        if let type = node.type?.type {
            let context = TypeMapper
                .TypeMappingContext(modifiers: node.attributesList,
                                    inNonnull: isNodeInNonnullContext(node))
            
            swiftType = typeMapper.swiftType(forObjcType: type, context: context)
            ownership = evaluateOwnershipPrefix(inType: type, property: node)
        }
        
        let attributes =
            node.attributesList?
                .attributes.map { attr -> PropertyAttribute in
                    switch attr.attribute {
                    case .getter(let getter):
                        return PropertyAttribute.getterName(getter)
                    case .setter(let setter):
                        return PropertyAttribute.setterName(setter)
                    case .keyword(let keyword):
                        return PropertyAttribute.attribute(keyword)
                    }
                } ?? []
        
        let storage =
            ValueStorage(type: swiftType, ownership: ownership, isConstant: false)
        
        // Protocol property
        if context.findContext(ofType: ProtocolGenerationIntention.self) != nil {
            let prop =
                ProtocolPropertyGenerationIntention(name: node.identifier?.name ?? "",
                                                    storage: storage,
                                                    attributes: attributes,
                                                    source: node)
            
            prop.isOptional = node.isOptionalProperty
            
            prop.inNonnullContext = isNodeInNonnullContext(node)
            
            ctx.addProperty(prop)
        } else {
            let prop =
                PropertyGenerationIntention(name: node.identifier?.name ?? "",
                                            storage: storage,
                                            attributes: attributes,
                                            source: node)
            
            prop.inNonnullContext = isNodeInNonnullContext(node)
            
            ctx.addProperty(prop)
        }
    }
    
    // MARK: - Method Declaration
    private func visitObjcClassMethodNode(_ node: MethodDefinition) {
        guard let ctx = context.findContext(ofType: TypeGenerationIntention.self) else {
            return
        }
        
        let signGen = SwiftMethodSignatureGen(context: context, typeMapper: typeMapper)
        let sign = signGen.generateDefinitionSignature(from: node)
        
        let method: MethodGenerationIntention
        
        if context.findContext(ofType: ProtocolGenerationIntention.self) != nil {
            let protMethod =
                ProtocolMethodGenerationIntention(signature: sign,
                                                  source: node)
            
            protMethod.isOptional = node.isOptionalMethod
            
            method = protMethod
        } else {
            method = MethodGenerationIntention(signature: sign, source: node)
        }
        
        method.inNonnullContext = isNodeInNonnullContext(node)
        
        if let body = node.body, let statements = body.statements {
            let reader = SwiftASTReader()
            let compound = reader.parseStatements(compoundStatement: statements)
            
            let methodBodyIntention = FunctionBodyIntention(body: compound, source: body)
            method.functionBody = methodBodyIntention
        }
        
        ctx.addMethod(method)
    }
    
    private func visitObjcClassSuperclassName(_ node: SuperclassName) {
        guard let ctx = context.findContext(ofType: ClassGenerationIntention.self) else {
            return
        }
        
        ctx.superclassName = node.name
    }
    
    private func visitObjcClassProtocolReferenceListNode(_ node: ProtocolReferenceList) {
        guard let ctx = context.findContext(ofType: TypeGenerationIntention.self) else {
            return
        }
        
        for protNode in node.protocols {
            let intent =
                ProtocolInheritanceIntention(protocolName: protNode.name,
                                             source: protNode)
            
            ctx.addProtocol(intent)
        }
    }
    
    // MARK: - IVar Section
    private func enterObjcClassIVarsListNode(_ node: IVarsList) {
        let ctx = IVarListContext(accessLevel: .private)
        context.pushContext(ctx)
    }
    
    private func visitObjcClassIVarDeclarationNode(_ node: IVarDeclaration) {
        guard let classCtx = context.findContext(ofType: BaseClassIntention.self) else {
            return
        }
        let ivarCtx = context.findContext(ofType: IVarListContext.self)
        
        let access = ivarCtx?.accessLevel ?? .private
        
        var swiftType: SwiftType = .anyObject
        var ownership = Ownership.strong
        var isConstant = false
        if let type = node.type?.type {
            swiftType = typeMapper.swiftType(forObjcType: type,
                                             context: .init(inNonnull: isNodeInNonnullContext(node)))
            ownership = evaluateOwnershipPrefix(inType: type)
            isConstant = SwiftWriter._isConstant(fromType: type)
        }
        
        let storage = ValueStorage(type: swiftType, ownership: ownership, isConstant: isConstant)
        let ivar =
            InstanceVariableGenerationIntention(name: node.identifier?.name ?? "",
                                                storage: storage,
                                                accessLevel: access,
                                                source: node)
        
        ivar.inNonnullContext = isNodeInNonnullContext(node)
        
        classCtx.addInstanceVariable(ivar)
    }
    
    private func exitObjcClassIVarsListNode(_ node: IVarsList) {
        context.popContext() // InstanceVarContext
    }
    
    // MARK: - Enum Declaration
    private func enterObjcEnumDeclarationNode(_ node: ObjcEnumDeclaration) {
        guard let identifier = node.identifier else {
            return
        }
        guard let type = node.type else {
            return
        }
        
        let swiftType = typeMapper.swiftType(forObjcType: type.type)
        
        let enumIntention =
            EnumGenerationIntention(typeName: identifier.name,
                                    rawValueType: swiftType,
                                    source: node)
        
        context
            .findContext(ofType: FileGenerationIntention.self)?
            .addType(enumIntention)
        
        context.pushContext(enumIntention)
    }
    
    private func visitObjcEnumCaseNode(_ node: ObjcEnumCase) {
        guard let ctx = context.currentContext(as: EnumGenerationIntention.self) else {
            return
        }
        guard let identifier = node.identifier?.name else {
            return
        }
        
        let enumCase =
            EnumCaseGenerationIntention(name: identifier, expression: nil,
                                        accessLevel: .internal, source: node)
        
        
        if let expression = node.expression?.expression {
            let reader = SwiftASTReader()
            let exp = reader.parseExpression(expression: expression)
            
            enumCase.expression = exp
        }
        
        ctx.addCase(enumCase)
    }
    
    private func exitObjcEnumDeclarationNode(_ node: ObjcEnumDeclaration) {
        guard node.identifier != nil && node.type != nil else {
            return
        }
        
        context.popContext() // EnumGenerationIntention
    }
    
    // MARK: -
    
    private class IVarListContext: Context {
        var accessLevel: AccessLevel
        
        init(accessLevel: AccessLevel = .private) {
            self.accessLevel = accessLevel
        }
    }
}
