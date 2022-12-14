import Foundation

public final class SwiftASTSerializer {
    internal struct StatementContainer: Codable {
        var kind: StatementKind
        
        init(statement: Statement) throws {
            guard let stmtKind = StatementKind(statement) else {
                throw Error.unexpectedStatementType(type(of: statement))
            }

            self.kind = stmtKind
        }
    }
    
    internal struct ExpressionContainer: Codable {
        var kind: ExpressionKind
        
        init(expression: Expression) throws {
            guard let expKind = ExpressionKind(expression) else {
                throw Error.unexpectedExpressionType(type(of: expression))
            }

            self.kind = expKind
        }
    }
    
    public enum Error: Swift.Error {
        case unknownStatementType(Statement.Type)
        case unknownExpressionType(Expression.Type)
        case unexpectedStatementType(Statement.Type)
        case unexpectedExpressionType(Expression.Type)
    }
}

public extension SwiftASTSerializer {
    
    static func encode(
        statement: Statement,
        encoder: JSONEncoder,
        options: SerializationOptions = []
    ) throws -> Data {
        
        let container = try SwiftASTSerializer.StatementContainer(statement: statement)
        
        encoder.userInfo.merge(optionsToUserInfo([options]), uniquingKeysWith: { $1 })
        
        return try encoder.encode(container)
    }
    
    static func decodeStatement(decoder: JSONDecoder, data: Data) throws -> Statement {
        let container = try decoder.decode(SwiftASTSerializer.StatementContainer.self, from: data)
        return container.kind.statement
    }
    
    static func encode(
        expression: Expression,
        encoder: JSONEncoder,
        options: SerializationOptions = []
    ) throws -> Data {
        
        let container = try SwiftASTSerializer.ExpressionContainer(expression: expression)
        
        encoder.userInfo.merge(optionsToUserInfo([options]), uniquingKeysWith: { $1 })
        
        return try encoder.encode(container)
    }
    
    static func decodeExpression(decoder: JSONDecoder, data: Data) throws -> Expression {
        let container = try decoder.decode(SwiftASTSerializer.ExpressionContainer.self, from: data)
        return container.kind.expression
    }
    
    private static func optionsToUserInfo(_ options: SerializationOptions) -> [CodingUserInfoKey: Any] {
        var dict: [CodingUserInfoKey: Any] = [:]
        
        if options.contains(.encodeExpressionTypes) {
            dict[SerializationOptions._encodeExpressionTypes] = true
        }
        
        return dict
    }
}
