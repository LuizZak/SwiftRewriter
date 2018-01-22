/// Indicates a location in a source file, either as a single location or as a
/// range
public enum SourceLocation {
    case location(String.Index)
    case range(Range<String.Index>)
    case invalid
    
    /// If this is a valid source location, returns its substring insertion on a
    /// given source string.
    /// If this location does not represent a range, nil is returned, instead.
    public func substring(in string: String) -> Substring? {
        switch self {
        case .range(let range):
            return string[range]
        case .location, .invalid:
            return nil
        }
    }
}

extension SourceLocation: Equatable {
    public static func ==(lhs: SourceLocation, rhs: SourceLocation) -> Bool {
        switch (lhs, rhs) {
        case let (.location(l), .location(r)):
            return l == r
        case let (.range(l), .range(r)):
            return l == r
        case (.invalid, .invalid):
            return true
            
        default:
            return false
        }
    }
}
