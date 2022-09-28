import struct Foundation.URL
import ArgumentParser
import SwiftSyntax
import SwiftSyntaxParser

@main
struct MainCommand: ParsableCommand {
    @Option(
        help: "Path for a .swift-format file to apply after modifying the code. If not provided, a default Swift pretty-print formatting is applied.",
        completion: .file(extensions: [".swift-format"])
    )
    var swiftFormatFilePath: String?

    @Flag(
        name: .shortAndLong,
        help: "Skips asking for confirmation prior to transforming files."
    )
    var skipConfirm: Bool = false
    
    @Argument(
        help: "Path to -Parser.swift and -Lexer.swift files to modify",
        completion: .file(extensions: ["swift"])
    )
    var files: [String]

    func run() throws {
        let fileIO = FileDisk()
        let files = files.map(URL.init(fileURLWithPath:))

        let parserFiles = files.filter {
            $0.lastPathComponent.lowercased().hasSuffix("parser.swift")
        }
        let lexerFiles = files.filter {
            $0.lastPathComponent.lowercased().hasSuffix("lexer.swift")
        }

        guard !files.isEmpty else {
            print("No input files to process!")
            return
        }

        let formatter = SwiftFormatterTransformer(
            formatFilePath: swiftFormatFilePath.map(URL.init(fileURLWithPath:))
        )

        let parserTransformers = parserFiles.map(ParserTransformer.init)
        let lexerTransformers = lexerFiles.map(LexerTransformer.init)
        let transformers: [TransformerType] = parserTransformers + lexerTransformers

        if !skipConfirm {
            print("WARNING: Proceeding will rewrite \(transformers.count) files!.")
            print("Press [Enter] to continue.")
            _=readLine()
        }

        // Pre-validate files
        print("Validating \(transformers.count) files...")

        // Pre-validate
        for transformer in transformers {
            try transformer.validate(fileIO)
        }

        // Transform files
        print("Transforming \(transformers.count) files...")

        for transformer in transformers {
            let result = try transformer.transform(fileIO, formatter: formatter)

            try fileIO.writeText(to: transformer.filePath, text: result.description)
        }

        print("Successfully transformed \(transformers.count) files!")
    }
}
