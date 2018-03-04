import XCTest
import IntentionPasses
import SwiftRewriterLib
import TestCommons

class ImportDirectiveIntentionPassTests: XCTestCase {
    func testImportDirectiveIntentionPass() {
        let intentions =
            IntentionCollectionBuilder()
                .createFile(named: "file") { file in
                    file.addPreprocessorDirective("#import <UIKit/UIKit.h>")
                        .addPreprocessorDirective("#import <Foundation/Foundation.h>")
                }.build()
        let sut = ImportDirectiveIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        let file = intentions.fileIntentions()[0]
        XCTAssertEqual(file.importDirectives, ["UIKit", "Foundation"])
    }
}
