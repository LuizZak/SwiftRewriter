import XCTest
import ObjcParser
import SwiftRewriterLib

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
    func translatesToSwift(_ expectedSwift: String, expectsErrors: Bool = false, file: String = #file, line: Int = #line) -> MultiFileTestBuilder {
        let inputs = files.map(TestInputSource.init)
        
        let output = TestWriterOutput()
        let input = TestMultiInputProvider(inputs: inputs)
        
        let sut = SwiftRewriter(input: input, output: output)
        
        sut.expressionPasses.append(AllocInitExpressionPass())
        sut.expressionPasses.append(CoreGraphicsExpressionPass())
        sut.expressionPasses.append(FoundationExpressionPass())
        sut.expressionPasses.append(UIKitExpressionPass())
        
        do {
            try sut.rewrite()
            
            if output.buffer != expectedSwift {
                test.recordFailure(withDescription: """
                    Failed: Expected to translate Objective-C inputs as:
                    \(expectedSwift)
                    but translated as:
                    \(output.buffer)
                    """, inFile: file, atLine: line, expected: false)
            }
            
            if !expectsErrors && sut.diagnostics.errors.count != 0 {
                test.recordFailure(withDescription: "Unexpected error(s) parsing objective-c: \(sut.diagnostics.errors.description)", inFile: file, atLine: line, expected: false)
            }
            
            var errorsOutput = ""
            sut.diagnostics.printDiagnostics(to: &errorsOutput)
            errors = errorsOutput.trimmingCharacters(in: .whitespacesAndNewlines)
        } catch {
            test.recordFailure(withDescription: "Unexpected error(s) parsing objective-c: \(error)", inFile: file, atLine: line, expected: false)
        }
        
        return self
    }
    
    func assertErrorStreamIs(_ expected: String, file: String = #file, line: Int = #line) {
        if errors != expected {
            test.recordFailure(withDescription: "Mismatched errors stream. Expected \(expected) but found \(errors)", inFile: file, atLine: line, expected: false)
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
    var writerOutput: TestWriterOutput
    
    init(path: String, writerOutput: TestWriterOutput) {
        self.path = path
        self.writerOutput = writerOutput
    }
    
    func close() {
        buffer += "\n// End of file \(path)"
        
        writerOutput.buffer += buffer
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
    var buffer: String = ""
    
    func createFile(path: String) -> FileOutput {
        return TestFileOutput(path: path, writerOutput: self)
    }
}
