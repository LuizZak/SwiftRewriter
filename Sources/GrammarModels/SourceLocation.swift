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
    public static var invalid: SourceLocation {
        return SourceLocation(source: InvalidSource.invalid,
                              range: .invalid)
    }
    
    /// The original source this location reference.
    public var source: Source {
        didSet {
            computeLineAndColumn()
        }
    }
    
    /// Line at which this location starts within the source.
    /// Valid source location lines start at 1.
    public var line: Int = 0
    
    /// Column offset at which this location starts within the source.
    /// Valid source location columns start at 1.
    public var column: Int = 0
    
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
            computeLineAndColumn()
        }
    }
    
    public init(source: Source, intRange: Range<Int>, line: Int, column: Int) {
        self.source = source
        _range = .intRange(intRange)
        self.line = line
        self.column = column
    }
    
    public init(source: Source, intRange: Range<Int>) {
        self.source = source
        _range = .intRange(intRange)
        
        computeLineAndColumn()
    }
    
    public init(source: Source, range: SourceRange) {
        self.source = source
        _range = .range(range)
        
        computeLineAndColumn()
    }
    
    private func computeLineAndColumn() {
        guard let loc = range.start else {
            return
        }
        
        self.line = source.lineNumber(at: loc)
        self.column = source.columnNumber(at: loc)
    }
    
    private enum _SourceRange {
        case range(SourceRange)
        case intRange(Range<Int>)
    }
}

extension SourceLocation: Equatable {
    public static func == (lhs: SourceLocation, rhs: SourceLocation) -> Bool {
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
