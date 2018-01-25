/// A protocol for a source for source code.
/// It is used to group up units of compilation to aid in checking of access control
/// across compilation unit/file boundaries.
public protocol Source {
    func isEqual(to other: Source) -> Bool
    
    /// Gets the line number at a given source location
    func lineNumber(at index: String.Index) -> Int
    func columnNumber(at index: String.Index) -> Int
}

/// Represents an invalid source, which is neither a file nor a stirng source.
public struct InvalidSource: Source {
    public static let invalid = InvalidSource()
    
    private init() {
        
    }
    
    public func isEqual(to other: Source) -> Bool {
        return other is InvalidSource
    }
    
    public func lineNumber(at index: String.Index) -> Int {
        return 0
    }
    
    public func columnNumber(at index: String.Index) -> Int {
        return 0
    }
}
