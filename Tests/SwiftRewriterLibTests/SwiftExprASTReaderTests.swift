import XCTest
import Antlr4
import ObjcParser
import ObjcParserAntlr
import SwiftRewriterLib
import SwiftAST

class SwiftExprASTReaderTests: XCTestCase {
    var tokens: CommonTokenStream!
    
    func testConstants() {
        assert(objcExpr: "1", readsAs: .constant(.int(1)))
        assert(objcExpr: "1ulL", readsAs: .constant(.int(1)))
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
        assert(objcExpr: "print()", readsAs: .postfix(.identifier("print"), .functionCall(arguments: [])))
        assert(objcExpr: "a.method()", readsAs: .postfix(.postfix(.identifier("a"), .member("method")), .functionCall(arguments: [])))
        assert(objcExpr: "print(123, 456)",
               readsAs: .postfix(.identifier("print"),
                                 .functionCall(arguments: [.unlabeled(.constant(123)),
                                                           .unlabeled(.constant(456))]))
        )
    }
    
    func testSubscript() {
        assert(objcExpr: "aSubscript[1]", readsAs: .postfix(.identifier("aSubscript"), .subscript(.constant(1))))
    }
    
    func testMemberAccess() {
        assert(objcExpr: "aSubscript.def", readsAs: .postfix(.identifier("aSubscript"), .member("def")))
    }
    
    func testSelectorMessage() {
        assert(objcExpr: "[a selector]", readsAs: .postfix(.postfix(.identifier("a"), .member("selector")), .functionCall(arguments: [])))
        
        assert(objcExpr: "[a selector:1, 2, 3]",
               readsAs: .postfix(.postfix(.identifier("a"), .member("selector")),
                                 .functionCall(arguments: [.unlabeled(.constant(1)), .unlabeled(.constant(2)), .unlabeled(.constant(3))])))
        
        assert(objcExpr: "[a selector:1 c:2, 3]",
               readsAs: .postfix(.postfix(.identifier("a"), .member("selector")),
                                 .functionCall(arguments: [.unlabeled(.constant(1)), .labeled("c", .constant(2)), .unlabeled(.constant(3))])))
    }
    
    func testCastExpression() {
        assert(objcExpr: "(NSString*)abc",
               readsAs: .cast(.identifier("abc"), type: .string))
    }
    
    func testSelectorExpression() {
        assert(objcExpr: "@selector(abc:def:)",
               readsAs: .postfix(.identifier("Selector"),
                                 .functionCall(arguments: [
                                    .unlabeled(.constant("abc:def:"))
                                    ]))
        )
    }
    
    func testAssignmentWithMethodCall() {
        let exp =
            Expression.postfix(
                .postfix(
                    .postfix(
                        .postfix(.identifier("UIView"), .member("alloc")),
                        .functionCall(arguments: [])), .member("initWithFrame")), .functionCall(arguments:
                            [
                            .unlabeled(
                                .postfix(.identifier("CGRectMake"),
                                         .functionCall(arguments:
                                            [
                                            .unlabeled(.constant(0)),
                                            .unlabeled(.identifier("kCPDefaultTimelineRowHeight")),
                                            .unlabeled(.postfix(.identifier("self"), .member("ganttWidth"))),
                                            .unlabeled(.postfix(.identifier("self"), .member("ganttHeight")))
                                            ])))
                            ]))
        
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
                .assignment(lhs: .postfix(.identifier("self"), .member("_ganttEndDate")),
                            op: .assign,
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
                .expression(.postfix(.identifier("thing"), .functionCall(arguments: [])))
                ]))
        assert(objcExpr: "^NSString*{ return thing(); }",
               readsAs: .block(parameters: [],
                               return: SwiftType.string.asImplicitUnwrapped,
                               body: [
                                .return(.postfix(.identifier("thing"), .functionCall(arguments: [])))
                                ]))
        assert(objcExpr: "^NSString*(NSInteger inty){ return thing(); }",
               readsAs: .block(parameters: [BlockParameter(name: "inty", type: .int)],
                               return: SwiftType.string.asImplicitUnwrapped,
                               body: [
                                .return(.postfix(.identifier("thing"), .functionCall(arguments: [])))
                                ]))
        assert(objcExpr: "^(NSInteger inty){ return thing(); }",
               readsAs: .block(parameters: [BlockParameter(name: "inty", type: .int)],
                               return: .void,
                               body: [
                                .return(.postfix(.identifier("thing"), .functionCall(arguments: [])))
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
    
    func assert(objcExpr: String, parseWith: (ObjectiveCParser) throws -> ParserRuleContext = { parser in try parser.expression() }, readsAs expected: Expression, file: String = #file, line: Int = #line) {
        let input = ANTLRInputStream(objcExpr)
        let lxr = ObjectiveCLexer(input)
        tokens = CommonTokenStream(lxr)
        
        let sut = SwiftExprASTReader(typeMapper: DefaultTypeMapper(context: TypeConstructionContext(typeSystem: DefaultTypeSystem())))
        
        do {
            let parser = try ObjectiveCParser(tokens)
            let expr = try parseWith(parser)
            
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
