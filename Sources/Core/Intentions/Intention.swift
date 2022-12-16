import Utils
import GrammarModelBase

/// An intention represents the intent of the code transpiler to generate a
/// file/class/struct/property/etc. with Swift code.
public protocol IntentionProtocol: AnyObject, Historic {

}

/// An intention represents the intent of the code transpiler to generate a
/// file/class/struct/property/etc. with Swift code.
public class Intention: IntentionProtocol, Codable {
    private var _history = IntentionHistoryTracker()

    /// Original source location of the node that generated this intention
    public var originLocation: SourceLocation?
    
    /// Reference to an AST node that originated this source-code generation
    /// intention
    public var source: ASTNode? {
        didSet {
            if let source = source {
                originLocation = source.location
            }
        }
    }

    /// Gets a string representing the source of the `ASTNode` that originated
    /// this intention object.
    ///
    /// Returns "<unknown>" if the origin could not be derived via `self.source`.
    public var sourceOrigin: String {
        get {
            guard let sourceNode = source else {
                return "<unknown>"
            }
            guard let source = sourceNode.originalSource else {
                return "<unknown>"
            }

            if let location = originLocation {
                return "\(source.filePath):\(location.line):\(location.column)"
            } else {
                return source.filePath
            }
        }
    }
    
    /// Parent for this intention
    public internal(set) weak var parent: Intention?

    /// Sub-intentions nested within this intention object.
    public var children: [Intention] {
        []
    }
    
    /// Gets the history tracker for this intention
    public var history: IntentionHistory {
        _history
    }

    /// Accesses custom run-time metadata for this intention object.
    public var metadata: SerializableMetadata
    
    public init(source: ASTNode?) {
        self.source = source
        self.originLocation = source?.location
        self.metadata = .init()
    }

    public convenience init() {
        self.init(source: nil)
    }

    public func accept<T: IntentionVisitor>(_ visitor: T) -> T.Result {
        fatalError("Must be overridden by subclasses")
    }
    
    private enum CodingKeys: String, CodingKey {
        case _history = "history"
        case metadata
    }
}

public extension Intention {
    func ancestor<T: Intention>(ofType type: T.Type) -> T? {
        if let parent = parent as? T {
            return parent
        }
        
        return parent?.ancestor(ofType: type)
    }
}
