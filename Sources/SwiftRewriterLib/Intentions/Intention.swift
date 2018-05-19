import GrammarModels

/// An intention represents the intent of the code transpiler to generate a
/// file/class/struct/property/etc. with Swift code.
public protocol Intention: class, Historic {
    /// Reference to an AST node that originated this source-code generation
    /// intention
    var source: ASTNode? { get }
    
    /// Parent for this intention
    var parent: Intention? { get }
}
