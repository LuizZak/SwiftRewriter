import XCTest
import ObjcParser
import SwiftRewriterLib
import ExpressionPasses
import IntentionPasses
import GlobalsProviders
import Utils
import WriterTargetOutput
import SwiftSyntaxRewriterPasses

class MultiFileTestBuilder {
    typealias File = (path: String, source: String)
    
    private let builder = SwiftRewriterJobBuilder()
    var expectedFiles: [ExpectedFile] = []
    var files: [File] = []
    let test: XCTestCase
    var errors: String = ""
    
    init(test: XCTestCase) {
        self.test = test
        
        builder.astRewriterPassSources = DefaultExpressionPasses()
        builder.intentionPassesSource = DefaultIntentionPasses()
        builder.globalsProvidersSource = DefaultGlobalsProvidersSource()
        builder.syntaxRewriterPassSource = DefaultSyntaxPassProvider()
    }
    
    func file(name: String, _ contents: String, isPrimary: Bool = true) -> MultiFileTestBuilder {
        builder.inputs.add(filePath: name, source: contents, isPrimary: isPrimary)
        files.append((name, contents))
        return self
    }
    
    func expectSwiftFile(
        name: String, _ contents: String,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> MultiFileTestBuilder {
        
        expectedFiles.append(
            ExpectedFile(path: name, source: contents, _file: file, _line: line)
        )
        return self
    }
    
    func transpile(
        expectsErrors: Bool = false,
        options: SwiftSyntaxOptions = .default,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> CompiledMultiFileTestResults {
        
        builder.swiftSyntaxOptions = options
        
        let job = builder.createJob()
        let output = TestWriterOutput()
        
        let results = job.execute(output: output)
        let errors = results.diagnostics.errors.map(\.description).joined(separator: "\n")
        
        if !expectsErrors && !results.diagnostics.errors.isEmpty {
            XCTFail(
                """
                Unexpected error(s) converting code:
                \(errors)
                """,
                file: file,
                line: line
            )
        }
        
        return CompiledMultiFileTestResults(
            test: test,
            results: output.outputs,
            files: files,
            expectedFiles: expectedFiles,
            errors: errors
        )
    }
    
    /// Assertion execution point
    @discardableResult
    func translatesToSwift(
        _ expectedSwift: String,
        expectsErrors: Bool = false,
        options: SwiftSyntaxOptions = .default,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> MultiFileTestBuilder {
        
        builder.swiftSyntaxOptions = options
        
        let job = builder.createJob()
        let output = TestWriterOutput()
        
        let results = job.execute(output: output)
        
        if !expectsErrors && !results.diagnostics.errors.isEmpty {
            let errors = results.diagnostics.errors.map(\.description).joined(separator: "\n")
            
            XCTFail(
                """
                Unexpected error(s) converting code:
                \(errors)
                """,
                file: file,
                line: line
            )
        } else {
            // Compute output
            let buffer = output.outputs
                .sorted { $0.path < $1.path }
                .map(\.buffer)
                .joined(separator: "\n")
            
            if buffer != expectedSwift {
                XCTFail(
                    """
                    Failed: Expected to translate Objective-C inputs as:
                    
                    \(expectedSwift)
                    but translated as:
                    
                    \(buffer)
                    
                    Diff:
                    
                    \(buffer.makeDifferenceMarkString(against: expectedSwift))
                    """,
                    file: file,
                    line: line
                )
            }
            
            var errorsOutput = ""
            results.diagnostics.printDiagnostics(to: &errorsOutput)
            errors = errorsOutput.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        return self
    }
    
    func assertErrorStreamIs(_ expected: String, file: StaticString = #filePath, line: UInt = #line) {
        if errors != expected {
            XCTFail(
                """
                Mismatched errors stream. Expected \(expected) but found \(errors)
                """,
                file: file,
                line: line
            )
        }
    }
}

class CompiledMultiFileTestResults {
    typealias File = (path: String, source: String)
    
    var test: XCTestCase
    var results: [TestFileOutput]
    var files: [File]
    var expectedFiles: [ExpectedFile]
    var errors: String
    
    init(
        test: XCTestCase,
        results: [TestFileOutput],
        files: [File],
        expectedFiles: [ExpectedFile],
        errors: String
    ) {
        
        self.test = test
        self.results = results
        self.files = files
        self.expectedFiles = expectedFiles
        self.errors = errors
        
    }
    
    func assertGeneratedFileCount(
        _ count: Int,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        
        if results.count != count {
            XCTFail(
                """
                Expected to generate \(count) file(s), but generated \(results.count)
                """,
                file: file,
                line: line
            )
        }
    }
    
    /// Asserts expected Swift files recorded with `expectSwiftFile(name:contents:)`
    /// where produced correctly.
    ///
    /// Does not assert if unexpected files where produced during compilation.
    func assertExpectedSwiftFiles(
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        
        assertMatchesWithExpectedFiles(results, file: file, line: line)
    }
    
    private func assertMatchesWithExpectedFiles(
        _ files: [TestFileOutput],
        file: StaticString,
        line: UInt
    ) {
        
        let expectedNotMatched = expectedFiles.filter { expected in
            !files.contains { $0.path == expected.path }
        }
        
        let matches = files.sorted { $0.path < $1.path }.compactMap { file -> ResultMatch? in
            guard let expected = expectedFiles.first(where: { expected in file.path == expected.path }) else {
                return nil
            }
            
            return ResultMatch(result: file, expectedFile: expected)
        }
        
        for match in matches where match.result.buffer != match.expectedFile.source {
            let expectedSwift = match.expectedFile.source
            let actualSwift = match.result.buffer
            
            XCTFail(
                """
                Failed: Expected to produce Swift file \(match.result) inputs as:
                
                --
                \(expectedSwift)
                --
                
                but translated as:
                
                --
                \(actualSwift)
                --
                
                Diff:
                
                \(actualSwift.makeDifferenceMarkString(against: expectedSwift))
                """,
                file: match.expectedFile._file,
                line: match.expectedFile._line
            )
            
            break
        }
        
        for nonMatched in expectedNotMatched {
            XCTFail(
                """
                Failed: Expected to produce Swift file \(nonMatched.path), \
                but no such file was created.
                """,
                file: file,
                line: line
            )
        }
    }
    
    func assertErrorStreamIs(_ expected: String, file: StaticString = #filePath, line: UInt = #line) {
        if errors != expected {
            XCTFail(
                """
                Mismatched errors stream. Expected \(expected) but found \(errors)
                """,
                file: file,
                line: line
            )
        }
    }
    
    private struct ResultMatch {
        var result: TestFileOutput
        var expectedFile: ExpectedFile
    }
}

struct ExpectedFile {
    var path: String
    var source: String
    var _file: StaticString
    var _line: UInt
}

class TestMultiInputProvider: InputSourcesProvider {
    var inputs: [InputSource]
    
    init(inputs: [InputSource]) {
        self.inputs = inputs
    }
    
    func sources() -> [InputSource] {
        return inputs
    }
}

class TestFileOutput: FileOutput {
    var path: String
    var buffer: String = ""
    
    init(path: String) {
        self.path = path
    }
    
    func close() {
        buffer += "\n// End of file \(path)"
    }
    
    func outputTarget() -> RewriterOutputTarget {
        let target = StringRewriterOutput()
        
        target.onChangeBuffer = { value in
            self.buffer = value
        }
        
        return target
    }
}

class TestWriterOutput: WriterOutput {
    let mutex = Mutex()
    var outputs: [TestFileOutput] = []
    
    func createFile(path: String) -> FileOutput {
        let output = TestFileOutput(path: path)
        mutex.locking {
            outputs.append(output)
        }
        return output
    }
}
