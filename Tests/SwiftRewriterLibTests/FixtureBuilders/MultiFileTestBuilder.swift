import XCTest
import ObjcParser
import SwiftRewriterLib
import ExpressionPasses
import IntentionPasses
import Utils

class MultiFileTestBuilder {
    var test: XCTestCase
    var files: [(name: String, souce: String)] = []
    var errors: String = ""
    
    init(test: XCTestCase) {
        self.test = test
    }
    
    func file(name: String, _ contents: String) -> MultiFileTestBuilder {
        files.append((name, contents))
        return self
    }
    
    /// Assertion execution point
    @discardableResult
    func translatesToSwift(_ expectedSwift: String, expectsErrors: Bool = false, options: ASTWriterOptions = .default, file: String = #file, line: Int = #line) -> MultiFileTestBuilder {
        let inputs = files.map(TestInputSource.init)
        
        let output = TestWriterOutput()
        let input = TestMultiInputProvider(inputs: inputs)
        
        let sut = SwiftRewriter(input: input, output: output)
        sut.writerOptions = options
        sut.syntaxNodeRewriterSources = DefaultExpressionPasses()
        sut.intentionPassesSource = DefaultIntentionPasses()
        
        do {
            try sut.rewrite()
            
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
            
            if !expectsErrors && sut.diagnostics.errors.count != 0 {
                test.recordFailure(withDescription: "Unexpected error(s) parsing objective-c: \(sut.diagnostics.errors.description)",
                                   inFile: file, atLine: line, expected: true)
            }
            
            var errorsOutput = ""
            sut.diagnostics.printDiagnostics(to: &errorsOutput)
            errors = errorsOutput.trimmingCharacters(in: .whitespacesAndNewlines)
        } catch {
            test.recordFailure(withDescription: "Unexpected error(s) parsing objective-c: \(error)",
                               inFile: file, atLine: line, expected: true)
        }
        
        return self
    }
    
    func assertErrorStreamIs(_ expected: String, file: String = #file, line: Int = #line) {
        if errors != expected {
            test.recordFailure(withDescription: "Mismatched errors stream. Expected \(expected) but found \(errors)",
                               inFile: file, atLine: line, expected: true)
        }
    }
}

struct TestInputSource: InputSource {
    var name: String
    var source: String
    
    func sourceName() -> String {
        return name
    }
    
    func loadSource() throws -> CodeSource {
        return StringCodeSource(source: source)
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
