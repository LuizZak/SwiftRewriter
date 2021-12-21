// Based on SwiftSyntax's own `SourceLength` structure
public struct SourceLength: Codable {
    /// A zero-length source length
    public static let zero: SourceLength =
        SourceLength(newlines: 0, columnsAtLastLine: 0, utf8Length: 0)
    
    public let newlines: Int
    public let columnsAtLastLine: Int
    public let utf8Length: Int
    
    public init(newlines: Int, columnsAtLastLine: Int, utf8Length: Int) {
        self.newlines = newlines
        self.columnsAtLastLine = columnsAtLastLine
        self.utf8Length = utf8Length
    }
    
    /// Combine the length of two source length. Note that the addition is *not*
    /// commutative (3 columns + 1 line = 1 line but 1 line + 3 columns = 1 line
    /// and 3 columns)
    public static func + (lhs: SourceLength, rhs: SourceLength) -> SourceLength {
        let utf8Length = lhs.utf8Length + rhs.utf8Length
        let newlines = lhs.newlines + rhs.newlines
        let columnsAtLastLine: Int
        if rhs.newlines == 0 {
            columnsAtLastLine = lhs.columnsAtLastLine + rhs.columnsAtLastLine
        } else {
            columnsAtLastLine = rhs.columnsAtLastLine
        }
        return SourceLength(newlines: newlines,
                            columnsAtLastLine: columnsAtLastLine,
                            utf8Length: utf8Length)
    }
    
    public static func += (lhs: inout SourceLength, rhs: SourceLength) {
        lhs = lhs + rhs
    }
}

extension SourceLocation {
    /// Determine the `SourceLocation` by advancing the `lhs` by the given source
    /// length.
    public static func + (lhs: SourceLocation, rhs: SourceLength) -> SourceLocation {
        let utf8Offset = lhs.utf8Offset + rhs.utf8Length
        let line = lhs.line + rhs.newlines
        let column: Int
        if rhs.newlines == 0 {
            column = lhs.column + rhs.columnsAtLastLine
        } else {
            column = rhs.columnsAtLastLine + 1 // SourceLocation has 1-based columns
        }
        return SourceLocation(line: line, column: column, utf8Offset: utf8Offset)
    }
    
    public static func += (lhs: inout SourceLocation, rhs: SourceLength) {
        lhs = lhs + rhs
    }
}
