import SwiftRewriterLib
import Utility
import Foundation
import ExpressionPasses

let arguments = Array(ProcessInfo.processInfo.arguments.dropFirst())

let parser =
    ArgumentParser(usage: "<files>",
                   overview: "Automates part of convering Objective-C source code into Swift")

let filesArg: PositionalArgument<[String]> =
    parser.add(positional: "<files>", kind: [String].self, usage: "Objective-C file(s) to convert")

do {
    let result = try parser.parse(arguments)
    
    if let files = result.get(filesArg) {
        let input = FileInputProvider(files: files)
        let output = StdoutWriterOutput()
        
        let converter = SwiftRewriter(input: input, output: output)
        
        converter.expressionPasses.append(AllocInitExpressionPass())
        converter.expressionPasses.append(CoreGraphicsExpressionPass())
        
        try converter.rewrite()
        
        // Print diagnostics
        for diag in converter.diagnostics.diagnostics {
            switch diag {
            case .note:
                print("Note: \(diag)")
            case .warning:
                print("Warning: \(diag)")
            case .error:
                print("Error: \(diag)")
            }
        }
    }
} catch {
    print("Error: \(error)")
}
