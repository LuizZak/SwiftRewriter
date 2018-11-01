import GrammarModels

/// An intention represents the intent of the code transpiler to generate a
/// file/class/struct/property/etc. with Swift code.
public protocol IntentionProtocol: class {
    /// Gets the history tracker for this intention
    var history: IntentionHistory { get }
}

/// An intention represents the intent of the code transpiler to generate a
/// file/class/struct/property/etc. with Swift code.
public class Intention: IntentionProtocol, Historic, Codable {
    private var _history = IntentionHistoryTracker()
    
    /// Original source location of the node that generated this intention
    public var originLocation: SourceLocation?
    
    /// Reference to an AST node that originated this source-code generation
    /// intention
    var source: ASTNode? {
        didSet {
            if let source = source {
                originLocation = source.location
            }
        }
    }
    
    /// Parent for this intention
    public internal(set) weak var parent: Intention?
    
    /// Gets the history tracker for this intention
    public var history: IntentionHistory {
        return _history
    }
    
    public init() {
        
    }
    
    public init(source: ASTNode?) {
        self.source = source
        self.originLocation = source?.location
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        _history = try container.decode(IntentionHistoryTracker.self,
                                        forKey: .history)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(_history, forKey: .history)
    }
    
    private enum CodingKeys: String, CodingKey {
        case history
    }
}

public extension Intention {
    public func ancestor<T: Intention>(ofType type: T.Type) -> T? {
        if let parent = parent as? T {
            return parent
        }
        
        return parent?.ancestor(ofType: type)
    }
}
