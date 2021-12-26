import ExpressionPasses
import GlobalsProviders
import GrammarModelBase
import IntentionPasses
import JsParser
import SwiftSyntaxRewriterPasses
import TestCommons
import Utils
import WriterTargetOutput
import XCTest

@testable import JavaScriptFrontend

class SingleFileTestBuilder {
    var test: XCTestCase
    var js: String
    var options: SwiftSyntaxOptions
    var settings: JavaScript2SwiftRewriter.Settings
    var diagnosticsStream: String = ""

    init(
        test: XCTestCase,
        js: String,
        options: SwiftSyntaxOptions,
        settings: JavaScript2SwiftRewriter.Settings
    ) {

        self.test = test
        self.js = js
        self.options = options
        self.settings = settings
    }

    func assertJsParse(
        swift expectedSwift: String,
        fileName: String = "test.m",
        expectsErrors: Bool = false,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {

        let output = TestSingleFileWriterOutput()
        let input = TestSingleInputProvider(
            fileName: fileName,
            code: js,
            isPrimary: true
        )

        let sut = JavaScript2SwiftRewriter(input: input, output: output)
        sut.writerOptions = options
        sut.settings = settings
        sut.astRewriterPassSources = DefaultExpressionPasses()
        sut.intentionPassesSource = DefaultIntentionPasses()
        sut.globalsProvidersSource = DefaultGlobalsProvidersSource()
        sut.syntaxRewriterPassSource = DefaultSyntaxPassProvider()

        do {
            try sut.rewrite()

            if output.buffer != expectedSwift {
                XCTFail(
                    """
                    Failed: Expected to translate JavaScript
                    \(formatCodeForDisplay(js))

                    as
                    --
                    \(formatCodeForDisplay(expectedSwift))
                    --

                    but translated as

                    --
                    \(formatCodeForDisplay(output.buffer))
                    --

                    Diff:

                    --
                    \(formatCodeForDisplay(output.buffer)
                        .makeDifferenceMarkString(against:
                            formatCodeForDisplay(expectedSwift)))
                    --
                    """,
                    file: file,
                    line: line
                )
            }

            if !expectsErrors && sut.diagnostics.errors.count != 0 {
                XCTFail(
                    "Unexpected error(s) converting JavaScript: \(sut.diagnostics.errors.description)",
                    file: file,
                    line: line
                )
            }

            diagnosticsStream = ""
            sut.diagnostics.printDiagnostics(to: &diagnosticsStream)
            diagnosticsStream = diagnosticsStream.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        catch {
            XCTFail(
                "Unexpected error(s) parsing JavaScript: \(error)",
                file: file,
                line: line
            )
        }
    }

    func assertDiagnostics(_ expected: String, file: StaticString = #filePath, line: UInt = #line) {
        if diagnosticsStream != expected {
            XCTFail(
                "Mismatched output stream. Expected \(expected) but found \(diagnosticsStream)",
                file: file,
                line: line
            )
        }
    }

    private func formatCodeForDisplay(_ str: String) -> String {
        return str
    }
}

class TestSingleInputProvider: InputSourcesProvider, InputSource {
    var fileName: String
    var code: String
    var isPrimary: Bool

    convenience init(code: String, isPrimary: Bool) {
        self.init(fileName: "\(type(of: self)).m", code: code, isPrimary: isPrimary)
    }

    init(fileName: String, code: String, isPrimary: Bool) {
        self.fileName = fileName
        self.code = code
        self.isPrimary = isPrimary
    }

    func sources() -> [InputSource] {
        return [self]
    }

    func sourcePath() -> String {
        return fileName
    }

    func loadSource() throws -> CodeSource {
        return StringCodeSource(source: code, fileName: sourcePath())
    }
}

class TestSingleFileWriterOutput: WriterOutput, FileOutput {
    var buffer: String = ""

    func createFile(path: String) -> FileOutput {
        return self
    }

    func close() {

    }

    func outputTarget() -> RewriterOutputTarget {
        let target = StringRewriterOutput()

        target.onChangeBuffer = { value in
            self.buffer = value
        }

        return target
    }
}

extension XCTestCase {

    @discardableResult
    func assertRewrite(
        js: String,
        swift expectedSwift: String,
        inputFileName: String = "test.m",
        options: SwiftSyntaxOptions = JavaScript2SwiftRewriter.defaultWriterOptions,
        rewriterSettings: JavaScript2SwiftRewriter.Settings = .default,
        expectsErrors: Bool = false,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> SingleFileTestBuilder {

        let test = SingleFileTestBuilder(
            test: self,
            js: js,
            options: options,
            settings: rewriterSettings
        )

        test.assertJsParse(
            swift: expectedSwift,
            fileName: inputFileName,
            expectsErrors: expectsErrors,
            file: file,
            line: line
        )

        return test
    }
}
