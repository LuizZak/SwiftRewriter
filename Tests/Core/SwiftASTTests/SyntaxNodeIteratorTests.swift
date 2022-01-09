import SwiftAST
import XCTest
import TestCommons
import SwiftSyntaxSupport

class SyntaxNodeIteratorTests: XCTestCase {
    func testAssignmentExpression() {
        assertExpression(
            .assignment(lhs: .identifier("a"), op: .assign, rhs: .identifier("b")),
            iteratesAs: [
                Expression.assignment(lhs: .identifier("a"), op: .assign, rhs: .identifier("b")),
                .identifier("a"),
                .identifier("b"),
            ]
        )
    }

    func testBinaryExpression() {
        assertExpression(
            .binary(lhs: .identifier("a"), op: .add, rhs: .identifier("b")),
            iteratesAs: [
                Expression.binary(lhs: .identifier("a"), op: .add, rhs: .identifier("b")),
                .identifier("a"),
                .identifier("b"),
            ]
        )
    }

    func testUnary() {
        assertExpression(
            .unary(op: .negate, .identifier("a")),
            iteratesAs: [
                Expression.unary(op: .negate, .identifier("a")),
                .identifier("a"),
            ]
        )
    }

    func testSizeOf() {
        assertExpression(
            .sizeof(.identifier("a")),
            iteratesAs: [
                Expression.sizeof(.identifier("a")),
                .identifier("a"),
            ]
        )
    }

    func testPrefix() {
        assertExpression(
            .prefix(op: .negate, .identifier("a")),
            iteratesAs: [
                Expression.prefix(op: .negate, .identifier("a")),
                .identifier("a"),
            ]
        )
    }

    func testPostfix() {
        assertExpression(
            .identifier("a").dot("a"),
            iteratesAs: [
                Expression.identifier("a").dot("a"),
                .identifier("a"),
            ]
        )

        // Test iterating into subscript expressions
        assertExpression(
            .identifier("a").sub(.identifier("b")),
            iteratesAs: [
                Expression.identifier("a").sub(.identifier("b")),
                .identifier("a"),
                .identifier("b"),
            ]
        )

        // Test iterating into function call arguments
        assertExpression(
            .identifier("a").call([
                .labeled("label", .identifier("b")),
                .unlabeled(.identifier("c")),
            ]),
            iteratesAs: [
                Expression.identifier("a").call([
                    .labeled("label", .identifier("b")),
                    .unlabeled(.identifier("c")),
                ]),
                .identifier("a"),
                .identifier("b"),
                .identifier("c"),
            ]
        )

        assertExpression(
            .identifier("a").optional().call([.identifier("b")]),
            iteratesAs: [
                Expression.identifier("a").optional().call([.identifier("b")]),
                .identifier("a"),
                .identifier("b"),
            ]
        )
    }

    func testParens() {
        assertExpression(
            .parens(.identifier("a")),
            iteratesAs: [
                Expression.parens(.identifier("a")),
                .identifier("a"),
            ]
        )
    }

    func testCast() {
        assertExpression(
            .identifier("a").casted(to: .typeName("B")),
            iteratesAs: [
                Expression.identifier("a").casted(to: .typeName("B")),
                .identifier("a"),
            ]
        )
    }

    func testTypeCheck() {
        assertExpression(
            .identifier("a").typeCheck(as: .typeName("B")),
            iteratesAs: [
                Expression.identifier("a").typeCheck(as: .typeName("B")),
                .identifier("a"),
            ]
        )
    }

    func testArrayLiteral() {
        assertExpression(
            .arrayLiteral([.identifier("a"), .identifier("b")]),
            iteratesAs: [
                Expression.arrayLiteral([.identifier("a"), .identifier("b")]),
                .identifier("a"),
                .identifier("b"),
            ]
        )
    }

    func testDictionaryLiteral() {
        assertExpression(
            .dictionaryLiteral([
                .init(key: .identifier("a"), value: .identifier("b")),
                .init(key: .identifier("c"), value: .identifier("d")),
            ]),
            iteratesAs: [
                Expression.dictionaryLiteral([
                    .init(key: .identifier("a"), value: .identifier("b")),
                    .init(key: .identifier("c"), value: .identifier("d")),
                ]),
                .identifier("a"),
                .identifier("b"),
                .identifier("c"),
                .identifier("d"),
            ]
        )
    }

    func testTernary() {
        assertExpression(
            .ternary(.identifier("a"), true: .identifier("b"), false: .identifier("c")),
            iteratesAs: [
                Expression.ternary(
                    .identifier("a"),
                    true: .identifier("b"),
                    false: .identifier("c")
                ),
                .identifier("a"),
                .identifier("b"),
                .identifier("c"),
            ]
        )
    }

    func testTuple() {
        assertExpression(
            .tuple([.identifier("a"), .identifier("b")]),
            iteratesAs: [
                Expression.tuple([.identifier("a"), .identifier("b")]),
                .identifier("a"),
                .identifier("b"),
            ]
        )
    }

    func testSelector() {
        assertExpression(
            .selector(FunctionIdentifier(name: "f", argumentLabels: [])),
            iteratesAs: [
                Expression.selector(FunctionIdentifier(name: "f", argumentLabels: []))
            ]
        )
    }

    func testBlockTraversalFalse() {
        assertExpression(makeBlock(), iteratesAs: [makeBlock()])
    }

    func testBlockTraversalTrue() {
        assertExpression(
            makeBlock(),
            inspectingBlocks: true,
            iteratesAs: [
                makeBlock(),
                Statement.compound([.expression(.identifier("a"))]),
                Statement.expression(Expression.identifier("a")),
                Expression.identifier("a"),
            ]
        )
    }

    func testIf() {
        assertStatement(
            .if(.constant(true), body: [.do([.break()])], else: [.do([.continue()])]),
            iteratesAs: [
                Statement.if(.constant(true), body: [.do([.break()])], else: [.do([.continue()])]),
                Expression.constant(true),
                Statement.compound([.do([.break()])]),
                Statement.compound([.do([.continue()])]),
                Statement.do([.break()]),
                Statement.do([.continue()]),
                Statement.compound([.break()]),
                Statement.compound([.continue()]),
                Statement.break(),
                Statement.continue(),
            ]
        )
    }

    func testIfLet() {
        assertStatement(
            .ifLet(.expression(.identifier("a")), .constant(true), body: [.do([.break()])], else: [.do([.continue()])]),
            iteratesAs: [
                Statement.ifLet(.expression(.identifier("a")), .constant(true), body: [.do([.break()])], else: [.do([.continue()])]),
                Expression.identifier("a"),
                Expression.constant(true),
                Statement.compound([.do([.break()])]),
                Statement.compound([.do([.continue()])]),
                Statement.do([.break()]),
                Statement.do([.continue()]),
                Statement.compound([.break()]),
                Statement.compound([.continue()]),
                Statement.break(),
                Statement.continue(),
            ]
        )
    }

    func testDo() {
        assertStatement(
            .do([.break(), .continue()]),
            iteratesAs: [
                Statement.do([.break(), .continue()]),
                .compound([.break(), .continue()]),
                .break(),
                .continue(),
            ]
        )
    }

    func testDoCatchBlock() {
        assertStatement(
            .do([
                .expression(.identifier("a")),
                .expression(.identifier("b")),
            ]).catch([
                .expression(.identifier("c")),
            ]),
            iteratesAs: [
                Statement.do([
                    .expression(.identifier("a")),
                    .expression(.identifier("b")),
                ]).catch([
                    .expression(.identifier("c")),
                ]),
                Statement.compound([
                    .expression(.identifier("a")),
                    .expression(.identifier("b")),
                ]),
                CatchBlock(pattern: nil, body: [
                    .expression(.identifier("c")),
                ]),
                Statement.expression(.identifier("a")),
                Statement.expression(.identifier("b")),
                Statement.compound([
                    .expression(.identifier("c")),
                ]),
                Expression.identifier("a"),
                Expression.identifier("b"),
                Statement.expression(.identifier("c")),
                Expression.identifier("c"),
            ]
        )
    }

    func testWhileStatement() {
        assertStatement(
            .while(.constant(true), body: [.break(), .continue()]),
            iteratesAs: [
                Statement.while(.constant(true), body: [.break(), .continue()]),
                Expression.constant(true),
                Statement.compound([
                    .break(),
                    .continue(),
                ]),
                Statement.break(),
                Statement.continue(),
            ]
        )
    }

    /*
     For loop traversal:

             1          2               3
     for <pattern> in <exp> < { compound statement } >

     1. Loop pattern
     2. Loop expression
     3. Compound loop body

     And then recursively within each one, in breadth-first manner.
     */

    func testForStatementNotInspectingBlocks() {
        assertStatement(
            .for(
                .expression(makeBlock()),
                makeBlock("b"),
                body: [.expression(.identifier("c"))]
            ),
            inspectingBlocks: false,
            iteratesAs: [
                Statement.for(
                    .expression(makeBlock()),
                    makeBlock("b"),
                    body: [.expression(.identifier("c"))]
                ),
                // Loop pattern
                makeBlock(),

                // Loop expression
                makeBlock("b"),

                // Loop body
                Statement.compound([.expression(.identifier("c"))]),

                // Loop body -> expression statement
                Statement.expression(.identifier("c")),

                // Loop body -> expression statement -> expression
                Expression.identifier("c"),
            ]
        )
    }

    func testForStatementInspectingBlocks() {
        assertStatement(
            .for(
                .expression(makeBlock("a")),
                makeBlock("b"),
                body: [.expression(.identifier("c"))]
            ),
            inspectingBlocks: true,
            iteratesAs: [
                Statement.for(
                    .expression(makeBlock()),
                    makeBlock("b"),
                    body: [.expression(.identifier("c"))]
                ),
                // Loop pattern
                makeBlock(),
                // Loop expression
                makeBlock("b"),
                // Loop body
                Statement.compound([.expression(.identifier("c"))]),

                // Loop pattern -> block
                Statement.compound([.expression(.identifier("a"))]),
                // Loop expression -> block
                Statement.compound([.expression(.identifier("b"))]),
                // Loop body -> expression statement
                Statement.expression(.identifier("c")),

                // Loop pattern -> block -> expression statement
                Statement.expression(.identifier("a")),
                // Loop expression -> block -> expression statement
                Statement.expression(.identifier("b")),
                // Loop body -> expression statement -> expression
                Expression.identifier("c"),

                // Loop pattern -> block -> expression statement -> expression
                Expression.identifier("a"),
                // Loop expression -> block -> expression statement -> expression
                Expression.identifier("b"),
            ]
        )
    }

    func testCompound() {
        assertStatement(
            .compound([
                .expression(.identifier("a")),
                .expression(.identifier("b")),
            ]),
            iteratesAs: [
                Statement.compound([
                    Statement.expression(.identifier("a")),
                    Statement.expression(.identifier("b")),
                ]),
                Statement.expression(.identifier("a")),
                Statement.expression(.identifier("b")),
                Expression.identifier("a"),
                Expression.identifier("b"),
            ]
        )
    }

    /*
     Switch statement traversal:

              1
     switch <exp> { <cases> <default> }
                       L. case -> patterns
                   2.           |    L. pattern -> expression(s)
                   3.  L. case -> statement(s)
                   4.  L. default ->  statement(s)

     1. Switch expression
     2. Switch cases' patterns
     3. Switch cases' statements
     4. Switch default statements

     And then recursively within each one, in breadth-first manner.
     */

    func testSwitchNotInspectingBlocks() throws {
        let switchExp = makeBlock("a")
        let stmt = Statement.switch(
            switchExp,
            cases: [
                .init(
                    patterns: [.expression(makeBlock("b"))],
                    statements: [.expression(.identifier("c"))]
                )
            ],
            defaultStatements: [
                .expression(.identifier("d"))
            ]
        )

        try assertNode(
            stmt,
            inspectingBlocks: false,
            iteratesAs: [
                // -- depth 0
                // switch
                el(stmt),

                // -- depth 1
                // switch -> exp
                el(switchExp),
                // switch -> case 0
                el(stmt.cases[0]),
                // switch -> default
                el(stmt.defaultCase),

                // -- depth 2
                // switch -> case 0 (patterns) 0 -> sub expression
                el(stmt.cases[0].patterns[0].subExpressions[0]),
                // switch -> case 0 -> statement 0
                el(stmt.cases[0].statements[0]),
                // switch -> default -> statement 0
                el(stmt.defaultCase?.statements[0]),

                // -- depth 3
                // switch -> case 0 -> statement 0 -> expression 0
                el(stmt.cases[0].statements[0].asExpressions?.expressions[0]),
                // switch -> default -> statement 0 -> expression 0
                el(stmt.defaultCase?.statements[0].asExpressions?.expressions[0]),
            ]
        )
    }

    func testSwitchInspectingBlocks() throws {
        let switchExp = makeBlock("a")
        let stmt = Statement.switch(
            switchExp,
            cases: [
                .init(
                    patterns: [.expression(makeBlock("b"))],
                    statements: [.expression(.identifier("c"))]
                )
            ],
            defaultStatements: [
                .expression(.identifier("d"))
            ]
        )

        try assertNode(
            stmt,
            inspectingBlocks: true,
            iteratesAs: [
                // -- depth 0
                // switch
                el(stmt),

                // -- depth 1
                // switch -> exp
                el(switchExp),
                // switch -> case 0
                el(stmt.cases[0]),
                // switch -> default
                el(stmt.defaultCase),

                // -- depth 2
                // switch -> exp -> body
                el(switchExp.body),
                // switch -> case 0 (patterns) 0 -> sub expression
                el(stmt.cases[0].patterns[0].subExpressions[0]),
                // switch -> case 0 -> statement 0
                el(stmt.cases[0].statements[0]),
                // switch -> default -> statement 0
                el(stmt.defaultCase?.statements[0]),

                // -- depth 3
                // switch -> exp -> body -> statements
                el(switchExp.body.statements[0]),
                // switch -> case 0 (patterns) 0 -> sub expression 0 -> body
                el(stmt.cases[0].patterns[0].subExpressions[0].asBlock?.body),
                // switch -> case 0 -> statement 0 -> expression 0
                el(stmt.cases[0].statements[0].asExpressions?.expressions[0]),
                // switch -> default -> statement 0 -> expression 0
                el(stmt.defaultCase?.statements[0].asExpressions?.expressions[0]),

                // -- depth 4
                // switch -> exp -> body -> statements -> expression
                el(switchExp.body.statements[0].asExpressions?.expressions[0]),
                // switch -> case 0 (patterns) 0 -> sub expression 0 -> body -> statement 0
                el(stmt.cases[0].patterns[0].subExpressions[0].asBlock?.body.statements[0]),

                // -- depth 5
                // switch -> case 0 (patterns) 0 -> sub expression 0 -> body -> statement 0 -> expression 0
                el(stmt.cases[0].patterns[0].subExpressions[0].asBlock?.body.statements[0].asExpressions?.expressions[0]),
            ]
        )

        /*
        assertStatement(
            stmt,
            inspectingBlocks: true,
            iteratesAs: [
                stmt,
                // switch expression
                stmt.exp,
                // case 0
                stmt.cases[0],
                // default
                stmt.defaultCase!,
                // switch expression -> block/statements
                stmt.exp.children[0],
                // case 0 -> [pattern] -> block
                stmt.cases[0].patterns[0].subExpressions[0],
                // case 0 -> statement(s)
                stmt.cases[0].statements[0],
                // default -> statement(s)
                stmt.defaultCase!.statements[0],

                // switch expression -> block -> compound statement
                Statement.compound([.expression(.identifier("a"))]),
                // case 0 -> [pattern] -> block -> compound statement
                Statement.compound([.expression(.identifier("b"))]),
                // case 0 -> statement(s) -> expression
                Expression.identifier("c"),
                // default -> statement(s) -> expression
                Expression.identifier("d"),

                // switch expression -> block -> compound statement -> expression statement
                Statement.expression(.identifier("a")),
                // case 0 -> [pattern] -> block -> compound statement -> expression statement
                Statement.expression(.identifier("b")),
                // switch expression -> block -> compound statement -> expression statement
                Expression.identifier("a"),
                // case 0 -> [pattern] -> block -> compound statement -> expression statement -> expression
                Expression.identifier("b"),
            ]
        )
        */
    }

    func testDefer() {
        assertStatement(
            .defer([
                .expression(.identifier("a")),
                .expression(.identifier("b")),
            ]),
            iteratesAs: [
                Statement.defer([
                    .expression(.identifier("a")),
                    .expression(.identifier("b")),
                ]),
                Statement.compound([
                    .expression(.identifier("a")),
                    .expression(.identifier("b")),
                ]),
                Statement.expression(.identifier("a")),
                Statement.expression(.identifier("b")),
                Expression.identifier("a"),
                Expression.identifier("b"),
            ]
        )
    }

    func testReturn() {
        assertStatement(.return(nil), iteratesAs: [Statement.return(nil)])
    }

    func testReturnInspectingBlocks() {
        assertStatement(
            .return(makeBlock("a")),
            inspectingBlocks: true,
            iteratesAs: [
                Statement.return(makeBlock("a")),
                makeBlock(),
                Statement.compound([Statement.expression(.identifier("a"))]),
                Statement.expression(.identifier("a")),
                Expression.identifier("a"),
            ]
        )
    }

    func testBreak() {
        assertStatement(.break(), iteratesAs: [Statement.break()])
    }

    func testContinue() {
        assertStatement(.continue(), iteratesAs: [Statement.continue()])
    }

    func testFallthourh() {
        assertStatement(.fallthrough, iteratesAs: [Statement.fallthrough])
    }

    func testVariableDeclarationsNotInspectingBlocks() {
        assertStatement(
            Statement.variableDeclarations([
                StatementVariableDeclaration(
                    identifier: "a",
                    type: .void,
                    ownership: .strong,
                    isConstant: false,
                    initialization: makeBlock("a")
                )
            ]),
            iteratesAs: [
                Statement.variableDeclarations([
                    StatementVariableDeclaration(
                        identifier: "a",
                        type: .void,
                        ownership: .strong,
                        isConstant: false,
                        initialization: makeBlock("a")
                    )
                ]),
                StatementVariableDeclaration(
                    identifier: "a",
                    type: .void,
                    ownership: .strong,
                    isConstant: false,
                    initialization: makeBlock("a")
                ),
                makeBlock("a"),
            ]
        )
    }

    func testVariableDeclarationsInspectingBlocks() {
        assertStatement(
            Statement.variableDeclarations([
                StatementVariableDeclaration(
                    identifier: "a",
                    type: .void,
                    ownership: .strong,
                    isConstant: false,
                    initialization: makeBlock("a")
                )
            ]),
            inspectingBlocks: true,
            iteratesAs: [
                Statement.variableDeclarations([
                    StatementVariableDeclaration(
                        identifier: "a",
                        type: .void,
                        ownership: .strong,
                        isConstant: false,
                        initialization: makeBlock("a")
                    )
                ]),
                StatementVariableDeclaration(
                    identifier: "a",
                    type: .void,
                    ownership: .strong,
                    isConstant: false,
                    initialization: makeBlock("a")
                ),
                makeBlock("a"),
                Statement.compound([.expression(.identifier("a"))]),
                Statement.expression(.identifier("a")),
                Expression.identifier("a"),
            ]
        )
    }

    func testCastExpression() {
        assertExpression(
            .cast(makeBlock(), type: .void),
            inspectingBlocks: true,
            iteratesAs: [
                Expression.cast(makeBlock(), type: .void),
                makeBlock(),
                Statement.compound([.expression(.identifier("a"))]),
                Statement.expression(.identifier("a")),
                Expression.identifier("a"),
            ]
        )
    }

    func testUnaryExpression() {
        assertExpression(
            .unary(op: .negate, makeBlock("a")),
            inspectingBlocks: true,
            iteratesAs: [
                Expression.unary(op: .negate, makeBlock("a")),
                makeBlock(),
                Statement.compound([.expression(.identifier("a"))]),
                Statement.expression(.identifier("a")),
                Expression.identifier("a"),
            ]
        )
    }

    func testPrefixExpression() {
        assertExpression(
            .prefix(op: .negate, makeBlock("a")),
            inspectingBlocks: true,
            iteratesAs: [
                Expression.prefix(op: .negate, makeBlock("a")),
                makeBlock(),
                Statement.compound([.expression(.identifier("a"))]),
                Statement.expression(.identifier("a")),
                Expression.identifier("a"),
            ]
        )
    }

    func testPostfixSubscriptExpression() {
        assertExpression(
            makeBlock().sub(makeBlock("b")),
            inspectingBlocks: true,
            iteratesAs: [
                makeBlock().sub(makeBlock("b")),
                makeBlock(),
                makeBlock("b"),

                Statement.compound([.expression(.identifier("a"))]),
                Statement.compound([.expression(.identifier("b"))]),

                Statement.expression(.identifier("a")),
                Statement.expression(.identifier("b")),

                Expression.identifier("a"),
                Expression.identifier("b"),
            ]
        )
    }

    func testPostfixFunctionCallExpression() {
        assertExpression(
            makeBlock("a").call([.unlabeled(makeBlock("b"))]),
            inspectingBlocks: true,
            iteratesAs: [
                makeBlock("a").call([.unlabeled(makeBlock("b"))]),
                makeBlock(),
                makeBlock("b"),

                Statement.compound([.expression(.identifier("a"))]),
                Statement.compound([.expression(.identifier("b"))]),

                Statement.expression(.identifier("a")),
                Statement.expression(.identifier("b")),

                Expression.identifier("a"),
                Expression.identifier("b"),
            ]
        )
    }

    func testParensExpression() {
        assertExpression(
            .parens(makeBlock("a")),
            inspectingBlocks: true,
            iteratesAs: [
                Expression.parens(makeBlock("a")),
                makeBlock(),
                Statement.compound([.expression(.identifier("a"))]),
                Statement.expression(.identifier("a")),
                Expression.identifier("a"),
            ]
        )
    }

    func testArrayLiteralExpression() {
        assertExpression(
            .arrayLiteral([makeBlock(), makeBlock("b")]),
            inspectingBlocks: true,
            iteratesAs: [
                Expression.arrayLiteral([makeBlock(), makeBlock("b")]),
                makeBlock(),
                makeBlock("b"),

                Statement.compound([.expression(.identifier("a"))]),
                Statement.compound([.expression(.identifier("b"))]),

                Statement.expression(.identifier("a")),
                Statement.expression(.identifier("b")),

                Expression.identifier("a"),
                Expression.identifier("b"),
            ]
        )
    }

    func testDictionaryLiteralExpression() {
        assertExpression(
            .dictionaryLiteral([
                ExpressionDictionaryPair(key: makeBlock("a"), value: makeBlock("b"))
            ]),
            inspectingBlocks: false,
            iteratesAs: [
                Expression.dictionaryLiteral([
                    ExpressionDictionaryPair(key: makeBlock(), value: makeBlock("b"))
                ]),
                makeBlock(),
                makeBlock("b"),
            ]
        )

        assertExpression(
            .dictionaryLiteral([
                ExpressionDictionaryPair(key: makeBlock(), value: makeBlock("b"))
            ]),
            inspectingBlocks: true,
            iteratesAs: [
                Expression.dictionaryLiteral([
                    ExpressionDictionaryPair(key: makeBlock(), value: makeBlock("b"))
                ]),

                makeBlock(),
                makeBlock("b"),

                Statement.compound([.expression(.identifier("a"))]),
                Statement.compound([.expression(.identifier("b"))]),

                Statement.expression(.identifier("a")),
                Statement.expression(.identifier("b")),

                Expression.identifier("a"),
                Expression.identifier("b"),
            ]
        )
    }

    func testTernaryExpression() {
        assertExpression(
            .ternary(
                makeBlock("a"),
                true: makeBlock("b"),
                false: makeBlock("c")
            ),
            inspectingBlocks: true,
            iteratesAs: [
                Expression.ternary(
                    makeBlock("a"),
                    true: makeBlock("b"),
                    false: makeBlock("c")
                ),

                makeBlock(),
                makeBlock("b"),
                makeBlock("c"),

                Statement.compound([.expression(.identifier("a"))]),
                Statement.compound([.expression(.identifier("b"))]),
                Statement.compound([.expression(.identifier("c"))]),

                Statement.expression(.identifier("a")),
                Statement.expression(.identifier("b")),
                Statement.expression(.identifier("c")),

                Expression.identifier("a"),
                Expression.identifier("b"),
                Expression.identifier("c"),
            ]
        )
    }

    /// When visiting expressions within blocks, enqueue them such that they happen
    /// only after expressions within the depth the block where visited.
    /// This allows the search to occur in a more controller breadth-first manner.
    func testStatementVisitOrder() {
        assertStatement(
            .expressions([
                .identifier("a"),
                .block(parameters: [], return: .void, body: [.expression(.identifier("b"))]),
                .identifier("c"),
            ]),
            inspectingBlocks: true,
            iteratesAs: [
                Statement.expressions([
                    .identifier("a"),
                    .block(parameters: [], return: .void, body: [.expression(.identifier("b"))]),
                    .identifier("c"),
                ]),
                Expression.identifier("a"),
                Expression.block(
                    parameters: [],
                    return: .void,
                    body: [.expression(.identifier("b"))]
                ),
                Expression.identifier("c"),
                Statement.compound([.expression(.identifier("b"))]),
                Statement.expression(.identifier("b")),
                Expression.identifier("b"),
            ]
        )

        // Test with block inspection off, just in case.
        assertStatement(
            .expressions([
                .identifier("a"),
                .block(parameters: [], return: .void, body: [.expression(.identifier("b"))]),
                .identifier("c"),
            ]),
            inspectingBlocks: false,
            iteratesAs: [
                Statement.expressions([
                    .identifier("a"),
                    .block(parameters: [], return: .void, body: [.expression(.identifier("b"))]),
                    .identifier("c"),
                ]),
                Expression.identifier("a"),
                Expression.block(
                    parameters: [],
                    return: .void,
                    body: [.expression(.identifier("b"))]
                ),
                Expression.identifier("c"),
            ]
        )
    }

    func testLocalFunctionStatement_inspectBlocksFalse() {
        assertStatement(
            .localFunction(
                signature: FunctionSignature(name: "f"),
                body: [
                    .expression(.identifier("a")),
                    .expression(.identifier("b")),
                ]
            ),
            inspectingBlocks: false,
            iteratesAs: [
                Statement.localFunction(
                    signature: FunctionSignature(name: "f"),
                    body: [
                        .expression(.identifier("a")),
                        .expression(.identifier("b")),
                    ]
                )
            ]
        )
    }

    func testLocalFunctionStatement_inspectBlocksTrue() {
        assertStatement(
            .localFunction(
                signature: FunctionSignature(name: "f"),
                body: [
                    .expression(.identifier("a")),
                    .expression(.identifier("b")),
                ]
            ),
            inspectingBlocks: true,
            iteratesAs: [
                Statement.localFunction(
                    signature: FunctionSignature(name: "f"),
                    body: [
                        .expression(.identifier("a")),
                        .expression(.identifier("b")),
                    ]
                ),
                Statement.compound([
                    .expression(.identifier("a")),
                    .expression(.identifier("b")),
                ]),
                Statement.expression(.identifier("a")),
                Statement.expression(.identifier("b")),
                Expression.identifier("a"),
                Expression.identifier("b"),
            ]
        )
    }

    func testThrowStatement() {
        assertStatement(
            .throw(.identifier("a")),
            iteratesAs: [
                Statement.throw(.identifier("a")),
                Expression.identifier("a"),
            ]
        )
    }
}

extension SyntaxNodeIteratorTests {
    typealias LazyIteratorElement<T: SyntaxNode> = ((T) -> SyntaxNode?, file: StaticString, line: UInt)
    typealias IteratorElement = (node: SyntaxNode, file: StaticString, line: UInt)

    /// Creates a test block which contains only a single statement containing an
    /// `Expression.identifier()` case with a given input value as the identifier.
    ///
    /// Used in tests to generate an expression that contains statements, to test
    /// iterating statements through expressions.
    private func makeBlock(_ identifier: String = "a") -> BlockLiteralExpression {
        return .block(
            parameters: [],
            return: .void,
            body: [.expression(.identifier(identifier))]
        )
    }

    private func assertExpression(
        _ source: Expression,
        inspectingBlocks: Bool = false,
        iteratesAs expected: [SyntaxNode],
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let iterator =
            SyntaxNodeIterator(
                expression: source,
                inspectBlocks: inspectingBlocks
            )

        assertIterator(iterator: iterator, iteratesAs: expected, file: file, line: line)
    }

    private func assertStatement(
        _ source: Statement,
        inspectingBlocks: Bool = false,
        iteratesAs expected: [SyntaxNode],
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let iterator =
            SyntaxNodeIterator(
                statement: source,
                inspectBlocks: inspectingBlocks
            )

        assertIterator(iterator: iterator, iteratesAs: expected, file: file, line: line)
    }

    private func assertNodeLazily<T: SyntaxNode>(
        _ source: T,
        inspectingBlocks: Bool = false,
        iteratesAsKeyPaths expected: [LazyIteratorElement<T>],
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let iterator =
            SyntaxNodeIterator(
                node: source,
                inspectBlocks: inspectingBlocks
            )

        assertIterator(
            iterator: iterator,
            object: source,
            iteratesLazilyAs: expected,
            file: file,
            line: line
        )
    }

    private func assertNode(
        _ source: SyntaxNode,
        inspectingBlocks: Bool = false,
        iteratesAs expected: [IteratorElement],
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let iterator =
            SyntaxNodeIterator(
                node: source,
                inspectBlocks: inspectingBlocks
            )

        assertIterator(
            iterator: iterator,
            iteratesAs: expected,
            file: file,
            line: line
        )
    }
    
    private func assertIterator(
        iterator: SyntaxNodeIterator,
        iteratesAs expected: [SyntaxNode],
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        var list: [IteratorElement] = []

        for node in expected {
            list.append((
                node: node,
                file: file,
                line: line
            ))
        }

        assertIterator(
            iterator: iterator,
            iteratesAs: list,
            file: file,
            line: line
        )
    }

    private func assertIterator<T: SyntaxNode>(
        iterator: SyntaxNodeIterator,
        object: T,
        iteratesLazilyAs expectedLazy: [LazyIteratorElement<T>],
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        var expectedList: [IteratorElement] = []

        for (i, expLazy) in expectedLazy.enumerated() {
            guard let element = expLazy.0(object) else {
                XCTFail(
                    "Unexpected nil element iterator at index #\(i)",
                    file: expLazy.file,
                    line: expLazy.line
                )
                return
            }

            expectedList.append((element, expLazy.file, expLazy.line))
        }

        assertIterator(
            iterator: iterator,
            iteratesAs: expectedList,
            file: file,
            line: line
        )
    }

    private func assertIterator(
        iterator: SyntaxNodeIterator,
        iteratesAs expectedList: [IteratorElement],
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let resultList = Array(AnyIterator(iterator))

        for (i, (expected, actual)) in zip(expectedList, resultList).enumerated() {
            switch (expected.node, actual) {
            case (let exp as Statement, let act as Statement):
                if exp == act { continue }

                assertStatementsEqual(
                    actual: act,
                    expected: exp,
                    messageHeader: "Expected index \(i) of iterator to be:",
                    printTypes: true,
                    file: expected.file,
                    line: expected.line
                )
            
            case (let exp as Expression, let act as Expression):
                if exp == act { continue }

                assertExpressionsEqual(
                    actual: act,
                    expected: exp,
                    messageHeader: "Expected index \(i) of iterator to be:",
                    printTypes: true,
                    file: expected.file,
                    line: expected.line
                )
            
            case (let exp as CatchBlock, let act as CatchBlock):
                if exp == act { continue }

                if exp.pattern != act.pattern {
                    XCTFail(
                        """
                        Expected index \(i) of iterator are catch blocks with different patterns:

                        expected: \(exp.pattern?.description ?? "<nil>")
                        found: \(act.pattern?.description ?? "<nil>")
                        """,
                        file: expected.file,
                        line: expected.line
                    )
                } else if exp.body != act.body {
                    assertStatementsEqual(
                        actual: act.body,
                        expected: exp.body,
                        messageHeader: "Expected body of catch block at index \(i) of iterator to be:",
                    printTypes: true,
                        file: expected.file,
                        line: expected.line
                    )
                }
            
            case (let exp as StatementVariableDeclaration, let act as StatementVariableDeclaration):
                if exp == act { continue }

                XCTFail(
                    """
                    Expected index \(i) of iterator are unequal variable declarations:

                    expected: \(dumpNode(exp))
                    found: \(dumpNode(act))
                    """,
                    file: expected.file,
                    line: expected.line
                )
            
            case (let exp as SwitchCase, let act as SwitchCase):
                if exp == act { continue }

                XCTFail(
                    """
                    Expected index \(i) of iterator are unequal switch cases:

                    Expected:
                    
                    \(dumpNode(exp))

                    Found:
                    
                    \(dumpNode(act))
                    """,
                    file: expected.file,
                    line: expected.line
                )
            
            case (let exp as SwitchDefaultCase, let act as SwitchDefaultCase):
                if exp == act { continue }

                XCTFail(
                    """
                    Expected index \(i) of iterator are unequal switch default cases:

                    Expected:
                    
                    \(dumpNode(exp))

                    Found:
                    
                    \(dumpNode(act))
                    """,
                    file: expected.file,
                    line: expected.line
                )

            default:
                XCTFail(
                    """
                    Items at index \(i) of type \(type(of: expected.node)) and \(type(of: actual)) \
                    cannot be compared.
                    """,
                    file: expected.file,
                    line: expected.line
                )
            }

            dumpFullIterators(expectedList, resultList, differenceIndex: i)

            return
        }

        if expectedList.count != resultList.count {
            XCTFail(
                """
                Mismatched result count: Expected \(expectedList.count) item(s) but \
                received \(resultList.count)
                """,
                file: file,
                line: expectedList.last?.line ?? line
            )
        }
    }

    func kp<T, S: SyntaxNode>(
        _ value: KeyPath<T, S>,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> LazyIteratorElement<T> {

        return ({ $0[keyPath: value] }, file, line)
    }

    func kp<T, S: SyntaxNode>(
        _ value: KeyPath<T, S?>,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> LazyIteratorElement<T> {

        return ({ $0[keyPath: value] }, file, line)
    }

    func el(
        _ value: SyntaxNode?,
        file: StaticString = #filePath,
        line: UInt = #line
    ) throws -> IteratorElement {
        
        guard let value = value else {
            throw Error.unexpectedNil
        }

        return (value, file, line)
    }
    
    func dumpFullIterators(
        _ expected: [IteratorElement],
        _ result: [SyntaxNode],
        differenceIndex: Int? = nil
    ) {
        
        print("Full iterators:")
        
        print("\nExpected:")
        dumpIterator(expected, differenceIndex: differenceIndex)
        
        print("\nActual:")
        dumpIterator(result, differenceIndex: differenceIndex)
    }

    func dumpIterator(_ sequence: [SyntaxNode], differenceIndex: Int? = nil) {
        for (i, node) in sequence.enumerated() {
            if i == differenceIndex {
                print("difference starts here => ", terminator: "")
            }
            print("#\(i) (<\(type(of: node))>): \(dumpNode(node))")
        }
    }

    func dumpIterator(_ sequence: [IteratorElement], differenceIndex: Int? = nil) {
        for (i, element) in sequence.enumerated() {
            if i == differenceIndex {
                print("difference starts here => ", terminator: "")
            }
            let node = element.0

            print("#\(i) (<\(type(of: node))>): \(dumpNode(node))")
        }
    }

    func dumpNode(_ node: SyntaxNode) -> String {
        let syntaxProducer = SwiftSyntaxProducer()

        switch node {
        case let node as Expression:
            return syntaxProducer.generateExpression(node).description

        case let stmt as Statement:
            return syntaxProducer.generateStatement(stmt).description

        case let catchBlock as CatchBlock:
            let body = syntaxProducer.generateStatement(catchBlock.body).description

            if let pattern = catchBlock.pattern {
                return "catch let \(pattern.description) \(body)"
            }

            return "catch \(body)"
        
        case let block as SwitchCase:
            let syntax = syntaxProducer.generateSwitchCase(block)

            return syntax.description
        
        case let block as SwitchDefaultCase:
            let syntax = syntaxProducer.generateSwitchDefaultCase(block)

            return syntax.description
        
        case let decl as StatementVariableDeclaration:
            var result = "\(decl.identifier): \(decl.type)"
            if let exp = decl.initialization {
                result += " = \(exp)"
            }

            return result

        default:
            return "<unknown SyntaxNode type \(type(of: node))>"
        }
    }

    private enum Error: Swift.Error {
        case unexpectedNil
    }
}
