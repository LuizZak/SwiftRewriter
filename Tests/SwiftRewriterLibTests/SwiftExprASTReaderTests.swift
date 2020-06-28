import XCTest
import Antlr4
import ObjcParser
import ObjcParserAntlr
import SwiftRewriterLib
import TypeSystem
import SwiftAST

class SwiftExprASTReaderTests: XCTestCase {
    var tokens: CommonTokenStream!
    
    func testConstants() {
        assert(objcExpr: "1", readsAs: .constant(.int(1, .decimal)))
        assert(objcExpr: "1ulL", readsAs: .constant(.int(1, .decimal)))
        assert(objcExpr: "1.0e2", readsAs: .constant(.float(1e2)))
        assert(objcExpr: "1f", readsAs: .constant(.float(1)))
        assert(objcExpr: "1F", readsAs: .constant(.float(1)))
        assert(objcExpr: "1d", readsAs: .constant(.float(1)))
        assert(objcExpr: "1D", readsAs: .constant(.float(1)))
        assert(objcExpr: "true", readsAs: .constant(.boolean(true)))
        assert(objcExpr: "YES", readsAs: .constant(.boolean(true)))
        assert(objcExpr: "false", readsAs: .constant(.boolean(false)))
        assert(objcExpr: "NO", readsAs: .constant(.boolean(false)))
        assert(objcExpr: "0123", readsAs: .constant(.octal(0o123)))
        assert(objcExpr: "0x123", readsAs: .constant(.hexadecimal(0x123)))
        assert(objcExpr: "\"abc\"", readsAs: .constant(.string("abc")))
    }
    
    func testParensExpression() {
        assert(objcExpr: "(1 + 2)",
               readsAs: .parens(.binary(lhs: .constant(1), op: .add, rhs: .constant(2))))
    }
    
    func testTernaryExpression() {
        assert(objcExpr: "value ? ifTrue : ifFalse",
               readsAs: .ternary(.identifier("value"), true: .identifier("ifTrue"), false: .identifier("ifFalse")))
    }
    
    func testFunctionCall() {
        assert(objcExpr: "print()",
               readsAs: Expression.identifier("print").call())
        
        assert(objcExpr: "a.method()",
               readsAs: Expression.identifier("a").dot("method").call())
        
        assert(objcExpr: "print(123, 456)",
               readsAs: Expression.identifier("print").call([.constant(123),
                                                             .constant(456)]))
    }
    
    func testSubscript() {
        assert(objcExpr: "aSubscript[1]", readsAs: Expression.identifier("aSubscript").sub(.constant(1)))
    }
    
    func testMemberAccess() {
        assert(objcExpr: "aValue.member", readsAs: Expression.identifier("aValue").dot("member"))
    }
    
    func testSelectorMessage() {
        assert(objcExpr: "[a selector]",
               readsAs: Expression.identifier("a").dot("selector").call())
        
        assert(objcExpr: "[a selector:1, 2, 3]",
               readsAs: Expression
                .identifier("a")
                .dot("selector").call([.unlabeled(.constant(1)),
                                       .unlabeled(.constant(2)),
                                       .unlabeled(.constant(3))]))
        
        assert(objcExpr: "[a selector:1 c:2, 3]",
               readsAs: Expression
                .identifier("a")
                .dot("selector").call([.unlabeled(.constant(1)),
                                       .labeled("c", .constant(2)),
                                       .unlabeled(.constant(3))]))
        
        assert(objcExpr: "[a selector:1 :2 c:3]",
               readsAs: Expression
                .identifier("a")
                .dot("selector").call([.unlabeled(.constant(1)),
                                       .unlabeled(.constant(2)),
                                       .labeled("c", .constant(3))]))
    }
    
    func testCastExpression() {
        assert(objcExpr: "(NSString*)abc",
               readsAs: Expression.identifier("abc").casted(to: .string))
    }
    
    func testSelectorExpression() {
        assert(objcExpr: "@selector(abc:def:)",
               readsAs: Expression.identifier("Selector").call([.constant("abc:def:")]))
    }
    
    func testAssignmentWithMethodCall() {
        let exp = Expression
            .identifier("UIView")
            .dot("alloc").call()
            .dot("initWithFrame").call([
                .unlabeled(
                    Expression
                        .identifier("CGRectMake")
                        .call([
                            .constant(0),
                            .identifier("kCPDefaultTimelineRowHeight"),
                            Expression.identifier("self").dot("ganttWidth"),
                            Expression.identifier("self").dot("ganttHeight")
                        ]))
                ])
        
        assert(objcExpr: """
            _cellContainerView =
                [[UIView alloc] initWithFrame:CGRectMake(0, kCPDefaultTimelineRowHeight, self.ganttWidth, self.ganttHeight)];
            """,
            readsAs: .assignment(lhs: .identifier("_cellContainerView"), op: .assign, rhs: exp))
    }
    
    func testBinaryOperator() {
        assert(objcExpr: "i + 10",
               readsAs: .binary(lhs: .identifier("i"), op: .add, rhs: .constant(10)))
        
        assert(objcExpr: "i - 10",
               readsAs: .binary(lhs: .identifier("i"), op: .subtract, rhs: .constant(10)))
        
        assert(objcExpr: "i > 10",
               readsAs: .binary(lhs: .identifier("i"), op: .greaterThan, rhs: .constant(10)))
        
        assert(objcExpr: "i < 10",
               readsAs: .binary(lhs: .identifier("i"), op: .lessThan, rhs: .constant(10)))
        
        assert(objcExpr: "i % 10",
               readsAs: .binary(lhs: .identifier("i"), op: .mod, rhs: .constant(10)))
        
        assert(objcExpr: "i << 10",
               readsAs: .binary(lhs: .identifier("i"), op: .bitwiseShiftLeft, rhs: .constant(10)))
        
        assert(objcExpr: "i >> 10",
               readsAs: .binary(lhs: .identifier("i"), op: .bitwiseShiftRight, rhs: .constant(10)))
    }
    
    func testPostfixIncrementDecrement() {
        assert(objcExpr: "i++",
               readsAs: .assignment(lhs: .identifier("i"), op: .addAssign, rhs: .constant(1)))
        assert(objcExpr: "i--",
               readsAs: .assignment(lhs: .identifier("i"), op: .subtractAssign, rhs: .constant(1)))
    }
    
    func testPostfixStructAccessWithAssignment() {
        let exp =
            Expression
                .identifier("self")
                .dot("_ganttEndDate")
                .assignment(op: .assign,
                            rhs: .identifier("ganttEndDate"))
        
        assert(objcExpr: "self->_ganttEndDate = ganttEndDate",
               readsAs: exp)
    }
    
    func testArrayLiteral() {
        assert(objcExpr: "@[]", readsAs: .arrayLiteral([]))
        assert(objcExpr: "@[@\"abc\"]", readsAs: .arrayLiteral([.constant("abc")]))
        assert(objcExpr: "@[@\"abc\", @1]", readsAs: .arrayLiteral([.constant("abc"), .constant(1)]))
    }
    
    func testDictionaryLiteral() {
        assert(objcExpr: "@{}", readsAs: .dictionaryLiteral([]))
        assert(objcExpr: "@{@1: @2}", readsAs: .dictionaryLiteral([ExpressionDictionaryPair(key: .constant(1), value: .constant(2))]))
        assert(objcExpr: "@{@1: @2, @3: @4}",
               readsAs: .dictionaryLiteral([
                ExpressionDictionaryPair(key: .constant(1), value: .constant(2)),
                ExpressionDictionaryPair(key: .constant(3), value: .constant(4))
                ]))
    }
    
    func testBlockExpression() {
        assert(objcExpr: "^{ thing(); }",
               readsAs: .block(parameters: [], return: .void, body: [
                .expression(Expression.identifier("thing").call())
                ]))
        assert(objcExpr: "^NSString*{ return thing(); }",
               readsAs: .block(parameters: [],
                               return: SwiftType.string.asNullabilityUnspecified,
                               body: [
                                .return(Expression.identifier("thing").call())
                                ]))
        assert(objcExpr: "^NSString*(NSInteger inty){ return thing(); }",
               readsAs: .block(parameters: [BlockParameter(name: "inty", type: .int)],
                               return: SwiftType.string.asNullabilityUnspecified,
                               body: [
                                .return(Expression.identifier("thing").call())
                                ]))
        assert(objcExpr: "^(NSInteger inty){ return thing(); }",
               readsAs: .block(parameters: [BlockParameter(name: "inty", type: .int)],
                               return: .void,
                               body: [
                                .return(Expression.identifier("thing").call())
                                ]))
    }
    
    func testBlockMultiExpression() {
        assert(objcExpr: "^{ thing(); thing2(); }",
               readsAs: .block(parameters: [], return: .void, body: [
                .expression(
                    Expression.identifier("thing").call()
                    ),
                .expression(
                    Expression.identifier("thing2").call()
                    )
                ]))
    }
    
    func testRangeExpression() {
        assert(objcExpr: "0",
               parseWith: { try $0.rangeExpression() },
               readsAs: .constant(0)
        )
        assert(objcExpr: "0 ... 20",
               parseWith: { try $0.rangeExpression() },
               readsAs: .binary(lhs: .constant(0), op: .closedRange, rhs: .constant(20))
        )
        assert(objcExpr: "ident ... 20",
               parseWith: { try $0.rangeExpression() },
               readsAs: .binary(lhs: .identifier("ident"), op: .closedRange, rhs: .constant(20))
        )
    }
    
    func testNestedCompoundStatementInExpression() {
        assert(
            objcExpr: """
            ({ 1 + 1; })
            """,
            readsAs: Expression
                .block(body: [
                    .expression(Expression.constant(1).binary(op: .add, rhs: .constant(1)))
                ])
                .call()
        )
    }
}

extension SwiftExprASTReaderTests {
    
    func assert(objcExpr: String,
                parseWith: (ObjectiveCParser) throws -> ParserRuleContext = { parser in try parser.expression() },
                readsAs expected: Expression,
                file: StaticString = #filePath,
                line: UInt = #line) {
        
        let typeSystem = TypeSystem()
        let typeMapper = DefaultTypeMapper(typeSystem: typeSystem)
        let typeParser = TypeParsing(state: SwiftExprASTReaderTests._state)
        
        let sut =
            SwiftExprASTReader(
                typeMapper: typeMapper,
                typeParser: typeParser,
                context: SwiftASTReaderContext(typeSystem: typeSystem,
                                               typeContext: nil,
                                               comments: []),
                delegate: nil)
        
        do {
            let state = try SwiftExprASTReaderTests._state.makeMainParser(input: objcExpr)
            tokens = state.tokens
            
            let expr = try parseWith(state.parser)
            
            let result = expr.accept(sut)
            
            if result != expected {
                var resStr = "nil"
                var expStr = ""
                
                if let result = result {
                    dump(result, to: &resStr)
                }
                dump(expected, to: &expStr)
                
                XCTFail("""
                        Failed: Expected to read Objective-C expression
                        \(objcExpr)
                        as
                        \(expStr)
                        but read as
                        \(resStr)
                        """,
                        file: file, line: line)
            }
        } catch {
            XCTFail("Unexpected error(s) parsing objective-c: \(error)",
                    file: file,
                    line: line)
        }
    }
    
    private static var _state = ObjcParserState()
}
