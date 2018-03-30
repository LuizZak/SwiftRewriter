import XCTest
import SwiftRewriterLib
import TestCommons
import GlobalsProviders

class IntentionCollectionTypeSystemTests: XCTestCase {
    /// When an extension in an intention collection is described for a global
    /// type (i.e UIView), make sure we don't actually end up only seeing the
    /// extension when calling `knownTypeWithName(_:)`
    func testGlobalClassWithIntentionExtensionProperlyComposesAsKnownType() {
        let intentions =
            IntentionCollectionBuilder()
                .createFile(named: "A") { file in
                    file.createExtension(forClassNamed: "UIView") { ext in
                        ext.createVoidMethod(named: "fromExtension")
                    }
                }.build()
        let sut = IntentionCollectionTypeSystem(intentions: intentions)
        sut.addKnownTypeProvider(UIKitGlobalsProvider().knownTypeProvider())
        
        guard let result = sut.knownTypeWithName("UIView") else {
            XCTFail("Expected to find UIView")
            return
        }
        
        XCTAssert(result.knownProperties.contains(where: { $0.name == "window" }))
        XCTAssert(result.knownMethods.contains(where: { $0.signature.name == "fromExtension" }))
    }
}
