import XCTest
import Antlr4
import Utils
import ObjcParser
import ObjcParserAntlr
import SwiftSyntaxSupport
import TypeSystem
import SwiftAST
import WriterTargetOutput
import ObjcGrammarModels
import GrammarModelBase

@testable import ObjectiveCFrontend

class ObjectiveCStatementASTReaderTests: XCTestCase {
    var tokens: CommonTokenStream!
    private var delegate: TestSwiftStatementASTReaderDelegate?

    override func setUp() {
        super.setUp()

        delegate = nil
    }
    
    func testIfStatement() {
        assert(objcStmt: "if(abc) { }",
               readsAs: .if(.identifier("abc"), body: .empty)
        )
        
        assert(objcStmt: "if(abc) { } else { }",
               readsAs: .if(.identifier("abc"), body: .empty, else: .empty)
        )
        
        assert(objcStmt: "if(abc) { } else if(def) { }",
               readsAs: .if(.identifier("abc"),
                            body: .empty,
                            else: CompoundStatement(statements: [.if(.identifier("def"), body: .empty)]))
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
                                cases: [SwitchCase(patterns: [.expression(.constant(0))], statements: [.break()])],
                                default: [.break()])
        )
        
        assert(objcStmt: "switch(value) { case 0: break; case 1: break; }",
               readsAs: .switch(.identifier("value"),
                                cases: [
                                    SwitchCase(patterns: [.expression(.constant(0))], statements: [.break()]),
                                    SwitchCase(patterns: [.expression(.constant(1))], statements: [.break()])
                                ],
                                default: [.break()])
        )
        
        assert(objcStmt: "switch(value) { case 0: case 1: break; }",
               readsAs: .switch(.identifier("value"),
                                cases: [
                                    SwitchCase(patterns: [.expression(.constant(0)), .expression(.constant(1))], statements: [.break()])
                                ],
                                default: [.break()])
        )
        
        assert(objcStmt: "switch(value) { case 0: case 1: break; default: stmt(); }",
               readsAs: .switch(.identifier("value"),
                                cases: [
                                    SwitchCase(patterns: [.expression(.constant(0)),
                                                          .expression(.constant(1))],
                                               statements: [.break()])
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
                                    SwitchCase(patterns: [.expression(.constant(1))], statements: [.break()])
                                ],
                                default: [.break()])
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
               readsAs: Statement.if(.constant(true), body: []).labeled("label")
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

    func testReportAutotypeDeclaration() {
        delegate = TestSwiftStatementASTReaderDelegate()

        assert(objcStmt: "__auto_type value;",
               parseBlock: { try $0.declaration() },
               readsAs: .variableDeclaration(identifier: "value",
                                             type: .typeName("__auto_type"),
                                             initialization: nil))

        XCTAssertEqual(delegate?.reportAutoTypeDeclaration,
                       .variableDeclaration(identifier: "value",
                                            type: .typeName("__auto_type"),
                                            initialization: nil))
        XCTAssertEqual(delegate?.declarationAtIndex, 0)
    }
    
    func testWeakNonPointerDefinition() {
        // Tests that non pointer definitions drop the __weak qualifier during
        // parsing
        assert(objcStmt: "__weak NSInteger value = 1;",
               parseBlock: { try $0.declaration() },
               readsAs: .variableDeclaration(identifier: "value",
                                             type: .int,
                                             ownership: .strong,
                                             initialization: .constant(1)))
    }
    
    func testAutotypeWeakDefinition() {
        assert(objcStmt: "__weak __auto_type value = nil;",
               parseBlock: { try $0.declaration() },
               readsAs: .variableDeclaration(identifier: "value",
                                             type: .typeName("__auto_type"),
                                             ownership: .weak,
                                             initialization: .constant(.nil)))
    }
    
    func testReadWithComments() {
        let comment = ObjcComment(string: "// A Comment",
                                  range: "// A Comment".cStyleCommentSectionRanges()[0],
                                  location: SourceLocation(line: 1, column: 1, utf8Offset: 0),
                                  length: SourceLength(newlines: 0, columnsAtLastLine: 12, utf8Length: "// A Comment".utf8.count))
        let expected = Statement.expression(Expression.identifier("test").call())
        expected.comments.append("// A Comment")
        
        assert(objcStmt: "\ntest();",
               comments: [comment],
               parseBlock: { try $0.statement() },
               readsAs: expected)
    }
    
    func testReadWithCommentsMultiple() throws {
        let string = """
            // A Comment
            // Another Comment
            test();
            // This should not be included
            """
        let objcParser = ObjcParser(string: string)
        try objcParser.parse()
        let comments = Array(objcParser.comments[0...1])
        let expected = Statement.expression(Expression.identifier("test").call())
        expected.comments.append("// A Comment")
        expected.comments.append("// Another Comment")
        
        assert(objcStmt: string,
               comments: comments,
               parseBlock: { try $0.statement() },
               readsAs: expected)
    }
    
    func testReadCommentInDeclaration() throws {
        let string = """
            {
                // A Comment
                // Another Comment
                NSInteger value;
                // This should not be included
            }
            """
        let objcParser = ObjcParser(string: string)
        try objcParser.parse()
        let comments = objcParser.comments
        let expected = Statement.variableDeclaration(identifier: "value", type: .int, initialization: nil)
        expected.comments.append("// A Comment")
        expected.comments.append("// Another Comment")
        
        assert(objcStmt: string,
               comments: comments,
               parseBlock: { try $0.statement() },
               readsAs: CompoundStatement(statements: [expected]))
    }
    
    func testReadWithCommentsComplex() throws {
        let string = """
            {
                // Define value
                NSInteger def;
                // Fetch value
                def = stmt();
                // Check value
                if (def) {
                    // Return
                    return def;
                }
            }
            """
        let objcParser = ObjcParser(string: string)
        try objcParser.parse()
        let comments = objcParser.comments
        let expected: CompoundStatement = [
            Statement
                .variableDeclaration(identifier: "def", type: .int, initialization: nil)
                .withComments(["// Define value"]),
            Statement
                .expression(Expression.identifier("def").assignment(op: .assign, rhs: Expression.identifier("stmt").call()))
                .withComments(["// Fetch value"]),
            Statement
                .if(.identifier("def"), body: [
                    Statement
                        .return(.identifier("def"))
                        .withComments(["// Return"])
                ])
                .withComments(["// Check value"])
        ]
        
        assert(objcStmt: string,
               comments: comments,
               parseBlock: { try $0.statement() },
               readsAs: expected)
    }
    
    func testReadWithCommentsTrailing() throws {
        let string = """
            test(); // A trailing comment
            """
        let objcParser = ObjcParser(string: string)
        try objcParser.parse()
        let comments = objcParser.comments
        let expected = Statement.expression(Expression.identifier("test").call())
        expected.trailingComment = "// A trailing comment"
        
        assert(objcStmt: string,
               comments: comments,
               parseBlock: { try $0.statement() },
               readsAs: expected)
    }
    
    func testReadWithCommentsTrailingStatement() throws {
        let string = """
            if (true) {
            } // A trailing comment
            """
        let objcParser = ObjcParser(string: string)
        try objcParser.parse()
        let comments = objcParser.comments
        let expected = Statement.if(.constant(true), body: [])
        expected.trailingComment = "// A trailing comment"
        
        assert(objcStmt: string,
               comments: comments,
               parseBlock: { try $0.statement() },
               readsAs: expected)
    }
}

extension ObjectiveCStatementASTReaderTests {
    @discardableResult
    func assert(objcStmt: String,
                comments: [ObjcComment] = [],
                parseBlock: (ObjectiveCParser) throws -> (ParserRuleContext) = { try $0.statement() },
                readsAs expected: Statement,
                file: StaticString = #filePath,
                line: UInt = #line) -> Statement? {
        
        let typeSystem = TypeSystem()
        let typeMapper = DefaultTypeMapper(typeSystem: typeSystem)
        let typeParser = TypeParsing(state: ObjectiveCStatementASTReaderTests._state)
        
        let expReader =
            ObjectiveCExprASTReader(
                typeMapper: typeMapper,
                typeParser: typeParser,
                context: ObjectiveCASTReaderContext(typeSystem: typeSystem,
                                               typeContext: nil,
                                               comments: comments),
                delegate: delegate)
        
        let sut = ObjectiveCStatementASTReader(expressionReader: expReader,
                                          context: expReader.context,
                                          delegate: delegate)
        
        do {
            let parser = try ObjectiveCStatementASTReaderTests._state.makeMainParser(input: objcStmt).parser
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
                
                let producer = SwiftSyntaxProducer()
                
                expString = producer.generateStatement(expected).description + "\n"
                resString = (result.map(producer.generateStatement)?.description ?? "") + "\n"
                
                dump(expected, to: &expString)
                dump(result, to: &resString)
                
                XCTFail("""
                        Failed: Expected to read Objective-C expression
                        \(objcStmt)
                        as
                        
                        \(expString)
                        
                        but read as
                        
                        \(resString)
                        
                        """,
                        file: file, line: line)
            }
            
            return result
        } catch {
            XCTFail("Unexpected error(s) parsing objective-c: \(error)", file: file, line: line)
        }
        
        return nil
    }
    
    private static var _state = ObjcParserState()
}

private class TestSwiftStatementASTReaderDelegate: ObjectiveCStatementASTReaderDelegate {

    var reportAutoTypeDeclaration: VariableDeclarationsStatement?
    var declarationAtIndex: Int?

    func swiftStatementASTReader(reportAutoTypeDeclaration varDecl: VariableDeclarationsStatement,
                                 declarationAtIndex index: Int) {
        self.reportAutoTypeDeclaration = varDecl
        self.declarationAtIndex = index
    }
}
