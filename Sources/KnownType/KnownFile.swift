/// Represents the symbolic structure of a known source code file.
public protocol KnownFile {
    /// Gets a file name, excluding path.
    var fileName: String { get }
    
    /// Gets a list of known types defined within this file.
    var types: [KnownType] { get }
}

/// Represents the structure of an Objective-C file.
public protocol KnownObjectiveCFile: KnownFile {
    /// Gets a list of all import compiler directives used within the file.
    var importDirectives: [String] { get }
}
