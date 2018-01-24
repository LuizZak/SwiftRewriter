import GrammarModels

/// Allows re-writing Objective-C constructs into Swift equivalents.
public class SwiftRewriter {
    
    private var outputTarget: WriterOutput
    private let globalNode: GlobalContextNode
    private let context: TypeContext
    private let typeMapper: TypeMapper
    private let intentionCollection: IntentionCollection
    
    public init(outputTarget: WriterOutput, globalNode: GlobalContextNode) {
        self.outputTarget = outputTarget
        self.globalNode = globalNode
        self.context = TypeContext()
        self.typeMapper = TypeMapper(context: context)
        self.intentionCollection = IntentionCollection()
    }
    
    public func add(classInterface interface: ObjcClassInterface) {
        globalNode.addChild(interface)
    }
    
    public func rewrite() throws {
        try collectDefinitions()
        outputDefinitions()
    }
    
    public func collectDefinitions() throws {
        let node = globalNode
        let visitor = AnonymousASTVisitor()
        let traverser = ASTTraverser(node: node, visitor: visitor)
        
        visitor.onEnterClosure = { node in
            switch node {
            case let n as ObjcClassInterface:
                self.enterObjcClassInterfaceNode(n)
            default:
                return
            }
        }
        
        visitor.visitClosure = { node in
            switch node {
            case let n as ObjcClassInterface:
                self.visitObjcClassInterfaceNode(n)
            case let n as ObjcClassInterface.Property:
                self.visitObjcClassInterfacePropertyNode(n)
            default:
                return
            }
        }
        
        visitor.onExitClosure = { node in
            switch node {
            case let n as ObjcClassInterface:
                self.exitObjcClassInterfaceNode(n)
            default:
                return
            }
        }
        
        traverser.traverse()
    }
    
    private func outputDefinitions() {
        let writer = SwiftWriter(intentions: intentionCollection, output: outputTarget)
        writer.execute()
    }
    
    // MARK: - ObjcClassInterface
    private func enterObjcClassInterfaceNode(_ node: ObjcClassInterface) {
        if let name = node.identifier.name {
            let intent =
                ClassGenerationIntention(typeName: name, source: node)
            
            intentionCollection.addIntention(intent)
            
            context.pushContext(intent)
        }
    }
    
    private func visitObjcClassInterfaceNode(_ node: ObjcClassInterface) {
        
    }
    
    private func exitObjcClassInterfaceNode(_ node: ObjcClassInterface) {
        context.popContext()
    }
    // MARK: -
    
    private func visitObjcClassInterfacePropertyNode(_ node: ObjcClassInterface.Property) {
        guard let ctx = context.context(ofType: ClassGenerationIntention.self) else {
            return
        }
        
        let prop =
            PropertyGenerationIntention(name: node.identifier.name ?? "",
                                        type: node.type.type ?? .struct(""),
                                        source: node)
        
        ctx.addProperty(prop)
    }
}
