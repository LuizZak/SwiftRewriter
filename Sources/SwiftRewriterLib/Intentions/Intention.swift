import GrammarModels

/// An intention represents the intent of the code transpiler to generate a
/// file/class/struct/property/etc. with Swift code.
public protocol IntentionProtocol: class {
    /// Gets the history tracker for this intention
    var history: IntentionHistory { get }
}

/// An intention represents the intent of the code transpiler to generate a
/// file/class/struct/property/etc. with Swift code.
public class Intention: IntentionProtocol, Historic {
    /// Reference to an AST node that originated this source-code generation
    /// intention
    public var source: ASTNode?
    
    /// Parent for this intention
    public internal(set) weak var parent: Intention?
    
    /// Gets the history tracker for this intention
    public let history: IntentionHistory = IntentionHistoryTracker()
    
    public init() {
        
    }
    
    public init(source: ASTNode?) {
        self.source = source
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
