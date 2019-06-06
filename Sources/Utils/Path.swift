import Foundation

// TODO: The path composition properties and methods here should probably return
// another `Path`, instead of a bare `String`.
// This is kept as is for now because it's more convenient to drop-in replace
// old `NSString` usages.

/// Helper class for dealing with path operations
public struct Path: CustomStringConvertible {
    /// The recognized path separtor for the current platform this code was built
    /// on.
    public static let pathSeparator: Character = "/"
    
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
            fullPath
                .split(separator: Path.pathSeparator)
                .last
                .map(String.init) ?? fullPath
    }
    
    public var pathComponents: [String] {
        return fullPath.split(separator: Path.pathSeparator).map(String.init)
    }
    
    public var deletingPathExtension: String {
        if fullPath == "/" || fullPath.hasPrefix(".") {
            return fullPath
        }
        
        let properPath: Substring
        if fullPath.hasSuffix("/") {
            properPath = fullPath.dropLast(1)
        } else {
            properPath = fullPath[...]
        }
        
        let splits = properPath.split(separator: ".", omittingEmptySubsequences: false)
        
        if splits.count <= 1 {
            return String(properPath)
        }
        
        return splits.dropLast().joined(separator: ".")
    }
    
    public var deletingLastPathComponent: String {
        if fullPath == String(Path.pathSeparator) {
            return fullPath
        }
        
        let startsWithSeparator = fullPath.first == Path.pathSeparator
        
        return
            (startsWithSeparator ? String(Path.pathSeparator) : "")
                + fullPath
                    .split(separator: Path.pathSeparator)
                    .dropLast()
                    .joined(separator: String(Path.pathSeparator))
    }
    
    public init(fullPath: String) {
        self.fullPath = fullPath
    }
    
    public init(tildePath: String) {
        self.fullPath = expandTildes(path: tildePath)
    }
    
    public func appendingPathComponent(_ component: String) -> String {
        if fullPath.isEmpty {
            return component
        }
        if fullPath.last.map({ Path.pathSeparator == $0 }) == true {
            return fullPath + component
        }
        
        return fullPath + String(Path.pathSeparator) + component
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
