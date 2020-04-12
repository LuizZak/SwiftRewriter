import GrammarModels
import Utils
import Intentions
import TypeSystem

/// A protocol for objects that perform passes through intentions collected and
/// perform changes and optimizations on them.
public protocol IntentionPass {
    func apply(on intentionCollection: IntentionCollection, context: IntentionPassContext)
}

/// Context for an intention pass
public struct IntentionPassContext {
    public let typeSystem: TypeSystem
    
    public let typeMapper: TypeMapper
    
    /// Frontend point to request type-resolution of expressions, statements and
    /// entire intention collections.
    public let typeResolverInvoker: TypeResolverInvoker
    
    /// Number of threads allowed to spin in parallel
    public let numThreads: Int
    
    /// Must be called by every `IntentionPass` if it makes any sort of change
    /// to the intentions list, or syntax tree of any member.
    ///
    /// Not calling this method may result in stale syntax structure metadata,
    /// like expression types, being fed to subsequent intention passes.
    public let notifyChange: () -> Void
    
    public init(typeSystem: TypeSystem,
                typeMapper: TypeMapper,
                typeResolverInvoker: TypeResolverInvoker,
                numThreads: Int,
                notifyChange: @escaping () -> Void = { }) {
        
        self.typeSystem = typeSystem
        self.typeMapper = typeMapper
        self.typeResolverInvoker = typeResolverInvoker
        self.numThreads = numThreads
        self.notifyChange = notifyChange
    }
}

/// A simple intention passes source that feeds from a contents array
public struct ArrayIntentionPassSource: IntentionPassSource {
    public var intentionPasses: [IntentionPass]
    
    public init(intentionPasses: [IntentionPass]) {
        self.intentionPasses = intentionPasses
    }
}

/// A protocol for sourcing intention passes
public protocol IntentionPassSource {
    var intentionPasses: [IntentionPass] { get }
}
