import Foundation

/// Helper class for dealing with path operations
public struct Path: CustomStringConvertible {
    var fullPath: String
    
    public var description: String {
        return fullPath.description
    }
    
    /// Returns the filename component of the path represented by this Path instance
    public var fileName: String {
        return (fullPath as NSString).lastPathComponent
    }
    
    init(fullPath: String) {
        self.fullPath = fullPath
    }
    
    init(tildePath: String) {
        self.fullPath = (tildePath as NSString).expandingTildeInPath
    }
    
    /// Returns `true` if this path's filename fully matches a given string.
    public func filename(is name: String, options: String.CompareOptions = .literal) -> Bool {
        return fileName.compare(name, options: options) == .orderedSame
    }
    
    /// Returns `true` if `substring` is contained within this path's filename.
    public func filename(contains substring: String, options: String.CompareOptions = .literal) -> Bool {
        return fileName.range(of: substring, options: options) != nil
    }
}

public extension Sequence where Element == Path {
    public func firstFilename(containing: String, options: String.CompareOptions = .literal) -> Path? {
        return first { $0.filename(contains: containing, options: options) }
    }
}

public extension Collection where Element == Path {
    public func indexOfFilename(containing: String, options: String.CompareOptions = .literal) -> Index? {
        return index { $0.filename(contains: containing, options: options) }
    }
    
    public func indexOfFilename(matching string: String, options: String.CompareOptions = .literal) -> Index? {
        return index { $0.filename(is: string, options: options) }
    }
}

public extension Sequence where Element == String {
    /// Returns a list of paths for each string in this sequence
    public var asPaths: [Path] {
        return map { $0.path }
    }
}

public extension String {
    /// Returns a `Path` with this string
    public var path: Path {
        return Path(fullPath: self)
    }
    
    /// Returns a `Path` with this string's path with tildes expanded
    public var tildePath: Path {
        return Path(fullPath: self)
    }
}
