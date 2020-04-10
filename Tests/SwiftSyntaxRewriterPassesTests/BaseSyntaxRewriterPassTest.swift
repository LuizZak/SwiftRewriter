import Foundation
import XCTest
import SwiftSyntax
import SwiftSyntaxSupport
import TestCommons

class BaseSyntaxRewriterPassTest: XCTestCase {
    var sut: SwiftSyntaxRewriterPass!
    
    func assertRewrite(input: String, expected: String, file: String = #file, line: Int = #line) {
        do {
            let transformed = sut.rewrite(try createSyntax(input))
            
            diffTest(expected: expected, highlightLineInEditor: false, file: file, line: line)
                .diff(transformed.description, file: file, line: line)
            
        } catch {
            recordFailure(withDescription: "Error creating test file: \(error)",
                          inFile: file,
                          atLine: line,
                          expected: false)
        }
    }
    
    func createSyntax(_ content: String) throws -> SourceFileSyntax {
        let url = try createTemporaryFile(content)
        defer {
            try! FileManager.default.removeItem(at: url)
        }
        
        return try SyntaxParser.parse(url)
    }
    
    func createTemporaryFile(_ contents: String) throws -> URL {
        let directory = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("___test.swift")
        
        try contents.write(to: directory, atomically: true, encoding: .utf8)
        
        return directory
    }
}
