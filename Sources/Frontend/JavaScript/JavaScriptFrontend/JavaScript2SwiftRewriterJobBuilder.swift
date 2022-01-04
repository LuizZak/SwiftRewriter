import Utils
import GrammarModelBase
import JsParser
import SwiftSyntaxSupport
import IntentionPasses
import ExpressionPasses
import SourcePreprocessors
import TypeSystem
import SwiftRewriterLib

/// Facility for creating `JavaScript2SwiftRewriterJob`s.
public struct JavaScript2SwiftRewriterJobBuilder {
    public var inputs = JavaScriptSwiftRewriterJobInputFiles()
    public var intentionPassesSource: IntentionPassSource
    public var astRewriterPassSources: ASTRewriterPassSource
    public var globalsProvidersSource: GlobalsProvidersSource?
    public var syntaxRewriterPassSource: SwiftSyntaxRewriterPassProvider = DefaultSyntaxPassProvider()
    public var preprocessors: [SourcePreprocessor] = []
    public var settings: JavaScript2SwiftRewriter.Settings = .default
    public var swiftSyntaxOptions: SwiftSyntaxOptions = .default
    public var parserCache: JavaScriptParserCache?
    
    public init() {
        self.intentionPassesSource = ArrayIntentionPassSource(intentionPasses: [
            DetectNoReturnsIntentionPass(),
            DetectTypePropertiesBySelfAssignmentIntentionPass(),
            FileTypeMergingIntentionPass(),
            SubscriptDeclarationIntentionPass(),
            PromoteProtocolPropertyConformanceIntentionPass(),
            ProtocolNullabilityPropagationToConformersIntentionPass(),
            PropertyMergeIntentionPass(),
            StoredPropertyToNominalTypesIntentionPass(),
            SwiftifyMethodSignaturesIntentionPass(),
            InitAnalysisIntentionPass(),
            ImportDirectiveIntentionPass(),
            UIKitCorrectorIntentionPass(),
            ProtocolNullabilityPropagationToConformersIntentionPass(),
            DetectNonnullReturnsIntentionPass(),
            RemoveEmptyExtensionsIntentionPass()
        ])
        
        self.astRewriterPassSources = ArrayASTRewriterPassSource(syntaxNodePasses: [
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
            JavaScriptASTCorrectorExpressionPass.self,
            NumberCommonsExpressionPass.self,
            EnumRewriterExpressionPass.self,
            LocalConstantPromotionExpressionPass.self,
            VariableNullabilityPromotionExpressionPass.self,
            ASTSimplifier.self,
        ])
    }

    /// Resets this job builder to its default state.
    public mutating func reset() {
        self = Self()
    }
    
    /// Returns a new `JavaScript2SwiftRewriterJob` created using the parameters configured
    /// with this builder object.
    public func createJob() -> JavaScript2SwiftRewriterJob {
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
public struct JavaScriptSwiftRewriterJobInputFiles {
    fileprivate(set) public var inputs: [InputSource] = []
    
    public mutating func add(_ input: InputSource) {
        inputs.append(input)
    }
    
    public mutating func add(inputs: [InputSource]) {
        self.inputs.append(contentsOf: inputs)
    }
    
    public mutating func add(filePath: String, source: String, isPrimary: Bool = true) {
        add(SwiftRewriterJobInputSource(filePath: filePath,
                                        source: source,
                                        isPrimary: isPrimary))
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
