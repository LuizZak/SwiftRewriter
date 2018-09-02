import Foundation
import Antlr4
import ObjcParserAntlr

/// Base node type
open class ASTNode {
    /// Location for this node within the original source code
    public var location: SourceLocation
    
    /// Original source for this node.
    public var originalSource: Source?
    
    /// Children nodes associated with this node
    private(set) public var children: [ASTNode] = []
    
    // TODO: Start stripping away references to ANTLR from ASTNodes so we can
    // start considering serialization options for this type.
    
    /// If this node was parsed from an Antlr rule, this value is set to the original
    /// parser rule that originated this node.
    public var sourceRuleContext: ParserRuleContext?
    
    /// Parent node for this node
    public weak var parent: ASTNode?
    
    /// Whether this node exists in the original source code or was synthesized
    /// (for syntax error correction etc.)
    public var existsInSource: Bool
    
    /// Trivia leading up to this node
    public var leadingTrivia: Trivia?
    
    /// Trivia leading after this node
    public var trailingTrivia: Trivia?
    
    /// Instantiates a bare ASTNode with a given range.
    /// Defaults to an invalid range
    public init(location: SourceLocation = .invalid, existsInSource: Bool = true) {
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
    
    /// Inserts a node as a child of this node.
    /// - precondition: `node` has no previous parent node (`node.parent == nil`).
    public func insertChild(_ node: ASTNode, at index: Int) {
        guard node.parent == nil else {
            if node.parent === self {
                fatalError("Node is already a child of \(self)")
            } else {
                fatalError("Node already has a parent \(node.parent!)")
            }
        }
        
        node.parent = self
        children.insert(node, at: index)
    }
    
    /// Adds a new series of nodes as children of this node
    /// - precondition: All of the nodes have no previous parent node (`node.parent == nil`).
    public func addChildren(_ nodes: [ASTNode]) {
        for node in nodes {
            addChild(node)
        }
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
    
    /// Gets a child of a given type at a given index
    public func child<T: ASTNode>(ofType type: T.Type = T.self, atIndex index: Int) -> T? {
        let ch = childrenMatching(type: type)
        
        if index < 0 || index >= ch.count {
            return nil
        }
        
        return ch[index]
    }
    
    /// Gets children of this node of a given type
    public func childrenMatching<T: ASTNode>(type: T.Type = T.self) -> [T] {
        return children.compactMap { $0 as? T }
    }
    
    /// Gets the first child of this `ASTNode` that passes a given predicate.
    public func firstChild<T: ASTNode>(where predicate: (T) -> Bool) -> T? {
        for child in children {
            guard let cast = child as? T else {
                continue
            }
            
            if predicate(cast) {
                return cast
            }
        }
        
        return nil
    }
    
    /// Gets the first child of this `ASTNode` that is derived from a given type.
    public func firstChild<T: ASTNode>(ofType type: T.Type = T.self) -> T? {
        return firstChild { _ in true }
    }
    
    /// Updates the source range by making it the union of all of this node's
    /// children's ranges combined.
    /// Does nothing if resulting range is .invalid.
    public func updateSourceRange() {
        let range = children.reduce(SourceRange.invalid, { $0.union(with: $1.location.range) })
        
        switch range {
        case .invalid:
            break
        default:
            self.location.range = range
        }
    }
    
    /// Overriden by subclasses to provide custom short descriptions to be used
    /// when printing AST nodes for diagnostics
    public func shortDescription() -> String {
        return ""
    }
}

/// Describes a node with a parameterless `init()`
public protocol InitializableNode {
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
