import XCTest
import Antlr4
import ObjcParser
import ObjcParserAntlr
import SwiftRewriterLib

class SwiftStatementASTReaderTests: XCTestCase {
    var tokens: CommonTokenStream!
    
    func testIfStatement() {
        assert(objcExpr: "if(abc) { }",
               readsAs: .if(.identifier("abc"), body: .empty, else: nil)
        )
        
        assert(objcExpr: "if(abc) { } else { }",
               readsAs: .if(.identifier("abc"), body: .empty, else: .empty)
        )
        
        assert(objcExpr: "if(abc) { } else if(def) { }",
               readsAs: .if(.identifier("abc"),
                            body: .empty,
                            else: CompoundStatement(statements: [.if(.identifier("def"), body: .empty, else: nil)]))
        )
    }
    
    func testWhile() {
        assert(objcExpr: "while(true) { }",
               readsAs: .while(.constant(true), body: .empty)
        )
        assert(objcExpr: "while(true) { thing(); }",
               readsAs: .while(.constant(true),
                               body: CompoundStatement(statements: [
                                .expression(
                                    .postfix(.identifier("thing"), .functionCall(arguments: []))
                                )
                                ]))
        )
    }
    
    func testFor() {
        assert(objcExpr: "for(int i = 0; i < 10; i++) { }",
               readsAs: .compound([
                    .variableDeclaration(identifier: "i", type: .struct("int"), initialization: .constant(0)),
                    .while(.binary(lhs: .identifier("i"), op: .lessThan, rhs: .constant(10)),
                           body: [
                            .defer([
                                .expression(.assignment(lhs: .identifier("i"), op: .addAssign, rhs: .constant(1)))
                                ])
                        ])
                ])
        )
        
        assert(objcExpr: "for(int i = 0; i < 10; i++, j--) { }",
               readsAs: .compound([
                .variableDeclaration(identifier: "i", type: .struct("int"), initialization: .constant(0)),
                .while(.binary(lhs: .identifier("i"), op: .lessThan, rhs: .constant(10)),
                       body: [
                        .defer([
                            .expressions([
                                .assignment(lhs: .identifier("i"), op: .addAssign, rhs: .constant(1)),
                                .assignment(lhs: .identifier("j"), op: .subtractAssign, rhs: .constant(1))
                                ]
                                )
                            ])
                    ])
                ])
        )
        
        assert(objcExpr: "for(; i < 10; i++) { }",
               readsAs:
                .while(.binary(lhs: .identifier("i"), op: .lessThan, rhs: .constant(10)),
                       body: [
                        .defer([
                            .expression(.assignment(lhs: .identifier("i"), op: .addAssign, rhs: .constant(1)))
                            ])
                    ])
        )
        
        assert(objcExpr: "for(int i = 0;; i++) { }",
               readsAs: .compound([
                .variableDeclaration(identifier: "i", type: .struct("int"), initialization: .constant(0)),
                .while(.constant(true),
                       body: [
                        .defer([
                            .expression(.assignment(lhs: .identifier("i"), op: .addAssign, rhs: .constant(1)))
                            ])
                    ])
                ])
        )
        
        assert(objcExpr: "for(int i = 0; i < 10;) { }",
               readsAs: .compound([
                .variableDeclaration(identifier: "i", type: .struct("int"), initialization: .constant(0)),
                .while(.binary(lhs: .identifier("i"), op: .lessThan, rhs: .constant(10)),
                       body: .empty)
                ])
        )
        
        assert(objcExpr: "for(;;) { }",
               readsAs: .while(.constant(true), body: .empty))
    }
    
    func testForIn() {
        assert(objcExpr: "for(NSString *item in list) { }",
               readsAs: .for(.identifier("item"), .identifier("list"), body: .empty)
        )
        
        assert(objcExpr: "for(NSString *item in @[]) { }",
               readsAs: .for(.identifier("item"), .arrayLiteral([]), body: .empty)
        )
    }
    
    func testExpressions() {
        assert(objcExpr: "abc;",
               readsAs: .expression(.identifier("abc"))
        )
        assert(objcExpr: "abc, def;",
               readsAs: .expressions([.identifier("abc"), .identifier("def")])
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

