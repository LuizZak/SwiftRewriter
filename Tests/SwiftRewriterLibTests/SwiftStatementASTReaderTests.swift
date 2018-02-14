import XCTest
import Antlr4
import ObjcParser
import ObjcParserAntlr
import SwiftRewriterLib

class SwiftStatementASTReaderTests: XCTestCase {
    var tokens: CommonTokenStream!
    
    func testIfStatement() {
        assert(objcExpr: "if(abc) { }",
               readsAs: .if(.identifier("abc"), body: .compound([]), else: nil)
        )
        
        assert(objcExpr: "if(abc) { } else { }",
               readsAs: .if(.identifier("abc"), body: .compound([]), else: .compound([]))
        )
        
        assert(objcExpr: "if(abc) { } else if(def) { }",
               readsAs: .if(.identifier("abc"),
                            body: .compound([]),
                            else: .if(.identifier("def"), body: .compound([]), else: nil))
        )
    }
    
    func assert(objcExpr: String, readsAs expected: Statement, file: String = #file, line: Int = #line) {
        let input = ANTLRInputStream(objcExpr)
        let lxr = ObjectiveCLexer(input)
        tokens = CommonTokenStream(lxr)
        
        let sut = SwiftStatementASTReader()
        
        do {
            let parser = try ObjectiveCParser(tokens)
            let expr = try parser.statement()
            
            let result = expr.accept(sut)
            
            if result != expected {
                var resStr = "nil"
                var expStr = ""
                
                if let result = result {
                    dump(result, to: &resStr)
                }
                dump(expected, to: &expStr)
                
                recordFailure(withDescription: """
                    Failed: Expected to read Objective-C expression
                    \(objcExpr)
                    as
                    \(expStr)
                    but read as
                    \(resStr)
                    """, inFile: file, atLine: line, expected: false)
            }
        } catch {
            recordFailure(withDescription: "Unexpected error(s) parsing objective-c: \(error)", inFile: file, atLine: line, expected: false)
        }
    }
}

