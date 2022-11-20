import JsGrammarModels
import JsParser
import XCTest

@testable import JavaScriptFrontend

class JavaScript2SwiftRewriter_MultiFilesTests: XCTestCase {

    func testReadmeSampleMerge() {
        assertThat()
            .file(
                name: "A.js",
                """
                import { symbols } from "B.js";

                function f() {
                    const a = symbols.aVar[0];

                    console.log(aFunction(a));
                }
                """
            )
            .file(
                name: "B.js",
                """
                const symbols = {
                    aVar: [
                        0, 1, 2, 3
                    ],

                    aFunction: function(a) {
                        return a;
                    }
                };

                export { symbols };
                """
            )
            .translatesToSwift(
                """
                func f() {
                    let a: Any = symbols.aVar[0]

                    console.log(aFunction(a))
                }
                // End of file A.swift
                var symbols: Any = [aVar: [0, 1, 2, 3], aFunction: { (a: Any) -> Any in
                    return a
                }]
                // End of file B.swift
                """,
                settings: .default.with(\.deduceTypes, true)
            )
    }
}

extension JavaScript2SwiftRewriter_MultiFilesTests {
    private func assertThat() -> MultiFileTestBuilder {
        return MultiFileTestBuilder(test: self)
    }
}
