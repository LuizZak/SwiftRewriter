import Antlr4

public class NonnullContextQuerier {
    /// When NS_ASSUME_NONNULL_BEGIN/END pairs are present on the source code, this
    /// array keeps the index of the BEGIN/END token pairs so that later on the
    /// rewriter can leverage this information to infer nonnull contexts.
    let nonnullMacroRegionsTokenRange: [(start: Int, end: Int)]
    
    public init(nonnullMacroRegionsTokenRange: [(start: Int, end: Int)]) {
        self.nonnullMacroRegionsTokenRange = nonnullMacroRegionsTokenRange
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
}
