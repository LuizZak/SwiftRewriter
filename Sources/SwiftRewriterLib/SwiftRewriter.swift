import GrammarModels
import ObjcParser

/// Allows re-writing Objective-C constructs into Swift equivalents.
public class SwiftRewriter {
    
    private var outputTarget: WriterOutput
    private let context: TypeContext
    private let typeMapper: TypeMapper
    private let intentionCollection: IntentionCollection
    private let sourcesProvider: InputSourcesProvider
    
    /// A diagnostics instance that collects all diagnostic errors during input
    /// source processing.
    public let diagnostics: Diagnostics
    
    public init(input: InputSourcesProvider, output: WriterOutput) {
        self.diagnostics = Diagnostics()
        self.sourcesProvider = input
        self.outputTarget = output
        self.context = TypeContext()
        self.typeMapper = TypeMapper(context: context)
        self.intentionCollection = IntentionCollection()
    }
    
    public func rewrite() throws {
        try loadInputSources()
        performIntentionPasses()
        outputDefinitions()
    }
    
    private func loadInputSources() throws {
        // Load input sources
        let sources = sourcesProvider.sources()
        
        for src in sources {
            try loadObjcSource(from: src)
        }
    }
    
    private func loadObjcSource(from source: InputSource) throws {
        // Generate intention for this source
        let fileIntent = FileGenerationIntention(filePath: source.sourceName())
        intentionCollection.addIntention(fileIntent)
        context.pushContext(fileIntent)
        defer {
            context.popContext()
        }
        
        let src = try source.loadSource()
        
        let parser = ObjcParser(source: src)
        parser.diagnostics = diagnostics
        
        try parser.parse()
        
        let node = parser.rootNode
        let visitor = AnonymousASTVisitor()
        let traverser = ASTTraverser(node: node, visitor: visitor)
        
        visitor.onEnterClosure = { node in
            switch node {
            case let n as ObjcClassInterface:
                self.enterObjcClassInterfaceNode(n)
            case let n as ObjcClassImplementation:
                self.enterObjcClassImplementationNode(n)
            case let n as IVarsList:
                self.enterObjcClassIVarsListNode(n)
            default:
                return
            }
        }
        
        visitor.visitClosure = { node in
            switch node {
            // Objective-C @interface class declarations
            case let n as ObjcClassInterface:
                self.visitObjcClassInterfaceNode(n)
                
            // Objective-C @implementation class definition
            case let n as ObjcClassImplementation:
                self.visitObjcClassImplementationNode(n)
                
            case let n as KeywordNode:
                self.visitKeywordNode(n)
            
            case let n as PropertyDefinition:
                self.visitObjcClassInterfacePropertyNode(n)
            
            case let n as MethodDefinition:
                self.visitObjcClassMethodNode(n)
                
            case let n as ObjcClassInterface.ProtocolReferenceList:
                self.visitObjcClassProtocolReferenceListNode(n)
                
            case let n as SuperclassName:
                self.visitObjcClassSuperclassName(n)
                
            case let n as IVarDeclaration:
                self.visitObjcClassIVarDeclarationNode(n)
            default:
                return
            }
        }
        
        visitor.onExitClosure = { node in
            switch node {
            case let n as ObjcClassInterface:
                self.exitObjcClassInterfaceNode(n)
            case let n as ObjcClassImplementation:
                self.exitObjcClassImplementationNode(n)
            case let n as IVarsList:
                self.exitObjcClassIVarsListNode(n)
            default:
                return
            }
        }
        
        traverser.traverse()
    }
    
    private func performIntentionPasses() {
        for pass in IntentionPasses.passes {
            pass.apply(on: intentionCollection)
        }
    }
    
    private func outputDefinitions() {
        let writer = SwiftWriter(intentions: intentionCollection, output: outputTarget)
        writer.execute()
    }
    
    private func visitKeywordNode(_ node: KeywordNode) {
        // Handle IVars list flagging
        if let ctx = context.context(ofType: IVarListContext.self) {
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
    
    // MARK: - ObjcClassInterface
    private func enterObjcClassInterfaceNode(_ node: ObjcClassInterface) {
        guard let name = node.identifier.name else {
            return
        }
        
        let intent =
            ClassGenerationIntention(typeName: name, source: node)
        
        intentionCollection.addIntention(intent)
        
        context
            .context(ofType: FileGenerationIntention.self)?
            .addType(intent)
        
        context.pushContext(intent)
    }
    
    private func visitObjcClassInterfaceNode(_ node: ObjcClassInterface) {
        
    }
    
    private func exitObjcClassInterfaceNode(_ node: ObjcClassInterface) {
        context.popContext() // ClassGenerationIntention
    }
    // MARK: -
    
    // MARK: - ObjcClassImplementation
    private func enterObjcClassImplementationNode(_ node: ObjcClassImplementation) {
        guard let name = node.identifier.name else {
            return
        }
        
        let intent =
            ClassGenerationIntention(typeName: name, source: node)
        
        intentionCollection.addIntention(intent)
        
        context
            .context(ofType: FileGenerationIntention.self)?
            .addType(intent)
        
        context.pushContext(intent)
    }
    
    private func visitObjcClassImplementationNode(_ node: ObjcClassImplementation) {
        
    }
    
    private func exitObjcClassImplementationNode(_ node: ObjcClassImplementation) {
        context.popContext() // ClassGenerationIntention
    }
    // MARK: -
    
    private func visitObjcClassInterfacePropertyNode(_ node: PropertyDefinition) {
        guard let ctx = context.context(ofType: ClassGenerationIntention.self) else {
            return
        }
        
        let prop =
            PropertyGenerationIntention(name: node.identifier.name ?? "",
                                        type: node.type.type ?? .struct(""),
                                        source: node)
        
        ctx.addProperty(prop)
    }
    
    private func visitObjcClassMethodNode(_ node: MethodDefinition) {
        guard let ctx = context.context(ofType: ClassGenerationIntention.self) else {
            return
        }
        
        let signGen =
            SwiftMethodSignatureGen(context: context, typeMapper: typeMapper)
        
        let sign = signGen.generateDefinitionSignature(from: node)
        
        let method =
            MethodGenerationIntention(signature: sign, source: node)
        
        method.body = node.body
        
        ctx.addMethod(method)
    }
    
    private func visitObjcClassSuperclassName(_ node: SuperclassName) {
        guard let ctx = context.context(ofType: ClassGenerationIntention.self) else {
            return
        }
        
        ctx.superclassName = node.name
    }
    
    private func visitObjcClassProtocolReferenceListNode(_ node: ObjcClassInterface.ProtocolReferenceList) {
        guard let ctx = context.context(ofType: ClassGenerationIntention.self) else {
            return
        }
        
        for protNode in node.protocols {
            let intent = ProtocolInheritanceIntention(protocolName: protNode.name, source: protNode)
            
            ctx.addProtocol(intent)
        }
    }
    
    // MARK: - IVar Section
    private func enterObjcClassIVarsListNode(_ node: IVarsList) {
        let ctx = IVarListContext(accessLevel: .private)
        context.pushContext(ctx)
    }
    
    private func visitObjcClassIVarDeclarationNode(_ node: IVarDeclaration) {
        guard let classCtx = context.context(ofType: ClassGenerationIntention.self) else {
            return
        }
        let ivarCtx =
            context.context(ofType: IVarListContext.self)
        
        let access = ivarCtx?.accessLevel ?? .private
        
        let ivar =
            InstanceVariableGenerationIntention(
                name: node.identifier.name ?? "",
                type: node.type.type ?? .struct(""),
                accessLevel: access,
                source: node)
        
        classCtx.addInstanceVariable(ivar)
    }
    
    private func exitObjcClassIVarsListNode(_ node: IVarsList) {
        context.popContext() // InstanceVarContext
    }
    // MARK: -
    
    private class IVarListContext: Context {
        var accessLevel: AccessLevel
        
        init(accessLevel: AccessLevel = .private) {
            self.accessLevel = accessLevel
        }
    }
}
