import Foundation
import Utility
import Console
import SwiftRewriterLib

let parser =
    ArgumentParser(
        usage: "[--colorize] [--print-expression-types] [--print-tracing-history] [files <files>]",
        overview: """
            Converts a set of files, or, if not provided, starts an interactive menu to navigate the file system and choose files to convert.
            """)

let filesParser =
    parser.add(subparser: "files",
               overview: "Converts one or more series of files to Swift and print them to the terminal.")

let filesArg: PositionalArgument<[String]> =
    filesParser.add(positional: "files", kind: [String].self, usage: "Objective-C file(s) to convert.")

let colorArg: OptionArgument<Bool> =
    parser.add(option: "--colorize", kind: Bool.self, usage: "Pass this parameter as true to enable terminal colorization during output.")

let outputExpressionTypesArg: OptionArgument<Bool> =
    parser.add(option: "--print-expression-types",
               kind: Bool.self,
               usage: "Pass this parameter as true to enable terminal colorization during output.")

let outputIntentionHistoryArg: OptionArgument<Bool> =
    parser.add(option: "--print-tracing-history",
               kind: Bool.self,
               usage: "Pass this parameter as true to enable terminal colorization during output.")

do {
    let arguments = Array(ProcessInfo.processInfo.arguments.dropFirst())
    
    let result = try parser.parse(arguments)
    
    let colorize = result.get(colorArg) ?? false
    
    options.outputExpressionTypes = result.get(outputExpressionTypesArg) ?? false
    options.printIntentionHistory = result.get(outputIntentionHistoryArg) ?? false
    
    if result.subparser(parser) == "files" {
        if let files = result.get(filesArg) {
            let output = StdoutWriterOutput(colorize: colorize)
            
            let rewriter: SwiftRewriterService = SwiftRewriterServiceImpl(output: output)
            try rewriter.rewrite(files: files.map { URL(fileURLWithPath: $0) })
        } else {
            throw Utility.ArgumentParserError.expectedValue(option: "<files>")
        }
    } else {
        let output = StdoutWriterOutput(colorize: colorize)
        let service = SwiftRewriterServiceImpl(output: output)
        let console = Console()
        let menu = Menu(rewriterService: service, console: console)
        
        menu.main()
    }
} catch {
    print("Error: \(error)")
}
