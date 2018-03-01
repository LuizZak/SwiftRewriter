import XCTest
import Antlr4
import ObjcParser
import ObjcParserAntlr
import SwiftRewriterLib
import SwiftAST

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
               readsAs: .for(.identifier("i"), .binary(lhs: .constant(0), op: .openRange, rhs: .constant(10)),
                             body: [])
        )
        assert(objcExpr: "for(int i = 0; i <= 10; i++) { }",
               readsAs: .for(.identifier("i"), .binary(lhs: .constant(0), op: .closedRange, rhs: .constant(10)),
                             body: [])
        )
        
        assert(objcExpr: "for(int i = 16; i <= 59; i += 1) { }",
               readsAs: .for(.identifier("i"), .binary(lhs: .constant(16), op: .closedRange, rhs: .constant(59)),
                             body: [])
        )
        
        // Loop variable is being accessed, but not modified, within loop
        assert(objcExpr: "for(int i = 0; i < 10; i++) { print(i); }",
               readsAs: .for(.identifier("i"), .binary(lhs: .constant(0), op: .openRange, rhs: .constant(10)),
                             body: [
                                .expression(.postfix(.identifier("print"),
                                                     .functionCall(arguments: [
                                                        .unlabeled(.identifier("i"))
                                                        ])))
                            ])
        )
    }
    
    func testForConvertingToWhile() {
        // In some cases, the parser has to unwrap for loops that cannot be cleanly
        // converted into `for-in` statements into equivalent while loops.
        // This test method tests for such behavior.
        
        // Loop iterator is being modified within the loop's body
        assert(objcExpr: "for(int i = 0; i < 10; i++) { i++; }",
               readsAs: .compound([
                .variableDeclaration(identifier: "i", type: .int, initialization: .constant(0)),
                .while(.binary(lhs: .identifier("i"), op: .lessThan, rhs: .constant(10)),
                       body: [
                        .defer([
                            .expression(
                                .assignment(lhs: .identifier("i"), op: .addAssign, rhs: .constant(1))
                            )
                            ]),
                        .expression(.assignment(lhs: .identifier("i"), op: .addAssign, rhs: .constant(1)))
                    ])
                ])
        )
        
        // Loop iterator is not incrementing the loop variable.
        assert(objcExpr: "for(int i = 0; i < 10; i--) { }",
               readsAs: .compound([
                .variableDeclaration(identifier: "i", type: .int, initialization: .constant(0)),
                .while(.binary(lhs: .identifier("i"), op: .lessThan, rhs: .constant(10)),
                       body: [
                        .defer([
                            .expression(
                                .assignment(lhs: .identifier("i"), op: .subtractAssign, rhs: .constant(1))
                                )
                            ])
                    ])
                ])
        )
        
        // Loop iterator is assigning to different variable than loop variable
        assert(objcExpr: "for(int i = 0; i < 10; j++) { }",
               readsAs: .compound([
                .variableDeclaration(identifier: "i", type: .int, initialization: .constant(0)),
                .while(.binary(lhs: .identifier("i"), op: .lessThan, rhs: .constant(10)),
                       body: [
                        .defer([
                            .expression(
                                .assignment(lhs: .identifier("j"), op: .addAssign, rhs: .constant(1))
                                )
                            ])
                    ])
                ])
        )
        
        // Loop iterator is complex (changing two values)
        assert(objcExpr: "for(int i = 0; i < 10; i++, j--) { }",
               readsAs: .compound([
                .variableDeclaration(identifier: "i", type: .int, initialization: .constant(0)),
                .while(.binary(lhs: .identifier("i"), op: .lessThan, rhs: .constant(10)),
                       body: [
                        .defer([
                            .expressions([
                                .assignment(lhs: .identifier("i"), op: .addAssign, rhs: .constant(1)),
                                .assignment(lhs: .identifier("j"), op: .subtractAssign, rhs: .constant(1))
                                ])
                            ])
                    ])
                ])
        )
        
        // Missing loop start
        assert(objcExpr: "for(; i < 10; i++) { }",
               readsAs:
                .while(.binary(lhs: .identifier("i"), op: .lessThan, rhs: .constant(10)),
                       body: [
                        .defer([
                            .expression(.assignment(lhs: .identifier("i"), op: .addAssign, rhs: .constant(1)))
                            ])
                    ])
        )
        
        // Missing loop condition
        assert(objcExpr: "for(int i = 0;; i++) { }",
               readsAs: .compound([
                .variableDeclaration(identifier: "i", type: .int, initialization: .constant(0)),
                .while(.constant(true),
                       body: [
                        .defer([
                            .expression(.assignment(lhs: .identifier("i"), op: .addAssign, rhs: .constant(1)))
                            ])
                    ])
                ])
        )
        
        // Missing loop iterator
        assert(objcExpr: "for(int i = 0; i < 10;) { }",
               readsAs: .compound([
                .variableDeclaration(identifier: "i", type: .int, initialization: .constant(0)),
                .while(.binary(lhs: .identifier("i"), op: .lessThan, rhs: .constant(10)),
                       body: .empty)
                ])
        )
        
        // Missing all loop components
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
    
    func testSwitch() {
        assert(objcExpr: "switch(value) { case 0: break; }",
               readsAs: .switch(.identifier("value"),
                                cases: [SwitchCase(patterns: [.expression(.constant(0))], statements: [.break])],
                                default: [.break])
        )
        
        assert(objcExpr: "switch(value) { case 0: break; case 1: break }",
               readsAs: .switch(.identifier("value"),
                                cases: [
                                    SwitchCase(patterns: [.expression(.constant(0))], statements: [.break]),
                                    SwitchCase(patterns: [.expression(.constant(1))], statements: [.break])
                                ],
                                default: [.break])
        )
        
        assert(objcExpr: "switch(value) { case 0: case 1: break }",
               readsAs: .switch(.identifier("value"),
                                cases: [
                                    SwitchCase(patterns: [.expression(.constant(0)), .expression(.constant(1))], statements: [.break])
                                ],
                                default: [.break])
        )
        
        assert(objcExpr: "switch(value) { case 0: case 1: break; default: stmt(); }",
               readsAs: .switch(.identifier("value"),
                                cases: [
                                    SwitchCase(patterns: [.expression(.constant(0)),
                                                          .expression(.constant(1))],
                                               statements: [.break])
                                ],
                                default: [
                                    .expression(
                                        .postfix(.identifier("stmt"),
                                                 .functionCall(arguments: [])
                                        )
                                    )
                                ])
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
    
    func testDeclaration() {
        assert(objcExpr: "CGFloat value = 1;",
               parseBlock: { try $0.declaration() },
               readsAs: .variableDeclaration(identifier: "value",
                                             type: .typeName("CGFloat"),
                                             initialization: .constant(1)))
    }
    
    func assert(objcExpr: String, parseBlock: (ObjectiveCParser) throws -> (ParserRuleContext) = { try $0.statement() }, readsAs expected: Statement, file: String = #file, line: Int = #line) {
        let input = ANTLRInputStream(objcExpr)
        let lxr = ObjectiveCLexer(input)
        tokens = CommonTokenStream(lxr)
        
        let typeMapper = TypeMapper(context: TypeConstructionContext(typeSystem: DefaultTypeSystem()))
        
        let sut = SwiftStatementASTReader(expressionReader: SwiftExprASTReader(typeMapper: typeMapper))
        
        do {
            let parser = try ObjectiveCParser(tokens)
            let expr = try parseBlock(parser)
            
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

