/// A protocol for a source for source code.
/// It is used to group up units of compilation to aid in checking of access control
/// across compilation unit/file boundaries, as well as providing lookups for
/// source locations and the underlying string.
public protocol Source {
    /// Gets the full file name for this source file.
    var filePath: String { get }
    
    func isEqual(to other: Source) -> Bool
    
    func stringIndex(forCharOffset offset: Int) -> String.Index
    func charOffset(forStringIndex index: String.Index) -> Int
    func utf8Index(forCharOffset offset: Int) -> Int
    
    /// Gets the line number at a given source location
    func lineNumber(at index: String.Index) -> Int
    func columnNumber(at index: String.Index) -> Int
    func sourceLocation(atStringIndex index: String.Index) -> SourceLocation

    /// Fetches a substring from the underlying source code string.
    /// If the range provided is outside of the bounds of the source string, `nil`
    /// is returned, instead.
    func sourceSubstring(_ range: SourceRange) -> Substring?
}

public extension Source {
    func sourceLocation(atStringIndex index: String.Index) -> SourceLocation {
        let line = lineNumber(at: index)
        let column = columnNumber(at: index)
        let utf8 = utf8Index(forCharOffset: charOffset(forStringIndex: index))

        return .init(line: line, column: column, utf8Offset: utf8)
    }
}

/// Represents an invalid source, which is neither a file nor a string source.
/// Used to represent an invalid original source location for a node.
public struct InvalidSource: Source {
    private static let _stringIndex = "".startIndex
    
    /// Gets the default invalid source instance singleton.
    public static let invalid = InvalidSource()
    
    public let filePath: String = "<invalid>"
    
    private init() {
        
    }
    
    public func stringIndex(forCharOffset offset: Int) -> String.Index {
        InvalidSource._stringIndex
    }
    
    public func charOffset(forStringIndex index: String.Index) -> Int {
        0
    }
    
    public func utf8Index(forCharOffset offset: Int) -> Int {
        0
    }
    
    public func isEqual(to other: Source) -> Bool {
        other is InvalidSource
    }
    
    public func lineNumber(at index: String.Index) -> Int {
        0
    }
    
    public func columnNumber(at index: String.Index) -> Int {
        0
    }

    public func sourceLocation(atStringIndex index: String.Index) -> SourceLocation {
        .invalid
    }

    public func sourceSubstring(_ range: SourceRange) -> Substring? {
        nil
    }
}
