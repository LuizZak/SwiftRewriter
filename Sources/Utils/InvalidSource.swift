
/// Represents an invalid source, which is neither a file nor a string source.
/// Used to represent an invalid original source location for a node.
public struct InvalidSource: Source {
    private static let _stringIndex = "".startIndex
    
    /// Gets the default invalid source instance singleton.
    public static let invalid = InvalidSource()
    
    public let filePath: String = "<invalid>"
    
    /// Gets the valid range of indices for the input source.
    public var sourceRange: Range<String.UnicodeScalarView.Index> {
        "".startIndex..<"".endIndex
    }
    
    private init() {
        
    }
    
    public func stringIndex(forCharOffset offset: Int) -> String.UnicodeScalarView.Index {
        InvalidSource._stringIndex
    }
    
    public func charOffset(forStringIndex index: String.UnicodeScalarView.Index) -> Int {
        0
    }
    
    public func utf8Index(forCharOffset offset: Int) -> Int {
        0
    }
    
    public func isEqual(to other: Source) -> Bool {
        other is InvalidSource
    }
    
    public func lineNumber(at index: String.UnicodeScalarView.Index) -> Int {
        0
    }
    
    public func columnNumber(at index: String.UnicodeScalarView.Index) -> Int {
        0
    }

    public func substring(inCharRange range: Range<Int>) -> Substring? {
        nil
    }

    public func sourceSubstring(_ range: SourceRange) -> Substring? {
        nil
    }
}
