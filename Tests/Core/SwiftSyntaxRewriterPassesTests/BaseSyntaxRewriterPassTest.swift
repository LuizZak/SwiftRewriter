import Foundation
import SwiftSyntax
import SwiftParser
import SwiftSyntaxSupport
import TestCommons
import XCTest

class BaseSyntaxRewriterPassTest: XCTestCase {
    var sut: SwiftSyntaxRewriterPass!

    func assertRewrite(
        input: String,
        expected: String,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        do {
            let transformed = sut.rewrite(try createSyntax(input))

            diffTest(expected: expected, highlightLineInEditor: false, file: file, line: line)
                .diff(transformed.description, file: file, line: line)

        }
        catch {
            XCTFail(
                "Error creating test file: \(error)",
                file: file,
                line: line
            )
        }
    }

    func createSyntax(_ content: String) throws -> SourceFileSyntax {
        Parser.parse(source: content)
    }
}
