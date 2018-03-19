import XCTest
import IntentionPasses
import SwiftRewriterLib

class DefaultIntentionPassesTests: XCTestCase {
    func testDefaultIntentionPasses() {
        let intents = DefaultIntentionPasses().intentionPasses
        
        // Using iterator so we can test ordering without indexing into array
        // (could crash and abort tests halfway through)
        var intentsIterator = intents.makeIterator()
        
        XCTAssertEqual(intents.count, 9)
        
        XCTAssert(intentsIterator.next() is FileTypeMergingIntentionPass)
        XCTAssert(intentsIterator.next() is ProtocolNullabilityPropagationToConformersIntentionPass)
        XCTAssert(intentsIterator.next() is PropertyMergeIntentionPass)
        XCTAssert(intentsIterator.next() is StoredPropertyToNominalTypesIntentionPass)
        XCTAssert(intentsIterator.next() is SwiftifyMethodSignaturesIntentionPass)
        XCTAssert(intentsIterator.next() is ImportDirectiveIntentionPass)
        XCTAssert(intentsIterator.next() is UIKitCorrectorIntentionPass)
        XCTAssert(intentsIterator.next() is ProtocolNullabilityPropagationToConformersIntentionPass)
        XCTAssert(intentsIterator.next() is DetectNonnullReturnsIntentionPass)
    }
}

// Helper method for constructing intention pass contexts for tests
func makeContext(intentions: IntentionCollection) -> IntentionPassContext {
    let system = IntentionCollectionTypeSystem(intentions: intentions)
    let invoker = DefaultTypeResolverInvoker(globals: GlobalDefinitions(),
                                             typeSystem: system, numThreads: 8)
    let typeMapper = DefaultTypeMapper(typeSystem: system)
    
    return IntentionPassContext(typeSystem: system, typeMapper: typeMapper,
                                typeResolverInvoker: invoker)
}
