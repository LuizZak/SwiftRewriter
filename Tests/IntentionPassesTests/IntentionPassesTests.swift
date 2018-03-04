import XCTest
import IntentionPasses
import SwiftRewriterLib

class IntentionPassesTests: XCTestCase {
    func testDefaultIntentionPasses() {
        let intents = DefaultIntentionPasses().intentionPasses
        
        XCTAssertEqual(intents.count, 6)
        
        XCTAssert(intents[0] is FileTypeMergingIntentionPass, "\(type(of: intents[0]))")
        XCTAssert(intents[1] is ProtocolNullabilityPropagationToConformersIntentionPass, "\(type(of: intents[1]))")
        XCTAssert(intents[2] is PropertyMergeIntentionPass, "\(type(of: intents[2]))")
        XCTAssert(intents[3] is StoredPropertyToNominalTypesIntentionPass, "\(type(of: intents[3]))")
        XCTAssert(intents[4] is SwiftifyMethodSignaturesIntentionPass, "\(type(of: intents[4]))")
        XCTAssert(intents[5] is ImportDirectiveIntentionPass, "\(type(of: intents[5]))")
    }
}

// Helper method for constructing intention pass contexts for tests
func makeContext(intentions: IntentionCollection) -> IntentionPassContext {
    let system = IntentionCollectionTypeSystem(intentions: intentions)
    let invoker = DefaultTypeResolverInvoker(typeSystem: system)
    let typeMapper = DefaultTypeMapper(context: TypeConstructionContext(typeSystem: system))
    
    return IntentionPassContext(typeSystem: system, typeMapper: typeMapper, typeResolverInvoker: invoker)
}
