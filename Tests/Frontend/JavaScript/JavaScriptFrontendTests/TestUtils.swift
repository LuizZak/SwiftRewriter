import Intentions
import SwiftRewriterLib
import TypeSystem
import IntentionPasses
import XCTest

// Helper method for constructing intention pass contexts for tests
func makeContext(intentions: IntentionCollection) -> IntentionPassContext {
    let system = IntentionCollectionTypeSystem(intentions: intentions)
    let invoker = DefaultTypeResolverInvoker(
        globals: ArrayDefinitionsSource(),
        typeSystem: system,
        numThreads: 8
    )
    let typeMapper = DefaultTypeMapper(typeSystem: system)

    return IntentionPassContext(
        typeSystem: system,
        typeMapper: typeMapper,
        typeResolverInvoker: invoker,
        numThreads: 8
    )
}
