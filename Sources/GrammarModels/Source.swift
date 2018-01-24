/// A protocol for a source for source code
public protocol Source {
    func isEqual(to other: Source) -> Bool
}

/// Represents an invalid source, which is neither a file nor a stirng source.
public struct InvalidSource: Source {
    public static let invalid = InvalidSource()
    
    private init() {
        
    }
    
    public func isEqual(to other: Source) -> Bool {
        return other is InvalidSource
    }
}
