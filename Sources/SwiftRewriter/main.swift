import SwiftRewriterLib
import Utility

let parser =
    ArgumentParser(usage: "<file>",
                   overview: "Automates part of convering Objective-C source code into Swift")

let fileArg: PositionalArgument<String> =
    parser.add(positional: "<file>", kind: String.self, usage: "Objective-C file to convert")

do {
    let result = try parser.parse()
    
    if let file = result.get(fileArg) {
        let input = FileInputProvider(file: file)
        let output = StdoutWriterOutput()
        
        let converter = SwiftRewriter(input: input, output: output)
        try converter.rewrite()
    }
} catch {
    print("Error: \(error)")
    _=readLine()
}
