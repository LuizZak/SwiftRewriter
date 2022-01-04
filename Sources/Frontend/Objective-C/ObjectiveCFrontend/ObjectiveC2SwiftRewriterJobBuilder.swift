import Utils
import GrammarModelBase
import ObjcParser
import SwiftSyntaxSupport
import SwiftSyntaxRewriterPasses
import IntentionPasses
import ExpressionPasses
import SourcePreprocessors
import TypeSystem
import SwiftRewriterLib

/// Facility for creating `ObjectiveC2SwiftRewriterJobBuilder`s.
public struct ObjectiveC2SwiftRewriterJobBuilder {
    public var inputs = ObjectiveCSwiftRewriterJobInputFiles()
    public var intentionPassesSource: IntentionPassSource = DefaultIntentionPasses()
    public var astRewriterPassSources: ASTRewriterPassSource = ArrayASTRewriterPassSource(syntaxNodePasses: [
        CanonicalNameExpressionPass.self,
        AllocInitExpressionPass.self,
        InitRewriterExpressionPass.self,
        ASTSimplifier.self,
        PropertyAsMethodAccessCorrectingExpressionPass.self,
        CompoundTypeApplierExpressionPass.self,
        CoreGraphicsExpressionPass.self,
        FoundationExpressionPass.self,
        UIKitExpressionPass.self,
        NilValueTransformationsPass.self,
        NumberCommonsExpressionPass.self,
        ObjectiveCASTCorrectorExpressionPass.self,
        NumberCommonsExpressionPass.self,
        EnumRewriterExpressionPass.self,
        LocalConstantPromotionExpressionPass.self,
        VariableNullabilityPromotionExpressionPass.self,
        ASTSimplifier.self,
    ])
    
    public var globalsProvidersSource: GlobalsProvidersSource = DefaultGlobalsProvidersSource()
    public var syntaxRewriterPassSource: SwiftSyntaxRewriterPassProvider = DefaultSyntaxPassProvider()
    public var preprocessors: [SourcePreprocessor] = [QuickSpecPreprocessor()]
    public var settings: ObjectiveC2SwiftRewriter.Settings = .default
    public var swiftSyntaxOptions: SwiftSyntaxOptions = .default
    public var parserCache: ObjectiveCParserCache?
    
    public init() {
        
    }

    /// Resets this job builder to its default state.
    public mutating func reset() {
        self = Self()
    }
    
    /// Returns a new `ObjectiveC2SwiftRewriterJob` created using the parameters configured
    /// with this builder object.
    public func createJob() -> ObjectiveC2SwiftRewriterJob {
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
public struct ObjectiveCSwiftRewriterJobInputFiles {
    fileprivate(set) public var inputs: [InputSource] = []
    
    public mutating func add(_ input: InputSource) {
        inputs.append(input)
    }
    
    public mutating func add(inputs: [InputSource]) {
        self.inputs.append(contentsOf: inputs)
    }
    
    public mutating func add(filePath: String, source: String, isPrimary: Bool = true) {
        add(SwiftRewriterJobInputSource(
            filePath: filePath,
            source: source,
            isPrimary: isPrimary
        ))
    }
    
    public mutating func addInputs(from inputsProvider: InputSourcesProvider) {
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
