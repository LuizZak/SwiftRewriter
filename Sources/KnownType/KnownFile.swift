import SwiftAST

/// Represents the symbolic structure of a known source code file.
public protocol KnownFile {
    /// Gets a file name, excluding path.
    var fileName: String { get }
    
    /// Gets a list of known types defined within this file.
    var knownTypes: [KnownType] { get }
    
    /// Gets a list of all globals defined within the file.
    var knownGlobals: [KnownGlobal] { get }
    
    /// Gets a list of all import compiler directives used within the file.
    var knownImportDirectives: [String] { get }
}

/// A protocol for denoting global-level declartions, such as functions and variables.
public protocol KnownGlobal: KnownDeclaration, SemanticalObject {
    
}

/// A protocol for denoting global-level variables.
public protocol KnownGlobalVariable: KnownGlobal {
    /// Gets the name for this variable
    var name: String { get }
    
    /// Gets the storage information for this global variable
    var storage: ValueStorage { get }
}

/// A protocol for denoting global-level functions.
public protocol KnownGlobalFunction: KnownGlobal {
    /// Gets the identifier for this global function
    var identifier: FunctionIdentifier { get }
    
    /// Gets the type signature for this global function
    var signature: FunctionSignature { get }
}
