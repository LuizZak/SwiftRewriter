import SwiftAST
import WriterTargetOutput
import XCTest

@testable import SwiftRewriterLib
@testable import SwiftSyntaxSupport

class SwiftASTSerializerTests: XCTestCase {

    func testEncodeDecodeRoundtrip() throws {
        let stmt: CompoundStatement = [
            .expression(
                .identifier("self")
                    .dot("member")
                    .assignment(op: .assign, rhs: .constant(0))
            ).labeled("exp"),
            .expression(
                .unknown(UnknownASTContext(context: "Context"))
            ),
            .expression(
                .ternary(
                    .constant(true),
                    true: .unary(op: .add, .constant("This")),
                    false: .constant("That")
                )
            ),
            .unknown(UnknownASTContext(context: "Context")),
            .do([
                .expression(
                    .dictionaryLiteral([
                        .prefix(op: .subtract, .constant(.nil)): .sizeof(.identifier("Int"))
                    ])
                )
            ]),
            .if(
                .typeCheck(.identifier("exp"), type: .string),
                body: [
                    .return(.constant(1.0)),
                    .throw(.identifier("Error").dot("error")),
                ],
                else: [
                    .return(.constant(1))
                ]
            ),
            .switch(
                .parens(.constant("abc")).dot("def").sub(.constant(1)).call([.constant(1)]),
                cases: [
                    SwitchCase(
                        patterns: [.expression(.constant("abc"))],
                        statements: [
                            .return(.constant(.rawConstant("raw_constant")))
                        ]
                    )
                ],
                default: nil
            ),
            .while(
                .arrayLiteral([.constant(0)]).sub(.constant(0)),
                body: [
                    .for(
                        .identifier("i"),
                        .constant(0).binary(op: .openRange, rhs: .constant(100)),
                        body: [
                            .continue(targetLabel: "label")
                        ]
                    ),
                    .continue(),
                ]
            ),
            .defer([
                .fallthrough,
                .variableDeclaration(identifier: "abc", type: .int, initialization: nil),
            ]),
            .repeatWhile(
                .cast(.constant(0), type: .int),
                body: [
                    .expressions([
                        .block(body: [
                            .break(targetLabel: "label")
                        ])
                    ]),
                    .break(),
                ]
            ),
            .expression(
                .tuple([.constant(0), .constant(1)])
            ),
            .expressions([
                .selector(FunctionIdentifier(name: "f", argumentLabels: [nil, "b"])),
                .selector("T", FunctionIdentifier(name: "f", argumentLabels: [nil, "b"])),
                .selector(getter: "p"),
                .selector("T", getter: "p"),
                .selector(setter: "p"),
                .selector("T", setter: "p"),
            ]),
            .localFunction(
                identifier: "localFunction",
                parameters: [.init(name: "a", type: .float)],
                returnType: .bool,
                body: [
                    .expression(.binary(lhs: .identifier("a"), op: .lessThan, rhs: .constant(2)))
                ]
            ),
            .expression(
                .try(.identifier("a"))
            )
        ]

        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try SwiftASTSerializer.encode(statement: stmt, encoder: encoder)
        let decoder = JSONDecoder()

        let decoded = try SwiftASTSerializer.decodeStatement(decoder: decoder, data: data)

        let writer = SwiftSyntaxProducer()

        let expBuffer = writer.generateStatement(stmt).description
        let resBuffer = writer.generateStatement((decoded as? CompoundStatement) ?? [decoded]).description

        XCTAssertEqual(
            stmt,
            decoded,
            """
            Expected:

            \(expBuffer)

            but received:

            \(resBuffer)
            """
        )
    }

    public func testEncodeExpressionType() throws {
        let exp = Expression.identifier("a").typed(.int)

        let encoded =
            try SwiftASTSerializer
            .encode(
                expression: exp,
                encoder: JSONEncoder(),
                options: []
            )

        let encodedWithType =
            try SwiftASTSerializer
            .encode(
                expression: exp,
                encoder: JSONEncoder(),
                options: .encodeExpressionTypes
            )

        let decoded =
            try SwiftASTSerializer
            .decodeExpression(
                decoder: JSONDecoder(),
                data: encoded
            )

        let decodedWithType =
            try SwiftASTSerializer
            .decodeExpression(
                decoder: JSONDecoder(),
                data: encodedWithType
            )

        XCTAssertNil(decoded.resolvedType)
        XCTAssertEqual(decodedWithType.resolvedType, exp.resolvedType)
    }

    public func testEncodeExpressionTypeOnEncodeStatements() throws {
        let stmt = Statement.expression(.identifier("a").typed(.int))

        let encoded =
            try SwiftASTSerializer
            .encode(
                statement: stmt,
                encoder: JSONEncoder(),
                options: []
            )

        let encodedWithType =
            try SwiftASTSerializer
            .encode(
                statement: stmt,
                encoder: JSONEncoder(),
                options: .encodeExpressionTypes
            )

        let decoded =
            try SwiftASTSerializer
            .decodeStatement(
                decoder: JSONDecoder(),
                data: encoded
            )

        let decodedWithType =
            try SwiftASTSerializer
            .decodeStatement(
                decoder: JSONDecoder(),
                data: encodedWithType
            )

        XCTAssertNil(decoded.asExpressions!.expressions[0].resolvedType)
        XCTAssertEqual(
            decodedWithType.asExpressions!.expressions[0].resolvedType,
            stmt.asExpressions!.expressions[0].resolvedType
        )
    }
}
