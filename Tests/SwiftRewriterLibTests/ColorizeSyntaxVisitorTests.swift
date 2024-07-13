import XCTest
import SwiftSyntax
import SwiftParser
import Console

@testable import SwiftRewriterLib

class ColorizeSyntaxVisitorTests: XCTestCase {
    func testColorizeKeywords() throws {
        let (sut, result) = try colorizeTest("""
            import Module
            """)
        let expected = makeColorizedString("""
            \("import", sut.keywordColor) \("Module", sut.identifierColor)
            """)

        assertColorized(result, expected)
    }

    func testColorizeNumericLiterals() throws {
        let (sut, result) = try colorizeTest("""
            let literal = 123.0
            """)
        let expected = makeColorizedString("""
            \("let", sut.keywordColor) \("literal", sut.identifierColor) = \("123.0", sut.numberLiteralColor)
            """)

        assertColorized(result, expected)
    }

    func testColorizeStringLiterals() throws {
        let (sut, result) = try colorizeTest("""
            let literal = "abc"
            """)
        let expected = makeColorizedString("""
            \("let", sut.keywordColor) \("literal", sut.identifierColor) = \("\"abc\"", sut.stringLiteralColor)
            """)

        assertColorized(result, expected)
    }

    func testColorizeBoolLiterals() throws {
        let (sut, result) = try colorizeTest("""
            let literal = true
            """)
        let expected = makeColorizedString("""
            \("let", sut.keywordColor) \("literal", sut.identifierColor) = \("true", sut.keywordColor)
            """)

        assertColorized(result, expected)
    }

    func testColorizeFile() throws {
        let (sut, result) = try colorizeTest("""
            import Module

            class AClass: BaseClass {
                let field: Int

                init(field: Int) {
                    self.field = field
                }
            }
            """)
        let expected = makeColorizedString("""
            \("import", sut.keywordColor) \("Module", sut.identifierColor)

            \("class", sut.keywordColor) \("AClass", sut.identifierColor): \("BaseClass", sut.typeNameColor) {
                \("let", sut.keywordColor) \("field", sut.identifierColor): \("Int", sut.typeNameColor)

                \("init", sut.keywordColor)(\("field", sut.identifierColor): \("Int", sut.typeNameColor)) {
                    \("self", sut.keywordColor).\("field", sut.identifierColor) = \("field", sut.identifierColor)
                }
            }
            """)

        assertColorized(result, expected)
    }

    func testColorizeComments() throws {
        let (sut, result) = try colorizeTest("""
            /*
            A Comment
            */
            let a: Int
            """)
        let expected = makeColorizedString("""
            \("""
            /*
            A Comment
            */
            """, sut.commentColor)
            \("let", sut.keywordColor) \("a", sut.identifierColor): \("Int", sut.typeNameColor)
            """)

        assertColorized(result, expected)
    }

    func testColorizeCommentsLeadingToString() throws {
        let (sut, result) = try colorizeTest("""
            /*
            A Comment
            */
            "abc"
            """)
        let expected = makeColorizedString("""
            \("""
            /*
            A Comment
            */
            """, sut.commentColor)
            \("\"abc\"", sut.stringLiteralColor)
            """)

        assertColorized(result, expected)
    }

    // MARK: - Test internals

    private func assertColorized(_ result: ResultType, _ expected: ResultType, line: UInt = #line) {
        XCTAssertEqual(
            toString(expected, colorized: false),
            toString(result, colorized: false), """

            Expected:

            \(toString(expected, colorized: true))

            Found:

            \(toString(result, colorized: true))

            """,
            line: line
        )
    }

    private func colorizeTest(_ input: String) throws -> (ColorizeSyntaxVisitor, ResultType) {
        let syntax = Parser.parse(source: input)
        let printTarget = PrintTarget()
        let sut = ColorizeSyntaxVisitor(printFunction: printTarget.printFunction)

        sut.walk(syntax)

        return (sut, printTarget.result)
    }

    private func makeColorizedString(_ string: ConsoleColorInterpolatedString) -> ResultType {
        return string.result
    }

    private func toString(_ result: ResultType, colorized: Bool = true) -> String {
        return result.map {
            guard let color = $0.color else { return $0.text }

            if colorized {
                return $0.text.terminalColorize(color)
            } else {
                return #"\("\#($0.text)", .\#(color))"#
            }
        }.joined()
    }
}

private typealias ResultType = [(text: String, color: ConsoleColor?)]

private class PrintTarget {
    var result: ResultType = []

    func printFunction(_ string: String, color: ConsoleColor?) {
        result.append((string, color))
    }
}

private struct ConsoleColorInterpolatedString: ExpressibleByStringInterpolation {
    var result: [(text: String, color: ConsoleColor?)]

    init(stringLiteral value: String) {
        result = [(value, nil)]
    }

    init(stringInterpolation: StringInterpolation) {
        result = stringInterpolation.output
    }

    func toString(colorized: Bool) -> String {
        return result.map {
            if colorized, let color = $0.color {
                return $0.text.terminalColorize(color)
            } else {
                return $0.text
            }
        }.joined()
    }

    struct StringInterpolation: StringInterpolationProtocol {
        private var _currentColor: ConsoleColor? = nil

        var output: [(String, ConsoleColor?)] = []

        init(literalCapacity: Int, interpolationCount: Int) {
            output.reserveCapacity(literalCapacity)
        }

        mutating func appendInterpolation(setColor: ConsoleColor?) {
            _currentColor = setColor
        }

        mutating func appendLiteral(_ literal: String) {
            _append(literal, _currentColor)
        }

        mutating func appendInterpolation<T>(_ literal: T) {
            _append("\(literal)", _currentColor)
        }

        mutating func appendInterpolation<T>(_ literal: T, _ color: ConsoleColor) {
            _append("\(literal)", color)
        }

        private mutating func _append(_ text: String, _ color: ConsoleColor?) {
            output.append((text, color))
        }
    }
}

