import SPMUtility

class SwiftRewriterArgumentsParser {
    
    let parser: ArgumentParser
    
    /// `--colorize`
    let colorArg: OptionArgument<Bool>
    /// `--print-expression-types`
    let outputExpressionTypesArg: OptionArgument<Bool>
    /// `--print-tracing-history`
    let outputIntentionHistoryArg: OptionArgument<Bool>
    /// `--verbose`
    let verboseArg: OptionArgument<Bool>
    /// `--num-threads`
    let numThreadsArg: OptionArgument<Int>
    /// `--force-ll`
    let forceUseLLPredictionArg: OptionArgument<Bool>
    /// `--emit-objc-compatibility`
    let emitObjcCompatibilityArg: OptionArgument<Bool>
    /// `--diagnose-file`
    let diagnoseFileArg: OptionArgument<String>
    /// `--target stdout | filedisk`
    let targetArg: OptionArgument<Target>
    
    /// `files <files...> [--follow-imports]`
    let filesParser: FilesParser
    
    /// `path <path> [--exclude-pattern <pattern>] [--include-pattern <pattern>] [--skip-confirm] [--overwrite] [--follow-imports]`
    let pathParser: PathParser
    
    init() {
        parser =
            ArgumentParser(
                usage: """
                [--colorize|-c] [--print-expression-types|-t] [--print-tracing-history|-p] \
                [--emit-objc-compatibility|-o] [--verbose|-v] [--num-threads|-t <n>] [--force-ll|-ll] \
                [--target|-w stdout | filedisk] \
                [files <files...> [--follow-imports] \
                | path <path> [--exclude-pattern|-e <pattern>] [--include-pattern|-i <pattern>] \
                [--skip-confirm|-s] [--overwrite|-o]]
                """,
                overview: """
                Converts a set of files, or, if not provided, starts an interactive \
                menu to navigate the file system and choose files to convert.
                """)
        
        // --colorize
        colorArg
            = parser.add(option: "--colorize", shortName: "-c", kind: Bool.self,
                         usage: "Pass this parameter as true to enable terminal colorization during output.")
        
        // --print-expression-types
        outputExpressionTypesArg
            = parser.add(option: "--print-expression-types", shortName: "-e",
                         kind: Bool.self,
                         usage: "Prints the type of each top-level resolved expression statement found in function bodies.")
        
        // --print-tracing-history
        outputIntentionHistoryArg
            = parser.add(option: "--print-tracing-history", shortName: "-p", kind: Bool.self,
                         usage: """
                Prints extra information before each declaration and member about the \
                inner logical decisions of intention passes as they change the structure \
                of declarations.
                """)
        
        // --verbose
        verboseArg
            = parser.add(option: "--verbose", shortName: "-v", kind: Bool.self,
                         usage: "Prints progress information to the console while performing a transpiling job.")
        
        // --num-threads
        numThreadsArg
            = parser.add(
                option: "--num-threads", shortName: "-t",
                kind: Int.self,
                usage: """
                Specifies the number of threads to use when performing parsing, as well \
                as intention and expression passes. If not specified, thread allocation \
                is defined by the system depending on usage conditions.
                """)
        
        // --force-ll
        forceUseLLPredictionArg
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
        emitObjcCompatibilityArg
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
        diagnoseFileArg
            = parser.add(
                option: "--diagnose-file", shortName: "-d",
                kind: String.self,
                usage: """
                Provides a target file path to diagnose during rewriting.
                After each intention pass and after expression passes, the file is written
                to the standard output for diagnosing rewriting issues.
                """)
        
        //// --target stdout | filedisk
        targetArg
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
        
        // files <files...>
        filesParser = FilesParser(parentParser: parser)
        
        // path <path> [--exclude-pattern <pattern>] [--skip-confirm] [--overwrite]
        pathParser = PathParser(parentParser: parser)
    }
    
    /// `files <files...>`
    class FilesParser {
        /// `files <files...> [--follow-imports]`
        let filesParser: ArgumentParser
        /// `<files...>`
        let filesArg: PositionalArgument<[String]>
        /// `--follow-imports`
        let followImportsArg: OptionArgument<Bool>
        
        init(parentParser: ArgumentParser) {
            filesParser
                = parentParser.add(subparser: "files",
                                   overview: "Converts one or more .h/.m file(s) to Swift.")
            filesArg
                = filesParser.add(positional: "files", kind: [String].self, usage: "Objective-C file(s) to convert.")

            followImportsArg
                = filesParser.add(option: "--follow-imports", shortName: "-f", kind: Bool.self,
                                  usage: "Follows #import declarations in files in order to parse other relevant files.")
        }
    }
    
    /// `path <path> [--exclude-pattern <pattern>] [--include-pattern <pattern>] [--skip-confirm] [--overwrite]`
    class PathParser {
        
        /// `path <path> [--exclude-pattern <pattern>] [--include-pattern <pattern>] [--skip-confirm] [--overwrite]`
        let pathParser: ArgumentParser
        /// `<path...>` (for path mode only)
        let pathArg: PositionalArgument<String>
        
        /// `--exclude-pattern <pattern>` (for path mode only)
        let excludePatternArg: OptionArgument<String>
        /// `--include-pattern <pattern>` (for path mode only)
        let includePatternArg: OptionArgument<String>
        /// `--skip-confirm` (for path mode only)
        let skipConfirmArg: OptionArgument<Bool>
        /// `--overwrite` (for path mode only)
        let overwriteArg: OptionArgument<Bool>
        /// `--follow-imports` (for path mode only)
        let followImportsArg: OptionArgument<Bool>
        
        init(parentParser: ArgumentParser) {
            pathParser
                = parentParser.add(
                    subparser: "path",
                    overview: """
                    Examines a path and collects all .h/.m files to convert, before presenting \
                    a prompt to confirm conversion of files.
                    """)
            
            pathArg
                = pathParser.add(positional: "path", kind: String.self,
                                 usage: "Path to the project to inspect")
            
            excludePatternArg
                = pathParser.add(
                    option: "--exclude-pattern", shortName: "-e", kind: String.self,
                    usage: """
                    Provides a file pattern for excluding matches from the initial Objective-C \
                    files search. Pattern is applied to the full path.
                    """)
            
            includePatternArg
                = pathParser.add(
                    option: "--include-pattern", shortName: "-i", kind: String.self,
                    usage: """
                    Provides a pattern for including matches from the initial Objective-C files \
                    search. Pattern is applied to the full path. --exclude-pattern takes \
                    priority over --include-pattern matches.
                    """)
            
            skipConfirmArg
                = pathParser.add(option: "--skip-confirm", shortName: "-s", kind: Bool.self,
                                 usage: "Skips asking for confirmation prior to parsing.")
            
            overwriteArg
                = pathParser.add(option: "--overwrite", shortName: "-o", kind: Bool.self,
                                 usage: "Overwrites any .swift file with a matching output name on the target path.")

            followImportsArg
                = pathParser.add(option: "--follow-imports", shortName: "-f", kind: Bool.self,
                                 usage: "Follows #import declarations in files in order to parse other relevant files.")
        }
    }
}
