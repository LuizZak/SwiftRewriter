import XCTest
import Antlr4
import ObjcParser
import ObjcParserAntlr
@testable import SwiftRewriterLib
import SwiftAST

class SwiftStatementASTReaderTests: XCTestCase {
    var tokens: CommonTokenStream!
    
    func testIfStatement() {
        assert(objcStmt: "if(abc) { }",
               readsAs: .if(.identifier("abc"), body: .empty, else: nil)
        )
        
        assert(objcStmt: "if(abc) { } else { }",
               readsAs: .if(.identifier("abc"), body: .empty, else: .empty)
        )
        
        assert(objcStmt: "if(abc) { } else if(def) { }",
               readsAs: .if(.identifier("abc"),
                            body: .empty,
                            else: CompoundStatement(statements: [.if(.identifier("def"), body: .empty, else: nil)]))
        )
    }
    
    func testWhile() {
        assert(objcStmt: "while(true) { }",
               readsAs: .while(.constant(true), body: .empty)
        )
        assert(objcStmt: "while(true) { thing(); }",
               readsAs: .while(.constant(true),
                               body: CompoundStatement(statements: [
                                .expression(
                                    Expression.identifier("thing").call()
                                )
                                ]))
        )
    }
    
    func testDoWhile() {
        assert(objcStmt: "do { } while(true);",
               readsAs: Statement.doWhile(.constant(true), body: .empty)
        )
    }
    
    func testFor() {
        assert(objcStmt: "for(NSInteger i = 0; i < 10; i++) { }",
               readsAs: .for(.identifier("i"), .binary(lhs: .constant(0), op: .openRange, rhs: .constant(10)),
                             body: [])
        )
        assert(objcStmt: "for(NSInteger i = 0; i <= 10; i++) { }",
               readsAs: .for(.identifier("i"), .binary(lhs: .constant(0), op: .closedRange, rhs: .constant(10)),
                             body: [])
        )
        
        assert(objcStmt: "for(NSInteger i = 16; i <= 59; i += 1) { }",
               readsAs: .for(.identifier("i"), .binary(lhs: .constant(16), op: .closedRange, rhs: .constant(59)),
                             body: [])
        )
        
        // Loop variable is being accessed, but not modified, within loop
        assert(objcStmt: "for(NSInteger i = 0; i < 10; i++) { print(i); }",
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
        assert(objcStmt: "for(NSInteger i = 0; i < 10; i++) { i++; }",
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
        assert(objcStmt: "for(NSInteger i = 0; i < 10; i--) { }",
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
        assert(objcStmt: "for(NSInteger i = 0; i < 10; j++) { }",
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
        assert(objcStmt: "for(NSInteger i = 0; i < 10; i++, j--) { }",
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
        assert(objcStmt: "for(; i < 10; i++) { }",
               readsAs:
                .while(.binary(lhs: .identifier("i"), op: .lessThan, rhs: .constant(10)),
                       body: [
                        .defer([
                            .expression(.assignment(lhs: .identifier("i"), op: .addAssign, rhs: .constant(1)))
                            ])
                    ])
        )
        
        // Missing loop condition
        assert(objcStmt: "for(NSInteger i = 0;; i++) { }",
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
        assert(objcStmt: "for(NSInteger i = 0; i < 10;) { }",
               readsAs: .compound([
                .variableDeclaration(identifier: "i", type: .int, initialization: .constant(0)),
                .while(.binary(lhs: .identifier("i"), op: .lessThan, rhs: .constant(10)),
                       body: .empty)
                ])
        )
        
        // Missing all loop components
        assert(objcStmt: "for(;;) { }",
               readsAs: .while(.constant(true), body: .empty))
    }
    
    func testForIn() {
        assert(objcStmt: "for(NSString *item in list) { }",
               readsAs: .for(.identifier("item"), .identifier("list"), body: .empty)
        )
        
        assert(objcStmt: "for(NSString *item in @[]) { }",
               readsAs: .for(.identifier("item"), .arrayLiteral([]), body: .empty)
        )
    }
    
    func testSwitch() {
        assert(objcStmt: "switch(value) { case 0: break; }",
               readsAs: .switch(.identifier("value"),
                                cases: [SwitchCase(patterns: [.expression(.constant(0))], statements: [.break])],
                                default: [.break])
        )
        
        assert(objcStmt: "switch(value) { case 0: break; case 1: break; }",
               readsAs: .switch(.identifier("value"),
                                cases: [
                                    SwitchCase(patterns: [.expression(.constant(0))], statements: [.break]),
                                    SwitchCase(patterns: [.expression(.constant(1))], statements: [.break])
                                ],
                                default: [.break])
        )
        
        assert(objcStmt: "switch(value) { case 0: case 1: break; }",
               readsAs: .switch(.identifier("value"),
                                cases: [
                                    SwitchCase(patterns: [.expression(.constant(0)), .expression(.constant(1))], statements: [.break])
                                ],
                                default: [.break])
        )
        
        assert(objcStmt: "switch(value) { case 0: case 1: break; default: stmt(); }",
               readsAs: .switch(.identifier("value"),
                                cases: [
                                    SwitchCase(patterns: [.expression(.constant(0)),
                                                          .expression(.constant(1))],
                                               statements: [.break])
                                ],
                                default: [
                                    .expression(
                                        Expression.identifier("stmt").call()
                                    )
                                ])
        )
    }
    
    func testAutomaticSwitchFallthrough() {
        assert(objcStmt: "switch(value) { case 0: stmt(); case 1: break; }",
               readsAs: .switch(.identifier("value"),
                                cases: [
                                    SwitchCase(patterns: [.expression(.constant(0))],
                                               statements: [
                                                .expression(Expression.identifier("stmt").call()),
                                                .fallthrough
                                                ]),
                                    SwitchCase(patterns: [.expression(.constant(1))], statements: [.break])
                                ],
                                default: [.break])
        )
    }
    
    func testExpressions() {
        assert(objcStmt: "abc;",
               readsAs: .expression(.identifier("abc"))
        )
        assert(objcStmt: "abc, def;",
               readsAs: .expressions([.identifier("abc"), .identifier("def")])
        )
    }
    
    func testLabeledStatement() {
        let stmt = assert(objcStmt: "label: if(true) { };",
               readsAs: Statement.if(.constant(true), body: [], else: nil)
        )
        
        XCTAssertEqual(stmt?.label, "label")
    }
    
    func testDeclaration() {
        assert(objcStmt: "CGFloat value = 1;",
               parseBlock: { try $0.declaration() },
               readsAs: .variableDeclaration(identifier: "value",
                                             type: .typeName("CGFloat"),
                                             initialization: .constant(1)))
    }
    
    func testBlockDeclaration() {
        assert(objcStmt: "void(^callback)();",
               parseBlock: { try $0.declaration() },
               readsAs: .variableDeclaration(identifier: "callback",
                                             type: .nullabilityUnspecified(.swiftBlock(returnType: .void, parameters: [])),
                                             initialization: nil))
        
        assert(objcStmt: "void(^_Nonnull callback)();",
               parseBlock: { try $0.declaration() },
               readsAs: .variableDeclaration(identifier: "callback",
                                             type: .swiftBlock(returnType: .void, parameters: []),
                                             initialization: nil))
    }
}

extension SwiftStatementASTReaderTests {
    @discardableResult
    func assert(objcStmt: String,
                parseBlock: (ObjectiveCParser) throws -> (ParserRuleContext) = { try $0.statement() },
                readsAs expected: Statement,
                file: String = #file,
                line: Int = #line) -> Statement? {
        
        let typeSystem = DefaultTypeSystem()
        let typeMapper = DefaultTypeMapper(typeSystem: typeSystem)
        let typeParser = TypeParsing(state: SwiftStatementASTReaderTests._state)
        
        let expReader =
            SwiftExprASTReader(
                typeMapper: typeMapper,
                typeParser: typeParser,
                context: SwiftASTReaderContext(typeSystem: typeSystem,
                                               typeContext: nil))
        
        let sut = SwiftStatementASTReader(expressionReader: expReader,
                                          context: expReader.context)
        
        do {
            let parser = try SwiftStatementASTReaderTests._state.makeMainParser(input: objcStmt).parser
            let expr = try parseBlock(parser)
            
            let result = expr.accept(sut)
            
            if result != expected {
                var resStr = "nil"
                var expStr = ""
                
                if let result = result {
                    resStr = ""
                    dump(result, to: &resStr)
                }
                dump(expected, to: &expStr)
                
                var expString = ""
                var resString = ""
                
                let prettyPrintExpWriter =
                    StatementWriter(options: .default,
                                    target: StringRewriterOutput(settings: .defaults),
                                    typeMapper: DefaultTypeMapper(),
                                    typeSystem: DefaultTypeSystem())
                
                let prettyPrintResWriter =
                    StatementWriter(options: .default,
                                    target: StringRewriterOutput(settings: .defaults),
                                    typeMapper: DefaultTypeMapper(),
                                    typeSystem: DefaultTypeSystem())
                
                prettyPrintExpWriter.visitStatement(expected)
                result.map(prettyPrintResWriter.visitStatement)
                
                dump(expected, to: &expString)
                dump(result, to: &resString)
                
                expString = (prettyPrintExpWriter.target as! StringRewriterOutput).buffer + "\n" + expString
                resString = (prettyPrintResWriter.target as! StringRewriterOutput).buffer + "\n" + resString
                
                recordFailure(withDescription: """
                    Failed: Expected to read Objective-C expression
                    \(objcStmt)
                    as
                    
                    \(expString)
                    
                    but read as
                    
                    \(resString)
                    
                    """, inFile: file, atLine: line, expected: true)
            }
            
            return result
        } catch {
            recordFailure(withDescription: "Unexpected error(s) parsing objective-c: \(error)", inFile: file, atLine: line, expected: false)
        }
        
        return nil
    }
    
    private static var _state = ObjcParserState()
}
