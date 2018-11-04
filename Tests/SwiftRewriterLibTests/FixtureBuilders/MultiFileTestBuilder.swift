import XCTest
import ObjcParser
import SwiftRewriterLib
import ExpressionPasses
import IntentionPasses
import GlobalsProviders
import Utils

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
    }
    
    func file(name: String, _ contents: String) -> MultiFileTestBuilder {
        builder.inputs.add(filePath: name, source: contents)
        files.append((name, contents))
        return self
    }
    
    func expectSwiftFile(name: String, _ contents: String,
                         file: String = #file, line: Int = #line) -> MultiFileTestBuilder {
        
        expectedFiles.append(
            ExpectedFile(path: name, source: contents, _file: file, _line: line)
        )
        return self
    }
    
    func transpile(expectsErrors: Bool = false,
                   options: ASTWriterOptions = .default,
                   file: String = #file,
                   line: Int = #line) -> CompiledMultiFileTestResults {
        
        builder.astWriterOptions = options
        
        let job = builder.createJob()
        let output = TestWriterOutput()
        
        let results = job.execute(output: output)
        let errors = results.diagnostics.errors.map { $0.description }.joined(separator: "\n")
        
        if !expectsErrors && !results.diagnostics.errors.isEmpty {
            test.recordFailure(
                withDescription: """
                Unexpected error(s) converting code:
                \(errors)
                """,
                inFile: file, atLine: line, expected: true)
        }
        
        return CompiledMultiFileTestResults(
            test: test,
            results: output.outputs,
            files: files,
            expectedFiles: expectedFiles,
            errors: errors)
    }
    
    /// Assertion execution point
    @discardableResult
    func translatesToSwift(_ expectedSwift: String,
                           expectsErrors: Bool = false,
                           options: ASTWriterOptions = .default,
                           file: String = #file,
                           line: Int = #line) -> MultiFileTestBuilder {
        
        builder.astWriterOptions = options
        
        let job = builder.createJob()
        let output = TestWriterOutput()
        
        let results = job.execute(output: output)
        
        if !expectsErrors && !results.diagnostics.errors.isEmpty {
            let errors = results.diagnostics.errors.map { $0.description }.joined(separator: "\n")
            
            test.recordFailure(
                withDescription: """
                Unexpected error(s) converting code:
                \(errors)
                """,
                inFile: file, atLine: line, expected: true)
        } else {
            // Compute output
            let buffer = output.outputs
                .sorted { $0.path < $1.path }
                .map { $0.buffer }
                .joined(separator: "\n")
            
            if buffer != expectedSwift {
                test.recordFailure(withDescription: """
                    Failed: Expected to translate Objective-C inputs as:
                    
                    \(expectedSwift)
                    but translated as:
                    
                    \(buffer)
                    
                    Diff:
                    
                    \(expectedSwift.makeDifferenceMarkString(against: buffer))
                    """, inFile: file, atLine: line, expected: true)
            }
            
            var errorsOutput = ""
            results.diagnostics.printDiagnostics(to: &errorsOutput)
            errors = errorsOutput.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        return self
    }
    
    func assertErrorStreamIs(_ expected: String, file: String = #file, line: Int = #line) {
        if errors != expected {
            test.recordFailure(
                withDescription: """
                Mismatched errors stream. Expected \(expected) but found \(errors)
                """,
                inFile: file, atLine: line, expected: true)
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
    
    init(test: XCTestCase,
         results: [TestFileOutput],
         files: [File],
         expectedFiles: [ExpectedFile],
         errors: String) {
        
        self.test = test
        self.results = results
        self.files = files
        self.expectedFiles = expectedFiles
        self.errors = errors
        
    }
    
    func assertGeneratedFileCount(_ count: Int,
                                  file: String = #file,
                                  line: Int = #line) {
        if results.count != count {
            test.recordFailure(
                withDescription: """
                Expected to generate \(count) file(s), but generated \(results.count)
                """,
                inFile: file,
                atLine: line,
                expected: true)
        }
    }
    
    /// Asserts expected Swift files recorded with `expectSwiftFile(name:contents:)`
    /// where produced correctly.
    ///
    /// Does not assert if unexpected files where produced during compilation.
    func assertExpectedSwiftFiles(file: String = #file,
                                  line: Int = #line) {
        
        assertMatchesWithExpectedFiles(results, file: file, line: line)
    }
    
    private func assertMatchesWithExpectedFiles(_ files: [TestFileOutput],
                                                file: String,
                                                line: Int) {
        
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
            
            test.recordFailure(withDescription: """
                Failed: Expected to produce Swift file \(match.result) inputs as:
                
                --
                \(expectedSwift)
                --
                
                but translated as:
                
                --
                \(actualSwift)
                --
                
                Diff:
                
                \(expectedSwift.makeDifferenceMarkString(against: actualSwift))
                """, inFile: match.expectedFile._file, atLine: match.expectedFile._line, expected: true)
            
            break
        }
        
        for nonMatched in expectedNotMatched {
    
            test.recordFailure(withDescription: """
                Failed: Expected to produce Swift file \(nonMatched.path), \
                but no such file was created.
                """, inFile: file, atLine: line, expected: true)
        }
    }
    
    func assertErrorStreamIs(_ expected: String, file: String = #file, line: Int = #line) {
        if errors != expected {
            test.recordFailure(withDescription: """
                Mismatched errors stream. Expected \(expected) but found \(errors)
                """,
                inFile: file, atLine: line, expected: true)
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
    var _file: String
    var _line: Int
}

struct TestInputSource: InputSource {
    var name: String
    var source: String
    
    func sourceName() -> String {
        return name
    }
    
    func loadSource() throws -> CodeSource {
        return StringCodeSource(source: source, fileName: name)
    }
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
    var outputs: [TestFileOutput] = []
    
    func createFile(path: String) -> FileOutput {
        let output = TestFileOutput(path: path)
        synchronized(self) {
            outputs.append(output)
        }
        return output
    }
}
