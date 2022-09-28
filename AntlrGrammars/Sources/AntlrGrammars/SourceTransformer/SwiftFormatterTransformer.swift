import Foundation
import SwiftSyntax
import SwiftSyntaxParser
import SwiftFormat
import SwiftFormatConfiguration
import SwiftFormatPrettyPrint

class SwiftFormatterTransformer {
    let formatFilePath: URL?

    init(formatFilePath: URL? = nil) {
        self.formatFilePath = formatFilePath
    }

    func format(_ input: SourceFileSyntax) throws -> SourceFileSyntax {
        var config: Configuration
        if let formatFilePath {
            config = try Configuration(contentsOf: formatFilePath)
        } else {
            config = Configuration()
            config.indentation = .spaces(4)
            config.respectsExistingLineBreaks = false
        }

        let formatter = SwiftFormatter(configuration: config)

        var output: String = ""
        try formatter.format(source: input.description, assumingFileURL: nil, to: &output)

        return try SyntaxParser.parse(source: output)
    }
}
