import Antlr4
import Utils

public class NonnullContextQuerier {
    /// When NS_ASSUME_NONNULL_BEGIN/END pairs are present on the source code, this
    /// array keeps the index of the BEGIN/END token pairs so that later on the
    /// rewriter can leverage this information to infer nonnull contexts.
    let nonnullMacroRegionsTokenRange: [(start: Int, end: Int)]

    /// When NS_ASSUME_NONNULL_BEGIN/END pairs are present on the source code, this
    /// array keeps the index of the BEGIN/END source location pairs so that
    /// later on the rewriter can leverage this information to infer nonnull contexts.
    ///
    /// Alternative to `nonnullMacroRegionsTokenRange`.
    let nonnullMacroRegionsRanges: [SourceRange]
    
    public init(
        nonnullMacroRegionsTokenRange: [(start: Int, end: Int)],
        nonnullMacroRegionsRanges: [SourceRange]
    ) {
        self.nonnullMacroRegionsTokenRange = nonnullMacroRegionsTokenRange
        self.nonnullMacroRegionsRanges = nonnullMacroRegionsRanges
    }
    
    public func isInNonnullContext(_ node: ParserRuleContext) -> Bool {
        guard let startToken = node.getStart(), let stopToken = node.getStop() else {
            return false
        }
        
        // Check if it the token start/end indices are completely contained
        // within NS_ASSUME_NONNULL_BEGIN/END intervals
        for n in nonnullMacroRegionsTokenRange {
            if n.start <= startToken.getTokenIndex() && n.end >= stopToken.getTokenIndex() {
                return true
            }
        }
        
        return false
    }

    /// Queries that a given source location is contained within a nonnull context.
    public func isInNonnullContext(_ location: SourceLocation) -> Bool {
        return nonnullMacroRegionsRanges.contains(where: { $0.contains(location) })
    }

    /// Queries that a given source range is contained entirely within a nonnull
    /// context.
    public func isInNonnullContext(_ range: SourceRange) -> Bool {
        guard let start = range.start, let end = range.end else {
            return false
        }

        return isInNonnullContext(start) && isInNonnullContext(end)
    }
}
