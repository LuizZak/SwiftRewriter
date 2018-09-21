import ObjcParser

/// Represents a transpilation job, with all required information to start a
/// transpile job.
public class SwiftRewriterJob {
    public var input: InputSourcesProvider
    public var intentionPassesSource: IntentionPassSource?
    public var astRewriterPassSources: ASTRewriterPassSource?
    public var globalsProvidersSource: GlobalsProvidersSource?
    public var settings: SwiftRewriter.Settings = .default
    public var astWriterOptions: ASTWriterOptions = .default
    
    public init(input: InputSourcesProvider,
                intentionPassesSource: IntentionPassSource?,
                astRewriterPassSources: ASTRewriterPassSource?,
                globalsProvidersSource: GlobalsProvidersSource?,
                settings: SwiftRewriter.Settings,
                astWriterOptions: ASTWriterOptions) {
        
        self.intentionPassesSource = intentionPassesSource
        self.astRewriterPassSources = astRewriterPassSources
        self.globalsProvidersSource = globalsProvidersSource
        self.settings = settings
        self.input = input
        self.astWriterOptions = astWriterOptions
    }
    
    /// Executes a transpilation job, returning the result of the operation.
    @discardableResult
    public func execute(output: WriterOutput) -> SwiftRewriterJobResult {
        
        let swiftRewriter = makeSwiftRewriter(output: output)
        
        var jobResult = SwiftRewriterJobResult(succeeded: false, diagnostics: Diagnostics())
        
        do {
            try swiftRewriter.rewrite()
            
            if swiftRewriter.diagnostics.errors.count != 0 {
                jobResult.diagnostics.merge(with: swiftRewriter.diagnostics)
            } else {
                jobResult.succeeded = true
            }
        } catch {
            jobResult.diagnostics.error("\(error)", location: .invalid)
        }
        
        return jobResult
    }
    
    func makeSwiftRewriter(output: WriterOutput) -> SwiftRewriter {
        let rewriter = SwiftRewriter(input: input,
                                     output: output,
                                     intentionPassesSource: intentionPassesSource,
                                     astRewriterPassSources: astRewriterPassSources,
                                     globalsProvidersSource: globalsProvidersSource,
                                     settings: settings)
        rewriter.writerOptions = astWriterOptions
        
        return rewriter
    }
}

/// Encapsulates the results of a transpilation job for inspection post-transpile.
public struct SwiftRewriterJobResult {
    /// If `true`, the transpilation succeeded with no errors.
    public var succeeded: Bool
    /// Diagnostics engine that collected messages during transpilation.
    public var diagnostics: Diagnostics
    
    init(succeeded: Bool, diagnostics: Diagnostics) {
        self.succeeded = succeeded
        self.diagnostics = diagnostics
    }
}
