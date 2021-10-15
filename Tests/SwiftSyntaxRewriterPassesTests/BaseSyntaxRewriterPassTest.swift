import Foundation
import XCTest
import SwiftSyntax
import SwiftSyntaxSupport
import TestCommons

class BaseSyntaxRewriterPassTest: XCTestCase {
    var sut: SwiftSyntaxRewriterPass!
    
    func assertRewrite(input: String, expected: String, file: StaticString = #filePath, line: UInt = #line) {
        do {
            let transformed = sut.rewrite(try createSyntax(input))
            
            diffTest(expected: expected, highlightLineInEditor: false, file: file, line: line)
                .diff(transformed.description, file: file, line: line)
            
        } catch {
            XCTFail("Error creating test file: \(error)",
                    file: file,
                    line: line)
        }
    }
    
    func createSyntax(_ content: String) throws -> SourceFileSyntax {
        try SyntaxParser.parse(source: content)
    }
    
    func createTemporaryFile(_ contents: String) throws -> URL {
        let directory = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("___test.swift")
        
        try contents.write(to: directory, atomically: true, encoding: .utf8)
        
        return directory
    }
}
