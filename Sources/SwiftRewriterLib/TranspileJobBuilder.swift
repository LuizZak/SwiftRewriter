import ObjcParser

protocol TranspileJobDelegate {
    func transpileJobBegan(_ transpileJob: TranspileJob)
    func transpileJob(_ transpileJob: TranspileJob, didEndWithResults results: TranspileJobResults)
    func writerOutputForTranspilerJob(_ transpileJob: TranspileJob) -> WriterOutput
}

class TranspileJob {
    var input: InputSourcesProvider
    var intentionPassesSource: IntentionPassSource?
    var astRewriterPassSources: ASTRewriterPassSource?
    var globalsProvidersSource: GlobalsProvidersSource?
    var settings: SwiftRewriter.Settings = .default
    let delegate: TranspileJobDelegate
    
    init(input: InputSourcesProvider,
         intentionPassesSource: IntentionPassSource?,
         astRewriterPassSources: ASTRewriterPassSource?,
         globalsProvidersSource: GlobalsProvidersSource?,
         settings: SwiftRewriter.Settings,
         delegate: TranspileJobDelegate) {
        
        self.intentionPassesSource = intentionPassesSource
        self.astRewriterPassSources = astRewriterPassSources
        self.globalsProvidersSource = globalsProvidersSource
        self.settings = settings
        self.input = input
        self.delegate = delegate
    }
    
    /// Executes a compilation step
    func transpile(expectsErrors: Bool = false,
                   options: ASTWriterOptions = .default,
                   file: String = #file,
                   line: Int = #line) -> TranspileJobResults {
        
        let swiftRewriter = makeSwiftRewriter()
        
        var jobResults = TranspileJobResults(errors: [])
        
        do {
            try swiftRewriter.rewrite()
            
            if swiftRewriter.diagnostics.errors.count != 0 {
                
                let diagnostics =
                    swiftRewriter
                        .diagnostics
                        .errorDiagnostics().map {
                            TranspileJobError.parseError($0)
                        }
                
                jobResults.errors.append(contentsOf: diagnostics)
            }
        } catch {
            jobResults.errors.append(.transpileError(error))
        }
        
        return jobResults
    }
    
    func makeSwiftRewriter() -> SwiftRewriter {
        let output = delegate.writerOutputForTranspilerJob(self)
        
        return SwiftRewriter(input: input,
                             output: output,
                             intentionPassesSource: intentionPassesSource,
                             astRewriterPassSources: astRewriterPassSources,
                             globalsProvidersSource: globalsProvidersSource,
                             settings: settings)
    }
}

class TranspileJobBuilder {
    typealias File = (path: String, souce: String)
    
    var intentionPassesSource: IntentionPassSource?
    var astRewriterPassSources: ASTRewriterPassSource?
    var globalsProvidersSource: GlobalsProvidersSource?
    var settings: SwiftRewriter.Settings = .default
    var output: WriterOutput
    var files: [InputSource] = []
    var errors: String = ""
    var delegate: TranspileJobDelegate
    
    private var _invokedCompile = false
    
    init(output: WriterOutput, delegate: TranspileJobDelegate) {
        self.output = output
        self.delegate = delegate
    }
    
    func file(path: String, _ contents: String) -> TranspileJobBuilder {
        files.append(InputFile(path: path, contents: contents))
        return self
    }
    
    func build() -> TranspileJob {
        let input = TranspileJobInputProvider(inputs: files)
        
        return TranspileJob(input: input,
                            intentionPassesSource: intentionPassesSource,
                            astRewriterPassSources: astRewriterPassSources,
                            globalsProvidersSource: globalsProvidersSource,
                            settings: settings,
                            delegate: delegate)
    }
    
    private struct InputFile: InputSource {
        var path: String
        var contents: String
        
        func sourceName() -> String {
            return path
        }
        
        func loadSource() throws -> CodeSource {
            return StringCodeSource(source: contents, fileName: path)
        }
    }
}

struct TranspileJobResults {
    var errors: [TranspileJobError]
    
    init(errors: [TranspileJobError]) {
        self.errors = errors
    }
}

enum TranspileJobError: Error {
    case parseError(ErrorDiagnostic)
    case transpileError(Error)
    case outputError(String)
}

struct TranspileJobInputSource: InputSource {
    var name: String
    var source: String
    
    func sourceName() -> String {
        return name
    }
    
    func loadSource() throws -> CodeSource {
        return StringCodeSource(source: source, fileName: name)
    }
}

class TranspileJobInputProvider: InputSourcesProvider {
    var inputs: [InputSource]
    
    init(inputs: [InputSource]) {
        self.inputs = inputs
    }
    
    func sources() -> [InputSource] {
        return inputs
    }
}
