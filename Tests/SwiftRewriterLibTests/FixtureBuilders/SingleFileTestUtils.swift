import XCTest
import SwiftRewriterLib
import ObjcParser
import ExpressionPasses
import IntentionPasses
import GlobalsProviders
import WriterTargetOutput

class SingleFileTestBuilder {
    var test: XCTestCase
    var objc: String
    var options: ASTWriterOptions
    var settings: SwiftRewriter.Settings
    var diagnosticsStream: String = ""
    
    init(test: XCTestCase,
         objc: String,
         options: ASTWriterOptions,
         settings: SwiftRewriter.Settings) {
        
        self.test = test
        self.objc = objc
        self.options = options
        self.settings = settings
    }
    
    func assertObjcParse(swift expectedSwift: String,
                         expectsErrors: Bool = false,
                         file: String = #file,
                         line: Int = #line) {
        
        let output = TestSingleFileWriterOutput()
        let input = TestSingleInputProvider(code: objc)
        
        let sut = SwiftRewriter(input: input, output: output)
        sut.writerOptions = options
        sut.settings = settings
        sut.astRewriterPassSources = DefaultExpressionPasses()
        sut.intentionPassesSource = DefaultIntentionPasses()
        sut.globalsProvidersSource = DefaultGlobalsProvidersSource()
        
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
                    """, inFile: file, atLine: line, expected: true)
            }
            
            if !expectsErrors && sut.diagnostics.errors.count != 0 {
                test.recordFailure(withDescription: "Unexpected error(s) converting objective-c: \(sut.diagnostics.errors.description)",
                                   inFile: file, atLine: line, expected: true)
            }
            
            diagnosticsStream = ""
            sut.diagnostics.printDiagnostics(to: &diagnosticsStream)
            diagnosticsStream = diagnosticsStream.trimmingCharacters(in: .whitespacesAndNewlines)
        } catch {
            test.recordFailure(withDescription: "Unexpected error(s) parsing objective-c: \(error)",
                               inFile: file, atLine: line, expected: false)
        }
    }
    
    func assertDiagnostics(_ expected: String, file: String = #file, line: Int = #line) {
        if diagnosticsStream != expected {
            test.recordFailure(withDescription: "Mismatched output stream. Expected \(expected) but found \(diagnosticsStream)",
                               inFile: file, atLine: line, expected: true)
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
        return StringCodeSource(source: code, fileName: sourceName())
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
                         rewriterSettings: SwiftRewriter.Settings = .default,
                         expectsErrors: Bool = false,
                         file: String = #file,
                         line: Int = #line) -> SingleFileTestBuilder  {
        
        let test = SingleFileTestBuilder(test: self,
                                         objc: objc,
                                         options: options,
                                         settings: rewriterSettings)
        
        test.assertObjcParse(swift: expectedSwift,
                             expectsErrors: expectsErrors,
                             file: file, line: line)
        
        return test
    }
}
