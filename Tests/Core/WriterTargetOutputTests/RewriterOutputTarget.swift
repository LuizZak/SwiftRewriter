import TestCommons
import XCTest

@testable import WriterTargetOutput

class RewriterOutputTargetTests: XCTestCase {

    func testOutput() {
        let sut = StringRewriterOutput()

        sut.output(line: "line")

        diffTest(
            expected: """
                line

                """
        )
        .diff(sut.buffer)
    }

    func testOutputInline() {
        let sut = StringRewriterOutput()

        sut.outputInline("inline")

        diffTest(
            expected: """
                inline
                """
        )
        .diff(sut.buffer)
    }

    func testOutputInlineWithSpace() {
        let sut = StringRewriterOutput()

        sut.outputInlineWithSpace("inline", style: .plain)
        sut.outputInline("space", style: .plain)

        diffTest(
            expected: """
                inline space
                """
        )
        .diff(sut.buffer)
    }

    func testIndented() {
        let sut = StringRewriterOutput()

        XCTAssertEqual(sut.indentDepth, 0)
        sut.indented {
            XCTAssertEqual(sut.indentDepth, 1)
        }
        XCTAssertEqual(sut.indentDepth, 0)
    }
}
