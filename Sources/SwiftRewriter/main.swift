import Foundation
import Dispatch
import Utility
import Console
import SwiftRewriterLib

enum Target: String, ArgumentKind {
    case stdout
    case filedisk
    
    init(argument: String) throws {
        if let value = Target(rawValue: argument) {
            self = value
        } else {
            throw ArgumentParserError.invalidValue(
                argument: argument,
                error: ArgumentConversionError.custom("Expected either 'stdout' or 'filedisk'")
            )
        }
    }
    
    static var completion: ShellCompletion {
        return ShellCompletion.values([
            ("terminal", "Prints output of conversion to the terminal's standard output."),
            ("filedisk", """
                Saves output of conversion to the filedisk as .swift files on the same folder as the input files.
                """)
        ])
    }
}

let parser =
    ArgumentParser(
        usage: """
        [--colorize|-c] [--print-expression-types|-t] [--print-tracing-history|-p] \
        [--emit-objc-compatibility|-o] [--verbose|-v] [--num-threads|-t <n>] [--force-ll|-ll] \
        [--target|-w stdout | filedisk] \
        [files <files...> \
        | path <path> [--exclude-pattern|-e <pattern>] [--include-pattern|-i <pattern>] \
        [--skip-confirm|-s] [--overwrite|-o]]
        """,
        overview: """
        Converts a set of files, or, if not provided, starts an interactive \
        menu to navigate the file system and choose files to convert.
        """)

// --colorize
let colorArg
    = parser.add(option: "--colorize", shortName: "-c", kind: Bool.self,
                 usage: "Pass this parameter as true to enable terminal colorization during output.")

// --print-expression-types
let outputExpressionTypesArg
    = parser.add(option: "--print-expression-types", shortName: "-e",
                 kind: Bool.self,
                 usage: "Prints the type of each top-level resolved expression statement found in function bodies.")

// --print-tracing-history
let outputIntentionHistoryArg: OptionArgument<Bool> =
    parser.add(option: "--print-tracing-history", shortName: "-p", kind: Bool.self,
               usage: """
        Prints extra information before each declaration and member about the \
        inner logical decisions of intention passes as they change the structure \
        of declarations.
        """)

// --verbose
let verboseArg
    = parser.add(option: "--verbose", shortName: "-v", kind: Bool.self,
                 usage: "Prints progress information to the console while performing a transpiling job.")

// --num-threads
let numThreadsArg
    = parser.add(
        option: "--num-threads", shortName: "-t",
        kind: Int.self,
        usage: """
        Specifies the number of threads to use when performing parsing, as well \
        as intention and expression passes. If not specified, thread allocation \
        is defined by the system depending on usage conditions.
        """)

// --force-ll
let forceUseLLPredictionArg
    = parser.add(
        option: "--force-ll", shortName: "-ll",
        kind: Bool.self,
        usage: """
        Forces ANTLR parsing to use LL prediction context, instead of making an \
        attempt at SLL first. \
        May be more performant in some circumstances depending on complexity of \
        original source code.
        """)

// --emit-objc-compatibility
let emitObjcCompatibilityArg
    = parser.add(
        option: "--emit-objc-compatibility", shortName: "-o",
        kind: Bool.self,
        usage: """
        Emits '@objc' attributes on definitions, and emits NSObject subclass \
        and NSObjectProtocol conformance on protocols.
        
        This forces Swift to create Objective-C-compatible subclassing structures
        which may increase compatibility with previous Obj-C code.
        """)

// --diagnose-file
let diagnoseFileArg
    = parser.add(
        option: "--diagnose-file", shortName: "-d",
        kind: String.self,
        usage: """
        Provides a target file path to diagnose during rewriting.
        After each intention pass and after expression passes, the file is written
        to the standard output for diagnosing rewriting issues.
        """)

//// --target stdout | filedisk
let targetArg
    = parser.add(
        option: "--target", shortName: "-w",
        kind: Target.self,
        usage: """
        Specifies the output target for the conversion.
        Defaults to 'filedisk' if not provided.
        
            stdout
                Prints the conversion results to the terminal's standard output;
            
            filedisk
                Saves output of conversion to the filedisk as .swift files on the same folder as the input files.
        """)

//// files <files...>

let filesParser
    = parser.add(subparser: "files",
                 overview: "Converts one or more .h/.m file(s) to Swift.")
let filesArg
    = filesParser.add(positional: "files", kind: [String].self, usage: "Objective-C file(s) to convert.")

//// path <path> [--exclude-pattern <pattern>] [--skip-confirm] [--overwrite]

let pathParser
    = parser.add(
        subparser: "path",
        overview: """
        Examines a path and collects all .h/.m files to convert, before presenting \
        a prompt to confirm conversion of files.
        """)

let pathArg
    = pathParser.add(positional: "path", kind: String.self,
                     usage: "Path to the project to inspect")

let excludePatternArg
    = pathParser.add(
        option: "--exclude-pattern", shortName: "-e", kind: String.self,
        usage: """
        Provides a file pattern for excluding matches from the initial Objective-C \
        files search. Pattern is applied to the full path.
        """)

let includePatternArg
    = pathParser.add(
        option: "--include-pattern", shortName: "-i", kind: String.self,
        usage: """
        Provides a pattern for including matches from the initial Objective-C files \
        search. Pattern is applied to the full path. --exclude-pattern takes \
        priority over --include-pattern matches.
        """)

let skipConfirmArg
    = pathParser.add(option: "--skip-confirm", shortName: "-s", kind: Bool.self,
                     usage: "Skips asking for confirmation prior to parsing.")

let overwriteArg
    = pathParser.add(option: "--overwrite", shortName: "-o", kind: Bool.self,
                     usage: "Overwrites any .swift file with a matching output name on the target path.")

do {
    let arguments = Array(ProcessInfo.processInfo.arguments.dropFirst())
    
    let result = try parser.parse(arguments)
    
    let colorize = result.get(colorArg) ?? false
    
    // Read settings
    Settings.rewriter.verbose = result.get(verboseArg) ?? false
    Settings.rewriter.diagnoseFiles = result.get(diagnoseFileArg).map({ [$0] }) ?? []
    Settings.rewriter.numThreads = result.get(numThreadsArg) ?? OperationQueue.defaultMaxConcurrentOperationCount
    Settings.astWriter.outputExpressionTypes = result.get(outputExpressionTypesArg) ?? false
    Settings.astWriter.printIntentionHistory = result.get(outputIntentionHistoryArg) ?? false
    Settings.astWriter.emitObjcCompatibility = result.get(emitObjcCompatibilityArg) ?? false
    Settings.rewriter.forceUseLLPrediction = result.get(forceUseLLPredictionArg) ?? false
    
    let target = result.get(targetArg) ?? .filedisk
    
    let rewriter: SwiftRewriterService
    
    switch target {
    case .filedisk:
        rewriter = SwiftRewriterServiceImpl.fileDisk()
    case .stdout:
        rewriter = SwiftRewriterServiceImpl.terminal(colorize: colorize)
    }
    
    if result.subparser(parser) == "files" {
        guard let files = result.get(filesArg) else {
            throw Utility.ArgumentParserError.expectedValue(option: "<files...>")
        }
        
        try rewriter.rewrite(files: files.map { URL(fileURLWithPath: $0) })
        
    } else if result.subparser(parser) == "path" {
        guard let path = result.get(pathArg) else {
            throw Utility.ArgumentParserError.expectedValue(option: "<path>")
        }
        
        let skipConfirm = result.get(skipConfirmArg) ?? false
        let excludePattern = result.get(excludePatternArg)
        let includePattern = result.get(includePatternArg)
        let overwrite = result.get(overwriteArg) ?? false
        
        let console = Console()
        let menu = Menu(rewriterService: rewriter, console: console)
        
        let options: SuggestConversionInterface.Options
            = .init(overwrite: overwrite, skipConfirm: skipConfirm,
                    excludePattern: excludePattern, includePattern: includePattern)
        
        let interface = SuggestConversionInterface(rewriterService: rewriter)
        interface.searchAndShowConfirm(in: menu,
                                       path: (path as NSString).standardizingPath,
                                       options: options)
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
