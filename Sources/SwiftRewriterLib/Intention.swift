import GrammarModels

/// An intention represents the intent of the code transpiler to generate a
/// file/class/struct/property/etc. with Swift code.
public protocol Intention: class, Context {
    /// Reference to an AST node that originated this source-code generation
    /// intention
    var source: ASTNode? { get }
    
    /// Parent for this intention
    var parent: Intention? { get }
}

/// Tracks changes made to an intention as it is read by AST readers and modified
/// by intention passes so it can be sourced
public protocol IntentionHistory {
    
}
