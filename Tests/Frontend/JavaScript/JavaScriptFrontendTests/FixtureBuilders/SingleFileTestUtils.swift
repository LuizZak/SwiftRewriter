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

        let output = TestWriterOutput()
        let input = TestSingleInputProvider(
            fileName: fileName,
            code: js,
            isPrimary: true
        )
        
        var jobBuilder = JavaScript2SwiftRewriterJobBuilder()
        jobBuilder.swiftSyntaxOptions = options
        jobBuilder.settings = settings
        jobBuilder.inputs.addInputs(from: input)

        let job = jobBuilder.createJob()

        let sut = job.makeSwiftRewriter(output: output)

        do {
            try sut.rewrite()

            let outputBuffer: String

            // Compute output
            if output.outputs.count == 1 {
                outputBuffer = output.outputs[0].getBuffer(withFooter: false)
            } else {
                outputBuffer = output.outputs
                    .sorted { $0.path < $1.path }
                    .map { $0.getBuffer(withFooter: true) }
                    .joined(separator: "\n")
            }

            if outputBuffer != expectedSwift {
                let formattedOutput = formatCodeForDisplay(outputBuffer)
                let formattedExpected = formatCodeForDisplay(expectedSwift)

                let diff = formattedOutput.makeDifferenceMarkString(
                    against: formattedExpected
                )

                XCTFail(
                    """
                    Failed: Expected to translate JavaScript
                    \(formatCodeForDisplay(js))

                    as
                    --
                    \(formattedExpected)
                    --

                    but translated as

                    --
                    \(formattedOutput)
                    --

                    Diff:

                    --
                    \(diff)
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
