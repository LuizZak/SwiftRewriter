import Foundation

public struct InputFile {
    var url: URL

    /// Whether this file is a primary file for conversion.
    /// If `false`, indicates that this file should be parsed but not be present
    /// in the final transpilation step.
    var isPrimary: Bool
}
