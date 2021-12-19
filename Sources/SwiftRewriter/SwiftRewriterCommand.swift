import ArgumentParser
import Foundation
import Console
import SwiftRewriterLib

struct SwiftRewriterCommand: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "SwiftRewriter",
        discussion: """
        Converts a set of files, or, if not provided, starts an interactive \
        menu to navigate the file system and choose files to convert.
        """,
        subcommands: [Files.self, Path.self, InteractiveMode.self],
        defaultSubcommand: InteractiveMode.self)
    
    func run() throws {
        
    }
}

extension SwiftRewriterCommand {
    struct Options: ParsableArguments {
        @Flag(name: .shortAndLong,
              help: "Pass this parameter as true to enable terminal colorization during output.")
        var colorize: Bool = false
        
        @Flag(name: [.long, .customShort("e")],
              help: "Prints the type of each top-level resolved expression statement found in function bodies.")
        var printExpressionTypes: Bool = false
        
        @Flag(name: [.long, .customShort("p")],
              help: """
            Prints extra information before each declaration and member about the \
            inner logical decisions of intention passes as they change the structure \
            of declarations.
            """)
        var printTracingHistory: Bool = false
        
        @Flag(name: .shortAndLong,
              help: "Prints progress information to the console while performing a transpiling job.")
        var verbose: Bool = false
        
        @Option(name: [.long, .customShort("t")],
                help: """
            Specifies the number of threads to use when performing parsing, as well \
            as intention and expression passes. If not specified, thread allocation \
            is defined by the system depending on usage conditions.
            """)
        var numThreads: Int?
        
        @Flag(help: """
            Forces ANTLR parsing to use LL prediction context, instead of making an \
            attempt at SLL first. \
            May be more performant in some circumstances depending on complexity of \
            original source code.
            """)
        var forceLl: Bool = false
        
        @Flag(help: """
            Emits '@objc' attributes on definitions, and emits NSObject subclass \
            and NSObjectProtocol conformance on protocols.

            This forces Swift to create Objective-C-compatible subclassing structures
            which may increase compatibility with previous Obj-C code.
            """)
        var emitObjcCompatibility: Bool = false
        
        @Option(help: """
            Provides a target file path to diagnose during rewriting.
            After each intention pass and after expression passes, the file is written
            to the standard output for diagnosing rewriting issues.
            """)
        var diagnoseFile: String?
        
        @Option(name: [.long, .customShort("w")],
                help: """
            Specifies the output target for the conversion.
            Defaults to 'filedisk' if not provided.
            Ihnored when converting from the standard input.

                stdout
                    Prints the conversion results to the terminal's standard output;
                
                filedisk
                    Saves output of conversion to the filedisk as .swift files on the same folder as the input files.
            """)
        var target: Target?

        @Flag(name: .shortAndLong,
              help: """
              Follows #import declarations in files in order to parse other relevant files.
              Ignored when converting from standard input.
              """)
        var followImports: Bool = false
    }
}

extension SwiftRewriterCommand {
    struct Files: ParsableCommand {
        static let configuration =
            CommandConfiguration(discussion: "Converts one or more .h/.m file(s) to Swift.")
        
        @Argument(help: "Objective-C file(s) to convert.")
        var files: [String]
        
        @OptionGroup()
        var options: Options
        
        func run() throws {
            let rewriter = makeRewriterService(options)
            
            let fileProvider = FileDiskProvider()
            let fileCollectionStep = ObjectiveCFileCollectionStep(fileProvider: fileProvider)
            let delegate = ImportDirectiveFileCollectionDelegate(parserCache: rewriter.parserCache,
                                                                 fileProvider: fileProvider)
            if options.followImports {
                fileCollectionStep.delegate = delegate
            }
            if options.verbose {
                fileCollectionStep.listener = StdoutFileCollectionStepListener()
            }
            try withExtendedLifetime(delegate) {
                for fileUrl in files {
                    try fileCollectionStep.addFile(fromUrl: URL(fileURLWithPath: fileUrl),
                                                   isPrimary: true)
                }
            }
            
            try rewriter.rewrite(files: fileCollectionStep.files)
        }
    }
}

extension SwiftRewriterCommand {
    struct Path: ParsableCommand {
        static let configuration =
            CommandConfiguration(discussion: """
                Examines a path and collects all .h/.m files to convert, before presenting \
                a prompt to confirm conversion of files.
                """)
        
        @Argument(help: "Path to the project to inspect")
        var path: String
        
        @Option(name: .shortAndLong, help: """
            Provides a file pattern for excluding matches from the initial Objective-C \
            files search. Pattern is applied to the full path.
            """)
        var excludePattern: String?
        
        @Option(name: .shortAndLong,
                help: """
            Provides a pattern for including matches from the initial Objective-C files \
            search. Pattern is applied to the full path. --exclude-pattern takes \
            priority over --include-pattern matches.
            """)
        var includePattern: String?
        
        @Flag(name: .shortAndLong,
              help: "Skips asking for confirmation prior to parsing.")
        var skipConfirm: Bool = false
        
        @Flag(name: .shortAndLong,
              help: "Overwrites any .swift file with a matching output name on the target path.")
        var overwrite: Bool = false
        
        @OptionGroup()
        var options: Options
        
        func run() throws {
            let rewriter = makeRewriterService(options)
            
            let console = Console()
            let menu = Menu(rewriterService: rewriter, console: console)
            
            let options: SuggestConversionInterface.Options
                = .init(overwrite: overwrite,
                        skipConfirm: skipConfirm,
                        followImports: self.options.followImports,
                        excludePattern: excludePattern,
                        includePattern: includePattern,
                        verbose: self.options.verbose)
            
            let interface = SuggestConversionInterface(rewriterService: rewriter)
            interface.searchAndShowConfirm(in: menu,
                                           path: (path as NSString).standardizingPath,
                                           options: options)
        }
    }
}

extension SwiftRewriterCommand {
    struct InteractiveMode: ParsableCommand {
        @OptionGroup()
        var options: Options
        
        func run() throws {
            let colorize = options.colorize
            let settings = makeSettings(options)
            
            let output = StdoutWriterOutput(colorize: colorize)
            let service = ObjectiveCSwiftRewriterServiceImpl(output: output, settings: settings)
            
            // Detect terminal
            if isatty(fileno(stdin)) != 0 {
                let console = Console()
                let menu = Menu(rewriterService: service, console: console)
                
                menu.main()
            } else {
                // If not invoked by a terminal, produce an output based on the
                // standard input
                
                output.signalEndOfFiles = false
                
                let inputData = FileHandle.standardInput.availableData
                let inputString = String(decoding: inputData, as: UTF8.self)

                let input = SingleInputProvider(code: inputString, isPrimary: true)

                try service.rewrite(inputs: [input])
            }
        }
    }
    
    struct SwiftRewriterError: Error {
        var description: String
    }
}

private func makeRewriterService(_ options: SwiftRewriterCommand.Options) -> ObjectiveCSwiftRewriterService {
    let colorize = options.colorize
    let target = options.target ?? .filedisk
    let settings = makeSettings(options)
    
    let rewriter: ObjectiveCSwiftRewriterService
    
    switch target {
    case .filedisk:
        rewriter = ObjectiveCSwiftRewriterServiceImpl.fileDisk(settings: settings)
    case .stdout:
        rewriter = ObjectiveCSwiftRewriterServiceImpl.terminal(settings: settings,
                                                               colorize: colorize)
    }
    
    return rewriter
}

private func makeSettings(_ options: SwiftRewriterCommand.Options) -> Settings {
    var settings = Settings()
    
    settings.rewriter.verbose = options.verbose
    settings.rewriter.diagnoseFiles = options.diagnoseFile.map { [$0] } ?? []
    settings.rewriter.numThreads = options.numThreads ?? OperationQueue.defaultMaxConcurrentOperationCount
    settings.astWriter.outputExpressionTypes = options.printExpressionTypes
    settings.astWriter.printIntentionHistory = options.printTracingHistory
    settings.astWriter.emitObjcCompatibility = options.emitObjcCompatibility
    settings.rewriter.forceUseLLPrediction = options.forceLl
    
    return settings
}
