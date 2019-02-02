import ObjcParser
import IntentionPasses

/// Facility for creating `SwiftRewriterJob`s.
public class SwiftRewriterJobBuilder {
    public let inputs = SwiftRewriterJobInputFiles()
    public var intentionPassesSource: IntentionPassSource?
    public var astRewriterPassSources: ASTRewriterPassSource?
    public var globalsProvidersSource: GlobalsProvidersSource?
    public var preprocessors: [SourcePreprocessor] = []
    public var settings: SwiftRewriter.Settings = .default
    public var swiftSyntaxOptions: SwiftSyntaxOptions = .default
    
    public init() {
        
    }
    
    /// Returns a new `SwiftRewriterJob` created using the parameters configured
    /// with this builder object.
    public func createJob() -> SwiftRewriterJob {
        let provider = inputs.createSourcesProvider()
        
        return SwiftRewriterJob(input: provider,
                                intentionPassesSource: intentionPassesSource,
                                astRewriterPassSources: astRewriterPassSources,
                                globalsProvidersSource: globalsProvidersSource,
                                preprocessors: preprocessors,
                                settings: settings,
                                swiftSyntaxOptions: swiftSyntaxOptions)
    }
}

/// Stores input files for a transpilation job
public class SwiftRewriterJobInputFiles {
    fileprivate(set) public var inputs: [InputSource] = []
    
    public func add(_ input: InputSource) {
        inputs.append(input)
    }
    
    public func add(inputs: [InputSource]) {
        self.inputs.append(contentsOf: inputs)
    }
    
    public func add(filePath: String, source: String) {
        add(SwiftRewriterJobInputSource(filePath: filePath, source: source))
    }
    
    public func addInputs(from inputsProvider: InputSourcesProvider) {
        add(inputs: inputsProvider.sources())
    }
    
    func createSourcesProvider() -> InputSourcesProvider {
        return SwiftRewriterJobInputProvider(inputs: inputs)
    }
}

struct SwiftRewriterJobInputSource: InputSource {
    var filePath: String
    var source: String
    
    func sourceName() -> String {
        return filePath
    }
    
    func loadSource() throws -> CodeSource {
        return StringCodeSource(source: source, fileName: filePath)
    }
}

class SwiftRewriterJobInputProvider: InputSourcesProvider {
    var inputs: [InputSource]
    
    init(inputs: [InputSource]) {
        self.inputs = inputs
    }
    
    func sources() -> [InputSource] {
        return inputs
    }
}
