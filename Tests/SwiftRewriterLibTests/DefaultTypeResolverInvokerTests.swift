import XCTest
import SwiftRewriterLib
import SwiftAST
import TestCommons

class DefaultTypeResolverInvokerTests: XCTestCase {
    func testExposesGlobalVariablesFromIntrinsics() {
        let intentions =
            IntentionCollectionBuilder()
                .createFile(named: "A.m") { file in
                    file.createGlobalVariable(withName: "a", type: .int)
                }.build()
        let typeSystem = IntentionCollectionTypeSystem(intentions: intentions)
        let typeResolver = ExpressionTypeResolver(typeSystem: typeSystem)
        let sut = DefaultTypeResolverInvoker(typeResolver: typeResolver)
    }
}
