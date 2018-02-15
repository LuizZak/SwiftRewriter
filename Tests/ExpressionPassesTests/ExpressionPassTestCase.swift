import XCTest
import Antlr4
import ObjcParser
import ObjcParserAntlr
import SwiftRewriterLib

class ExpressionPassTestCase: XCTestCase {
    var sut: ExpressionPass!
    
    func assertTransformParsed(original: String, expected: String, file: String = #file, line: Int = #line) {
        let result = sut.applyPass(on: parse(original))
        
        if expected != result.description {
            recordFailure(withDescription: "Failed to convert: Expected to convert expression\n\n\(expected)\n\nbut received\n\n\(result.description)", inFile: file, atLine: line, expected: false)
        }
    }
    
    func assertTransformParsed(original: String, expected: Expression, file: String = #file, line: Int = #line) {
        assertTransform(original: parse(original), expected: expected, file: file, line: line)
    }
    
    func assertTransform(original: Expression, expected: Expression, file: String = #file, line: Int = #line) {
        let result = sut.applyPass(on: original)
        
        if expected != result {
            var expString = ""
            var resString = ""
            
            dump(expected, to: &expString)
            dump(result, to: &resString)
            
            recordFailure(withDescription: "Failed to convert: Expected to convert expression\n\(expString)\nbut received\n\(resString)", inFile: file, atLine: line, expected: false)
        }
    }
    
    func parse(_ exp: String) -> Expression {
        let (stream, parser) = objcParser(for: exp)
        defer {
            _=stream // Keep alive!
        }
        let expression = try! parser.expression()
        
        let reader = SwiftExprASTReader()
        return expression.accept(reader)!
    }
    
    func objcParser(for objc: String) -> (CommonTokenStream, ObjectiveCParser) {
        let input = ANTLRInputStream(objc)
        let lxr = ObjectiveCLexer(input)
        let tokens = CommonTokenStream(lxr)
        
        let parser = try! ObjectiveCParser(tokens)
        
        return (tokens, parser)
    }
}
