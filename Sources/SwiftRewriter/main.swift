import Foundation
import Utility
import Console
import SwiftRewriterLib

let arguments = Array(ProcessInfo.processInfo.arguments.dropFirst())

let parser =
    ArgumentParser(usage: "<files>",
                   overview: "Automates part of convering Objective-C source code into Swift")

let filesArg: PositionalArgument<[String]> =
    parser.add(positional: "<files>", kind: [String].self, usage: "Objective-C file(s) to convert")

let colorArg: OptionArgument<Bool> =
    parser.add(option: "-colorize", kind: Bool.self, usage: "Pass this parameter as true to enable terminal colorization during output.")

do {
    if let result = try? parser.parse(arguments) {
        if let files = result.get(filesArg) {
            let output = StdoutWriterOutput(colorize: result.get(colorArg) ?? false)
            
            let rewriter: SwiftRewriterService = SwiftRewriterServiceImpl(output: output)
            try rewriter.rewrite(files: files.map { URL(fileURLWithPath: $0) })
        } else {
            throw Utility.ArgumentParserError.expectedValue(option: "<files>")
        }
    } else {
        let output = StdoutWriterOutput(colorize: true)
        let service = SwiftRewriterServiceImpl(output: output)
        let console = Console()
        let menu = Menu(rewriterService: service, console: console)
        
        menu.main()
    }
} catch {
    print("Error: \(error)")
}
