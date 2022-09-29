import struct Foundation.URL
import SwiftSyntax

protocol TransformerType {
    var filePath: URL { get }

    /// Validates if the transformation can be performed.
    func validate(_ fileIO: FileIOType) throws

    /// Performs the transformation of the file associated with this transformer,
    /// and returns the result.
    func transform(_ fileIO: FileIOType, formatter: SwiftFormatterTransformer?) throws -> SourceFileSyntax
}

extension TransformerType {
    func transform(_ fileIO: FileIOType) throws -> SourceFileSyntax {
        try transform(fileIO, formatter: nil)
    }
}
