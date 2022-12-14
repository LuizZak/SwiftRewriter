import SwiftAST
import KnownType
import Intentions
import TypeSystem

/// Simplified API interface to find usages of symbols across intentions
public protocol UsageAnalyzer {
    /// Finds all usages of a known method
    func findUsagesOf(method: KnownMethod) -> [DefinitionUsage]
    
    /// Finds all usages of a known property
    func findUsagesOf(property: KnownProperty) -> [DefinitionUsage]
}
