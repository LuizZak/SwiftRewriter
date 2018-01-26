/// Indicates a location in a source file, either as a single location or as a
/// range
public struct SourceLocation {
    /// Gets the default invalid source location construct.
    ///
    /// It always has a `SourceRange.invalid` range and a source pointing to an
    /// `InvalidSource` instance.
    public static let invalid = SourceLocation(source: InvalidSource.invalid, range: .invalid)
    
    /// The original source this location references.
    public var source: Source
    
    /// Range within the original source this location points to.
    public var range: SourceRange
    
    public init(source: Source, range: SourceRange) {
        self.source = source
        self.range = range
    }
}

extension SourceLocation: Equatable {
    public static func ==(lhs: SourceLocation, rhs: SourceLocation) -> Bool {
        return lhs.range == rhs.range && lhs.source.isEqual(to: rhs.source)
    }
}

extension SourceLocation: CustomStringConvertible {
    public var description: String {
        guard let start = range.start else {
            return "line \(0) column \(0)"
        }
        
        let line = source.lineNumber(at: start)
        let col = source.columnNumber(at: start)
        
        return "line \(line) column \(col)"
    }
}
