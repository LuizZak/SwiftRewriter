import SourcePreprocessors
import TestCommons
import XCTest

@testable import ObjectiveCFrontend

class ObjectiveC2SwiftRewriter_SourcePreprocessor: XCTestCase {
    func testPreprocessorIsInvokedBeforeParsing() throws {
        let input = TestSingleInputProvider(
            code: """
                an invalid parsing file
                """,
            isPrimary: true
        )
        let output = TestWriterOutput()
        let preprocessor =
            TestSourcePreprocessor(
                replaceWith: """
                    @interface MyClass
                    @end
                    """
            )
        let rewriter = ObjectiveC2SwiftRewriter(input: input, output: output)
        rewriter.preprocessors.append(preprocessor)

        try rewriter.rewrite()

        XCTAssertEqual(
            try output.outputs[try: 0].getBuffer(withFooter: false),
            """
            class MyClass {
            }
            """
        )
    }

    private class TestSourcePreprocessor: SourcePreprocessor {
        var replaceWith: String

        init(replaceWith: String) {
            self.replaceWith = replaceWith
        }

        func preprocess(source: String, context: PreprocessingContext) -> String {
            return replaceWith
        }
    }
}
