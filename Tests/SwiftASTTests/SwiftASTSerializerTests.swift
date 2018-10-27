import XCTest

import SwiftAST
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
                        Expression.prefix(op: .subtract, .constant(0)):
                            Expression.sizeof(Expression.identifier("Int"))
                        ])
                )
                ]),
            Statement.semicolon,
            Statement.if(
                Expression.constant(true),
                body: [
                    Statement.return(nil)
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
                            Statement.return(Expression.constant(1))
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
                            
                        ]),
                    Statement.continue
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
                            
                            ])
                        ]),
                    Statement.break
                ]
            )
        ]
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try SwiftASTSerializer.encode(statement: stmt, encoder: encoder)
        let decoder = JSONDecoder()
        
        let decoded = try SwiftASTSerializer.decodeStatement(decoder: decoder, data: data)
        
        let writer = SwiftASTWriter(options: ASTWriterOptions.default,
                                    typeMapper: DefaultTypeMapper(),
                                    typeSystem: DefaultTypeSystem())
        
        let expBuffer = StringRewriterOutput()
        let resBuffer = StringRewriterOutput()
        writer.write(compoundStatement: stmt, into: expBuffer)
        writer.write(compoundStatement: (decoded as? CompoundStatement) ?? [decoded], into: resBuffer)
        
        XCTAssertEqual(
            stmt,
            decoded,
            """
            Expected:
            
            \(expBuffer.buffer)
            
            but received:
            
            \(resBuffer.buffer)
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
