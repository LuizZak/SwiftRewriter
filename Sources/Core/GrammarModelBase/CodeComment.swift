import Utils

/// A language-agnostic reference to a comment from an input file
public struct CodeComment {
    public var string: String
    public var range: Range<String.Index>
    public var location: SourceLocation
    public var length: SourceLength
    
    public init(string: String,
                range: Range<String.Index>,
                location: SourceLocation,
                length: SourceLength) {
        
        self.string = string
        self.range = range
        self.location = location
        self.length = length
    }
}
