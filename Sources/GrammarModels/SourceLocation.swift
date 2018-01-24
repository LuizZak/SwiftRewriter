/// Indicates a location in a source file, either as a single location or as a
/// range
public struct SourceLocation {
    public static let invalid = SourceLocation(range: .invalid, source: InvalidSource.invalid)
    
    public var range: SourceRange
    public var source: Source
    
    public init(range: SourceRange, source: Source) {
        self.range = range
        self.source = source
    }
}

extension SourceLocation: Equatable {
    public static func ==(lhs: SourceLocation, rhs: SourceLocation) -> Bool {
        return lhs.range == rhs.range && lhs.source.isEqual(to: rhs.source)
    }
}
