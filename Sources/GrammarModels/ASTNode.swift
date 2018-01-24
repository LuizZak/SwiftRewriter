/// A protocol wrapping node types
public protocol ASTNodeValue {
    /// Location for this node
    var location: SourceRange { get }
    
    /// Trivia leading up to this node
    var leadingTrivia: Trivia? { get }
    
    /// Trivia leading after this node
    var trailingTrivia: Trivia? { get }
    
    /// Parent node value for this node
    var parentNode: ASTNodeValue? { get }
}

/// Base node type
open class ASTNode: ASTNodeValue {
    /// Location for this node
    public var location: SourceRange
    
    /// Children nodes associated with this node
    private(set) public var children: [ASTNode] = []
    
    /// Parent node for this node
    public weak var parent: ASTNode?
    public var parentNode: ASTNodeValue? {
        return parent
    }
    
    /// Whether this node exists in the original source code or was synthesized
    /// (for syntax error correction etc.)
    public var existsInSource: Bool
    
    /// Trivia leading up to this node
    public var leadingTrivia: Trivia?
    
    /// Trivia leading after this node
    public var trailingTrivia: Trivia?
    
    /// Instantiates a bare ASTNode with a given range.
    /// Defaults to an invalid range
    public init(location: SourceRange = .invalid, existsInSource: Bool = true) {
        self.location = location
        self.existsInSource = existsInSource
    }
    
    /// Adds a new node as a child of this node
    /// - precondition: `node` has no previous parent node (`node.parent == nil`).
    public func addChild(_ node: ASTNode) {
        guard node.parent == nil else {
            if node.parent === self {
                fatalError("Node is already a child of \(self)")
            } else {
                fatalError("Node already has a parent \(node.parent!)")
            }
        }
        
        node.parent = self
        children.append(node)
    }
    
    /// Removes a node as a child of this node
    public func removeChild(_ node: ASTNode) {
        guard node.parent === self else {
            return
        }
        
        node.parent = nil
        if let index = children.index(where: { $0 === node }) {
            children.remove(at: index)
        }
    }
    
    /// Gets children of this node of a given type
    public func childrenMatching<T: ASTNode>(type: T.Type = T.self) -> [T] {
        return children.flatMap { $0 as? T }
    }
    
    /// Updates the source range by making it the union of all of this node's
    /// children's ranges combined.
    /// Does nothing if resulting range is .invalid.
    public func updateSourceRange() {
        let range = children.reduce(SourceRange.invalid, { $0.union(with: $1.location) })
        
        switch range {
        case .invalid:
            break
        default:
            self.location = range
        }
    }
}

/// Describes a node with a parameterless `init()`
public protocol InitializableNode: ASTNodeValue {
    init()
}

/// A bare node used to specify invalid contexts
public class InvalidNode: ASTNode {
    
}

/// Trivia encompasses spacing characters and comments between nodes
public enum Trivia {
    indirect case singleLineComment(String, leadingSpace: String)
    indirect case multiLineComments(String, leadingSpace: String)
    case spacing(String)
}

public enum ASTNodeRef<Node: ASTNodeValue>: ASTNodeValue {
    case valid(Node)
    case invalid(InvalidNode)
    
    public static var placeholder: ASTNodeRef<Node> {
        return .invalid(InvalidNode(location: .invalid))
    }
    
    /// Node value in case this is `.valid(node)`, or `nil`, otherwise.
    public var nodeValue: Node? {
        switch self {
        case .valid(let node):
            return node
        case .invalid:
            return nil
        }
    }
    
    /// Returns `true` if self is an instance of the `valid` case
    public var exists: Bool {
        switch self {
        case .valid:
            return true
        case .invalid:
            return false
        }
    }
    
    public var location: SourceRange {
        switch self {
        case .valid(let node):
            return node.location
        case .invalid:
            return .invalid
        }
    }
    
    public var leadingTrivia: Trivia? {
        switch self {
        case .valid(let node):
            return node.leadingTrivia
        case .invalid:
            return nil
        }
    }
    
    public var trailingTrivia: Trivia? {
        switch self {
        case .valid(let node):
            return node.trailingTrivia
        case .invalid:
            return nil
        }
    }
    
    public var parentNode: ASTNodeValue? {
        switch self {
        case .valid(let node):
            return node.parentNode
        case .invalid(let node):
            return node.parentNode
        }
    }
}
