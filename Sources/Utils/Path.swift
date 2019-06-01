#if canImport(Foundation)
import Foundation
#endif

/// Helper class for dealing with path operations
public struct Path: CustomStringConvertible {
    /// The recognized path separtors for the current platform this code was built
    // on.s
    public static let pathSeparators: [Character] = ["/"]
    
    public private(set) var fullPath: String
    
    public var description: String {
        return fullPath.description
    }
    
    /// Returns the filename component of the path represented by this Path instance
    public var fileName: String {
        return lastPathComponent
    }
    
    public var lastPathComponent: String {
        return
            fullPath.split(separator: Path.pathSeparators[0],
                           maxSplits: Int.max,
                           omittingEmptySubsequences: true).last.map(String.init) ?? fullPath
    }
    
    public init(fullPath: String) {
        self.fullPath = fullPath
    }
    
    public init(tildePath: String) {
        self.fullPath = expandTildes(path: tildePath)
    }
    
    #if canImport(Foundation)
    
    /// Returns `true` if this path's filename fully matches a given string.
    public func filename(is name: String, options: String.CompareOptions = .literal) -> Bool {
        return fileName.compare(name, options: options) == .orderedSame
    }
    
    /// Returns `true` if `substring` is contained within this path's filename.
    public func filename(contains substring: String, options: String.CompareOptions = .literal) -> Bool {
        return fileName.range(of: substring, options: options) != nil
    }
    
    #endif
}

#if canImport(Foundation)

public extension Sequence where Element == Path {
    func firstFilename(containing: String, options: String.CompareOptions = .literal) -> Path? {
        return first { $0.filename(contains: containing, options: options) }
    }
}

public extension Collection where Element == Path {
    func indexOfFilename(containing: String, options: String.CompareOptions = .literal) -> Index? {
        return firstIndex { $0.filename(contains: containing, options: options) }
    }
    
    func indexOfFilename(matching string: String, options: String.CompareOptions = .literal) -> Index? {
        return firstIndex { $0.filename(is: string, options: options) }
    }
}

#endif

public extension Sequence where Element == String {
    /// Returns a list of paths for each string in this sequence
    var asPaths: [Path] {
        return map { $0.path }
    }
}

public extension String {
    /// Returns a `Path` with this string
    var path: Path {
        return Path(fullPath: self)
    }
    
    /// Returns a `Path` with this string's path with tildes expanded
    var tildePath: Path {
        return Path(fullPath: self)
    }
}
