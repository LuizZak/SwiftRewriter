import Foundation

public final class SwiftASTSerializer {
    internal struct StatementContainer: Codable {
        var kind: StatementKind
        var statement: Statement
        
        init(statement: Statement) throws {
            let kind: StatementKind
            
            switch statement {
            case is BreakStatement:
                kind = .break
                
            case is CompoundStatement:
                kind = .compound
                
            case is ContinueStatement:
                kind = .continue
                
            case is DeferStatement:
                kind = .defer
                
            case is DoStatement:
                kind = .do
                
            case is DoWhileStatement:
                kind = .doWhile
                
            case is ExpressionsStatement:
                kind = .expressions
                
            case is FallthroughStatement:
                kind = .fallthrough
                
            case is ForStatement:
                kind = .for
                
            case is IfStatement:
                kind = .if
                
            case is ReturnStatement:
                kind = .return
                
            case is SwitchStatement:
                kind = .switch
                
            case is UnknownStatement:
                kind = .unknown
                
            case is VariableDeclarationsStatement:
                kind = .varDecl
                
            case is WhileStatement:
                kind = .while
                
            default:
                throw Error.unknownStatementType(type(of: statement))
            }
            
            self.kind = kind
            self.statement = statement
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            kind = try container.decode(StatementKind.self, forKey: .kind)
            
            switch kind {
            case .if:
                statement = try container.decode(IfStatement.self, forKey: .statement)
            case .while:
                statement = try container.decode(WhileStatement.self, forKey: .statement)
            case .doWhile:
                statement = try container.decode(DoWhileStatement.self, forKey: .statement)
            case .compound:
                statement = try container.decode(CompoundStatement.self, forKey: .statement)
            case .do:
                statement = try container.decode(DoStatement.self, forKey: .statement)
            case .defer:
                statement = try container.decode(DeferStatement.self, forKey: .statement)
            case .switch:
                statement = try container.decode(SwitchStatement.self, forKey: .statement)
            case .for:
                statement = try container.decode(ForStatement.self, forKey: .statement)
            case .expressions:
                statement = try container.decode(ExpressionsStatement.self, forKey: .statement)
            case .varDecl:
                statement = try container.decode(VariableDeclarationsStatement.self, forKey: .statement)
            case .return:
                statement = try container.decode(ReturnStatement.self, forKey: .statement)
            case .break:
                statement = try container.decode(BreakStatement.self, forKey: .statement)
            case .fallthrough:
                statement = try container.decode(FallthroughStatement.self, forKey: .statement)
            case .continue:
                statement = try container.decode(ContinueStatement.self, forKey: .statement)
            case .unknown:
                statement = try container.decode(UnknownStatement.self, forKey: .statement)
            }
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            try container.encode(kind, forKey: .kind)
            try container.encode(statement, forKey: .statement)
        }

        private enum CodingKeys: String, CodingKey {
            case kind
            case statement
        }
    }
    
    internal struct ExpressionContainer: Codable {
        var kind: ExpressionKind
        var expression: Expression
        
        init(expression: Expression) throws {
            let kind: ExpressionKind
            
            switch expression {
            case is ArrayLiteralExpression:
                kind = .arrayLiteral
                
            case is AssignmentExpression:
                kind = .assignment
                
            case is BinaryExpression:
                kind = .binary
                
            case is BlockLiteralExpression:
                kind = .block
                
            case is CastExpression:
                kind = .cast
                
            case is ConstantExpression:
                kind = .constant
                
            case is DictionaryLiteralExpression:
                kind = .dictionaryLiteral
                
            case is IdentifierExpression:
                kind = .identifier
                
            case is ParensExpression:
                kind = .parens
                
            case is PostfixExpression:
                kind = .postfix
                
            case is PrefixExpression:
                kind = .prefix
                
            case is SizeOfExpression:
                kind = .sizeOf
                
            case is TernaryExpression:
                kind = .ternary
                
            case is UnaryExpression:
                kind = .unary
                
            case is TupleExpression:
                kind = .tuple
                
            case is SelectorExpression:
                kind = .selector
                
            case is UnknownExpression:
                kind = .unknown
                
            default:
                throw Error.unknownExpressionType(type(of: expression))
            }
            
            self.kind = kind
            self.expression = expression
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            kind = try container.decode(ExpressionKind.self, forKey: .kind)
            
            switch kind {
                
            case .arrayLiteral:
                expression = try container.decode(ArrayLiteralExpression.self, forKey: .expression)
                
            case .assignment:
                expression = try container.decode(AssignmentExpression.self, forKey: .expression)
                
            case .binary:
                expression = try container.decode(BinaryExpression.self, forKey: .expression)
                
            case .block:
                expression = try container.decode(BlockLiteralExpression.self, forKey: .expression)
                
            case .cast:
                expression = try container.decode(CastExpression.self, forKey: .expression)
                
            case .constant:
                expression = try container.decode(ConstantExpression.self, forKey: .expression)
                
            case .dictionaryLiteral:
                expression = try container.decode(DictionaryLiteralExpression.self, forKey: .expression)
                
            case .identifier:
                expression = try container.decode(IdentifierExpression.self, forKey: .expression)
                
            case .parens:
                expression = try container.decode(ParensExpression.self, forKey: .expression)
                
            case .postfix:
                expression = try container.decode(PostfixExpression.self, forKey: .expression)
                
            case .prefix:
                expression = try container.decode(PrefixExpression.self, forKey: .expression)
                
            case .sizeOf:
                expression = try container.decode(SizeOfExpression.self, forKey: .expression)
                
            case .ternary:
                expression = try container.decode(TernaryExpression.self, forKey: .expression)
                
            case .unary:
                expression = try container.decode(UnaryExpression.self, forKey: .expression)
                
            case .tuple:
                expression = try container.decode(TupleExpression.self, forKey: .expression)
                
            case .selector:
                expression = try container.decode(SelectorExpression.self, forKey: .expression)
                
            case .unknown:
                expression = try container.decode(UnknownExpression.self, forKey: .expression)
            }
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            try container.encode(kind, forKey: .kind)
            try container.encode(expression, forKey: .expression)
        }
        
        private enum CodingKeys: String, CodingKey {
            case kind
            case expression
        }
    }
    
    internal enum ExpressionKind: String, Codable {
        case arrayLiteral
        case assignment
        case binary
        case block
        case cast
        case constant
        case dictionaryLiteral
        case identifier
        case parens
        case postfix
        case prefix
        case sizeOf
        case ternary
        case unary
        case tuple
        case selector
        case unknown
    }
    
    internal enum StatementKind: String, Codable {
        case `break`
        case `compound`
        case `continue`
        case `defer`
        case `do`
        case doWhile
        case expressions
        case `fallthrough`
        case `for`
        case `if`
        case `return`
        case `switch`
        case unknown
        case varDecl
        case `while`
    }
    
    public enum Error: Swift.Error {
        case unknownStatementType(Statement.Type)
        case unknownExpressionType(Expression.Type)
        case unexpectedStatementType(Statement.Type)
        case unexpectedExpressionType(Expression.Type)
    }
}

public extension SwiftASTSerializer {
    
    static func encode(statement: Statement,
                       encoder: JSONEncoder,
                       options: SerializationOptions = []) throws -> Data {
        
        let container = try SwiftASTSerializer.StatementContainer(statement: statement)
        
        encoder.userInfo.merge(optionsToUserInfo([options]), uniquingKeysWith: { $1 })
        
        return try encoder.encode(container)
    }
    
    static func decodeStatement(decoder: JSONDecoder, data: Data) throws -> Statement {
        let container = try decoder.decode(SwiftASTSerializer.StatementContainer.self, from: data)
        return container.statement
    }
    
    static func encode(expression: Expression,
                       encoder: JSONEncoder,
                       options: SerializationOptions = []) throws -> Data {
        
        let container = try SwiftASTSerializer.ExpressionContainer(expression: expression)
        
        encoder.userInfo.merge(optionsToUserInfo([options]), uniquingKeysWith: { $1 })
        
        return try encoder.encode(container)
    }
    
    static func decodeExpression(decoder: JSONDecoder, data: Data) throws -> Expression {
        let container = try decoder.decode(SwiftASTSerializer.ExpressionContainer.self, from: data)
        return container.expression
    }
    
    private static func optionsToUserInfo(_ options: SerializationOptions) -> [CodingUserInfoKey: Any] {
        var dict: [CodingUserInfoKey: Any] = [:]
        
        if options.contains(.encodeExpressionTypes) {
            dict[SerializationOptions._encodeExpressionTypes] = true
        }
        
        return dict
    }
}
