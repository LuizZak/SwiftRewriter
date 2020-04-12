import XCTest
import IntentionPasses
import Intentions
import SwiftRewriterLib
import Commons
import GlobalsProviders
import TypeSystem

class DefaultIntentionPassesTests: XCTestCase {
    func testDefaultIntentionPasses() {
        let intents = DefaultIntentionPasses().intentionPasses
        
        // Using iterator so we can test ordering without indexing into array
        // (could crash and abort tests halfway through)
        var intentsIterator = intents.makeIterator()
        
        XCTAssert(intentsIterator.next() is FileTypeMergingIntentionPass)
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
        XCTAssert(intentsIterator.next() is PromoteNSMutableArrayIntentionPass)
        XCTAssertNil(intentsIterator.next())
    }
}

// Helper method for constructing intention pass contexts for tests
func makeContext(intentions: IntentionCollection,
                 resolveTypes: Bool = false) -> IntentionPassContext {
    
    let commonsTypeProvider = CompoundedMappingTypesGlobalsProvider()
    
    let globals = CompoundDefinitionsSource()
    
    // Register globals first
    globals.addSource(commonsTypeProvider.definitionsSource())
    
    let typeSystem = IntentionCollectionTypeSystem(intentions: intentions)
    
    typeSystem.addTypealiasProvider(commonsTypeProvider.typealiasProvider())
    typeSystem.addKnownTypeProvider(commonsTypeProvider.knownTypeProvider())
    
    let invoker = DefaultTypeResolverInvoker(globals: globals,
                                             typeSystem: typeSystem,
                                             numThreads: 8)
    let typeMapper = DefaultTypeMapper(typeSystem: typeSystem)
    
    if resolveTypes {
        invoker.resolveAllExpressionTypes(in: intentions, force: true)
    }
    
    return IntentionPassContext(typeSystem: typeSystem,
                                typeMapper: typeMapper,
                                typeResolverInvoker: invoker,
                                numThreads: 8)
}
