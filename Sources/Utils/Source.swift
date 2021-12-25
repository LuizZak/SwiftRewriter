/// A protocol for a source for source code.
/// It is used to group up units of compilation to aid in checking of access control
/// across compilation unit/file boundaries.
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

    /// Returns a substring within a given range, if the range is valid.
    func substring(inCharRange range: Range<Int>) -> Substring?
}
