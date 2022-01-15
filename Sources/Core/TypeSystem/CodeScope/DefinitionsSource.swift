import SwiftAST

/// An object that can provide definitions for a type resolver
public protocol DefinitionsSource {
    /// Searches for the first definition matching a given name, recursively
    /// through all scopes, from innermost to outermost
    func firstDefinition(named name: String) -> CodeDefinition?
    
    /// Returns all function definitions that match a given function identifier
    func functionDefinitions(matching identifier: FunctionIdentifier) -> [CodeDefinition]
    
    /// Returns all function definitions that have an initial function identifier
    /// matching a given name
    func functionDefinitions(named name: String) -> [CodeDefinition]
    
    /// Returns all definitions from this local scope only
    func localDefinitions() -> [CodeDefinition]
}
