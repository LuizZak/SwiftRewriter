import Utils
import GrammarModelBase
import JsParser
import SwiftSyntaxSupport
import IntentionPasses
import ExpressionPasses
import SourcePreprocessors
import TypeSystem
import SwiftRewriterLib

/// Facility for creating `JavaScriptSwiftRewriterJob`s.
public class JavaScriptSwiftRewriterJobBuilder {
    public let inputs = JavaScriptSwiftRewriterJobInputFiles()
    public var intentionPassesSource: IntentionPassSource?
    public var astRewriterPassSources: ASTRewriterPassSource?
    public var globalsProvidersSource: GlobalsProvidersSource?
    public var syntaxRewriterPassSource: SwiftSyntaxRewriterPassProvider?
    public var preprocessors: [SourcePreprocessor] = []
    public var settings: JavaScript2SwiftRewriter.Settings = .default
    public var swiftSyntaxOptions: SwiftSyntaxOptions = .default
    public var parserCache: JavaScriptParserCache?
    
    public init() {
        
    }
    
    /// Returns a new `JavaScriptSwiftRewriterJob` created using the parameters configured
    /// with this builder object.
    public func createJob() -> JavaScriptSwiftRewriterJob {
        let provider = inputs.createSourcesProvider()
        
        return .init(
            input: provider,
            intentionPassesSource: intentionPassesSource,
            astRewriterPassSources: astRewriterPassSources,
            globalsProvidersSource: globalsProvidersSource,
            syntaxRewriterPassSource: syntaxRewriterPassSource,
            preprocessors: preprocessors,
            settings: settings,
            swiftSyntaxOptions: swiftSyntaxOptions,
            parserCache: parserCache
        )
    }
}

/// Stores input files for a transpilation job
public class JavaScriptSwiftRewriterJobInputFiles {
    fileprivate(set) public var inputs: [InputSource] = []
    
    public func add(_ input: InputSource) {
        inputs.append(input)
    }
    
    public func add(inputs: [InputSource]) {
        self.inputs.append(contentsOf: inputs)
    }
    
    public func add(filePath: String, source: String, isPrimary: Bool = true) {
        add(SwiftRewriterJobInputSource(filePath: filePath,
                                        source: source,
                                        isPrimary: isPrimary))
    }
    
    public func addInputs(from inputsProvider: InputSourcesProvider) {
        add(inputs: inputsProvider.sources())
    }
    
    func createSourcesProvider() -> InputSourcesProvider {
        SwiftRewriterJobInputProvider(inputs: inputs)
    }
}

struct SwiftRewriterJobInputSource: InputSource {
    var filePath: String
    var source: String
    var isPrimary: Bool
    
    func sourcePath() -> String {
        filePath
    }
    
    func loadSource() throws -> CodeSource {
        StringCodeSource(source: source, fileName: filePath)
    }
}

class SwiftRewriterJobInputProvider: InputSourcesProvider {
    var inputs: [InputSource]
    
    init(inputs: [InputSource]) {
        self.inputs = inputs
    }
    
    func sources() -> [InputSource] {
        inputs
    }
}
