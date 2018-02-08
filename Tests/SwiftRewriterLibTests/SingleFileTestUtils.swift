import XCTest
import SwiftRewriterLib
import ObjcParser

class TestSingleInputProvider: InputSourcesProvider, InputSource {
    var code: String
    
    init(code: String) {
        self.code = code
    }
    
    func sources() -> [InputSource] {
        return [self]
    }
    
    func sourceName() -> String {
        return "\(type(of: self)).m"
    }
    
    func loadSource() throws -> CodeSource {
        return StringCodeSource(source: code)
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

public extension XCTestCase {
    
    func assertObjcParse(objc: String, swift expectedSwift: String, file: String = #file, line: Int = #line) throws {
        let output = TestSingleFileWriterOutput()
        let input = TestSingleInputProvider(code: objc)
        
        let sut = SwiftRewriter(input: input, output: output)
        
        do {
            try sut.rewrite()
            
            if output.buffer != expectedSwift {
                recordFailure(withDescription: """
                    Failed: Expected to translate Objective-C
                    \(formatCodeForDisplay(objc))
                    
                    as
                    
                    \(formatCodeForDisplay(expectedSwift))
                    
                    but translated as
                    
                    \(formatCodeForDisplay(output.buffer))
                    """, inFile: file, atLine: line, expected: false)
            }
            
            if sut.diagnostics.errors.count != 0 {
                recordFailure(withDescription: "Unexpected error(s) parsing objective-c: \(sut.diagnostics.errors.description)", inFile: file, atLine: line, expected: false)
            }
        } catch {
            recordFailure(withDescription: "Unexpected error(s) parsing objective-c: \(error)", inFile: file, atLine: line, expected: false)
        }
    }
    
    private func formatCodeForDisplay(_ str: String) -> String {
        return str
    }
}
