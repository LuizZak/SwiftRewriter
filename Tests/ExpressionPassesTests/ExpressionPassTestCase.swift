import XCTest
import Antlr4
import ObjcParser
import ObjcParserAntlr
import SwiftRewriterLib
import SwiftAST

class ExpressionPassTestCase: XCTestCase {
    var sut: SyntaxNodeRewriterPass!
    
    func assertTransformParsed(expression original: String, into expected: String, file: String = #file, line: Int = #line) {
        let result = parse(original).accept(sut)
        
        if expected != result.description {
            recordFailure(withDescription: "Failed to convert: Expected to convert expression\n\n\(expected)\n\nbut received\n\n\(result.description)", inFile: file, atLine: line, expected: false)
        }
    }
    
    func assertTransformParsed(expression original: String, into expected: Expression, file: String = #file, line: Int = #line) {
        assertTransform(expression: parse(original), into: expected, file: file, line: line)
    }
    
    func assertTransform(expression original: Expression, into expected: Expression, file: String = #file, line: Int = #line) {
        let result = original.accept(sut)
        
        if expected != result {
            var expString = ""
            var resString = ""
            
            dump(expected, to: &expString)
            dump(result, to: &resString)
            
            recordFailure(withDescription: "Failed to convert: Expected to convert expression into\n\(expString)\nbut received\n\(resString)", inFile: file, atLine: line, expected: false)
        }
    }
    
    func assertTransform(statement: Statement, into expected: Statement, file: String = #file, line: Int = #line) {
        let result = statement.accept(sut)
        
        if expected != result {
            var expString = ""
            var resString = ""
            
            dump(expected, to: &expString)
            dump(result, to: &resString)
            
            recordFailure(withDescription: "Failed to convert: Expected to convert statement into\n\(expString)\nbut received\n\(resString)", inFile: file, atLine: line, expected: false)
        }
    }
    
    func parse(_ exp: String) -> Expression {
        let (stream, parser) = objcParser(for: exp)
        defer {
            _=stream // Keep alive!
        }
        let expression = try! parser.expression()
        
        let reader = SwiftExprASTReader(typeMapper: DefaultTypeMapper(context: TypeConstructionContext(typeSystem: DefaultTypeSystem())))
        return expression.accept(reader)!
    }
    
    func objcParser(for objc: String) -> (CommonTokenStream, ObjectiveCParser) {
        let input = ANTLRInputStream(objc)
        let lxr = ObjectiveCLexer(input)
        let tokens = CommonTokenStream(lxr)
        
        let parser = try! ObjectiveCParser(tokens)
        
        return (tokens, parser)
    }
    
    func makeContext() -> SyntaxNodeRewriterPassContext {
        return SyntaxNodeRewriterPassContext(typeSystem: DefaultTypeSystem())
    }
}
