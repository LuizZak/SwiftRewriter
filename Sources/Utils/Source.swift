/// A protocol for a source for source code.
/// It is used to group up units of compilation to aid in checking of access control
/// across compilation unit/file boundaries, as well as providing lookups for
/// source locations and the underlying string.
public protocol Source {
    /// Gets the full file name for this source file.
    var filePath: String { get }

    /// Gets the valid range of indices for the input source.
    var sourceRange: Range<String.UnicodeScalarView.Index> { get }
    
    func isEqual(to other: Source) -> Bool
    
    func stringIndex(forCharOffset offset: Int) -> String.UnicodeScalarView.Index
    func charOffset(forStringIndex index: String.UnicodeScalarView.Index) -> Int
    func utf8Index(forCharOffset offset: Int) -> Int
    
    /// Gets the line number at a given source location
    func lineNumber(at index: String.UnicodeScalarView.Index) -> Int
    func columnNumber(at index: String.UnicodeScalarView.Index) -> Int
    func sourceLocation(atStringIndex index: String.Index) -> SourceLocation

    /// Returns a substring within a given range, if the range is valid.
    func substring(inCharRange range: Range<Int>) -> Substring?

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
