/// Range in source code a node spans.
public enum SourceRange: Hashable, Codable {
    /// Source range is composed of a single source location with no span.
    case location(SourceLocation)

    /// An open range between `start..<end`.
    case range(start: SourceLocation, end: SourceLocation)

    /// Invalid source range.
    case invalid
    
    /// Gets a value that represents the start of this source range.
    /// For `location` cases, this is the same as the associated value, for `range`
    /// cases, this is `range.lowerBound`, and for `invalid` nodes this is nil.
    public var start: SourceLocation? {
        switch self {
        case .location(let l):
            return l
        case .range(let start, _):
            return start
        case .invalid:
            return nil
        }
    }
    
    /// Gets a value that represents the end of this source range.
    /// For `location` cases, this is the same as the associated value, for `range`
    /// cases, this is `range.upperBound`, and for `invalid` nodes this is nil.
    public var end: SourceLocation? {
        switch self {
        case .location(let l):
            return l
        case .range(_, let end):
            return end
        case .invalid:
            return nil
        }
    }

    /// If this source range object represents a location or a range, returns the
    /// `SourceLength` for that range, otherwise returns `nil` if this source
    /// range is `.invalid`.
    public var length: SourceLength? {
        switch self {
        case .location:
            return .zero

        case .range(let start, let end):
            return start.length(to: end)

        case .invalid:
            return nil
        }
    }

    /// Returns `true` if this source range contains a given source location
    /// within its span.
    ///
    /// If this source range is a `.location` case, returns `true` if its stored
    /// location matches `location`, if it's a `.range` case, returns `true` if
    /// `start <= location && location < end`, and if it's `.invalid`, always
    /// returns `false`.
    public func contains(_ location: SourceLocation) -> Bool {
        switch self {
        case .location(let loc):
            return loc == location
        case .range(let start, let end):
            return start <= location && location < end
        case .invalid:
            return false
        }
    }
    
    public func union(with location: SourceLocation) -> SourceRange {
        if !location.isValid {
            return self
        }

        return SourceRange.location(location).union(with: self)
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
            let start = min(lhs, rhs)
            let end = max(lhs, rhs)
            
            return .range(start: start, end: end)
            
        case let (.range(lhsStart, lhsEnd), .range(rhsStart, rhsEnd)):
            let start = min(lhsStart, rhsStart)
            let end = max(lhsEnd, rhsEnd)
            
            return .range(start: start, end: end)

        case let (.range(start, end), .location(loc)),
             let (.location(loc), .range(start, end)):
            
            let start = min(start, loc)
            let end = max(end, loc)
            
            return .range(start: start, end: end)
        default:
            return .invalid
        }
    }
    
    /// If this is a valid source location, returns its substring insertion on a
    /// given source string based on its UTF8 offset value.
    /// If this location does not represent a range, nil is returned, instead.
    /// Returns `nil` if this range cannot fit in `string`.
    public func substring(in string: String) -> Substring? {
        switch self {
        case .range(let start, let end):
            guard let startIndex = string.utf8.index(
                string.startIndex,
                offsetBy: start.utf8Offset,
                limitedBy: string.endIndex
            ) else {
                return nil
            }
            guard let endIndex = string.utf8.index(
                string.startIndex,
                offsetBy: end.utf8Offset,
                limitedBy: string.endIndex
            ) else {
                return nil
            }

            return string[startIndex..<endIndex]
        case .location, .invalid:
            return nil
        }
    }

    /// Returns the smallest `SourceRange` capable of fitting all values in
    /// `ranges`.
    /// Result may be `.invalid` if array is empty, or no valid locations are
    /// present.
    public init(union ranges: [SourceRange]) {
        self = ranges.reduce(.invalid, { $0.union(with: $1) })
    }

    /// Initializes this source range as either a `SourceRange.range(start:end:)`
    /// or `SourceRange.location(_:)`, depending on whether `start == end`.
    public init(forStart start: SourceLocation, end: SourceLocation) {
        if start == end {
            self = .location(start)
        } else {
            self = .range(start: start, end: end)
        }
    }
}
