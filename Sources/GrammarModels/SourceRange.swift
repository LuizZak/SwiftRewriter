/// Range in source code a node spans
public enum SourceRange {
    case valid(Range<String.Index>)
    case invalid
    
    public func union(with node: SourceRange) -> SourceRange {
        switch (self, node) {
        case let (.valid(lhs), .valid(rhs)):
            return .valid(lhs.lowerBound..<rhs.upperBound)
        case let (.valid(lhs), .invalid):
            return .valid(lhs)
        case let (.invalid, .valid(rhs)):
            return .valid(rhs)
        default:
            return .invalid
        }
    }
    
    /// If this is a valid source range, returns its substring insertion on a given
    /// source string.
    /// If this range is invalid, nil is returned, instead.
    public func substring(in string: String) -> Substring? {
        switch self {
        case .valid(let range):
            return string[range]
        case .invalid:
            return nil
        }
    }
}

extension SourceRange: Equatable {
    public static func ==(lhs: SourceRange, rhs: SourceRange) -> Bool {
        switch (lhs, rhs) {
        case let (.valid(l), .valid(r)):
            return l == r
        case (.invalid, .invalid):
            return true
            
        default:
            return false
        }
    }
}
