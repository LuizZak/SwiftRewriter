/// Indicates a location in a source file, either as a single location or as a
/// range
public enum SourceLocation {
    case location(String.Index)
    case range(Range<String.Index>)
    
    /// If this is a valid source location, returns its substring insertion on a
    /// given source string.
    /// If this location does not represent a range, nil is returned, instead.
    public func substring(in string: String) -> Substring? {
        switch self {
        case .range(let range):
            return string[range]
        case .location:
            return nil
        }
    }
}
