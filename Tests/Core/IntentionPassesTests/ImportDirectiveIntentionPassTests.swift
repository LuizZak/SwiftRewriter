import XCTest
import IntentionPasses
import SwiftRewriterLib
import TestCommons

class ImportDirectiveIntentionPassTests: XCTestCase {
    func testImportDirectiveIntentionPass() {
        let intentions =
            IntentionCollectionBuilder()
                .createFile(named: "file") { file in
                    file.addPreprocessorDirective("#import <UIKit/UIKit.h>", line: 1)
                        .addPreprocessorDirective("#import <Foundation/Foundation.h>", line: 2)
                        .addPreprocessorDirective("#import <Framework.h>", line: 3)
                }.build()
        let sut = ImportDirectiveIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        let file = intentions.fileIntentions()[0]
        XCTAssertEqual(file.importDirectives, ["UIKit", "Foundation", "Framework"])
    }
}
