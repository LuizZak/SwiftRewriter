import Utils
import JsParser
import SwiftSyntaxSupport
import IntentionPasses
import ExpressionPasses
import SourcePreprocessors
import TypeSystem
import SwiftRewriterLib

/// Represents a transpilation job, with all required information to start a
/// transpile job.
public class JavaScript2SwiftRewriterJob {
    public var input: InputSourcesProvider
    public var intentionPassesSource: IntentionPassSource?
    public var astRewriterPassSources: ASTRewriterPassSource?
    public var globalsProvidersSource: GlobalsProvidersSource?
    public var syntaxRewriterPassSource: SwiftSyntaxRewriterPassProvider?
    public var preprocessors: [SourcePreprocessor]
    public var settings: JavaScript2SwiftRewriter.Settings
    public var swiftSyntaxOptions: SwiftSyntaxOptions
    public var parserCache: JavaScriptParserCache?
    
    public init(
        input: InputSourcesProvider,
        intentionPassesSource: IntentionPassSource?,
        astRewriterPassSources: ASTRewriterPassSource?,
        globalsProvidersSource: GlobalsProvidersSource?,
        syntaxRewriterPassSource: SwiftSyntaxRewriterPassProvider?,
        preprocessors: [SourcePreprocessor],
        settings: JavaScript2SwiftRewriter.Settings,
        swiftSyntaxOptions: SwiftSyntaxOptions,
        parserCache: JavaScriptParserCache?
    ) {
        
        self.intentionPassesSource = intentionPassesSource
        self.astRewriterPassSources = astRewriterPassSources
        self.globalsProvidersSource = globalsProvidersSource
        self.syntaxRewriterPassSource = syntaxRewriterPassSource
        self.preprocessors = preprocessors
        self.settings = settings
        self.input = input
        self.swiftSyntaxOptions = swiftSyntaxOptions
        self.parserCache = parserCache
    }
    
    /// Executes a transpilation job, returning the result of the operation.
    @discardableResult
    public func execute(output: WriterOutput) -> JavaScriptSwiftRewriterJobResult {
        
        let swiftRewriter = makeSwiftRewriter(output: output)
        
        var jobResult = JavaScriptSwiftRewriterJobResult(succeeded: false, diagnostics: Diagnostics())
        
        do {
            try swiftRewriter.rewrite()
            
            if !swiftRewriter.diagnostics.errors.isEmpty {
                jobResult.diagnostics.merge(with: swiftRewriter.diagnostics)
            } else {
                jobResult.succeeded = true
            }
        } catch {
            jobResult.diagnostics.error("\(error)", location: .invalid)
        }
        
        return jobResult
    }
    
    func makeSwiftRewriter(output: WriterOutput) -> JavaScript2SwiftRewriter {
        let rewriter = JavaScript2SwiftRewriter(
            input: input,
            output: output,
            intentionPassesSource: intentionPassesSource,
            astRewriterPassSources: astRewriterPassSources,
            globalsProvidersSource: globalsProvidersSource,
            syntaxRewriterPassSource: syntaxRewriterPassSource,
            settings: settings
        )
        
        rewriter.writerOptions = swiftSyntaxOptions
        rewriter.preprocessors = preprocessors
        rewriter.parserCache = parserCache
        
        return rewriter
    }
}

/// Encapsulates the results of a transpilation job for inspection post-transpile.
public struct JavaScriptSwiftRewriterJobResult {
    /// If `true`, the transpilation succeeded with no errors.
    public var succeeded: Bool
    /// Diagnostics engine that collected messages during transpilation.
    public var diagnostics: Diagnostics
    
    init(succeeded: Bool, diagnostics: Diagnostics) {
        self.succeeded = succeeded
        self.diagnostics = diagnostics
    }
}
