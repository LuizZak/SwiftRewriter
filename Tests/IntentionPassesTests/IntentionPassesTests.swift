import XCTest
import IntentionPasses
import SwiftRewriterLib

class IntentionPassesTests: XCTestCase {
    func testDefaultIntentionPasses() {
        let intents = DefaultIntentionPasses().intentionPasses
        var intentsIterator = intents.makeIterator() // Using iterator so we can test ordering without indexing into array (could crash and abort tests halfway through)
        
        // Asserter shortcut
        func assertNext<T: IntentionPass>(is type: T.Type, _ line: Int = #line) {
            guard let next = intentsIterator.next() else {
                recordFailure(withDescription: "Reached unexpected end of intentions list.", inFile: #file, atLine: line, expected: true)
                return
            }
            
            if Swift.type(of: next) != type {
                recordFailure(withDescription: "Expected type \(type) but found \(Swift.type(of: next))", inFile: #file, atLine: line, expected: true)
            }
        }
        
        XCTAssertEqual(intents.count, 6)
        
        assertNext(is: FileTypeMergingIntentionPass.self)
        assertNext(is: ProtocolNullabilityPropagationToConformersIntentionPass.self)
        assertNext(is: PropertyMergeIntentionPass.self)
        assertNext(is: StoredPropertyToNominalTypesIntentionPass.self)
        assertNext(is: SwiftifyMethodSignaturesIntentionPass.self)
        assertNext(is: ImportDirectiveIntentionPass.self)
    }
}

// Helper method for constructing intention pass contexts for tests
func makeContext(intentions: IntentionCollection) -> IntentionPassContext {
    let system = IntentionCollectionTypeSystem(intentions: intentions)
    let invoker = DefaultTypeResolverInvoker(globals: GlobalDefinitions(), typeSystem: system)
    let typeMapper = DefaultTypeMapper(context: TypeConstructionContext(typeSystem: system))
    
    return IntentionPassContext(typeSystem: system, typeMapper: typeMapper, typeResolverInvoker: invoker)
}
