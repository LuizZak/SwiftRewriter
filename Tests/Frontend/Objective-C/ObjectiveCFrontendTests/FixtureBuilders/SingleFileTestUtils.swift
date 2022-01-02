import ExpressionPasses
import GlobalsProviders
import GrammarModelBase
import IntentionPasses
import ObjcParser
import SwiftSyntaxRewriterPasses
import TestCommons
import Utils
import WriterTargetOutput
import XCTest

@testable import ObjectiveCFrontend

class SingleFileTestBuilder {
    var test: XCTestCase
    var objc: String
    var options: SwiftSyntaxOptions
    var settings: ObjectiveC2SwiftRewriter.Settings
    var diagnosticsStream: String = ""

    init(
        test: XCTestCase,
        objc: String,
        options: SwiftSyntaxOptions,
        settings: ObjectiveC2SwiftRewriter.Settings
    ) {

        self.test = test
        self.objc = objc
        self.options = options
        self.settings = settings
    }

    func assertObjcParse(
        swift expectedSwift: String,
        fileName: String = "test.m",
        expectsErrors: Bool = false,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {

        let output = TestWriterOutput()
        let input = TestSingleInputProvider(
            fileName: fileName,
            code: objc,
            isPrimary: true
        )

        let sut = ObjectiveC2SwiftRewriter(input: input, output: output)
        sut.writerOptions = options
        sut.settings = settings
        sut.astRewriterPassSources = DefaultExpressionPasses()
        sut.intentionPassesSource = DefaultIntentionPasses()
        sut.globalsProvidersSource = DefaultGlobalsProvidersSource()
        sut.syntaxRewriterPassSource = DefaultSyntaxPassProvider()

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
                XCTFail(
                    """
                    Failed: Expected to translate Objective-C
                    \(formatCodeForDisplay(objc))

                    as

                    \(formatCodeForDisplay(expectedSwift))

                    but translated as

                    \(formatCodeForDisplay(outputBuffer))

                    Diff:

                    \(formatCodeForDisplay(outputBuffer)
                        .makeDifferenceMarkString(against:
                            formatCodeForDisplay(expectedSwift)))
                    """,
                    file: file,
                    line: line
                )
            }

            if !expectsErrors && sut.diagnostics.errors.count != 0 {
                XCTFail(
                    "Unexpected error(s) converting objective-c: \(sut.diagnostics.errors.description)",
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
                "Unexpected error(s) parsing objective-c: \(error)",
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
        objc: String,
        swift expectedSwift: String,
        inputFileName: String = "test.m",
        options: SwiftSyntaxOptions = .default,
        rewriterSettings: ObjectiveC2SwiftRewriter.Settings = .default,
        expectsErrors: Bool = false,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> SingleFileTestBuilder {

        let test = SingleFileTestBuilder(
            test: self,
            objc: objc,
            options: options,
            settings: rewriterSettings
        )

        test.assertObjcParse(
            swift: expectedSwift,
            fileName: inputFileName,
            expectsErrors: expectsErrors,
            file: file,
            line: line
        )

        return test
    }
}
