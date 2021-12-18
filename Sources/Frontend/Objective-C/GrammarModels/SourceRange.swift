/// Range in source code a node spans
public enum SourceRange: Equatable {
    case location(String.Index)
    case range(Range<String.Index>)
    case invalid
    
    /// Gets a value that represents the start of this source range.
    /// For `location` cases, this is the same as the associated value, for `range`
    /// cases, this is `range.lowerBound`, and for `invalid` nodes this is nil.
    public var start: String.Index? {
        switch self {
        case .location(let l):
            return l
        case .range(let r):
            return r.lowerBound
        case .invalid:
            return nil
        }
    }
    
    /// Gets a value that represents the end of this source range.
    /// For `location` cases, this is the same as the associated value, for `range`
    /// cases, this is `range.upperBound`, and for `invalid` nodes this is nil.
    public var end: String.Index? {
        switch self {
        case .location(let l):
            return l
        case .range(let r):
            return r.upperBound
        case .invalid:
            return nil
        }
    }
    
    public func union(with node: SourceRange) -> SourceRange {
        switch (self, node) {
        case (.invalid, .invalid):
            return .invalid
        case (_, .invalid):
            return self
        case (.invalid, _):
            return node
            
        case let (.location(lhs), .location(rhs)):
            if lhs == rhs {
                return .location(lhs)
            }
            
            return .range(min(lhs, rhs)..<max(lhs, rhs))
            
        case let (.range(lhs), .range(rhs)):
            let lower = min(lhs.lowerBound, rhs.lowerBound)
            let upper = max(lhs.upperBound, rhs.upperBound)
            
            return .range(lower..<upper)
        case let (.range(rang), .location(loc)),
             let (.location(loc), .range(rang)):
            if rang.contains(loc) {
                return .range(rang)
            }
            
            if rang.lowerBound > loc {
                return .range(loc..<rang.upperBound)
            } else {
                return .range(rang.lowerBound..<loc)
            }
        default:
            return .invalid
        }
    }
    
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
