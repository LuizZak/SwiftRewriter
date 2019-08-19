import Foundation

public struct InputFile {
    public var url: URL

    /// Whether this file is a primary file for conversion.
    /// If `false`, indicates that this file should be parsed but not be present
    /// in the final transpilation step.
    public var isPrimary: Bool
}
