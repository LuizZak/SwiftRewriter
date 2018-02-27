import XCTest
import IntentionPasses

class IntentionPassesTests: XCTestCase {
    func testDefaultIntentionPasses() {
        let intents = DefaultIntentionPasses().intentionPasses
        
        XCTAssertEqual(intents.count, 6)
        
        XCTAssert(intents[0] is FileTypeMergingIntentionPass)
        XCTAssert(intents[1] is RemoveDuplicatedTypeIntentIntentionPass)
        XCTAssert(intents[2] is StoredPropertyToNominalTypesIntentionPass)
        XCTAssert(intents[3] is ProtocolNullabilityPropagationToConformersIntentionPass)
        XCTAssert(intents[4] is PropertyMergeIntentionPass)
        XCTAssert(intents[5] is SwiftifyMethodSignaturesIntentionPass)
    }
}
