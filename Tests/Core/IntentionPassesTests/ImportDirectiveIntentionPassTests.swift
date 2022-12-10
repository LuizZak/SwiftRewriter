import SwiftRewriterLib
import TestCommons
import XCTest

@testable import IntentionPasses

class ImportDirectiveIntentionPassTests: XCTestCase {
    func testImportDirectiveIntentionPass() {
        let intentions =
            IntentionCollectionBuilder()
            .createFile(named: "file") { file in
                file.addHeaderComment("#import <UIKit/UIKit.h>")
                    .addHeaderComment("#import <Foundation/Foundation.h>")
                    .addHeaderComment("#import <Framework.h>")
            }.build()
        let sut = ImportDirectiveIntentionPass()

        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        Asserter(object: intentions).asserter(forTargetPathFile: "file") { file in
            file.assert(importDirectives: [
                "UIKit", "Foundation", "Framework"
            ])
        }
    }
}
