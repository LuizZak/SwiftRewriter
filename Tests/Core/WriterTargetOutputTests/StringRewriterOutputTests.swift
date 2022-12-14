import TestCommons
import XCTest
import SwiftSyntax
import SwiftSyntaxParser

@testable import WriterTargetOutput

class StringRewriterOutputTests: XCTestCase {
    func testOutputFile() throws {
        let input = """
        import Lib

        class AClass: BaseClass {
            var field: Int

            init() {
                field = 0
            }
        }
        """
        let fileSyntax = try SyntaxParser.parse(source: input)
        let sut = StringRewriterOutput()

        sut.outputFile(fileSyntax)

        diffTest(expected: input, highlightLineInEditor: false)
            .diff(sut.buffer)
    }

    func testOutputRaw() {
        let sut = StringRewriterOutput()

        sut.outputRaw("rawTest")

        diffTest(
            expected: """
                rawTest
                """
        )
        .diff(sut.buffer)
    }

    func testOutputLine() {
        let sut = StringRewriterOutput()

        sut.output(line: "line", style: .plain)

        diffTest(
            expected: """
                line

                """
        )
        .diff(sut.buffer)
    }

    func testOutputLineIndented() {
        let sut = StringRewriterOutput()
        sut.increaseIndentation()

        sut.output(line: "line", style: .plain)

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
        sut.outputInline(" content")

        diffTest(
            expected: """
                inline content
                """
        )
        .diff(sut.buffer)
    }

    func testIncreaseIndentation() {
        let sut = StringRewriterOutput()

        sut.increaseIndentation()

        XCTAssertEqual(sut.indentDepth, 1)
    }

    func testDecreaseIndentation() {
        let sut = StringRewriterOutput()
        sut.indentDepth = 1

        sut.decreaseIndentation()

        XCTAssertEqual(sut.indentDepth, 0)
    }

    func testDecreaseIndentationStopsAtZero() {
        let sut = StringRewriterOutput()
        sut.indentDepth = 0

        sut.decreaseIndentation()

        XCTAssertEqual(sut.indentDepth, 0)
    }

    func testOnAfterOutputTrimsWhitespaces() {
        let sut = StringRewriterOutput()
        sut.outputInline("text  ")

        sut.onAfterOutput()

        diffTest(
            expected: """
                text
                """
        )
        .diff(sut.buffer)
    }
}
