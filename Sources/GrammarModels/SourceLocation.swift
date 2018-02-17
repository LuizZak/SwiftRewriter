/// Indicates a location in a source file, either as a single location or as a
/// range
public final class SourceLocation {
    // Cached value that wraps over integer source ranges so they can be lazily
    // evaluated later on.
    private var _range: _SourceRange
    
    /// Gets the default invalid source location construct.
    ///
    /// It always has a `SourceRange.invalid` range and a source pointing to an
    /// `InvalidSource` instance.
    public static let invalid = SourceLocation(source: InvalidSource.invalid, range: .invalid)
    
    /// The original source this location references.
    public var source: Source
    
    /// Range within the original source this location points to.
    public var range: SourceRange {
        get {
            switch _range {
            case .intRange(let intRange):
                
                let start = source.stringIndex(forCharOffset: intRange.lowerBound)
                let end = source.stringIndex(forCharOffset: intRange.upperBound)
                
                let range = SourceRange.range(start..<end)
                _range = .range(range)
                return range
            case .range(let range):
                return range
            }
        }
        set {
            _range = .range(newValue)
        }
    }
    
    public init(source: Source, intRange: Range<Int>) {
        self.source = source
        _range = .intRange(intRange)
    }
    
    public init(source: Source, range: SourceRange) {
        self.source = source
        _range = .range(range)
    }
    
    private enum _SourceRange {
        case range(SourceRange)
        case intRange(Range<Int>)
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
