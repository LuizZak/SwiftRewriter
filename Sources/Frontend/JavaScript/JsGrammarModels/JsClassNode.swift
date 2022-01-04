/// A node describing a JavaScript class.
public class JsClassNode: JsASTNode, JsInitializableNode {
    /// The name identifier for this class.
    public var identifier: JsIdentifierNode? {
        firstChild()
    }

    /// A list of constructors
    public var constructors: [JsConstructorDefinitionNode] {
        childrenMatching()
    }

    /// A list of methods.
    public var methods: [JsMethodDefinitionNode] {
        childrenMatching()
    }

    /// A list of class properties.
    public var properties: [JsClassPropertyNode] {
        childrenMatching()
    }

    /// A list of properties.

    public required init() {
        super.init()
    }
}
