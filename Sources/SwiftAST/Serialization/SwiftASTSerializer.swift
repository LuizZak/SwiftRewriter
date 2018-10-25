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
                
            case is SemicolonStatement:
                kind = .semicolon
                
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
            let container = try decoder.container(keyedBy: StatementContainerKeys.self)
            
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
            case .semicolon:
                statement = try container.decode(SemicolonStatement.self, forKey: .statement)
            case .unknown:
                statement = try container.decode(UnknownStatement.self, forKey: .statement)
            }
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: StatementContainerKeys.self)
            
            try container.encode(kind, forKey: .kind)
            try container.encode(statement, forKey: .statement)
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
                
            case is UnknownExpression:
                kind = .unknown
                
            default:
                throw Error.unknownExpressionType(type(of: expression))
            }
            
            self.kind = kind
            self.expression = expression
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: ExpressionContainerKeys.self)
            
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
                
            case .unknown:
                expression = try container.decode(UnknownExpression.self, forKey: .expression)
            }
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: ExpressionContainerKeys.self)
            
            try container.encode(kind, forKey: .kind)
            try container.encode(expression, forKey: .expression)
        }
    }
    
    internal enum StatementContainerKeys: String, CodingKey {
        case kind
        case statement
    }
    
    internal enum ExpressionContainerKeys: String, CodingKey {
        case kind
        case expression
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
        case semicolon
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
    
    public static func encode(statement: Statement, encoder: JSONEncoder) throws -> Data {
        let container = try SwiftASTSerializer.StatementContainer(statement: statement)
        return try encoder.encode(container)
    }
    
    public static func decodeStatement(decoder: JSONDecoder, data: Data) throws -> Statement {
        let container = try decoder.decode(SwiftASTSerializer.StatementContainer.self, from: data)
        return container.statement
    }
    
}

// MARK: - Encoding/DecodingContainer Statement Extensions

public extension UnkeyedDecodingContainer {
    
    public mutating func decodeStatement<S: Statement>(_ type: S.Type = S.self) throws -> S {
        let container = try self.decode(SwiftASTSerializer.StatementContainer.self)
        
        if let s = container.statement as? S {
            return s
        }
        
        throw SwiftASTSerializer.Error.unexpectedStatementType(Swift.type(of: container.statement))
    }
    
    public mutating func decodeStatementIfPresent<S: Statement>(_ type: S.Type = S.self) throws -> S? {
        guard let container = try self.decodeIfPresent(SwiftASTSerializer.StatementContainer.self) else {
            return nil
        }
        
        if let s = container.statement as? S {
            return s
        }
        
        throw SwiftASTSerializer.Error.unexpectedStatementType(Swift.type(of: container.statement))
    }
    
}

public extension KeyedDecodingContainerProtocol {
    
    public func decodeStatement<S: Statement>(_ type: S.Type = S.self, forKey key: Key) throws -> S {
        let container = try self.decode(SwiftASTSerializer.StatementContainer.self, forKey: key)
        
        if let s = container.statement as? S {
            return s
        }
        
        throw SwiftASTSerializer.Error.unexpectedStatementType(Swift.type(of: container.statement))
    }
    
    public func decodeStatements(forKey key: Key) throws -> [Statement] {
        var nested = try self.nestedUnkeyedContainer(forKey: key)
        
        var stmts: [Statement] = []
        
        while !nested.isAtEnd {
            stmts.append(try nested.decodeStatement(Statement.self))
        }
        
        return stmts
    }
    
    public func decodeStatementIfPresent<S: Statement>(_ type: S.Type = S.self, forKey key: Key) throws -> S? {
        guard let container = try self.decodeIfPresent(SwiftASTSerializer.StatementContainer.self, forKey: key) else {
            return nil
        }
        
        if let s = container.statement as? S {
            return s
        }
        
        throw SwiftASTSerializer.Error.unexpectedStatementType(Swift.type(of: container.statement))
    }
    
    public func decodeStatementsIfPresent(forKey key: Key) throws -> [Statement]? {
        if !self.contains(key) {
            return nil
        }
        
        var nested = try self.nestedUnkeyedContainer(forKey: key)
        
        var stmts: [Statement] = []
        
        while !nested.isAtEnd {
            stmts.append(try nested.decodeStatement(Statement.self))
        }
        
        return stmts
    }
}

public extension UnkeyedEncodingContainer {
    
    public mutating func encodeStatement(_ stmt: Statement) throws {
        let container = try SwiftASTSerializer.StatementContainer(statement: stmt)
        
        try self.encode(container)
    }
    
    public mutating func encodeStatementIfPresent(_ stmt: Statement?) throws {
        guard let stmt = stmt else {
            return
        }
        
        let container = try SwiftASTSerializer.StatementContainer(statement: stmt)
        
        try self.encode(container)
    }
    
}

public extension KeyedEncodingContainerProtocol {
    
    public mutating func encodeStatement(_ stmt: Statement, forKey key: Key) throws {
        let container = try SwiftASTSerializer.StatementContainer(statement: stmt)
        
        try self.encode(container, forKey: key)
    }
    
    public mutating func encodeStatements(_ stmts: [Statement], forKey key: Key) throws {
        var nested = self.nestedUnkeyedContainer(forKey: key)
        
        for stmt in stmts {
            try nested.encodeStatement(stmt)
        }
    }
    
    public mutating func encodeStatementIfPresent(_ stmt: Statement?, forKey key: Key) throws {
        guard let stmt = stmt else {
            return
        }
        
        let container = try SwiftASTSerializer.StatementContainer(statement: stmt)
        
        try self.encode(container, forKey: key)
    }
}

// MARK: Encoding/DecodingContainer Expression Extensions


public extension UnkeyedDecodingContainer {
    
    public mutating func decodeExpression<E: Expression>(_ type: E.Type = E.self) throws -> E {
        let container = try self.decode(SwiftASTSerializer.ExpressionContainer.self)
        
        if let s = container.expression as? E {
            return s
        }
        
        throw SwiftASTSerializer.Error.unexpectedExpressionType(Swift.type(of: container.expression))
    }
    
    public mutating func decodeExpressionIfPresent<S: Expression>(_ type: S.Type = S.self) throws -> S? {
        guard let container = try self.decodeIfPresent(SwiftASTSerializer.ExpressionContainer.self) else {
            return nil
        }
        
        if let s = container.expression as? S {
            return s
        }
        
        throw SwiftASTSerializer.Error.unexpectedExpressionType(Swift.type(of: container.expression))
    }
    
}

public extension KeyedDecodingContainerProtocol {
    
    public func decodeExpression<E: Expression>(_ type: E.Type = E.self, forKey key: Key) throws -> E {
        let container = try self.decode(SwiftASTSerializer.ExpressionContainer.self, forKey: key)
        
        if let s = container.expression as? E {
            return s
        }
        
        throw SwiftASTSerializer.Error.unexpectedExpressionType(Swift.type(of: container.expression))
    }
    
    public func decodeExpressions(forKey key: Key) throws -> [Expression] {
        var nested = try self.nestedUnkeyedContainer(forKey: key)
        
        var stmts: [Expression] = []
        
        while !nested.isAtEnd {
            stmts.append(try nested.decodeExpression(Expression.self))
        }
        
        return stmts
    }
    
    public func decodeExpressionIfPresent<E: Expression>(_ type: E.Type = E.self, forKey key: Key) throws -> E? {
        guard let container = try self.decodeIfPresent(SwiftASTSerializer.ExpressionContainer.self, forKey: key) else {
            return nil
        }
        
        if let s = container.expression as? E {
            return s
        }
        
        throw SwiftASTSerializer.Error.unexpectedExpressionType(Swift.type(of: container.expression))
    }
}

public extension UnkeyedEncodingContainer {
    
    public mutating func encodeExpression(_ exp: Expression) throws {
        let container = try SwiftASTSerializer.ExpressionContainer(expression: exp)
        
        try self.encode(container)
    }
    
    public mutating func encodeExpressionIfPresent(_ exp: Expression?) throws {
        guard let exp = exp else {
            return
        }
        
        let container = try SwiftASTSerializer.ExpressionContainer(expression: exp)
        
        try self.encode(container)
    }
    
}

public extension KeyedEncodingContainerProtocol {
    
    public mutating func encodeExpression(_ exp: Expression, forKey key: Key) throws {
        let container = try SwiftASTSerializer.ExpressionContainer(expression: exp)
        
        try self.encode(container, forKey: key)
    }
    
    public mutating func encodeExpressions(_ exps: [Expression], forKey key: Key) throws {
        var nested = self.nestedUnkeyedContainer(forKey: key)
        
        for exp in exps {
            try nested.encodeExpression(exp)
        }
    }
    
    public mutating func encodeExpressionIfPresent(_ exp: Expression?, forKey key: Key) throws {
        guard let exp = exp else {
            return
        }
        
        let container = try SwiftASTSerializer.ExpressionContainer(expression: exp)
        
        try self.encode(container, forKey: key)
    }
}

