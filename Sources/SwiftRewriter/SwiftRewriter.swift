import GrammarModels

/// Allows re-writing Objective-C constructs into Swift equivalents.
public class SwiftRewriter {
    
    private var outputTarget: RewriterOutputTarget
    private let globalNode: GlobalContextNode
    
    public init(outputTarget: RewriterOutputTarget, globalNode: GlobalContextNode) {
        self.outputTarget = outputTarget
        self.globalNode = globalNode
    }
    
    public func add(classInterface interface: ObjcClassInterface) {
        globalNode.addChild(interface)
    }
    
    public func rewrite() throws {
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
        
        outputTarget.onAfterOutput()
    }
    
    private func enterObjcClassInterfaceNode(_ node: ObjcClassInterface) {
        outputTarget.output(line: "class \(node.identifier.name ?? "<Unknown>") {")
    }
    
    private func visitObjcClassInterfaceNode(_ node: ObjcClassInterface) {
        
    }
    
    private func exitObjcClassInterfaceNode(_ node: ObjcClassInterface) {
        outputTarget.output(line: "}")
    }
}
