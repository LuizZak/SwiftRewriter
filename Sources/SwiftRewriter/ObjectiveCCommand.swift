import ArgumentParser
import Foundation
import Console
import ObjectiveCFrontend
import SwiftRewriterCLI

struct ObjectiveCCommand: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "objc",
        abstract: "Objective-C code conversion frontend",
        discussion: """
        Converts a set of Objective-C (.h/.m) files, or, if not provided, starts \
        an interactive menu to navigate the file system and choose files to convert.
        """,
        subcommands: [Files.self, Path.self, InteractiveMode.self],
        defaultSubcommand: InteractiveMode.self)
    
    func run() throws {
        
    }
}

extension ObjectiveCCommand {
    struct Options: ParsableArguments {
        @Flag(
            help: """
            Emits '@objc' attributes on definitions, and emits NSObject subclass \
            and NSObjectProtocol conformance on protocols.

            This forces Swift to create Objective-C-compatible subclassing structures
            which may increase compatibility with previous Obj-C code.
            """
        )
        var emitObjcCompatibility: Bool = false
        
        @Option(
            help: """
            Provides a target file path to diagnose during rewriting.
            After each intention pass and after expression passes, the file is written
            to the standard output for diagnosing rewriting issues.
            """
        )
        var diagnoseFile: String?
        
        @Flag(
            name: .shortAndLong,
            help: """
            Follows #import declarations in files in order to parse other relevant files.
            Ignored when converting from standard input.
            """
        )
        var followImports: Bool = false
        
        @Flag(
            name: .long,
            help: """
            If set, prints the call graph of the entire final Swift program generated \
            to the standard output before emitting the files.
            """
        )
        var printCallGraph: Bool = false

        @OptionGroup()
        var globalOptions: GlobalOptions
    }
}

extension ObjectiveCCommand {
    struct Files: ParsableCommand {
        static let configuration = CommandConfiguration(
            discussion: "Converts one or more .h/.m file(s) to Swift."
        )
        
        @Argument(help: "Objective-C file(s) to convert.")
        var files: [String]
        
        @OptionGroup()
        var options: Options
        
        func run() throws {
            let rewriter = try makeRewriterService(options)
            
            let fileProvider = FileDiskProvider()
            let fileCollectionStep = ObjectiveCFileCollectionStep(fileProvider: fileProvider)
            let delegate = ObjectiveCImportDirectiveFileCollectionDelegate(
                parserCache: rewriter.parserCache,
                fileProvider: fileProvider
            )
            
            if options.followImports {
                fileCollectionStep.delegate = delegate
            }
            if options.globalOptions.verbose {
                fileCollectionStep.listener = StdoutFileCollectionStepListener()
            }
            try withExtendedLifetime(delegate) {
                for fileUrl in files {
                    try fileCollectionStep.addFile(
                        fromUrl: URL(fileURLWithPath: fileUrl),
                        isPrimary: true
                    )
                }
            }
            
            try rewriter.rewrite(files: fileCollectionStep.files)
        }
    }
}

extension ObjectiveCCommand {
    struct Path: ParsableCommand {
        static let configuration = CommandConfiguration(
            discussion: """
            Examines a path and collects all .h/.m files to convert, before presenting \
            a prompt to confirm conversion of files.
            """
        )
        
        @Argument(help: "Path to the project to inspect")
        var path: String
        
        @Option(
            name: .shortAndLong,
            help: """
            Provides a file pattern for excluding matches from the initial Objective-C \
            files search. Pattern is applied to the full path.
            """
        )
        var excludePattern: String?
        
        @Option(
            name: .shortAndLong,
            help: """
            Provides a pattern for including matches from the initial Objective-C files \
            search. Pattern is applied to the full path. --exclude-pattern takes \
            priority over --include-pattern matches.
            """
        )
        var includePattern: String?
        
        @Flag(
            name: .shortAndLong,
            help: "Skips asking for confirmation prior to parsing."
        )
        var skipConfirm: Bool = false
        
        @Flag(
            name: .shortAndLong,
            help: "Overwrites any .swift file with a matching output name on the target path."
        )
        var overwrite: Bool = false
        
        @OptionGroup()
        var options: Options
        
        func run() throws {
            let rewriter = try makeRewriterService(options)
            let frontend = ObjectiveCFrontendImpl(rewriterService: rewriter)
            let fileProvider = FileDiskProvider()
            
            let console = Console()
            let menu = Menu(rewriterFrontend: frontend, fileProvider: fileProvider, console: console)
            
            let options: SuggestConversionInterface.Options = .init(
                overwrite: overwrite,
                skipConfirm: skipConfirm,
                followImports: self.options.followImports,
                excludePattern: excludePattern,
                includePattern: includePattern,
                verbose: self.options.globalOptions.verbose
            )
            
            let interface = SuggestConversionInterface(
                rewriterFrontend: frontend,
                fileProvider: fileProvider
            )
            interface.searchAndShowConfirm(
                in: menu,
                url: URL(fileURLWithPath: path).standardizedFileURL,
                options: options
            )
        }
    }
}

extension ObjectiveCCommand {
    struct InteractiveMode: ParsableCommand {
        @OptionGroup()
        var options: Options
        
        func run() throws {
            let colorize = options.globalOptions.colorize
            let settings = try makeSettings(options)
            let fileProvider = FileDiskProvider()
            
            let output = StdoutWriterOutput(colorize: colorize)
            let service = ObjectiveCSwiftRewriterServiceImpl(output: output, settings: settings)
            let frontend = ObjectiveCFrontendImpl(rewriterService: service)
            
            // Detect terminal
            if isatty(fileno(stdin)) != 0 {
                let console = Console()
                let menu = Menu(rewriterFrontend: frontend, fileProvider: fileProvider, console: console)
                
                menu.main()
            } else {
                // If not invoked by a terminal, produce an output based on the
                // standard input
                
                output.signalEndOfFiles = false
                
                let inputData = FileHandle.standardInput.availableData
                let inputString = String(decoding: inputData, as: UTF8.self)

                let input = SingleInputProvider(code: inputString, isPrimary: true, fileName: "input.m")

                try service.rewrite(inputs: [input])
            }
        }
    }
    
    struct SwiftRewriterError: Error {
        var description: String
    }
}

private func makeRewriterService(_ options: ObjectiveCCommand.Options) throws -> ObjectiveCSwiftRewriterService {
    let colorize = options.globalOptions.colorize
    let target = options.globalOptions.target ?? .filedisk
    let settings = try makeSettings(options)
    
    let rewriter: ObjectiveCSwiftRewriterService
    
    switch target {
    case .filedisk:
        rewriter = ObjectiveCSwiftRewriterServiceImpl.fileDisk(
            settings: settings
        )
    case .stdout:
        rewriter = ObjectiveCSwiftRewriterServiceImpl.terminal(
            settings: settings,
            colorize: colorize
        )
    }
    
    return rewriter
}

private func makeSettings(_ options: ObjectiveCCommand.Options) throws -> ObjectiveCSwiftRewriterServiceImpl.Settings {
    var settings = ObjectiveCSwiftRewriterServiceImpl.Settings()
    
    settings.rewriter.verbose = options.globalOptions.verbose
    settings.rewriter.diagnoseFiles = options.diagnoseFile.map { [$0] } ?? []
    settings.rewriter.numThreads = options.globalOptions.numThreads ?? OperationQueue.defaultMaxConcurrentOperationCount
    settings.astWriter.outputExpressionTypes = options.globalOptions.printExpressionTypes
    settings.astWriter.printIntentionHistory = options.globalOptions.printTracingHistory
    settings.astWriter.emitObjcCompatibility = options.emitObjcCompatibility
    settings.astWriter.format = try options.globalOptions.computeFormatterMode()
    settings.rewriter.forceUseLLPrediction = options.globalOptions.forceLl

    if options.globalOptions.printCallGraph {
        settings.rewriter.stageDiagnostics.append(.callGraph)
    }
    
    return settings
}
