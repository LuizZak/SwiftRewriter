import Foundation
import ArgumentParser
import SwiftFormatConfiguration
import SwiftRewriterLib

/// Group of global options available to all frontends in files- or path- mode.
struct GlobalOptions: ParsableArguments {
    @Flag(
        name: .shortAndLong,
        help: "Pass this parameter as true to enable terminal colorization during output."
    )
    var colorize: Bool = false
    
    @Flag(
        name: [.long],
        help: "Prints the type of each top-level resolved expression statement found in function bodies."
    )
    var printExpressionTypes: Bool = false
    
    @Flag(
        name: [.long, .customShort("p")],
        help: """
        Prints extra information before each declaration and member about the \
        inner logical decisions of intention passes as they change the structure \
        of declarations.
        """
    )
    var printTracingHistory: Bool = false
    
    @Flag(
        name: .shortAndLong,
        help: "Prints progress information to the console while performing a transpiling job."
    )
    var verbose: Bool = false
    
    @Option(
        name: [.long, .customShort("t")],
        help: """
        Specifies the number of threads to use when performing parsing, as well \
        as intention and expression passes. If not specified, thread allocation \
        is defined by the system depending on usage conditions.
        """
    )
    var numThreads: Int?
    
    @Flag(
        help: """
        Forces ANTLR parsing to use LL prediction context, instead of making an \
        attempt at SLL first. \
        May be more performant in some circumstances depending on complexity of \
        original source code.
        """
    )
    var forceLl: Bool = false
    
    @Option(
        name: [.long, .customShort("w")],
        help: """
        Specifies the output target for the conversion.
        Defaults to 'filedisk' if not provided.
        Ignored when converting from the standard input.

            stdout
                Prints the conversion results to the terminal's standard output;
            
            filedisk
                Saves output of conversion to the filedisk as .swift files on the same folder as the input files.
        """
    )
    var target: Target?

    @Flag(
        name: .long,
        help: """
        Formats the source code using the standard formatting configuration provided \
        by SwiftFormat (https://github.com/apple/swift-format).
        Formatting is applied before final custom syntax rewriting passes defined by \
        the frontend.
        """
    )
    var format: Bool = false

    @Option(
        name: .long,
        help: """
        Path to a SwiftFormat configuration file to use, in case --format is specified. \
        If not provided, defaults to SwiftFormat's built-in default configuration.
        """
    )
    var swiftFormatFilePath: String?

    @Flag(
        name: .long,
        help: """
        If set, prints the call graph of the entire final Swift program generated \
        to the standard output before emitting the files.
        """
    )
    var printCallGraph: Bool = false

    /// Fetches the computed formatter mode from this option group.
    func computeFormatterMode() throws -> SwiftSyntaxOptions.FormatOption {
        guard format else {
            return .noFormatting
        }

        if let path = swiftFormatFilePath {
            let url = URL(fileURLWithPath: path)

            return try .swiftFormat(configuration: .init(contentsOf: url))
        } else {
            return .swiftFormat(configuration: nil)
        }
    }
}
