import Antlr4
import Utils

extension Source {
    /// Returns the source location for the beginning of a specified parser token.
    ///
    /// Assumes that the token was directly parsed from this source code in full,
    /// and not a substring.
    public func sourceLocation(for token: Token) -> SourceLocation {
        let startIndex = token.getStartIndex()
        if startIndex == -1 {
            return .invalid
        }

        let sourceStartIndex = stringIndex(forCharOffset: startIndex)

        return sourceLocation(atStringIndex: sourceStartIndex)
    }

    /// Returns the source location for the beginning of a specified parser rule
    /// context object.
    ///
    /// Assumes that the parser rule was directly parsed from this source code
    /// in full, and not a substring.
    public func sourceLocation(for rule: ParserRuleContext) -> SourceLocation {
        guard let startIndex = rule.start?.getStartIndex() else {
            return .invalid
        }

        let sourceStartIndex = stringIndex(forCharOffset: startIndex)

        return sourceLocation(atStringIndex: sourceStartIndex)
    }

    /// Returns the source range for a specified parser rule context object.
    ///
    /// Assumes that the parser rule was directly parsed from this source code
    /// in full, and not a substring.
    public func sourceRange(for rule: ParserRuleContext) -> SourceRange {
        guard let startIndex = rule.start?.getStartIndex(), let endIndex = rule.stop?.getStopIndex() else {
            return .invalid
        }

        let sourceStartIndex = stringIndex(forCharOffset: startIndex)
        let sourceEndIndex = stringIndex(forCharOffset: endIndex + 1 /* ANTLR character ranges are inclusive */)

        let startLoc = sourceLocation(atStringIndex: sourceStartIndex)
        let endLoc = sourceLocation(atStringIndex: sourceEndIndex)

        return .range(start: startLoc, end: endLoc)
    }

    /// Returns the source range for a specified terminal node rule context object.
    ///
    /// Assumes that the terminal node was directly parsed from this source code
    /// in full, and not a substring.
    public func sourceRange(for node: TerminalNode) -> SourceRange {
        guard let symbol = node.getSymbol() else {
            return .invalid
        }
        
        let startIndex = symbol.getStartIndex()
        let endIndex = symbol.getStopIndex()

        let sourceStartIndex = stringIndex(forCharOffset: startIndex)
        let sourceEndIndex = stringIndex(forCharOffset: endIndex + 1 /* ANTLR character ranges are inclusive */)

        let startLoc = sourceLocation(atStringIndex: sourceStartIndex)
        let endLoc = sourceLocation(atStringIndex: sourceEndIndex)

        return .range(start: startLoc, end: endLoc)
    }
}
