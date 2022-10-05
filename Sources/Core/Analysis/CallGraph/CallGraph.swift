import Intentions
import TypeSystem
import KnownType

/// Represents call order dependencies of functions, computed variables, and
/// subscripts in a program.
public class CallGraph: DirectedGraphBase<CallGraphNode, CallGraphEdge> {
    /// Adds an edge `start -> end` to this graph.
    @discardableResult
    override func addEdge(from start: Node, to end: Node) -> Edge {
        assert(
            containsNode(start),
            "Attempted to add edge between nodes that are not contained within this graph: \(start)."
        )
        assert(
            containsNode(end),
            "Attempted to add edge between nodes that are not contained within this graph: \(end)."
        )
        
        let edge = Edge(start: start, end: end)
        addEdge(edge)
        
        return edge
    }

    public static func fromIntentions(
        _ collection: IntentionCollection,
        typeSystem: TypeSystem
    ) -> CallGraph {
        
        _fromIntentions(collection, typeSystem: typeSystem)
    }

    @discardableResult
    func ensureNode(_ declaration: FunctionBodyCarryingIntention) -> Node {
        if let node = nodes.first(where: { $0.declaration == declaration }) {
            return node
        }

        let node = Node(declaration: declaration)
        addNode(node)
        
        return node
    }
}

/// A node in a call graph.
public class CallGraphNode: DirectedGraphNode {
    public let declaration: FunctionBodyCarryingIntention

    /// Gets the type symbol that owns the node related to this call graph, in
    /// case the node is a member of a type.
    var ownerType: KnownType? {
        switch declaration {
        case .method(let decl):
            return decl.type

        case .initializer(let decl):
            return decl.type

        case .deinit(let decl):
            return decl.type

        case .propertyGetter(let decl, _):
            return decl.type

        case .propertySetter(let decl, _):
            return decl.type

        case .subscriptGetter(let decl, _):
            return decl.type

        case .subscriptSetter(let decl, _):
            return decl.type

        case .propertyInitializer(let decl, _):
            return decl.type

        case .global, .globalVariable:
            return nil
        }
    }

    /// Gets the file that owns the node related to this call graph, in case the
    /// node is a member of a file.
    var ownerFile: KnownFile? {
        switch declaration {
        case .method(let decl):
            return decl.file

        case .initializer(let decl):
            return decl.file

        case .deinit(let decl):
            return decl.file

        case .propertyGetter(let decl, _):
            return decl.file

        case .propertySetter(let decl, _):
            return decl.file

        case .subscriptGetter(let decl, _):
            return decl.file

        case .subscriptSetter(let decl, _):
            return decl.file

        case .propertyInitializer(let decl, _):
            return decl.file

        case .global(let decl):
            return decl.file
        
        case .globalVariable(let decl, _):
            return decl.file
        }
    }

    init(declaration: FunctionBodyCarryingIntention) {
        self.declaration = declaration
    }
}

/// An edge in a call graph.
public class CallGraphEdge: DirectedGraphBaseEdgeType {
    public let start: CallGraphNode
    public let end: CallGraphNode

    /// A label that can be used during debugging to discern call graph edges.
    public var debugLabel: String?

    internal init(start: CallGraphNode, end: CallGraphNode) {
        self.start = start
        self.end = end
    }
}
