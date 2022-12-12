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
        // Detect stored variables that should be declared using CallGraphValueStorageIntention
        switch declaration {
        // Separate initializers from variable references
        case .globalVariable(let decl, _):
            let initializer = ensureNode(.statement(declaration))
            let declNode = ensureNode(CallGraphValueStorageIntention.globalVariable(decl))

            ensureEdge(from: declNode, to: initializer)

            return declNode
        default:
            break
        }

        return ensureNode(.statement(declaration))
    }

    @discardableResult
    func ensureNode(_ declaration: CallGraphValueStorageIntention) -> Node {
        ensureNode(.stored(declaration))
    }

    @discardableResult
    func ensureNode(_ declaration: CallGraphNode.DeclarationKind) -> Node {
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
    public let declaration: DeclarationKind

    /// Gets the type symbol that owns the node related to this call graph, in
    /// case the node is a member of a type.
    var ownerType: KnownType? {
        declaration.ownerType
    }

    /// Gets the file that owns the node related to this call graph, in case the
    /// node is a member of a file.
    var ownerFile: KnownFile? {
        declaration.ownerFile
    }

    init(declaration: FunctionBodyCarryingIntention) {
        self.declaration = .statement(declaration)
    }

    init(declaration: CallGraphValueStorageIntention) {
        self.declaration = .stored(declaration)
    }

    init(declaration: DeclarationKind) {
        self.declaration = declaration
    }

    /// Specifies the declaration that is referenced by this call graph node.
    /// Is either a statement-based construct, like a function body or computed
    /// property getter, or a stored value like 
    public enum DeclarationKind: Hashable {
        case statement(FunctionBodyCarryingIntention)
        case stored(CallGraphValueStorageIntention)

        /// If this enumerator value is a `.statement` case, returns the associated
        /// value, otherwise returns `nil`.
        var asStatement: FunctionBodyCarryingIntention? {
            switch self {
            case .statement(let decl):
                return decl
            case .stored:
                return nil
            }
        }

        /// If this enumerator value is a `.statement` case, returns the associated
        /// value, otherwise returns `nil`.
        var asStored: CallGraphValueStorageIntention? {
            switch self {
            case .stored(let decl):
                return decl
            case .statement:
                return nil
            }
        }

        /// Gets the type symbol that owns the node related to this call graph
        /// declaration kind, in case the declaration is a member of a type.
        var ownerType: KnownType? {
            switch self {
            case .statement(let declaration):
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
            
            case .stored(let declaration):
                switch declaration {
                case .property(let decl):
                    return decl.type
                case .instanceVariable(let decl):
                    return decl.type
                case .globalVariable:
                    return nil
                }
            }
        }

        /// Gets the file that owns the symbol related to this call graph declaration
        /// kind.
        var ownerFile: KnownFile? {
            switch self {
            case .statement(let decl):
                return decl.ownerFile

            case .stored(let decl):
                return decl.ownerFile
            }
        }

        public func hash(into hasher: inout Hasher) {
            switch self {
            case .statement(let stmt):
                hasher.combine(stmt)
            case .stored(let intention):
                hasher.combine(intention)
            }
        }

        public static func == (lhs: Self, rhs: Self) -> Bool {
            switch (lhs, rhs) {
            case (.statement(let lhs), .statement(let rhs)):
                return lhs == rhs
            
            case (.stored(let lhs), .stored(let rhs)):
                return lhs == rhs
            
            default:
                return false
            }
        }
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

/// Describes an intention that is configured to reference a stored value, instead
/// of a computed property getter or function body.
public enum CallGraphValueStorageIntention: Hashable {
    case property(PropertyGenerationIntention)
    case instanceVariable(InstanceVariableGenerationIntention)
    case globalVariable(GlobalVariableGenerationIntention)

    public var asProperty: PropertyGenerationIntention? {
        switch self {
        case .property(let value):
            return value
        default:
            return nil
        }
    }

    public var asInstanceVariable: InstanceVariableGenerationIntention? {
        switch self {
        case .instanceVariable(let value):
            return value
        default:
            return nil
        }
    }

    public var asGlobalVariable: GlobalVariableGenerationIntention? {
        switch self {
        case .globalVariable(let value):
            return value
        default:
            return nil
        }
    }

    /// Returns the type-erased `ValueStorageIntention` associated with this
    /// enumerator value.
    public var storageIntention: ValueStorageIntention {
        switch self {
        case .globalVariable(let intention):
            return intention
        case .instanceVariable(let intention):
            return intention
        case .property(let intention):
            return intention
        }
    }

    /// Gets the file that owns the underlying symbol referenced by this
    /// `CallGraphValueStorageIntention`.
    var ownerFile: KnownFile? {
        switch self {
        case .globalVariable(let intention):
            return intention.file
        case .instanceVariable(let intention):
            return intention.file
        case .property(let intention):
            return intention.file
        }
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(storageIntention))
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.storageIntention === rhs.storageIntention
    }
}
