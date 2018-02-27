import GrammarModels
import Foundation
import Utils

/// A protocol for objects that perform passes through intentions collected and
/// perform changes and optimizations on them.
public protocol IntentionPass {
    func apply(on intentionCollection: IntentionCollection, context: IntentionPassContext)
}

/// Context for an intention pass
public struct IntentionPassContext {
    public let typeSystem: TypeSystem
    
    /// Frontend point to request type-resolution of expressions, statements and
    /// entire intention collections.
    public let typeResolverInvoker: TypeResolverInvoker
    
    public init(typeSystem: TypeSystem, typeResolverInvoker: TypeResolverInvoker) {
        self.typeSystem = typeSystem
        self.typeResolverInvoker = typeResolverInvoker
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
