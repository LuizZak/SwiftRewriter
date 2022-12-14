import SwiftAST
import Intentions

/// A basic protocol with two front-end methods for requesting resolving of types
/// of expression and statements on intention collections.
public protocol TypeResolverInvoker {
    /// Invocates the resolution of types for all expressions from all method bodies
    /// contained within an intention collection.
    func resolveAllExpressionTypes(in intentions: IntentionCollection, force: Bool)
    
    /// Resolves all types within a given method intention.
    func resolveExpressionTypes(in method: MethodGenerationIntention, force: Bool)
    
    /// Resolves all types from all expressions that may be contained within
    /// computed accessors of a given property.
    func resolveExpressionTypes(in property: PropertyGenerationIntention, force: Bool)

    /// Resolves all types from a given function body-carrying intention.
    func resolveExpressionTypes(in functionBody: FunctionBodyCarryingIntention, force: Bool)
    
    /// Resolves the type of a given expression as if it was a global expression
    /// located at a given file.
    func resolveGlobalExpressionType(
        in expression: Expression,
        inFile file: FileGenerationIntention,
        force: Bool
    )
}
