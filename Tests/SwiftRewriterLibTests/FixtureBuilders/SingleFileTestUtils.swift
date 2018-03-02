import XCTest
import SwiftRewriterLib
import ObjcParser
import ExpressionPasses
import IntentionPasses

class SingleFileTestBuilder {
    var test: XCTestCase
    var objc: String
    var options: ASTWriterOptions
    var diagnosticsStream: String = ""
    
    init(test: XCTestCase, objc: String, options: ASTWriterOptions) {
        self.test = test
        self.objc = objc
        self.options = options
    }
    
    func assertObjcParse(swift expectedSwift: String, expectsErrors: Bool = false, file: String = #file, line: Int = #line) throws {
        let output = TestSingleFileWriterOutput()
        let input = TestSingleInputProvider(code: objc)
        
        let sut = SwiftRewriter(input: input, output: output)
        
        sut.writerOptions = options
        
        sut.syntaxNodeRewriters.append(ASTSimplifier())
        sut.syntaxNodeRewriters.append(AllocInitExpressionPass())
        sut.syntaxNodeRewriters.append(CoreGraphicsExpressionPass())
        sut.syntaxNodeRewriters.append(FoundationExpressionPass())
        sut.syntaxNodeRewriters.append(UIKitExpressionPass())
        
        sut.intentionPassesSource = DefaultIntentionPasses()
        
        do {
            try sut.rewrite()
            
            if output.buffer != expectedSwift {
                test.recordFailure(withDescription: """
                    Failed: Expected to translate Objective-C
                    \(formatCodeForDisplay(objc))
                    
                    as
                    
                    \(formatCodeForDisplay(expectedSwift))
                    
                    but translated as
                    
                    \(formatCodeForDisplay(output.buffer))
                    
                    Diff:
                    
                    \(formatCodeForDisplay(output.buffer)
                        .makeDifferenceMarkString(against:
                            formatCodeForDisplay(expectedSwift)))
                    """, inFile: file, atLine: line, expected: false)
            }
            
            if !expectsErrors && sut.diagnostics.errors.count != 0 {
                test.recordFailure(withDescription: "Unexpected error(s) converting objective-c: \(sut.diagnostics.errors.description)", inFile: file, atLine: line, expected: false)
            }
            
            diagnosticsStream = ""
            sut.diagnostics.printDiagnostics(to: &diagnosticsStream)
            diagnosticsStream = diagnosticsStream.trimmingCharacters(in: .whitespacesAndNewlines)
        } catch {
            test.recordFailure(withDescription: "Unexpected error(s) parsing objective-c: \(error)", inFile: file, atLine: line, expected: false)
        }
    }
    
    func assertDiagnostics(_ expected: String, file: String = #file, line: Int = #line) {
        if diagnosticsStream != expected {
            test.recordFailure(withDescription: "Mismatched output stream. Expected \(expected) but found \(diagnosticsStream)", inFile: file, atLine: line, expected: false)
        }
    }
    
    private func formatCodeForDisplay(_ str: String) -> String {
        return str
    }
}

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

extension XCTestCase {
    
    @discardableResult
    func assertObjcParse(objc: String, swift expectedSwift: String,
                         options: ASTWriterOptions = .default,
                         expectsErrors: Bool = false, file: String = #file,
                         line: Int = #line) throws -> SingleFileTestBuilder  {
        let test = SingleFileTestBuilder(test: self, objc: objc, options: options)
        try test.assertObjcParse(swift: expectedSwift, expectsErrors: expectsErrors,
                                 file: file, line: line)
        
        return test
    }
}
