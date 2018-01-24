/// Range in source code a node spans
public enum SourceRange {
    case location(String.Index)
    case range(Range<String.Index>)
    case invalid
    
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
            return .range(lhs.lowerBound..<rhs.upperBound)
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

extension SourceRange: Equatable {
    public static func ==(lhs: SourceRange, rhs: SourceRange) -> Bool {
        switch (lhs, rhs) {
        case let (.range(l), .range(r)):
            return l == r
        case let (.location(l), .location(r)):
            return l == r
        case (.invalid, .invalid):
            return true
            
        default:
            return false
        }
    }
}
