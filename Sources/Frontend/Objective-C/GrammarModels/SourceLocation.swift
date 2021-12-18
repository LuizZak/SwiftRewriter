// Based on SwiftSyntax's own 'AbsolutePosition' structure
public struct SourceLocation: Comparable, Codable {
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
    
    public static func < (lhs: SourceLocation, rhs: SourceLocation) -> Bool {
        lhs.utf8Offset < rhs.utf8Offset
    }
}
