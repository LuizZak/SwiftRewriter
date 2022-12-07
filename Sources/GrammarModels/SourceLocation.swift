// Based on SwiftSyntax's own 'AbsolutePosition' structure
public struct SourceLocation: Comparable, Hashable, Codable {
    public static let invalid = SourceLocation(line: 0, column: 0, utf8Offset: 0)
    
    public var isValid: Bool {
        line != 0 || column != 0 || utf8Offset != 0
    }
    
    public let line: Int
    public let column: Int
    public let utf8Offset: Int
    
    public init(line: Int, column: Int, utf8Offset: Int) {
        self.line = line
        self.column = column
        self.utf8Offset = utf8Offset
    }

    /// Returns the source length that represents the number of lines and columns
    /// between `self` and `other`.
    public func length(to other: Self) -> SourceLength {
        let start = min(self, other)
        let end = max(self, other)

        let lineOffset = end.line - start.line
        let columnsAtLastLine = end.column
        let utf8Offset = end.utf8Offset - start.utf8Offset

        return SourceLength(
            newlines: lineOffset,
            columnsAtLastLine: columnsAtLastLine,
            utf8Length: utf8Offset
        )
    }
    
    public static func < (lhs: SourceLocation, rhs: SourceLocation) -> Bool {
        lhs.utf8Offset < rhs.utf8Offset
    }
}
