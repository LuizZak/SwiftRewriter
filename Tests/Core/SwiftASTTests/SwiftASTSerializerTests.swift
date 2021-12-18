import XCTest

import SwiftAST
import WriterTargetOutput
@testable import SwiftSyntaxSupport
@testable import SwiftRewriterLib

class SwiftASTSerializerTests: XCTestCase {
    
    func testEncodeDecodeRoundtrip() throws {
        let stmt: CompoundStatement = [
            Statement.expression(
                Expression
                    .identifier("self")
                    .dot("member")
                    .assignment(op: .assign, rhs: .constant(0))
            ).labeled("exp"),
            Statement.expression(
                Expression.unknown(UnknownASTContext(context: "Context"))
            ),
            Statement.expression(
                Expression.ternary(
                    Expression.constant(true),
                    true: Expression.unary(op: .add, .constant("This")),
                    false: .constant("That")
                )
            ),
            Statement.unknown(UnknownASTContext(context: "Context")),
            Statement.do([
                Statement.expression(
                    Expression.dictionaryLiteral([
                        Expression.prefix(op: .subtract, .constant(.nil)):
                            Expression.sizeof(Expression.identifier("Int"))
                        ])
                )
            ]),
            Statement.if(
                Expression.constant(true),
                body: [
                    Statement.return(Expression.constant(1.0))
                ],
                else: [
                    Statement.return(Expression.constant(1))
                ]
            ),
            Statement.switch(
                Expression.parens(.constant("abc")).dot("def").sub(.constant(1)).call([Expression.constant(1)]),
                cases: [
                    SwitchCase(
                        patterns: [.expression(.constant("abc"))],
                        statements: [
                            Statement.return(Expression.constant(.rawConstant("raw_constant")))
                        ]
                    )
                ],
                default: nil
            ),
            Statement.while(
                Expression.arrayLiteral([.constant(0)]).sub(.constant(0)),
                body: [
                    Statement.for(
                        SwiftAST.Pattern.identifier("i"),
                        Expression.constant(0).binary(op: .openRange, rhs: .constant(100)),
                        body: [
                            Statement.continue(targetLabel: "label")
                        ]),
                    Statement.continue()
                ]),
            Statement.defer([
                Statement.fallthrough,
                Statement.variableDeclaration(identifier: "abc", type: .int, initialization: nil)
            ]),
            Statement.doWhile(
                Expression.cast(.constant(0), type: .int),
                body: [
                    Statement.expressions([
                        Expression.block(body: [
                                Statement.break(targetLabel: "label")
                            ])
                        ]),
                    Statement.break()
                ]
            ),
            Statement.expression(
                Expression.tuple([.constant(0), .constant(1)])
            ),
            Statement.expressions([
                Expression.selector(FunctionIdentifier(name: "f", argumentLabels: [nil, "b"])),
                Expression.selector("T", FunctionIdentifier(name: "f", argumentLabels: [nil, "b"])),
                Expression.selector(getter: "p"),
                Expression.selector("T", getter: "p"),
                Expression.selector(setter: "p"),
                Expression.selector("T", setter: "p"),
            ])
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
                .encode(expression: exp,
                        encoder: JSONEncoder(),
                        options: [])
        
        let encodedWithType =
            try SwiftASTSerializer
                .encode(expression: exp,
                        encoder: JSONEncoder(),
                        options: .encodeExpressionTypes)
        
        let decoded =
            try SwiftASTSerializer
                .decodeExpression(decoder: JSONDecoder(),
                                  data: encoded)
        
        let decodedWithType =
            try SwiftASTSerializer
                .decodeExpression(decoder: JSONDecoder(),
                                  data: encodedWithType)
        
        XCTAssertNil(decoded.resolvedType)
        XCTAssertEqual(decodedWithType.resolvedType, exp.resolvedType)
    }
    
    public func testEncodeExpressionTypeOnEncodeStatements() throws {
        let stmt = Statement.expression(Expression.identifier("a").typed(.int))
        
        let encoded =
            try SwiftASTSerializer
                .encode(statement: stmt,
                        encoder: JSONEncoder(),
                        options: [])
        
        let encodedWithType =
            try SwiftASTSerializer
                .encode(statement: stmt,
                        encoder: JSONEncoder(),
                        options: .encodeExpressionTypes)
        
        let decoded =
            try SwiftASTSerializer
                .decodeStatement(decoder: JSONDecoder(),
                                  data: encoded)
        
        let decodedWithType =
            try SwiftASTSerializer
                .decodeStatement(decoder: JSONDecoder(),
                                  data: encodedWithType)
        
        XCTAssertNil(decoded.asExpressions!.expressions[0].resolvedType)
        XCTAssertEqual(decodedWithType.asExpressions!.expressions[0].resolvedType,
                       stmt.asExpressions!.expressions[0].resolvedType)
    }
}
