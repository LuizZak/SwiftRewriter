import XCTest

@testable import JavaScriptFrontend

class JavaScript2SwiftRewriterJobBuilderTests: XCTestCase {
    func testEphemeral() {
        let sut = JavaScript2SwiftRewriterJobBuilder()

        XCTAssertTrue(sut.inputs.inputs.isEmpty)
    }

    func testDefaultIntentionPasses() {
        let sut = JavaScript2SwiftRewriterJobBuilder()

        let intents = sut.intentionPassesSource.intentionPasses

        // Using iterator so we can test ordering without indexing into array
        // (could crash and abort tests halfway through)
        var intentsIterator = intents.makeIterator()

        XCTAssert(intentsIterator.next() is DetectNoReturnsIntentionPass)
        XCTAssert(intentsIterator.next() is DetectTypePropertiesBySelfAssignmentIntentionPass)
        XCTAssert(intentsIterator.next() is FileTypeMergingIntentionPass)
        XCTAssert(intentsIterator.next() is SubscriptDeclarationIntentionPass)
        XCTAssert(intentsIterator.next() is PromoteProtocolPropertyConformanceIntentionPass)
        XCTAssert(intentsIterator.next() is ProtocolNullabilityPropagationToConformersIntentionPass)
        XCTAssert(intentsIterator.next() is PropertyMergeIntentionPass)
        XCTAssert(intentsIterator.next() is StoredPropertyToNominalTypesIntentionPass)
        XCTAssert(intentsIterator.next() is SwiftifyMethodSignaturesIntentionPass)
        XCTAssert(intentsIterator.next() is InitAnalysisIntentionPass)
        XCTAssert(intentsIterator.next() is ImportDirectiveIntentionPass)
        XCTAssert(intentsIterator.next() is UIKitCorrectorIntentionPass)
        XCTAssert(intentsIterator.next() is ProtocolNullabilityPropagationToConformersIntentionPass)
        XCTAssert(intentsIterator.next() is DetectNonnullReturnsIntentionPass)
        XCTAssert(intentsIterator.next() is RemoveEmptyExtensionsIntentionPass)
        XCTAssertNil(intentsIterator.next())
    }
    
    func testDefaultExpressionPasses() {
        let sut = JavaScript2SwiftRewriterJobBuilder()

        let source = sut.astRewriterPassSources
        var passes = source.syntaxNodePasses.makeIterator()

        XCTAssert(passes.next() == CanonicalNameExpressionPass.self)
        XCTAssert(passes.next() == AllocInitExpressionPass.self)
        XCTAssert(passes.next() == InitRewriterExpressionPass.self)
        XCTAssert(passes.next() == ASTSimplifier.self)
        XCTAssert(passes.next() == PropertyAsMethodAccessCorrectingExpressionPass.self)
        XCTAssert(passes.next() == CompoundTypeApplierExpressionPass.self)
        XCTAssert(passes.next() == CoreGraphicsExpressionPass.self)
        XCTAssert(passes.next() == FoundationExpressionPass.self)
        XCTAssert(passes.next() == UIKitExpressionPass.self)
        XCTAssert(passes.next() == NilValueTransformationsPass.self)
        XCTAssert(passes.next() == NumberCommonsExpressionPass.self)
        XCTAssert(passes.next() == JavaScriptASTCorrectorExpressionPass.self)
        XCTAssert(passes.next() == NumberCommonsExpressionPass.self)
        XCTAssert(passes.next() == EnumRewriterExpressionPass.self)
        XCTAssert(passes.next() == LocalConstantPromotionExpressionPass.self)
        XCTAssert(passes.next() == VariableNullabilityPromotionExpressionPass.self)
        XCTAssert(passes.next() == ASTSimplifier.self)
        XCTAssertNil(passes.next())
    }

    func testDefaultSyntaxPasses() {
        let sut = JavaScript2SwiftRewriterJobBuilder()
        
        let passes = sut.syntaxRewriterPassSource.passes

        // Using iterator so we can test ordering without indexing into array
        // (could crash and abort tests halfway through)
        var passesIterator = passes.makeIterator()

        XCTAssert(passesIterator.next() is StatementSpacingSyntaxPass)
        XCTAssertNil(passesIterator.next())
    }

    func testDefaultSourcePreprocessors() {
        let sut = JavaScript2SwiftRewriterJobBuilder()

        let preprocessors = sut.preprocessors

        // Using iterator so we can test ordering without indexing into array
        // (could crash and abort tests halfway through)
        var iterator = preprocessors.makeIterator()

        XCTAssertNil(iterator.next())
    }
}
