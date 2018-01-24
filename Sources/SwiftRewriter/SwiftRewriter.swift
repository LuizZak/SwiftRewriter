import GrammarModels

/// Allows re-writing Objective-C constructs into Swift equivalents.
public class SwiftRewriter {
    
    private var outputTarget: RewriterOutputTarget
    private let globalNode: GlobalContextNode
    private let context: TypeContext
    private let typeMapper: TypeMapper
    
    public init(outputTarget: RewriterOutputTarget, globalNode: GlobalContextNode) {
        self.outputTarget = outputTarget
        self.globalNode = globalNode
        self.context = TypeContext()
        self.typeMapper = TypeMapper(context: context)
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
        // Output class definitions in the order they where collected
        for cls in context.classes {
            outputClass(cls)
        }
        
        outputTarget.onAfterOutput()
    }
    
    private func outputClass(_ cls: ClassConstruct) {
        outputTarget.output(line: "class \(cls.name) {")
        outputTarget.idented {
            for prop in cls.properties {
                outputClassProperty(prop)
            }
        }
        outputTarget.output(line: "}")
    }
    
    private func outputClassProperty(_ prop: ClassConstruct.Property) {
        let type = prop.source!.type.type!
        
        let typeName = typeMapper.swiftType(forObjcType: type)
        
        var decl: String = "var "
        decl += "\(prop.name): \(typeName)"
        
        outputTarget.output(line: decl)
    }
    
    // MARK: - ObjcClassInterface
    private func enterObjcClassInterfaceNode(_ node: ObjcClassInterface) {
        if let name = node.identifier.name {
            let cls = context.defineClass(named: name)
            context.pushContext(cls)
        }
    }
    
    private func visitObjcClassInterfaceNode(_ node: ObjcClassInterface) {
        
    }
    
    private func exitObjcClassInterfaceNode(_ node: ObjcClassInterface) {
        context.popContext()
    }
    // MARK: -
    
    private func visitObjcClassInterfacePropertyNode(_ node: ObjcClassInterface.Property) {
        guard let ctx = context.context(ofType: ClassConstruct.self) else {
            return
        }
        
        ctx.addProperty(named: node.identifier.name ?? "",
                        type: node.type.type?.description ?? "",
                        source: node)
    }
}
